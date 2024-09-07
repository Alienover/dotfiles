local consts = require("utils.constants")

local window_sizing = consts.window_sizing

local M = {}

---@alias KeymapMode string | string[]
---@alias KeymapLHS string
---@alias KeymapRHS string | fun(): nil
---@alias KeymapOPTs string|table|nil
---
---@param keymaps {[1]: KeymapMode, [2]: KeymapLHS, [3]: KeymapRHS, [4]: KeymapOPTs}[]
M.create_keymaps = function(keymaps)
  for _, keymap in ipairs(keymaps) do
    local modes, lhs, rhs, opts = unpack(keymap)

    M.map(modes, lhs, rhs, opts)
  end
end

---@alias CommandOPTName 'desc' | string
---@param commands {[1]: string, [2]: ( fun(): nil ), [3]: table<CommandOPTName, any>|nil}[]
M.create_commands = function(commands)
  for _, command in ipairs(commands) do
    local name, handler, opts = unpack(command)

    vim.api.nvim_create_user_command(
      name,
      handler,
      vim.tbl_extend("force", {
        desc = "User Command: " .. name,
      }, opts or {})
    )
  end
end

M.log = function(msg, level, name)
  name = name or "Neovim"

  local output = string.format("%s: %s", name, msg)
  vim.notify(output, level)
end

M.warn = function(msg, name)
  M.log(msg, vim.log.levels.WARN, name)
end

M.error = function(msg, name)
  M.log(msg, vim.log.levels.ERROR, name)
end

M.info = function(msg, name)
  M.log(msg, vim.log.levels.INFO, name)
end

M.o = vim.o
-- Local to buffer
M.bo = vim.bo
-- Buffer-scoped variables
M.b = vim.b
-- Local to window
M.wo = vim.wo
-- Window-scoped variables
M.w = vim.w
-- Global variables
M.g = vim.g
-- Tabpage-scope variables
M.t = vim.t
-- Vim command
M.cmd = vim.cmd

---@param expr string
M.expand = function(expr)
  ---@diagnostic disable-next-line: param-type-mismatch
  local resp = vim.fn.expand(expr, false, false)
  if type(resp) == "table" then
    return resp[1]
  else
    return resp
  end
end

---@param mode string|table
---@param key string
---@param cmd string|function
---@param opts string|table|nil
M.map = function(mode, key, cmd, opts)
  if type(opts) == "string" then
    opts = { desc = opts }
  end

  opts = vim.tbl_deep_extend(
    "force",
    { noremap = true, silent = true, desc = "User Keymap: " .. key },
    opts or {}
  )

  vim.keymap.set(mode, key, cmd, opts)
end

--- Populate the mode-preseted map func for `nmap`, `imap`, `tmap`, `vmap`, `smap`, `xmap`
for _, mode in ipairs({ "n", "i", "t", "v", "s", "x" }) do
  M[mode .. "map"] = function(...)
    M.map(mode, ...)
  end
end

M.r_code = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.table_map_values = function(input_table, func)
  local new_table = {}
  for key, value in pairs(input_table) do
    new_table[key] = func(value, key)
  end

  return new_table
end

M.table_map_list = function(input_table, func)
  local new_list = {}
  for i, value in ipairs(input_table) do
    new_list[i] = func(value, i)
  end

  return new_list
end

M.get_window_sepc = function()
  return {
    columns = vim.api.nvim_get_option_value("columns", {}),
    lines = vim.api.nvim_get_option_value("lines", {}),
  }
end

M.get_window_default_spacing = function(width, height)
  local l, t = 0.25, 0.25
  local win_spec = M.get_window_sepc()

  width = width or win_spec.columns
  height = height or win_spec.lines

  if width <= window_sizing.md.width then
    l = 0.1
  end

  if height <= window_sizing.md.height then
    t = 0.1
  end

  return { l = l, t = t }
end

---@param args ?table
---@return table
M.get_float_win_opts = function(args)
  args = args or {}
  local win_spec = M.get_window_sepc()
  local default_offset =
    M.get_window_default_spacing(win_spec.columns, win_spec.lines)

  local l_offset, t_offset =
    args.l_offset or default_offset.l, args.t_offset or default_offset.t

  local border = args.border
  args.border = nil

  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.tbl_deep_extend("force", {
    row = math.floor(t_offset * win_spec.lines),
    col = math.floor(l_offset * win_spec.columns),
    height = math.floor((1 - t_offset * 2) * win_spec.lines),
    width = math.floor((1 - l_offset * 2) * win_spec.columns),
    style = "minimal",
    relative = "editor",
    border = border and {
      "╭",
      "─",
      "╮",
      "│",
      "╯",
      "─",
      "╰",
      "│",
    },
  }, args)
end

M.get_float_win_sizing = function()
  local spec = M.get_window_sepc()
  local win_opts = M.get_float_win_opts()

  return {
    width = tonumber(string.format("%0.2f", win_opts.width / spec.columns)),
    height = tonumber(string.format("%0.2f", win_opts.height / spec.lines)),
  }
end

M.is_inside_git_repo = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

---@param path string
---@return string?
M.find_git_ancestor = function(path)
  local cmd = string.format("git -C %s rev-parse --show-toplevel", path)

  local result = vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    ---INFO: remove tailing new-line
    result = string.gsub(result, "\n$", "")
    return result
  end

  return nil
end

M.change_cwd = function()
  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
  local head = vim.fn.expand("%:p:h")
  local git_ancestor = M.find_git_ancestor(head) or head
  local cwd = vim.fn.getcwd()

  if cwd ~= git_ancestor then
    cwd = git_ancestor
  end

  local ok, _ = pcall(vim.fn.execute, "lcd " .. cwd, true)

  if ok then
    local formatted, home = cwd, os.getenv("HOME")
    if home then
      formatted = string.gsub(cwd, home, "~")
    end

    vim.notify("Set the current working directory to " .. formatted)
  else
    vim.notify(
      "Failed to set the current working directory",
      vim.log.levels.WARN
    )
  end
end

M.highlight = {
  names = {},
}

function M.highlight:get(name)
  return self.names[name]
end

function M.highlight:set(name, hl_name)
  self.names[name] = hl_name
end

function M.highlight:has(name)
  return self.names[name] and true or false
end

function M.highlight:create(name, opts)
  local hl_name = "MyCustomHighlight_" .. name

  if self:has(name) then
    return self:get(name)
  end

  if type(opts) == "table" then
    vim.api.nvim_set_hl(
      0,
      hl_name,
      { fg = opts.fg, bg = opts.bg, style = opts.style }
    )

    self:set(name, hl_name)
  end

  return hl_name
end

function M.highlight:format(args)
  local prefix = ""
  if type(args) == "table" then
    if args.name ~= nil and self:has(args.name) then
      prefix = "%#" .. self:get(args.name) .. "#"
    elseif args.hl_name ~= nil then
      prefix = "%#" .. args.hl_name .. "#"
    end

    return prefix .. args[1]
  else
    return ""
  end
end

M.file_existed = function(path)
  ---@diagnostic disable-next-line: missing-parameter
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

--- Setup vim options by given list
---@param options table
M.setup_options = function(options)
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
end

--- Setup vim global variables
---@param global table
M.setup_global = function(global)
  for k, v in pairs(global) do
    vim.g[k] = v
  end
end

--- Setup custom filetyps
---@param filetypes vim.filetype.add.filetypes
M.setup_filetypes = function(filetypes)
  if vim.filetype then
    vim.filetype.add(filetypes)
  end
end

M.telescope = function(cmd, opts)
  local flags = {}
  opts = opts or {}

  local win_spec = M.get_window_sepc()
  if win_spec.columns < window_sizing.md.width then
    opts.theme = "dropdown"
    opts.previewer = false
  end

  for k, v in pairs(opts) do
    table.insert(
      flags,
      type(k) == "number" and v or string.format("%s=%s", k, v)
    )
  end

  M.cmd(string.format("%s %s %s", "Telescope", cmd, table.concat(flags, " ")))
end

M.buffer_is_big = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local max_filesize = 100 * 1024 -- 100 KB

  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

--- Zoom in/out the focused pane
M.zoom = function()
  local var_name = "zoom_winrestcmd"
  local winnr = vim.api.nvim_get_current_win()

  ---@type string?
  local winrestcmd = vim.fn.getwinvar(winnr, var_name, "")

  if winrestcmd and #winrestcmd > 0 then
    M.cmd(winrestcmd)
    vim.api.nvim_win_del_var(winnr, var_name)
  else
    vim.api.nvim_win_set_var(winnr, var_name, vim.fn.winrestcmd())

    -- INFO: expand the current pane
    M.cmd([[resize]])
    M.cmd([[vertical resize]])
  end
end

---@generic T
---@param module_name  string
---@return `T`
M.LazyRequire = function(module_name)
  return setmetatable({
    __module_name = module_name,
    __module = false,
  }, {
    __index = function(ctx, key)
      if not ctx.__module then
        ---@type boolean, T
        local status_ok, module = pcall(require, ctx.__module_name)
        if not status_ok then
          vim.notify(
            string.format("Failed to load module: %s", ctx.__module_name),
            vim.log.levels.ERROR
          )
          return nil
        end

        ctx.__module = module
      end

      return ctx.__module[key]
    end,
  })
end

---
---@param name string
---@param mock_fun  fun(): table
M.MockPackage = function(name, mock_fun)
  package.preload[name] = function()
    local mock_pkg = mock_fun()

    if package.loaded[name] == nil then
      package.preload[name] = function()
        return mock_pkg
      end
    else
      package.loaded[name] = mock_pkg
    end

    return mock_pkg
  end
end

return M
