---@type LazySpec
return {
	{ -- UI for messages, cmdline and the popupmenu
		"folke/noice.nvim",
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
			},
			routes = {
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			{ "MunifTanjim/nui.nvim" },
		},
	},
}
