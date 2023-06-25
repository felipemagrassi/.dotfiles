return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  { "ellisonleao/gruvbox.nvim", opts = {
    transparent_mode = true,
  } },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    event = "VimEnter",
    opts = {
      transparent_background = true,
    },
  },
}
