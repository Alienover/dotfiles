---@type LazySpec
return {
	{ -- Status Line
		"nvim-lualine/lualine.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local icons = require("custom.icons")
			local comps = require("config.statusline")

			require("lualine").setup({
				options = {
					-- Theme
					theme = "catppuccin",

					-- Icons
					icons_enabled = true,

					-- Global line
					globalstatus = true,

					-- Symbols
					symbols = {
						error = icons.get("extended", "error") .. " ",
						warn = icons.get("extended", "warn") .. " ",
						info = icons.get("extended", "info") .. " ",
						hint = icons.get("extended", "hint") .. " ",
					},
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", comps.diff },
					lualine_c = { comps.spellcheck, "filename" },
					lualine_x = { "diagnostics", comps.filetype },
					lualine_y = { comps.encoding, comps.spaces },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
