---@type LazySpec
return {
	{ -- Tabs
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "catppuccin" },
		opts = function(_, opts)
			return vim.tbl_extend("force", opts, {
				-- Integrate the Catppuccin theme
				highlights = require("catppuccin.special.bufferline").get_theme(),
				options = {
					-- Styling
					mode = "tabs",
					indicator = {
						icon = "▎", -- this should be omitted if indicator style is not 'icon'
					},
					separator_style = { "", "" },

					-- Flags
					show_close_icon = false,
					show_buffer_close_icons = false,
					always_show_bufferline = false,

					-- LSP diagnostics
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count)
						return "(" .. count .. ")"
					end,
				},
			})
		end,
	},
}
