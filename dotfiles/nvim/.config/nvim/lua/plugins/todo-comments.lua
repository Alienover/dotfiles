---@type LazySpec
return {
	{ -- Highlight keywords like utils.snacks_picker.todo_commentstodo, fix, and info
		"folke/todo-comments.nvim",
		keys = {
			{
				"<space>ht",
				---@diagnostic disable-next-line: undefined-field
				"<CMD>lua Snacks.picker.todo_comments()<CR>",
				desc = "[T]odo Comments",
			},
		},
		event = "User LazyPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
					string.format("--glob=!{%s}", table.concat({ "flow-typed", "node_modules" }, ",")),
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS):]], -- ripgrep regex
				-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		},
	},
}
