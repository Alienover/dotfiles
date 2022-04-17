local ls = require("luasnip")

return {
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n\t$0\nend"),
}
