local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

--- Checks whether the string starts with `#`
---@param line_to_cursor string
---@return boolean
local function startsWithHash(line_to_cursor)
	return string.find(line_to_cursor, "^#") and true or false
end

return {
	s({ trig = "frozen_string_literal", show_condition = startsWithHash }, t("frozen_string_literal: true")),
	s({
		trig = "frozen_string_literal",
		show_condition = function(...)
			return not startsWithHash(...)
		end,
	}, t("# frozen_string_literal")),
}
