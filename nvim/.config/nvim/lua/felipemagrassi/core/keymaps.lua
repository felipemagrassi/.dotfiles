vim.g.mapleader = " " 
vim.g.maplocalleader = "\\"
local keymap = vim.keymap
keymap.set("n", "<leader>vp", '<cmd>lua vim.pack.update()<CR>')
keymap.set("n", "<leader>vr", '<cmd>restart<CR>')
