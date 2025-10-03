---@type LazySpec
return {
	{ -- Markdown
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-mini/mini.icons",
		},
		--- @module 'render-markdown'
		--- @type render.md.UserConfig
		opts = {
			file_types = { "markdown" },

			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/CodeBlocks
			code = {
				position = "right",
				width = "block",
				min_width = 80,
				left_pad = 2,
				language_pad = 2,
			},

			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Checkboxes
			checkbox = {
				checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
				custom = {
					important = {
						raw = "[!]",
						rendered = "󰓎 ",
						highlight = "DiagnosticWarn",
					},
					incomplete = {
						raw = "[/]",
						rendered = "󱎖 ",
						highlight = "DiagnosticHint",
					},
					canceled = {
						raw = "[-]",
						rendered = "✘ ",
						scope_highlight = "@markup.strikethrough",
						highlight = "Comment",
					},
				},
			},

			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Tables
			pipe_table = { preset = "round" },

			sign = { enabled = false },
		},
	},
}
