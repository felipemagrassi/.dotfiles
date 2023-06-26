local map = require("helpers.keys").map

-- Blazingly fast way out of insert mode
map("i", "jk", "<esc>")

vim.api.nvim_create_user_command("AC", [[:execute "e " . eval('rails#buffer().alternate()')]], { nargs = 0 })

vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":TestFile<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ts", ":TestSuite<cr>", { noremap = true, silent = true })
