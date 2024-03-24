-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank to clipboard' })
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>jc', '<cmd>:e ~/.config/nvim/init.lua<cr>', { desc = 'Jump to config' })
vim.keymap.set('n', '<leader>mq', "<cmd>:%s/^/'/c | %s/$/',/c<cr>", { desc = 'Add quotes and commas' })
vim.opt.spell = true
vim.opt.spelllang = 'pt_br,en_us'

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<leader>x', '<cmd>:qa!<cr>', { desc = 'Quit' })

require('which-key').register {
  ['<leader>j'] = { name = '[J]ump', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]est', _ = 'which_key_ignore' },
  ['<leader>m'] = { name = '[M]agestic Scripts', _ = 'which_key_ignore' },
}

require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      'node_modules',
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
}

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'https://github.com/rafamadriz/friendly-snippets',
  },
  {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'nvim-telescope/telescope-live-grep-args.nvim',
    -- This will not install any breaking changes.
    -- For major updates, this must be adjusted manually.
    version = '^1.0.0',
    config = function()
      require('telescope').load_extension 'live_grep_args'
    end,
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  { 'tpope/vim-dispatch' },
  { 'rebelot/kanagawa.nvim' },
  {
    'tpope/vim-rails',
    ft = { 'ruby' },
    keys = {
      { '<leader>ja', [[:execute "e " . eval('rails#buffer().alternate()')<cr>]], desc = 'Jump rails alternate' },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    keys = {
      { '<leader>k', ':Neotree reveal toggle<cr>', desc = 'Toggle NvimTree' },
    },
    config = function()
      require('neo-tree').setup {}
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():append()
      end)
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(4)
      end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end)
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    event = 'VimEnter',
    init = function()
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
    config = function()
      require('catppuccin').setup {
        transparent_background = true,
      }
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    keys = {
      { '<leader>mp', ':MarkdownPreview<cr>', {
        noremap = true,
        silent = true,
        desc = 'Markdown Preview',
      } },
    },
    ft = 'markdown',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-go',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'olimorris/neotest-rspec',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)
      require('neotest').setup {
        adapters = {
          require 'neotest-vitest' {
            filter_dir = function(name, rel_path, root)
              return name ~= 'node_modules'
            end,
          },
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            jestConfigFile = 'custom.jest.config.ts',
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          },
          require 'neotest-go' {
            recursive_run = true,
            experimental = {
              test_table = true,
            },
            args = { '-v', '-count=1' },
          },
          require 'neotest-rspec' {
            rspec_cmd = function()
              return vim.tbl_flatten {
                'bundle',
                'exec',
                'rspec',
              }
            end,
          },
        },
      }

      vim.keymap.set('n', '<leader>tn', function()
        require('neotest').run.run()
      end)
      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end)
      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').run.run(vim.fn.getcwd())
      end)
      vim.keymap.set('n', '<leader>tp', function()
        require('neotest').output_panel.toggle()
        require('neotest').summary.toggle()
      end)
    end,
  },
  -- {
  --   'vim-test/vim-test',
  --   config = function()
  --     vim.cmd [[ let g:test#strategy = 'neovim' ]]
  --     vim.cmd [[ let g:test#neovim#start_normal = 1 ]]
  --     vim.cmd [[ let g:test#neovim#term_position = "vert botright" ]]
  --     vim.cmd [[ let g:test#javascript#runner = 'jest' ]]
  --     vim.cmd [[ let g:test#preserve_screen = 1 ]]
  --     vim.cmd [[ let g:test#ruby#rspec#executable = 'bundle exec rspec' ]]
  --     vim.cmd [[ let g:test#ruby#rspec#options = '--format documentation --color' ]]
  --   end,
  --   keys = {
  --     { '<leader>tn', ':TestNearest<cr>', desc = 'Test Nearest' },
  --     { '<leader>tf', ':TestFile<cr>', desc = 'Test File' },
  --     { '<leader>ts', ':TestSuite<cr>', desc = 'Test Suite' },
  --     { '<leader>tl', ':TestLast<cr>', desc = 'Test Last' },
  --     { '<leader>tv', ':TestVisit<cr>', desc = 'Test Visit' },
  --   },
  -- },
  { 'EdenEast/nightfox.nvim' },
  { 'xiyaowong/transparent.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  {
    'rest-nvim/rest.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    ft = 'http',
    keys = {
      { '<leader>tr', '<Plug>RestNvim<cr>', desc = 'Test Request' },
    },
    config = function()
      require('rest-nvim').setup {
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
            json = 'jq',
            html = function(body)
              return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      }
    end,
  },
  { 'fatih/vim-go', ft = 'go' },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        auto_refresh = true,
        suggestion = {
          enabled = false,
          auto_trigger = true,
        },
        panel = {
          enabled = false,
        },
        filetypes = {
          markdown = true,
        },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'rest-nvim/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('rest-nvim').setup {
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
            json = 'jq',
            html = function(body)
              return vim.fn.system({ 'tidy', '-i', '-q', '-' }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = '.env',
        -- for telescope select
        env_pattern = '\\.env$',
        env_edit_command = 'tabedit',
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      }
    end,
  },
}
