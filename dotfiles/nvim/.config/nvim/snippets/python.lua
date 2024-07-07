local ls = require("luasnip")

return {
  ls.parser.parse_snippet(
    "py-header",
    table.concat({
      "#! /usr/bin/env python",
      "# -*- coding:utf-8 -*-",
      "",
      "",
    }, "\n")
  ),
}
