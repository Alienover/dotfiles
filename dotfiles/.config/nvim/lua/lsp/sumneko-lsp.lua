local status_ok, neodev = pcall(require, "neodev")
if not status_ok then
  return {}
end

neodev.setup({
  -- add any options here, or leave empty to use the default settings
})

local M = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}

return M
