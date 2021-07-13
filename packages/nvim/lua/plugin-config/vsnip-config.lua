local Utils = require "utils"

local g = Utils.g

local imap, smap, xmap = Utils.imap, Utils.smap, Utils.xmap

local opts = {expr = true, silent = true}

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.vsnip_expand_or_jump()
    if vim.fn.call("vsnip#available", {1}) then
        return t "<Plug>(vsnip-expand-or-jump)"
    else
        return t "<C-l>"
    end
end

imap("<C-l>", "v:lua.vsnip_expand_or_jump()", opts)
smap("<C-l>", "v:lua.vsnip_expand_or_jump()", opts)

xmap("<C-l>", "<Plug>(vsnip-select-text)", {})
xmap("<C-l>", "<Plug>(vsnip-cut-text)", {})

g.vsnip_snippet_dir = Utils.snippets_dir
