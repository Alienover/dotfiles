local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

local function date(_, _)
	return os.date("%Y-%m-%d")
end

return {
	s({ trig = "/done", name = "Task: Done" }, { t("[completion:: "), f(date), t("]") }),

	s({ trig = "/due", name = "Task: Due" }, { t("[due:: "), i(1), t("]") }),

	s({ trig = "/cancelled", name = "Task: Cancel" }, { t("[cancelled:: "), i(1, date()), t("]") }),

	s({ trig = "/scheduled", name = "Task: Schedule" }, { t("[scheduled:: "), i(1), t(" ]") }),
}
