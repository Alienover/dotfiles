-- lua_language_server installation guide
-- Reference:
-- https://github.com/kabouzeid/nvim-lspinstall/blob/main/lua/lspinstall/servers/lua.lua
--
-- Related commands
-- curl -L -o sumneko-lua.vsix $(curl -s https://api.github.com/repos/sumneko/vscode-lua/releases/latest | grep 'browser_' | cut -d\" -f4)
-- rm -rf sumneko-lua
-- unzip sumneko-lua.vsix -d sumneko-lua
-- rm sumneko-lua.vsix
-- chmod +x sumneko-lua/extension/server/bin/$platform/lua-language-server

return require("lua-dev").setup({
    lspconfig = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
            },
        },
    },
})

-- local M = {}

-- M = {
--     cmd = lua_cmd,
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = "LuaJIT",
--                 -- Setup your lua path
--                 path = (function()
--                     local path = vim.split(package.path, ";")
--                     table.insert(path, "lua/?.lua")
--                     table.insert(path, "lua/?/?.lua")
--                     return path
--                 end)()
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = {"vim"}
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file("", true),
--                 checkThirdParty = false
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false
--             }
--         }
--     }
-- }

-- return M
