local ls = require("luasnip")

local f = ls.function_node

local M = {}

--- Returns current date with given format
---@param fmt string
---@overload fun(): string
---@overload fun(fmt: string): string
M.date = function(fmt)
  local fn = function(_, _, arg)
    return os.date(arg)
  end

  fmt = fmt or "%Y-%m-%d"
  return f(fn, {}, { user_args = { fmt } })
end

return M
