--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.clipboard = "unnamedplus"          -- allows neovim to access the system clipboard
vim.g.markdown_recommended_style = 0
vim.opt.cmdheight = 2                      -- more space in the neovim command line for displaying messages
vim.opt.colorcolumn = "99999"              -- fixes indentline for now
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0                   -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"             -- the encoding written to a file
vim.opt.foldmethod = "manual"              -- folding set to "expr" for treesitter based folding
vim.opt.foldexpr = ""                      -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.guifont = "monospace:h17"          -- the font used in graphical neovim applications
vim.opt.hidden = true                      -- required to keep multiple buffers and open multiple buffers
vim.opt.hlsearch = true                    -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                  -- ignore case in search patterns
vim.opt.mouse = "a"                        -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                     -- pop up menu height
vim.opt.showmode = false                   -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 2                    -- always show tabs
vim.opt.smartcase = true                   -- smart case
vim.opt.smartindent = true                 -- make indenting smarter again
vim.opt.splitbelow = true                  -- force all horizontal splits to go below current window
vim.opt.splitright = true                  -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                   -- creates a swapfile
vim.opt.termguicolors = true               -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 100                   -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title = true                       -- set the title of window to the value of the titlestring
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
vim.opt.undodir = vim.fn.stdpath "cache" .. "/undo"
vim.opt.undofile = true                    -- enable persistent undo
vim.opt.updatetime = 300                   -- faster completion
vim.opt.writebackup = false                -- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited
vim.opt.expandtab = true                   -- convert tabs to spaces
vim.opt.shiftwidth = 2                     -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                        -- insert 2 spaces for a tab
vim.opt.cursorline = true                  -- highlight the current line
vim.opt.number = true                      -- set numbered lines
vim.opt.relativenumber = false             -- set relative numbered lines
vim.opt.numberwidth = 4                    -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                 -- always show the sign column otherwise it would shift the text each time
vim.opt.wrap = false                       -- display lines as one long line
vim.opt.spell = false
vim.opt.spelllang = "pt"
vim.opt.scrolloff = 8 -- is one of my fav
vim.opt.sidescrolloff = 8

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- -- Change theme settings
-- lvim.colorscheme = "lunar"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
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

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local markdownlint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "markdown" },
  -- null_ls.generator creates an async source
  -- that spawns the command with the given arguments and options
  generator = null_ls.generator({
    command = "markdownlint",
    args = { "--stdin" },
    to_stdin = true,
    from_stderr = true,
    -- choose an output format (raw, json, or line)
    format = "line",
    check_exit_code = function(code, stderr)
      local success = code <= 1

      if not success then
        -- can be noisy for things that run often (e.g. diagnostics), but can
        -- be useful for things that run on demand (e.g. formatting)
        print(stderr)
      end

      return success
    end,
    -- use helpers to parse the output from string matchers,
    -- or parse it manually with a function
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
        groups = { "row", "col", "message" },
      },
      {
        pattern = [[:(%d+) [%w-/]+ (.*)]],
        groups = { "row", "message" },
      },
    }),
  }),
}

null_ls.register(markdownlint)

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.fixjson,
    null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.code_actions.proselint,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.erb_format,
    null_ls.builtins.formatting.erb_lint,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.rubocop,
  },
})


-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "vim-test/vim-test" },
  { "tpope/vim-dispatch" },
  {
    "jubnzv/mdeval.nvim",
    config = function()
      vim.defer_fn(function()
        require("mdeval").setup {
          require_confirmation = false,
          eval_options = {
            -- Set custom configuration for C++
            ruby = {
              default_header = [[
      require 'rspec/autorun'
      ]]
            }
          }
        }
      end, 100)
    end
  },
  { "morhetz/gruvbox" },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  {
    "tpope/vim-rails",
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
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
          panel = {
            enabled = true,
          },
          suggestion = {
            auto_trigger = true
          },
          filetypes = {
            markdown = true,
            ruby = true
          }
        }
      end, 100)
    end,
  },
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
    end
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
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
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
  },
}
-- require 'mdeval'.setup({
--   },
-- })

lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
vim.b.copilot_suggestion_hidden = false

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
  t = {
    [[<cmd>:0r ~/Minhas-Coisas/Templates/note.md | %s/{{date}}, {{time}}/\=strftime('%c')/g | %s!{{title}}!\=expand('%')!g  <CR>]],
    "Markdown Template" }
}

lvim.builtin.which_key.mappings["r"] = {
  name = "+Ruby",
  t = { "<cmd>:execute 'e ' . eval('rails#buffer().alternate()')<cr>", "Go to test file" },
  r = { "<cmd>:!bundle exec rubocop -A %<cr>", "Rubocop" },
  s = { "<cmd>:RorSchemaListColumns<cr>", "Schema List" },
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
