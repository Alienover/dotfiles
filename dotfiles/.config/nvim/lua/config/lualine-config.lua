-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local Utils = require "utils"

local c = Utils.colors

require "lualine".setup {
    options = {
        theme = "tokyonight",
        -- theme = "onedark",
        color_added = c.GREEN,
        color_removed = c.DARK_RED,
        color_modified = c.DARK_YELLOW,
        symbols = {
            modified = "#"
        }
    },
    sections = {
        lualine_x = {"encoding", "filetype"},
        lualine_y = {"diff", "progress"}
    }
}
