local M = {}

M.log = function(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

M.warn = function(msg, name)
  M.log(msg, "DiagnosticWarn", name)
end

M.error = function(msg, name)
  M.log(msg, "DiagnosticError", name)
end

M.info = function(msg, name)
  M.log(msg, "DiagnosticInfo", name)
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

local map = function(mode, key, cmd, opts)
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})

  if opts.buffer ~= nil then
    local buffer = opts.buffer
    opts.buffer = nil

    vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
  else
    vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

M.nmap = function(...)
  map("n", ...)
end

M.imap = function(...)
  map("i", ...)
end

M.tmap = function(...)
  map("t", ...)
end

M.vmap = function(...)
  map("v", ...)
end

M.smap = function(...)
  map("s", ...)
end

M.xmap = function(...)
  map("x", ...)
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

  vim.cmd([[packadd nvim-lspconfig]])

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
  vim.cmd(table.concat(autocmd, " "))
  vim.cmd([[startinsert]])
end
return M
