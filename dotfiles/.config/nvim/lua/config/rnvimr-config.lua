local Utils = require "utils"

local g, cmd = Utils.g, Utils.cmd

local nmap = Utils.nmap

-- Make Ranger replace netrw and be the file explorer
-- let g:rnvimr_vanilla = 1
g.rnimr_ex_enable = 1
g.rnvimr_enable_ex = 1
g.rnvimr_draw_border = 1
g.rnvimr_enable_picker = 1
g.rnvimr_enable_bw = 1
g.rnvimr_ranger_cmd = g.python3_venv_home .. "/bin/ranger"

-- Add views for Ranger to adapt the size of floating window
g.rnvimr_ranger_views = {
    {minwidth = 90, ratio = {1, 2, 3}},
    {minwidth = 50, maxwidth = 89, ratio = {1, 2}},
    {maxwidth = 49, ratio = {1}}
}

g.rnvimr_layout =
    Utils.get_float_win_opts(
    {
        {
            relative = "editor",
            style = "minimal"
        }
    }
)

-- Link CursorLine into RnvimrNormal highlight in the Floating window
cmd [[highlight link RnvimrNormal CursorLine]]

if vim.fn.executable(g.rnvimr_ranger_cmd) then
    nmap("<C-f>", "<cmd>RnvimrToggle<CR>", {noremap = true})
else
    nmap("<C-f>", "<NOP>", {noremap = true})
end
