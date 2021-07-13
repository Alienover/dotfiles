-- Reference
-- https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lua/lspconfig/flow.lua

local util = require "lspconfig/util"

local M = {
    cmd = {"yarn", "flow", "lsp"},
    filetypes = {"javascript", "javascriptreact", "javascript.jsx"},
    root_dir = util.root_pattern(".flowconfig")
}

-- require "lspconfig".flow.setup(M)
return M
