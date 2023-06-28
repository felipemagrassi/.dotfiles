-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.relativenumber = false
vim.opt.swapfile = false

-- Vim-test
local tmux_shell = vim.fn.exists("$TMUX") == 1

if tmux_shell == 1 then
  vim.g["test#strategy"] = "vimux"
  vim.g["VimuxOrientation"] = "v"
  vim.g["VimuxHeight"] = "30"
else
  vim.g["test#strategy"] = "dispatch"
end

vim.g["test#preserve_screen"] = 1
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
vim.g["test#ruby#rspec#options"] = "--format documentation --color"
