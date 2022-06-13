-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local utils = require("utils")
local constants = require("utils.constants")

local o, expand = utils.o, utils.expand

local c, icons = constants.colors, constants.icons

local spellcheck = {
  function()
    if o.spell then
      return ("%s [%s]"):format(icons.ui.Language, o.spelllang)
    end

    return ""
  end,
}

local function filename()
  local devicons = require("nvim-web-devicons")

  local name, ext = expand("%:t"), expand("%:e")

  if name == "" then
    return ""
  end

  local icon, color = devicons.get_icon(name, ext, { default = true })

  return "%#"
    .. color
    .. "#"
    .. icon
    .. " "
    .. "%*"
    .. "%#CursorLineNr#"
    .. name
    .. "%*"
end

local function gps_location()
  local gps = require("nvim-gps")
  local location = ""
  if gps.is_available() then
    location = gps.get_location()
  end

  return location
end

local diff = {
  "diff",
  diff_color = {
    added = { fg = c.GREEN },
    modified = { fg = c.DARK_YELLOW },
    removed = { fg = c.DARK_RED },
  },
  symbols = {
    added = icons.git.Add .. " ",
    modified = icons.git.Mod .. " ",
    removed = icons.git.Remove .. " ",
  },
  separator = "",
}

local spaces = {
  function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  separator = "",
}

require("lualine").setup({
  options = {
    -- Theme
    theme = "tokyonight",

    -- Icons
    icons_enabled = true,

    -- Global line
    globalstatus = true,

    -- Symbols
    symbols = {
      error = icons.ERROR,
      warn = icons.WARN,
      info = icons.INFOR,
      hint = icons.HINT,
    },
    -- Separators
    component_separators = {
      left = icons.ui.ChevronRight,
      right = icons.ui.ChevronLeft,
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = {
          left = icons.ui.HalfCircleLeft,
          right = icons.ui.TriangleRight,
        },
      },
    },
    lualine_b = {
      "branch",
      "diagnostics",
    },
    lualine_c = {
      spellcheck,
      filename,
      gps_location,
    },
    lualine_x = { diff, "filetype" },
    lualine_y = { "encoding", spaces },
    lualine_z = {
      {
        "location",
        separator = {
          left = icons.ui.TriangelLeft,
          right = icons.ui.HalfCircleRight,
        },
      },
    },
  },
})
