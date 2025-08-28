local consts = require("custom.constants")

---@type LazySpec
return {

	{ -- Obsidian
		"obsidian-nvim/obsidian.nvim",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			string.format("BufReadPre %s/*.md", consts.files.obsidian),
		},
		dependencies = {
			-- see below for full list of optional dependencies 👇
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = consts.files.obsidian,
				},
			},

			new_notes_location = "0-inbox",

			ui = { enable = false },

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "journals/daily-notes",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
			},

			--- see below for full list of options 👇
			---
			---@class obsidian.config.CheckboxOpts
			---
			---Order of checkbox state chars, e.g. { " ", "x" }
			---@field order? string[]
			checkbox = {
				order = { " ", "/", "x", "!", "-" },
			},
		},
	},
}
