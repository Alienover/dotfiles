---@type LazySpec
return {
	{ -- Go forward/backward with square brackets
		"nvim-mini/mini.bracketed",
		keys = { "[", "]" },
		opts = {
			comment = { suffix = "" },
			file = { suffix = "" },
			window = { suffix = "" },
			quickfix = { suffix = "" },
			yank = { suffix = "" },
			treesitter = { suffix = "" },
			undo = { suffix = "u", options = { wrap = false } },
		},
	},
}
