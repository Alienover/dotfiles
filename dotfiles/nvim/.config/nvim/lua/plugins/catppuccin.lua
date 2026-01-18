---@type LazySpec
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		init = function()
			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
		build = function()
			vim.cmd("CatppuccinCompile")
		end,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			term_colors = true,
			float = { transparent = true, solid = true },
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
					ok = { "undercurl" },
				},
			},
			integrations = {
				blink_cmp = true,
				noice = true,
				which_key = true,
			},
			custom_highlights = function(colors)
				return {
					FoldedVirtualText = { fg = colors.overlay0, style = { "bold", "italic" } },

					WinSeparator = { fg = colors.surface1 },

					-- Mods for `vim-matchup`
					MatchParen = { style = { "bold", "italic" } },

					CursorLineNr = { fg = colors.maroon },

					BufferlineIndicatorSelected = { fg = colors.red, style = { "bold" } },
				}
			end,
		},
	},
}
