-- require("neodev").setup({
--   -- add any options here, or leave empty to use the default settings
-- })

local M = {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
    },
  },
}
return M
