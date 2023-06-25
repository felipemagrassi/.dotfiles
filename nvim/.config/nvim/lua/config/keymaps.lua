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
vim.keymap.set("n", "<leader>nn", ":ZkNew<cr>", { noremap = true, silent = true, desc = "New note" })
vim.keymap.set(
  "v",
  "<leader>ne",
  "'<,'>ZkNewFromTitleSelection<cr>",
  { noremap = true, silent = true, desc = "New note from selection" }
)

vim.api.nvim_create_user_command("AC", [[:execute "e " . eval('rails#buffer().alternate()')]], { nargs = 0 })
