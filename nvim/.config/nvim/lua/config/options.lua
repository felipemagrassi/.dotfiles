-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- The setup below will automatically configure connections without the need for manual input each time.

vim.g.dbs = {
  { name = "dev", url = "Replace with your database connection URL." },
  { name = "staging", url = "Replace with your database connection URL." },
}
