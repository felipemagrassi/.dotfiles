return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "ruby",
        "typescript",
        "tsx",
        "java",
        "gosum",
      })
    end,
  },
}
