local utils = require("utils")

local g, cmd = utils.g, utils.cmd

local ranger_cmd = g.python3_venv_home .. "/bin/ranger"

-- Make Ranger replace netrw and be the file explorer
g.rnvimr_enable_ex = 1
g.rnvimr_draw_border = 1
g.rnvimr_enable_picker = 1
g.rnvimr_enable_bw = 1
g.rnvimr_ranger_cmd = { ranger_cmd }

-- Add views for Ranger to adapt the size of floating window
g.rnvimr_ranger_views = {
  { minwidth = 90, ratio = { 1, 2, 3 } },
  { minwidth = 50, maxwidth = 89, ratio = { 1, 2 } },
  { maxwidth = 49, ratio = { 1 } },
}

g.rnvimr_layout = utils.get_float_win_opts()

-- Link CursorLine into RnvimrNormal highlight in the Floating window
cmd([[highlight link RnvimrNormal CursorLine]])

if vim.fn.executable(ranger_cmd) then
  vim.keymap.set({ "n" }, "<C-f>", function()
    cmd("RnvimrToggle")
  end, { silent = true })
end
