--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "lunar"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }
-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"
-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["t"] = {
    name = "+Test",
    rf = { "<cmd>:RorTestRun<cr>", "Test File" },
    rl = { "<cmd>lua require('ror.test').run('Line')<cr>", "Test File" },
    rt = { "<cmd>:RorTestAttachTerminal<CR>", "Terminal" },
    tf = { "<cmd>:TestFile<cr>", "Test File" },
    tl = { "<cmd>:TestNearest<CR>", "Test File" }
}

lvim.builtin.which_key.mappings["m"] = {
    name = "+Markdown",
    e = { "<cmd>:MdEval<cr>", "Evaluate block" },
    p = { "<cmd>:MarkdownPreview<cr>", "Markdown Preview" },
    f = { "<cmd>:!mdformat %<cr>", "Markdown Format" },
}

lvim.builtin.which_key.mappings["r"] = {
    name = "+Ruby",
    t = { "<cmd>:execute 'e ' . eval('rails#buffer().alternate()')<cr>", "Go to test file" },
    r = { "<cmd>:!bundle exec rubocop -A %<cr>", "Rubocop" },
    s = { "<cmd>:RorSchemaListColumns<cr>", "Schema List" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "ruby",
    "python",
    "typescript",
    "tsx",
    "css",
    "java",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings

-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--     { command = "rubocop" }
-- }

-- -- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--     { command = "rubocop" }
-- }

-- Additional Plugins
lvim.plugins = {
    {
        { "zbirenbaum/copilot.lua",
            event = { "VimEnter" },
            config = function()
              vim.defer_fn(function()
                require("copilot").setup {
                    plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
                    suggestion = {
                        auto_trigger = true
                    },
                    filetypes = {
                        ruby = true
                    },
                    copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/19.6.0/bin/node"
                }
              end, 100)
            end,
        },
        { "zbirenbaum/copilot-cmp",
            after = { "copilot.lua", "nvim-cmp" },
        },
        { 'aaronhallaert/continuous-testing.nvim' },
        { "tpope/vim-dispatch" },
        { 
          "vim-test/vim-test",
          config = function()
            vim.g["test#strategy"] = "neovim"
            vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
          end
        },
        {
            "tpope/vim-rails",
            ft = { 'ruby' },
            cmd = {
                "Eview",
                "Econtroller",
                "Emodel",
                "Smodel",
                "Sview",
                "Scontroller",
                "Vmodel",
                "Vview",
                "Vcontroller",
                "Tmodel",
                "Tview",
                "Tcontroller",
                "Rails",
                "Generate",
                "Runner",
                "Extract"
            }
        },
        {
            'nvim-neotest/neotest',
            requires = {
                'olimorris/neotest-rspec',
            },
            config = function()
              require('neotest').setup({
                  adapters = {
                      require('neotest-rspec')({
                          rspec_cmd = function()
                            return vim.tbl_flatten({
                                    "bundle",
                                    "exec",
                                    "rspec",
                                })
                          end
                      }),
                  }
              })
            end
        },
        { 'rcarriga/nvim-notify' },
        { 'weizheheng/ror.nvim' },
        {
            "iamcco/markdown-preview.nvim",
            run = "cd app && npm install",
            ft = "markdown",
            config = function()
              vim.g.mkdp_auto_start = 1
            end,
        },
        {
            "jubnzv/mdeval.nvim",
        },
        { "chrisbra/csv.vim" }
    }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
--

require 'mdeval'.setup({
    -- Don't ask before executing code blocks
    require_confirmation = false,
    -- Change code blocks evaluation options.
    eval_options = {
        -- Set custom configuration for C++
        cpp = {
            command = { "clang++", "-std=c++20", "-O0" },
            default_header = [[
    #include <iostream>
    #include <vector>
    using namespace std;
      ]]
        },
        -- Add new configuration for Racket
        racket = {
            command = { "racket" }, -- Command to run interpreter
            language_code = "racket", -- Markdown language code
            exec_type = "interpreted", -- compiled or interpreted
            extension = "rb", -- File extension for temporary files
        },
    },
})

require("continuous-testing").setup {
    notify = true, -- The default is false
    run_tests_on_setup = true, -- The default is true, run test on attach
    framework_setup = {
        ruby = {
            test_tool = "rspec",
            test_cmd = "bundle exec rspec %file",
        },
        javascript = {
            test_tool = "vitest", -- cwd of the executing test will be at package.json
            test_cmd = "yarn vitest run %file",
            root_pattern = "tsconfig.json", -- used to populate the root option of vitest
        },
    },
    project_override = {
        ["/Users/name/Developer/ruby-project"] = {
            ruby = {
                test_tool = "rspec",
                test_cmd = "docker exec -it name -- bundle exec rspec %file",
            },
        },
    },
}

lvim.builtin.telescope.defaults.layout_config.width = 0.98
lvim.builtin.telescope.defaults.layout_config.preview_cutoff = 40

lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
vim.b.copilot_suggestion_hidden = false
