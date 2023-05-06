return {
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		init = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	},
	{
		"jubnzv/mdeval.nvim",
		config = function()
			vim.defer_fn(function()
				require("mdeval").setup {
					require_confirmation = false,
					eval_options = {
						ruby = {
							default_header = [[
								require 'rspec/autorun'
								]]
						}
					}
				}
			end, 100)
		end
	}
}
