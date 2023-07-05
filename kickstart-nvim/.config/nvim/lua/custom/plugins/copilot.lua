return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = 'VeryLazy',
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      copilot_node_command = os.getenv("HOME") .. "/node",
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },
}
