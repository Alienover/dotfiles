-- Reference
-- https://github.com/mattn/efm-langserver

local prettier = {
    formatStdin = true,
    formatCommand = (function()
        local prettier_bin = ""
        -- Find the prettier config under current working dir
        -- Otherwise use the common config under home dir
        if not vim.fn.empty(vim.fn.glob(vim.loop.cwd() .. "/.prettierrc")) then
            prettier_bin = vim.loop.cwd() .. "/node_modules/.bin/prettier"
        else
            prettier_bin = "prettier --config " .. vim.loop.os_homedir() .. "/.prettierrc"
        end

        print(prettier_bin)

        return prettier_bin .. " --stdin-filepath ${INPUT}"
    end)()
}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"}
}

local luafmt = {
    formatStdin = true,
    formatCommand = "luafmt --stdin ${INPUT}"
}

local M = {
    init_options = {documentFormatting = true},
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "css",
        "html",
        "json",
        "lua"
    },
    settings = {
        rootMarkers = {".git/", "package.json"},
        languages = {
            javascript = {eslint, prettier},
            javascriptreact = {eslint, prettier},
            ["javascript.jsx"] = {eslint, prettier},
            typescript = {eslint, prettier},
            typescriptreact = {eslint, prettier},
            ["typescript.tsx"] = {eslint, prettier},
            css = {prettier},
            html = {prettier},
            json = {prettier},
            lua = {luafmt}
        }
    }
}

-- require "lspconfig".efm.setup(M)
return M
