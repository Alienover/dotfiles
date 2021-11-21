-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local Utils = require("utils")

local c, icons = Utils.colors, Utils.icons

require("lualine").setup({
    options = {
        theme = "tokyonight",
        -- theme = "onedark",
        color_added = c.GREEN,
        color_removed = c.DARK_RED,
        color_modified = c.DARK_YELLOW,
        symbols = {
            error = icons.ERROR,
            warn = icons.WARN,
            info = icons.INFOR,
            hint = icons.HINT,
            modified = "#",
        },
    },
    sections = {
        lualine_x = { "encoding", "filetype" },
    },
})
