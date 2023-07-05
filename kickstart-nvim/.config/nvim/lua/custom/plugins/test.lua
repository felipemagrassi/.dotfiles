vim.cmd([[ let g:test#strategy = 'neovim' ]])
vim.cmd([[ let g:test#neovim#term_position = 'vert' ]])
vim.cmd([[ let g:test#javascript#runner = 'jest' ]])
vim.cmd([[ let g:test#preserve_screen = 1 ]])
vim.cmd([[ let g:test#ruby#rspec#executable = 'bundle exec rspec' ]])
vim.cmd([[ let g:test#ruby#rspec#options = '--format documentation --color' ]])

return {
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tn", ":TestNearest<cr>", desc = "Test Nearest" },
      { "<leader>tf", ":TestFile<cr>",    desc = "Test File" },
      { "<leader>ts", ":TestSuite<cr>",   desc = "Test Suite" },
      { "<leader>tl", ":TestLast<cr>",    desc = "Test Last" },
      { "<leader>tv", ":TestVisit<cr>",   desc = "Test Visit" },
    },
  },
}
