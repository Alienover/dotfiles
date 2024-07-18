local plenary = require("plenary.scandir")

local library = plenary.scan_dir(
  vim.fn.stdpath("data") .. "/lazy",
  { depth = 1, only_dirs = true }
)

table.insert(library, 1, vim.env.VIMRUNTIME)

-- config from https://github.com/neovim/neovim/issues/21686#issuecomment-1522446128
local M = {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = library,
        checkThirdParty = false,
      },
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
