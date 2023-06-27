local opts = {
	shiftwidth = 4,
	tabstop = 4,
	expandtab = true,
	wrap = false,
	termguicolors = true,
	number = true,
	relativenumber = true,
}

-- Set options from table
for opt, val in pairs(opts) do
	vim.o[opt] = val
end

-- Set other options
local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)

local tmux_shell = vim.fn.exists("$TMUX") == 1

if tmux_shell == 1 then
	vim.g["test#strategy"] = "vimux"
	vim.g["VimuxOrientation"] = "h"
	vim.g["VimuxHeight"] = "30"
else
	vim.g["test#strategy"] = "dispatch"
end

vim.g["test#preserve_screen"] = 1
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
vim.g["test#ruby#rspec#options"] = "--format documentation --color"
