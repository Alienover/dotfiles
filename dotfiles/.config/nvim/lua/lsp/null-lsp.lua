local nls = require("null-ls")
nls.config({
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
                if
                    vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. "/.prettierrc"))
                    == 1
                then
                    return {
                        "--config",
                        vim.loop.os_homedir() .. "/.prettierrc",
                    }
                end
                return {}
            end,
        }),
        -- Refer to: https://github.com/mantoni/eslint_d.js
        nls.builtins.diagnostics.eslint_d,
        -- Json
        -- Refer to: https://github.com/rhysd/fixjson
        nls.builtins.formatting.fixjson,
        -- Lua
        -- Refer to: https://github.com/JohnnyMorganz/StyLua
        nls.builtins.formatting.stylua.with({
            extra_args = {
                "--indent-type",
                "Spaces",
                "--column-width",
                "80",
            },
        }),
        -- Python
        -- Refer to: https://github.com/PyCQA/isort
        nls.builtins.formatting.isort,
        -- Refer to: https://github.com/psf/black
        nls.builtins.formatting.black,
    },
})

local M = {}

return M
