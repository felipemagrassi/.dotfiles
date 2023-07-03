-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.relativenumber = false
vim.opt.swapfile = false

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vert"
vim.g["test#javascript#runner"] = "jest"
vim.g["test#preserve_screen"] = 1
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
vim.g["test#ruby#rspec#options"] = "--format documentation --color"
