local utils = require("utils")
local nls = require("null-ls")

local g = utils.g

local config = {
  debounce = 150,
  default_timeout = 5000,
  save_after_format = false,
  diagnostics_format = "[#{s}] #{m}",
  sources = {
    -- JavaScript
    -- Faster prettier
    -- Reter to: https://github.com/mikew/prettier_d_slim
    nls.builtins.formatting.prettier_d_slim.with({
      extra_args = function()
        if vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. "/.prettierrc")) == 1 then
          return {
            "--config",
            vim.loop.os_homedir() .. "/.prettierrc",
          }
        end
        return {}
      end,
    }),
    -- Refer to: https://github.com/mantoni/eslint_d.js
    nls.builtins.diagnostics.eslint_d.with({
      extra_args = function()
        if vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. "/.eslintrc")) == 1 then
          return {
            "--no-eslintrc",
            "--env",
            "es6",
          }
        end
        return {}
      end,
    }),
    -- Json
    -- Refer to: https://github.com/rhysd/fixjson
    nls.builtins.formatting.fixjson,
    -- Lua
    -- Refer to: https://github.com/JohnnyMorganz/StyLua
    nls.builtins.formatting.stylua.with({
      extra_args = {
        "--indent-width",
        "2",
        "--indent-type",
        "Spaces",
        "--column-width",
        "80",
      },
    }),
    -- Python
    -- Refer to: https://github.com/PyCQA/isort
    nls.builtins.formatting.isort.with({
      command = g.python3_venv_home .. "/bin/isort",
    }),
    -- Refer to: https://github.com/psf/black
    nls.builtins.formatting.black.with({
      command = g.python3_venv_home .. "/bin/black",
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
