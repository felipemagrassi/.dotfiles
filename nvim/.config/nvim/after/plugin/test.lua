vim.keymap.set('n', "<leader>tn", ":TestNearest<cr>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader>tf", ":TestFile<cr>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader>ts", ":TestSuite<cr>", { noremap = true, silent = true })

local test = vim.api.nvim_create_augroup("test", { clear = true })
vim.api.nvim_create_autocmd('BufWrite', {
    callback = function()
        if vim.g.auto_test_file == 1 then
            vim.cmd("TestFile")
        end
    end,
    group = test
})

local tmux_shell = vim.fn.exists('$TMUX')

if tmux_shell == 1 then
    vim.g["test#strategy"] = "vimux"
    vim.g["VimuxOrientation"] = "h"
    vim.g["VimuxHeight"] = 30
else
    vim.g["test#strategy"] = "dispatch"
end

vim.g["test#preserve_screen"] = 0

vim.api.nvim_create_user_command('AC', [[:execute "e " . eval('rails#buffer().alternate()')]], { nargs = 0 })

