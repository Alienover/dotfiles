local ls = require("luasnip")

local u = require("utils.snippets")

local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local t = ls.text_node

return {
  s(
    {
      trig = "meta-heading",
      name = "Meta Heading",
      dscr = "Meta info for the heading",
    },
    fmt(
      table.concat({
        "@comment",
        "  created at: {}",
        "@end",
      }, "\n"),
      { u.date() }
    )
  ),
}
