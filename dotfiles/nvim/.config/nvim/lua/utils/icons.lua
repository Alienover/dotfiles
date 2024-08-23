local utils = require("utils")

local MiniIcons = utils.LazyRequire("mini.icons")

local presets = {
  extended = {
    arrowLeft = { glyph = "<" },
    arrowRight = { glyph = ">" },

    check = { glyph = "󰄬" },
    circle = { glyph = "" },
    close = { glyph = "󰅖" },

    command = { glyph = "󰘳" },
    ellipsisH = { glyph = "" },

    halfCircleLeft = { glyph = "" },
    halfCircleRight = { glyph = "" },

    spell = { glyph = "" },

    triangelLeft = { glyph = "" },
    triangleRight = { glyph = "" },

    -- Diagnosing
    error = { glyph = "" },
    warn = { glyph = "" },
    hint = { glyph = "" },
    info = { glyph = "" },
  },
  git = {
    add = { glyph = "" },
    modified = { glyph = "" },
    remove = { glyph = "" },
  },
}

local get_impl = setmetatable({}, {
  __index = function(_, key)
    local category = presets[key]

    if category then
      return function(name)
        return category[name]
      end
    end

    return nil
  end,
})

local M = {}

---@param category  'git' | 'extended' | string Supported Categories:
--- - `git` - icon data for Git status
---
--- - `extended` - extended icons data for mini.icons
---
--- and other categories from mini.icons
--- See: https://github.com/echasnovski/mini.icons/blob/12e7b5d47bfc1b4c5ba4278fb49ec9100138df14/lua/mini/icons.lua#L334-L447
---@param name  string
---@return string?, string?, boolean
M.get = function(category, name)
  local getter = get_impl[category]

  if getter == nil then
    -- Fallback to mini.icons
    return MiniIcons.get(category, name)
  end

  local icon = getter(name)

  return icon.glyph, "", true
end

return M
