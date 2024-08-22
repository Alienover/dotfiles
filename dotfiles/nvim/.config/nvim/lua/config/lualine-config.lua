-- Reference
-- https://github.com/hoob3rt/lualine.nvim
local utils = require("utils")
local icons = require("utils.icons")
local constants = require("utils.constants")

local o, expand = utils.o, utils.expand

local c = constants.colors

local spellcheck = {
  function()
    if o.spell then
      return ("%s [%s]"):format(icons.get("extended", "spell"), o.spelllang)
    end

    return ""
  end,
}

local function filename()
  local status_ok, MiniIcons = pcall(require, "mini.icons")
  if not status_ok then
    return ""
  end

  local name = expand("%:t")

  if name == "" then
    return ""
  end

  local icon, hl = MiniIcons.get("file", name)

  return "%#"
    .. hl
    .. "#"
    .. icon
    .. " "
    .. "%*"
    .. "%#CursorLineNr#"
    .. name
    .. "%*"
end

local function filetype()
  local status_ok, MiniIcons = pcall(require, "mini.icons")
  if not status_ok then
    return ""
  end

  local ext = expand("%:e")
  if ext == "" then
    return ""
  end

  local icon, color = MiniIcons.get("filetype", ext)
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
    added = icons.get("git", "add") .. " ",
    modified = icons.get("git", "modified") .. " ",
    removed = icons.get("git", "remove") .. " ",
  },
  separator = "",
}

local spaces = {
  function()
    --- @type boolean
    local expandTab =
      vim.api.nvim_get_option_value("expandtab", { scope = "local" })

    if expandTab then
      local siftWidth =
        vim.api.nvim_get_option_value("shiftwidth", { scope = "local" })

      if siftWidth ~= 0 then
        return "Spaces: " .. siftWidth
      end
    else
      local tabStop =
        vim.api.nvim_get_option_value("tabstop", { scope = "local" })

      if tabStop ~= 0 then
        return "Tabs: " .. tabStop
      end
    end

    return " "
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
      error = icons.get("extended", "error") .. " ",
      warn = icons.get("extended", "warn") .. " ",
      info = icons.get("extended", "info") .. " ",
      hint = icons.get("extended", "hint") .. " ",
    },
    -- Separators
    component_separators = {
      left = icons.get("extended", "arrowRight"),
      right = icons.get("extended", "arrowLeft"),
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = {
          left = icons.get("extended", "halfCircleLeft"),
          right = icons.get("extended", "triangleRight"),
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
          left = icons.get("extended", "triangelLeft"),
          right = icons.get("extended", "halfCircleRight"),
        },
      },
    },
  },
}

require("lualine").setup(config)
