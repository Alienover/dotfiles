local util = require("lspconfig.util")

local M = {
  cmd = { "bundle", "exec", "solargraph", "stdio" },
  root_dir = util.root_pattern("Gemfile", ".git", "."),
  settings = {
    solargraph = {
      diagnostics = true,
      formatting = true,
    },
  },
}

return M
