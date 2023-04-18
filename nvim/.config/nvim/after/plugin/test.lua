vim.keymap.set('n', "<leader>\\", ":TestNearest<cr>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader><cr>", ":TestFile<cr>", { noremap = true, silent = true })

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
local condition = vim.api.nvim_call_function("test#exists", {})

if condition then
    vim.api.nvim_create_autocmd('BufWrite', { command = ":TestFile", group = test })
end
