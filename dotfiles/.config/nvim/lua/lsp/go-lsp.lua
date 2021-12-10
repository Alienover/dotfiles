local M = {
  filetypes = { "go", "gomod" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

-- require "lspconfig".gopls.setup(M)
return M
