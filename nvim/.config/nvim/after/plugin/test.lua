vim.keymap.set('n', "<leader>tn", ":TestNearest<cr>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader>tf", ":TestFile<cr>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader>ts", ":TestSuite<cr>", { noremap = true, silent = true })

local tmux_shell  = vim.fn.exists('$TMUX')

if tmux_shell == 1 then
    vim.g["test#strategy"] = "vimux"
    vim.g["VimuxOrientation"] = "h"
    vim.g["VimuxHeight"] = 30
else
    vim.g["test#strategy"] = "dispatch"
end

vim.g["test#preserve_screen"] = 0

local test = vim.api.nvim_create_augroup("test", { clear = true })
local condition_testfile = vim.g["autorun/testfile"]
local condition_testsuite = vim.g["autorun/testsuite"]

if condition_testfile == 1 then
    vim.api.nvim_create_autocmd('BufWrite', { command = ":TestFile", group = test })
end

if condition_testsuite == 1 then
    vim.api.nvim_create_autocmd('BufWrite', { command = ":TestSuite", group = test })
end
