local Utils = require("utils")

local g, cmd = Utils.g, Utils.cmd

-- Keybindings for snippets expand, jumpping forward or backward
cmd([[
    imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
    smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

    imap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
    smap <expr> <C-h>   vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
]])

-- Directory to save the custom snippets
g.vsnip_snippet_dir = Utils.files.snippets_dir
