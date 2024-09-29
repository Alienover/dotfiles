require("render-markdown").setup({
	file_types = { "markdown", "Avante" },
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
		custom = {
			important = {
				raw = "[!]",
				rendered = "󰓎 ",
				highlight = "DiagnosticWarn",
			},
		},
	},

	-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Tables
	pipe_table = { preset = "round" },

	sign = { enabled = false },
})
