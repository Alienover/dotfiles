local utils = require("utils")
local constants = require("utils.constants")

local expand = utils.expand

local icons = constants.icons

local SEPARATOR = string.format(" %%#LineNr#%s%%* ", icons.ui.ChevronRight)

local DEFAULT_OPTS = {
  separator = icons.ui.ChevronRight,
  separator_hl = "LineNr",
  text_hl = "CursorLineNr",
  max_path_depth = 4,
  show_filepath = true,
  show_gps = true,
  excluded_filetypes = {
    "git",
    "help",
    "packer",
  },
}

local M = {}

local is_excluded = function(opts)
  local ft = vim.bo.filetype
  return ft == "" or vim.tbl_contains(opts.excluded_filetypes, ft)
end

local set_winbar = function(value)
  pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
end

local separator = function(opts)
  return string.format(" %%#%s#%s%%* ", opts.separator_hl, opts.separator)
end

local get_filepath_depth = function(opts)
  local winwidth = vim.api.nvim_win_get_width(0)

  if winwidth > 150 then
    return opts.max_path_depth
  elseif winwidth > 120 then
    return opts.max_path_depth > 3 and 3 or opts.max_path_depth
  elseif winwidth > 100 then
    return opts.max_path_depth > 2 and 2 or opts.max_path_depth
  elseif winwidth > 70 then
    return 1
  else
    return 0
  end
end

function M.get_filepath(opts)
  if opts.max_path_depth == 0 then
    return ""
  end

  local head = expand("%:h")

  if head == "" or head == "." then
    return ""
  end

  local splitted = vim.split(head, "/")
  local paths = {}

  for i = #splitted, 1, -1 do
    if #paths < opts.max_path_depth then
      table.insert(
        paths,
        #splitted - i + 1,
        string.format("%%#%s#%s%%*", opts.text_hl, splitted[i])
      )
    else
      local prefix = string.format(
        "%%#%s#%s%%*",
        opts.text_hl,
        icons.ui.EllipsisH
      )
      table.insert(paths, 1, prefix .. " ")
      break
    end
  end

  return table.concat(paths, separator(opts))
end

function M.get_filename(opts)
  opts = opts or {}

  local name, ext = expand("%:t"), expand("%:e")

  if name == "" then
    return ""
  end

  local status_ok, devicons = pcall(require, "nvim-web-devicons")

  local icon = nil
  local color, hl = "", opts.text_hl
  if status_ok then
    icon, color = devicons.get_icon(name, ext, { default = true })
  end

  icon = string.format("%%#%s#%s%%*", color, icon)
  name = string.format("%%#%s#%s%%*", hl, name)

  return icon .. " " .. name
end

function M.get_gps_location()
  local status_ok, gps = pcall(require, "nvim-gps")
  local location = ""
  if status_ok and gps.is_available() then
    location = gps.get_location()
  end

  return location
end

function M.get_winbar(opts)
  opts = setmetatable(opts or {}, {
    __index = function(_, key)
      return DEFAULT_OPTS[key]
    end,
  })

  if is_excluded(opts) then
    set_winbar("")
    return
  end

  opts.max_path_depth = get_filepath_depth(opts)

  local winbar = {}

  local filename = M.get_filename(opts)

  if filename == "" then
    set_winbar("")
    return
  else
    table.insert(winbar, filename)
  end

  if opts.show_filepath then
    local filepath = M.get_filepath(opts)
    if filepath ~= "" then
      table.insert(winbar, 1, filepath)
    end
  end

  if opts.show_gps then
    local gps = M.get_gps_location()

    if gps ~= "" then
      table.insert(winbar, gps)
    end
  end

  if #winbar > 0 then
    set_winbar(" " .. table.concat(winbar, SEPARATOR))
  else
    set_winbar("")
  end
end

return M
