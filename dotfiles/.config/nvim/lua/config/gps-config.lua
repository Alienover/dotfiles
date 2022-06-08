local gps = require("nvim-gps")
local constants = require("utils.constants")

local icons = constants.icons

local hl_groups = {
  ["function"] = "CmpItemKindFunction",
  class = "CmpItemKindClass",
  field = "CmpItemKindField",
  keyword = "CmpItemKindKeyword",
  method = "CmpItemKindMethod",
  module = "CmpItemKindModule",
  property = "CmpItemKindProperty",
  value = "CmpItemKindValue",
}

local function make_icon(hl, icon)
  return "%#" .. hl .. "#" .. icon .. "%*" .. " "
end

local config = {
  text_hl = "CursorLineNr",
  icons = {
    ["array-name"] = make_icon(hl_groups.property, icons.type.Array),
    ["boolean-name"] = make_icon(hl_groups.value, icons.type.Boolean),
    -- Classes and class-like objects
    ["class-name"] = make_icon(hl_groups.class, icons.kind.Class),
    --Containers (example: lua.tables )
    ["container-name"] = make_icon(hl_groups.property, icons.type.Object),
    ["date-name"] = make_icon(hl_groups.value, icons.ui.Calendar),
    ["date-time-name"] = make_icon(hl_groups.value, icons.ui.Table),
    ["float-name"] = make_icon(hl_groups.value, icons.type.Number),
    --Functions
    ["function-name"] = make_icon(hl_groups["function"], icons.kind.Function),
    ["inline-table-name"] = make_icon(hl_groups.property, icons.ui.Calendar),
    ["integer-name"] = make_icon(hl_groups.value, icons.type.Number),
    ["mapping-name"] = make_icon(hl_groups.property, icons.type.Object),
    --Methods (functions inside class-like objects)
    ["method-name"] = make_icon(hl_groups.method, icons.kind.Method),
    ["module-name"] = make_icon(hl_groups.module, icons.kind.Module),
    ["null-name"] = make_icon(hl_groups.field, icons.kind.Field),
    ["number-name"] = make_icon(hl_groups.value, icons.type.Number),
    ["object-name"] = make_icon(hl_groups.property, icons.type.Object),
    ["sequence-name"] = make_icon(hl_groups.property, icons.type.Array),
    ["string-name"] = make_icon(hl_groups.value, icons.type.String),
    ["table-name"] = make_icon(hl_groups.property, icons.ui.Table),
    --Tags (example: html tags )
    ["tag-name"] = make_icon(hl_groups.keyword, icons.misc.Tag),
    ["time-name"] = make_icon(hl_groups.value, icons.misc.Watch),
  },
}

gps.setup(config)
