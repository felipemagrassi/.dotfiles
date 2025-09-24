local keymap = vim.keymap
vim.pack.add({
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/catppuccin/nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mcauley-penney/techbase.nvim" },
})

-- LSP
vim.lsp.enable({
	"bashls",
	"gopls",
	"lua_ls",
	"texlab",
	"ts_ls",
	"rust-analyzer",
	"helm_ls",
})
vim.diagnostic.config({ virtual_text = true })

-- fugitive
keymap.set("n", "<leader>gs", "<cmd>Git<CR>", opts)
keymap.set("n", "<leader>gp", "<cmd>Git push<CR>", opts)

-- Mason
require("mason").setup({})

-- Fzf.lua
local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
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
		},
	},
	actions = {
		files = {
			["ctrl-q"] = actions.file_sel_to_qf,
			["ctrl-n"] = actions.toggle_ignore,
			["ctrl-h"] = actions.toggle_hidden,
			["enter"] = actions.file_edit_or_qf,
		},
	},
})
keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>")

-- gitsigns
require("gitsigns").setup({ signcolumn = false })

--- Oil.nvim
require("oil").setup({
	default_file_explorer = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		natural_order = true,
	},
})
keymap.set("n", "<leader>e", vim.cmd.Oil)

-- Blink.cmp
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-space>"] = {},
		["<C-p>"] = {},
		["<Tab>"] = {},
		["<S-Tab>"] = {},
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-n>"] = { "select_and_accept" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_down", "fallback" },
		["<C-f>"] = { "scroll_documentation_up", "fallback" },
		["<C-l>"] = { "snippet_forward", "fallback" },
		["<C-h>"] = { "snippet_backward", "fallback" },
		-- ["<C-e>"] = { "hide" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	cmdline = {
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},

	sources = { default = { "lsp" } },
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
	},
})
keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({
		lsp_fallback = true,
		async = true,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Themes
-- require("tokyonight").setup({
-- 	style = "storm",
-- 	transparent = "true",
-- 	terminal_colors = true,
-- })
-- vim.cmd([[colorscheme tokyonight-storm]])

require("techbase").setup({
	transparent = true,
})

require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})

-- vim.opt.background = "light"
vim.cmd([[colorscheme oxocarbon]])
--vim.cmd([[colorscheme github_light]])
