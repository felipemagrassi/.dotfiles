-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set(
  "n",
  "<leader>nf",
  ":ZkNotes { excludeHrefs = { 'node_modules' } }<cr>",
  { noremap = true, silent = true, desc = "Notes" }
)
vim.keymap.set(
  "n",
  "<leader>nt",
  ":ZkTags { excludeHrefs = { 'node_modules' } }<cr>",
  { noremap = true, silent = true, desc = "Tags" }
)
vim.keymap.set(
  "n",
  "<leader>nn",
  ":ZkNew({title = '' })<LEFT><LEFT><LEFT><LEFT>",
  { noremap = true, silent = true, desc = "New note" }
)
vim.keymap.set(
  "v",
  "<leader>ne",
  "'<,'>ZkNewFromTitleSelection<cr>",
  { noremap = true, silent = true, desc = "New note from selection" }
)
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<cr>", { noremap = true, silent = true, desc = "markdown preview" })

vim.api.nvim_create_user_command("AC", [[:execute "e " . eval('rails#buffer().alternate()')]], { nargs = 0 })

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>tn", ":TestNearest<cr>", { noremap = true, silent = true, desc = "Test Nearest" })
vim.keymap.set("n", "<leader>tf", ":TestFile<cr>", { noremap = true, silent = true, desc = "Test File" })
vim.keymap.set("n", "<leader>ts", ":TestSuite<cr>", { noremap = true, silent = true, desc = "Test Suite" })
vim.keymap.set("n", "<leader>tl", ":TestLast<cr>", { noremap = true, silent = true, desc = "Test Last" })
vim.keymap.set("n", "<leader>tv", ":TestVisit<cr>", { noremap = true, silent = true, desc = "Test Visit" })
