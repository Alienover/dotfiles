local utils = require("utils")
local nls = require("null-ls")

local NODE_MODULES_LOCAL_BIN = vim.loop.cwd() .. "/node_modules/.bin"

local config = {
  debounce = 150,
  default_timeout = 5000,
  save_after_format = false,
  diagnostics_format = "#{m}",
  sources = {
    nls.builtins.code_actions.gitsigns,
    -- JavaScript
    -- Faster prettier
    -- Reter to: https://github.com/mikew/prettier_d_slim
    nls.builtins.formatting.prettier.with({
      prefer_local = NODE_MODULES_LOCAL_BIN,
    }),
    nls.builtins.diagnostics.eslint.with({
      prefer_local = NODE_MODULES_LOCAL_BIN,
    }),
    nls.builtins.code_actions.eslint.with({
      prefer_local = NODE_MODULES_LOCAL_BIN,
    }),
    -- Json
    -- Refer to: https://github.com/stedolan/jq
    nls.builtins.formatting.jq,
    -- Lua
    -- Refer to: https://github.com/JohnnyMorganz/StyLua
    nls.builtins.formatting.stylua.with({
      extra_args = function()
        if not utils.file_existed(vim.loop.cwd() .. "/.stylua.toml") then
          return {
            "--indent-width",
            "2",
            "--indent-type",
            "Spaces",
            "--column-width",
            "80",
          }
        end
      end,
    }),
    -- Python
    -- Refer to: https://github.com/PyCQA/isort
    nls.builtins.formatting.isort,
    -- Refer to: https://github.com/psf/black
    nls.builtins.formatting.black.with({
      extra_args = { "--fast" },
    }),

    -- Shell
    nls.builtins.diagnostics.zsh,
    nls.builtins.formatting.beautysh.with({
      extra_args = { "--indent-size", "2" },
    }),
  },
}

local M = {
  config = config,
}

function M:setup(opts)
  nls.setup(vim.tbl_deep_extend("keep", self.config, opts))
end

return M
