local neodev = vim.F.npcall(require, "neodev")
if neodev then
  -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
  neodev.setup({
    -- add any options here, or leave empty to use the default settings
  })
end

local M = {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = {
        callSnippet = "Replace",
      },
      hint = {
        enable = true,
        arrayIndex = "Enable",
        setType = true,
      },
    },
  },
}
return M
