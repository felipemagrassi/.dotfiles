return {
  {
    "tpope/vim-rails",
    ft = { "ruby" },
    keys = {
      { "<leader>ja", [[:execute "e " . eval('rails#buffer().alternate()')<cr>]], desc = "Jump rails alternate" },
    },
  },
}