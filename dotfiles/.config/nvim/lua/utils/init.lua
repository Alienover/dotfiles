local M = {}

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
-- Tabpage-scipe variables
M.t = vim.t
-- Vim command
M.cmd = vim.api.nvim_command

M.expand = function(expr)
  return vim.fn.expand(expr, nil, nil)
end

M.map = function(mode, key, cmd, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

  vim.keymap.set(mode, key, cmd, opts)
end

M.nmap = function(...)
  M.map("n", ...)
end

M.imap = function(...)
  M.map("i", ...)
end

M.tmap = function(...)
  M.map("t", ...)
end

M.vmap = function(...)
  M.map("v", ...)
end

M.smap = function(...)
  M.map("s", ...)
end

M.xmap = function(...)
  M.map("x", ...)
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
    columns = vim.api.nvim_get_option("columns"),
    lines = vim.api.nvim_get_option("lines"),
  }
end

M.get_float_win_opts = function(args)
  args = args or {}
  local win_spec = M.get_window_sepc()
  local l_offset, t_offset = args.l_offset or 0.25, args.t_offset or 0.25

  local border = args.border
  args.border = nil

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

M.find_git_ancestor = function()
  local pwd = os.getenv("PWD")

  return require("lspconfig.util").find_git_ancestor(pwd)
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

function M.highlight:create(name, colors)
  local hl_name = "MyCustomHighlight_" .. name
  local command = { "highlight", hl_name }

  if self:has(name) then
    return self:get(name)
  end

  if type(colors) == "table" then
    if colors.fg then
      table.insert(command, "guifg=" .. colors.fg)
    end

    if colors.bg then
      table.insert(command, "guibg=" .. colors.bg)
    end

    M.cmd(table.concat(command, " "))

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

M.float_terminal = function(args)
  local cmd = args[1]
  args[1] = nil

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(
    buf,
    true,
    M.get_float_win_opts(vim.tbl_deep_extend("force", {
      border = true,
    }, args))
  )

  vim.fn.termopen(cmd)
  local autocmd = {
    "autocmd! TermClose <buffer> lua",
    string.format("vim.api.nvim_win_close(%d, {force = true});", win),
    string.format("vim.api.nvim_buf_delete(%d, {force = true});", buf),
  }
  M.cmd(table.concat(autocmd, " "))
  M.cmd([[startinsert]])
end

M.file_existed = function(path)
  ---@diagnostic disable-next-line: missing-parameter
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

M.require_lazy = function(pkg_name, module)
  local pkg = package.loaded[module]
  if pkg ~= nil then
    return true, pkg
  else
    M.cmd("packadd " .. pkg_name)

    return pcall(require, module)
  end
end

M.has_nvim_08 = vim.fn.has("nvim-0.8") == 1

return M
