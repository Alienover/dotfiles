local ls = require("luasnip")

local u = require("utils.snippets")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node

return {
  s({
    trig = "date",
    name = "Date",
    dscr = "Date in the form of %Y-%m-%d",
  }, {
    u.date(),
  }),

  s({
    trig = "date1",
    name = "Date",
    dscr = "Date in the form of %Y-%m-%d %H:%M:%S",
  }, {
    u.date("%Y-%m-%d %H:%M:%S"),
  }),
}
