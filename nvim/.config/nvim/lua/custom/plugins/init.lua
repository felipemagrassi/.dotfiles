-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  { "tpope/vim-dispatch" },
  {
    "tpope/vim-rails",
    ft = { "ruby" },
    keys = {
      { "<leader>ja", [[:execute "e " . eval('rails#buffer().alternate()')<cr>]], desc = 'Jump rails alternate' }
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>k", ":Neotree reveal toggle<cr>", desc = "Toggle NvimTree" },
    },
    config = function()
      require('neo-tree').setup {}
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "VimEnter",
    config = function()
      require("catppuccin").setup({
        transparent_background = true
      })
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      { "<leader>mp", ":MarkdownPreview<cr>", {
        noremap = true,
        silent = true,
        desc = "markdown preview"
      } },
    },
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "vim-test/vim-test",
    config = function()
      vim.cmd([[ let g:test#strategy = 'neovim' ]])
      vim.cmd([[ let g:test#neovim#start_normal = 1 ]])
      vim.cmd([[ let g:test#neovim#term_position = "vert botright" ]])
      vim.cmd([[ let g:test#javascript#runner = 'jest' ]])
      vim.cmd([[ let g:test#preserve_screen = 1 ]])
      vim.cmd([[ let g:test#ruby#rspec#executable = 'bundle exec rspec' ]])
      vim.cmd([[ let g:test#ruby#rspec#options = '--format documentation --color' ]])
    end,
    keys = {
      { "<leader>tn", ":TestNearest<cr>", desc = "Test Nearest" },
      { "<leader>tf", ":TestFile<cr>",    desc = "Test File" },
      { "<leader>ts", ":TestSuite<cr>",   desc = "Test Suite" },
      { "<leader>tl", ":TestLast<cr>",    desc = "Test Last" },
      { "<leader>tv", ":TestVisit<cr>",   desc = "Test Visit" },
    },
  },
  { "EdenEast/nightfox.nvim" },
  { 'xiyaowong/transparent.nvim' },
  { "ellisonleao/gruvbox.nvim" },
  {
    "rest-nvim/rest.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    ft = "http",
    keys = {
      { "<leader>tr", "<Plug>RestNvim<cr>", desc = "Test Request" },
    },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- stay in current windows (.http file) or change to results window (default)
        stay_in_current_window_after_split = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- table of curl `--write-out` variables or false if disabled
          -- for more granular control see Statistics Spec
          show_statistics = false,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
    end
  },
  { 'fatih/vim-go', ft = "go" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
        },
        panel = {
          enabled = false
        }
      })
    end,
  }
}
