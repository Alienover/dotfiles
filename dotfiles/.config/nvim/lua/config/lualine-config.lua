-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local utils = require("utils")
local constants = require("utils.constants")

local o = utils.o

local c, icons = constants.colors, constants.icons

local function spellcheck()
  if o.spell then
    return ("SPELL [%s]"):format(o.spelllang)
  end

  return ""
end

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
    lualine_a = {
      {
        "mode",
        separator = { left = "", right = "" },
      },
    },
    lualine_c = {
      spellcheck,
      "filename",
    },
    lualine_x = { "encoding", "filetype" },
    lualine_z = {
      {
        "location",
        separator = { left = "", right = "" },
      },
    },
  },
})
