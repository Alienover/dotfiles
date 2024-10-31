local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node

local date = function(fmt)
	local fn = function(_, _, arg)
		return os.date(arg)
	end

	fmt = fmt or "%Y-%m-%d"
	return f(fn, {}, { user_args = { fmt } })
end

return {
	s({
		trig = "date",
		name = "Date",
		dscr = "Date in the form of %Y-%m-%d",
	}, {
		date(),
	}),

	s({
		trig = "date1",
		name = "Date",
		dscr = "Date in the form of %Y-%m-%d %H:%M:%S",
	}, {
		date("%Y-%m-%d %H:%M:%S"),
	}),
}
