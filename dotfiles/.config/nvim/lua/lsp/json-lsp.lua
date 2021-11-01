-- Reference:
-- https://github.com/elianiva/dotfiles/blob/master/nvim/lua/modules/lsp/json.lua

local M = {
    cmd = {"vscode-json-language-server", "--stdio"},
    filetypes = {"json", "jsonc"},
    settings = {
        json = {
            -- Find more schemas from: https://www.schemastore.org/json/
            schemas = {
                {
                    fileMatch = {"package.json"},
                    url = "https://json.schemastore.org/package.json"
                },
                {
                    fileMatch = {"tsconfig*.json"},
                    url = "https://json.schemastore.org/tsconfig.json"
                },
                {
                    fileMatch = {
                        ".prettierrc",
                        ".prettierrc.json",
                        "prettier.config.json"
                    },
                    url = "https://json.schemastore.org/prettierrc.json"
                },
                {
                    fileMatch = {".eslintrc", ".eslintrc.json"},
                    url = "https://json.schemastore.org/eslintrc.json"
                }
            }
        }
    }
}

return M
