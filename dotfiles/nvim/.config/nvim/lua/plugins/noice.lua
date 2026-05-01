---@type LazySpec
return {
	{ -- UI for messages, cmdline and the popupmenu
		"folke/noice.nvim",
		enabled = false,
		event = "VeryLazy",
		---@module 'noice'
		---@type NoiceConfig
		opts = {
			---@type NoicePresets
			presets = {
				inc_rename = true,
				lsp_doc_border = true,
				long_message_to_split = true, -- long messages will be sent to a split
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
				hover = {
					silent = false, -- set to true to not show a message if hover is not available
				},
			},
		},
	},
}
