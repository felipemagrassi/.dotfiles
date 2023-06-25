return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
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
}
