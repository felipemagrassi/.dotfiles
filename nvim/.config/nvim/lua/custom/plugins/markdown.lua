return {
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
