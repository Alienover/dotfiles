local ls = require("luasnip")

print("snippets loaded")

return {
  ls.parser.parse_snippet("default", "-- Default Comment"),
}
