-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local utils = require("utils")
local constants = require("utils.constants")

local o = utils.o

local c, icons = constants.colors, constants.icons

local function spellcheck()
  if o.spell then
    return (" [%s]"):format(o.spelllang)
local function gps_location()
  local gps = require("nvim-gps")
  local location = ""
  if gps.is_available() then
    location = gps.get_location()
  end

  return location
end

require("lualine").setup({
  options = {
    -- Theme
    theme = "tokyonight",

    -- Icons
    icons_enabled = true,

    -- Colors
    color_added = c.GREEN,
    color_removed = c.DARK_RED,
    color_modified = c.DARK_YELLOW,

    -- Global line
    globalstatus = true,

    -- Symbols
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
      filename,
      gps_location,
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
