local keymap = vim.keymap
vim.pack.add{
	  { src = 'https://github.com/neovim/nvim-lspconfig' },
	  { src = 'https://github.com/stevearc/oil.nvim' },
	  { src = 'https://github.com/stevearc/conform.nvim' },
	  { src = 'https://github.com/echasnovski/mini.icons'},
	  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('*') },
	  { src = 'https://github.com/rafamadriz/friendly-snippets'},
	  { src = 'https://github.com/numToStr/Comment.nvim'},
	  { src = 'https://github.com/folke/tokyonight.nvim'},
      { src = "https://github.com/ibhagwan/fzf-lua" },
      { src = "https://github.com/tpope/vim-fugitive" },
}

vim.lsp.enable('pyright')
vim.lsp.enable('ts_ls')
vim.lsp.enable('luals')

-- fugitive
keymap.set("n", "<leader>gs", '<cmd>Git<CR>', opts)
keymap.set("n", "<leader>gp", '<cmd>Git push<CR>', opts)

-- Fzf.lua
local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = { backdrop = 85 },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})
keymap.set("n", "<leader>ff", '<cmd>FzfLua files<CR>')
keymap.set("n", "<leader>fg", '<cmd>FzfLua live_grep<CR>')
--- Oil.nvim
require("oil").setup({
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		natural_order = true
	}
})
keymap.set("n", "<leader>e", vim.cmd.Oil)

-- Blink.cmp
require('blink.cmp').setup({
})

-- Conform
require("conform").setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		terraform = { "terraform_fmt" },
		python = { "isort", "black" },
	},
	format_after_save = {
		lsp_fallback = true,
		async = true,
		timeout_ms = 1000,
	}
})
keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({
		lsp_fallback = true,
		async = true,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Themes 
require('tokyonight').setup({
	style="storm",
	transparent="true",
	terminal_colors = true,
})

vim.cmd([[colorscheme tokyonight-storm]])
