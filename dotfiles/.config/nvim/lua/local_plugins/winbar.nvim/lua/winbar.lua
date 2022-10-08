local utils = require("utils")
local constants = require("utils.constants")

local expand = utils.expand

local icons = constants.icons

local DEFAULT_OPTS = {
  separator = icons.ui.ChevronRight,
  separator_hl = "LineNr",
  text_hl = "CursorLineNr",
  max_path_depth = 3,
  show_filepath = true,
  show_symbol = true,
  excluded_filetypes = {
    "git",
    "help",
    "packer",
    "rnvimr",
  },
}

local M = {}
local MM = {}

function MM:is_excluded()
  local ft = vim.bo.filetype
  return ft == "" or vim.tbl_contains(self.opts.excluded_filetypes, ft)
end

function MM:separator()
  local sep, sep_hl = self.opts.separator, self.opts.separator_hl
  return string.format(" %%#%s#%s%%* ", sep_hl, sep)
end

function MM:get_filepath_depth()
  local max_path_depth = self.opts.max_path_depth
  local winnr = vim.api.nvim_get_current_win()
  local winwidth = vim.api.nvim_win_get_width(winnr)

  if winwidth > 150 then
    return max_path_depth
  elseif winwidth > 120 then
    return max_path_depth > 2 and 2 or max_path_depth
  elseif winwidth > 100 then
    return max_path_depth > 1 and 1 or max_path_depth
  elseif winwidth > 70 then
    return 1
  else
    return 0
  end
end

function MM:get_filepath()
  local show_filepath, text_hl = self.opts.show_filepath, self.opts.text_hl
  local max_path_depth = self:get_filepath_depth()

  if max_path_depth == 0 or not show_filepath then
    return
  end

  local head = expand("%:h")

  if head == "" or head == "." then
    return
  end

  local splitted = vim.split(head, "/")
  local paths = {}

  for i = #splitted, 1, -1 do
    if #paths < max_path_depth then
      table.insert(paths, 1, string.format("%%#%s#%s%%*", text_hl, splitted[i]))
    else
      local prefix = string.format("%%#%s#%s%%*", text_hl, icons.ui.EllipsisH)
      table.insert(paths, 1, prefix .. " ")
      break
    end
  end

  table.insert(self.elements, table.concat(paths, self:separator()))
end

function MM:get_filename()
  local name, ext = expand("%:t"), expand("%:e")

  if name == "" then
    return
  end

  local status_ok, devicons = pcall(require, "nvim-web-devicons")

  local icon = nil
  local color, hl = "", self.opts.text_hl
  if status_ok then
    icon, color = devicons.get_icon(name, ext, { default = true })
  end

  icon = string.format("%%#%s#%s%%*", color, icon)
  name = string.format("%%#%s#%s%%*", hl, name)

  table.insert(self.elements, icon .. " " .. name)
end

function MM:get_symbol_node()
  local status_ok, winbar = pcall(require, "lspsaga.symbolwinbar")
  if not status_ok or not self.opts.show_symbol then
    return
  end

  local symbol_node = winbar.get_symbol_node()

  if symbol_node ~= "" then
    table.insert(self.elements, symbol_node)
  end
end

local set_winbar = function(value)
  pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
end

function M.render_winbar(opts)
  MM.opts = setmetatable(opts or {}, {
    __index = function(_, key)
      return DEFAULT_OPTS[key]
    end,
  })

  if MM:is_excluded() then
    set_winbar("")
    return
  end

  MM.elements = {}

  MM:get_filepath()
  MM:get_filename()
  MM:get_symbol_node()

  if #MM.elements > 0 then
    set_winbar(" " .. table.concat(MM.elements, MM:separator()))
  else
    set_winbar("")
  end
end

return M
