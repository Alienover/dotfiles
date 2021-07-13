local Utils = require "utils"

local w, cmd = Utils.w, Utils.cmd
local nmap, vmap, tmap = Utils.nmap, Utils.vmap, Utils.tmap

local opts = {noremap = true, silent = true}

-- Reload the config file
nmap("<leader>r", ":source " .. Utils.files.nvim .. "<CR>", opts)

-- Buffers navigation
nmap("<C-h>", ":bp<CR>", opts)
nmap("<C-l>", ":bn<CR>", opts)

-- Open  nvim terminal in split or vertival split
nmap("<C-t>", ":terminal<CR>i", opts)

-- Unfocus the terminal window
tmap("<leader><ESC>", "<C-\\><C-n>", opts)

-- Move lines in <Normal> and <Visual>
-- ∆ for <Option-j> up and ˚ for <Option-k> down
nmap("∆", ":m .+1<CR>==", opts)
nmap("˚", ":m .-2<CR>==", opts)
vmap("∆", ":m '>+1<CR>gv=gv", opts)
vmap("˚", ":m '<-2<CR>gv=gv", opts)

-- Diff mode
cmd [[
    if &diff
	nnoremap <silent> [c [c zz
	nnoremap <silent> ]c ]c zz
    endif
]]

function _G.zoom_toogle()
    if w.zoomed and w.zoom_winrestcmd then
        cmd [[ execute w:zoom_winrestcmd ]]
        w.zoomed = false
    else
        w.zoom_winrestcmd = vim.fn.winrestcmd()
        cmd [[resize]]
        cmd [[vertical resize]]
        w.zoomed = true
    end
    return true
end

nmap("zo", "v:lua.zoom_toogle()", {expr = true, silent = true})
