-- require("neodev").setup({
--   -- add any options here, or leave empty to use the default settings
-- })

local runtime = { "lua/?.lua", "lua/?/init.lua" }

local M = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        path = runtime,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
        library = vim.api.nvim_get_runtime_file("", true),
      },
      semantic = { enable = false },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

return M
