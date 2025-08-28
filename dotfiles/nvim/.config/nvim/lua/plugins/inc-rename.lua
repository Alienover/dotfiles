---@type LazySpec
return {
	{
		"smjonas/inc-rename.nvim",
		event = "LspAttach",
		opts = {},
		keys = {
			{
				"grn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "Inc [R]ename",
				expr = true,
			},
		},
	},
}
