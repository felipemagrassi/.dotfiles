-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })

vim.opt.relativenumber = false
vim.opt.swapfile = false

lvim.format_on_save.enabled = true

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

lvim.builtin.which_key.mappings["l"]["f"] = {
  function()
    require("lvim.lsp.utils").format { timeout_ms = 2000 }
  end,
  "Format",
}

lvim.plugins = {
  { "tpope/vim-dispatch",      ft = { "ruby" } },
  {
    "tpope/vim-rails",
    ft = { "ruby" },
    keys = {
      { "<leader>ja", [[:execute "e " . eval('rails#buffer().alternate()')<cr>]], desc = 'Jump rails alternate' } }
  },
  {
    "folke/tokyonight.nvim",
  },
  { "ellisonleao/gruvbox.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "VimEnter",
  },

  {
    "preservim/vimux"
  },
  {
    "vim-test/vim-test",
    config = function()
      vim.cmd([[ let g:test#strategy = 'vimux' ]])
      vim.cmd([[ let g:test#neovim#term_position = 'vert' ]])
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
  {
    "mickael-menu/zk-nvim",
    keys = {
      { "<leader>nf", ":ZkNotes { excludeHrefs = { 'node_modules' } }<cr>",
        {
          noremap = true,
          silent = true,
          desc = "Notes"
        } },
      { "<leader>nt", ":ZkTags { excludeHrefs = { 'node_modules' } }<cr>",
        {
          noremap = true,
          silent = true,
          desc = "Tags"
        } },
      { "<leader>nn", ":ZkNew({title = '' })<LEFT><LEFT><LEFT><LEFT>",
        {
          noremap = true,
          silent = true,
          desc = "New note"
        } },
      { "<leader>ne", "'<,'>ZkNewFromTitleSelection<cr>",
        {
          noremap = true,
          silent = true,
          desc = "New note from selection"
        } },
    },
    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
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
    config = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}

-- Copilot
table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup({
        filetypes = {
          markdown = true
        }
      })                             -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

lvim.transparent_window = false

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "rubocop",
    filetypes = { "ruby" }
  },
  {
    command = "clang-format",
    filetypes = { "java" },
    extra_args = { "--style", "Google" }
  },
  {
    command = "markdownlint",
    filetypes = { "markdown" },
  }
}
