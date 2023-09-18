return {
  { "nvim-neotest/neotest-jest" },
  { "nvim-neotest/neotest-plenary" },
  { "olimorris/neotest-rspec" },
  { "nvim-neotest/neotest-go" },
  {
    "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        "neotest-plenary",
        ["neotest-jest"] = {
          jestCommand = "yarn jest --watch",
        },
        "neotest-rspec",
        "neotest-go",
      },
    },
  },
}
