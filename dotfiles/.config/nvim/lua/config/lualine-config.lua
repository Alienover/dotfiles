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
  local status_ok, devicons = pcall(require, "nvim-web-devicons")
  if not status_ok then
    return ""
  end

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

local function filetype()
  local status_ok, devicons = pcall(require, "nvim-web-devicons")
  if not status_ok then
    return ""
  end

  local name, ext = expand("%:t"), expand("%:e")
  if ext == "" then
    return ""
  end

  local icon, color = devicons.get_icon(name, ext, { default = true })
  icon = "%#" .. color .. "#" .. icon .. "%*"

  local ft = constants.filetype_mappings[vim.bo.filetype]

  return icon .. " " .. ft
end

local function encoding()
  return vim.opt.fileencoding:get():upper()
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
    return "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  separator = "",
}

local config = {
  options = {
    -- Theme
    theme = "catppuccin",

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
      diff,
    },
    lualine_c = {
      spellcheck,
      filename,
    },
    lualine_x = { "diagnostics", filetype },
    lualine_y = { encoding, spaces },
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
}

require("lualine").setup(config)
