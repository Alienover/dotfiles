local status_ok, lua_dev = pcall(require, "lua-dev")
if not status_ok then
  return {}
end

return lua_dev.setup({
  lspconfig = {
    settings = {
      Lua = {
        diagnostics = {
          libraryFiles = "Disable",
        },
      },
    },
  },
})
