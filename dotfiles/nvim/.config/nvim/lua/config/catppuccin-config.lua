require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	term_colors = true,
	integrations = {
		blink_cmp = true,
		diffview = true,
		lsp_saga = true,
		noice = true,
		which_key = true,
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
		},
	},
	custom_highlights = function(colors)
		return {
			FoldedVirtualText = { fg = colors.overlay0, style = { "bold", "italic" } },

			TabLineSel = { bg = colors.red },

			-- Mods for `lspsaga.nvim`
			SagaBorder = { fg = colors.surface1 },
			FloatBorder = { fg = colors.surface1 },

			WinSeparator = { fg = colors.surface1 },

			-- Mods for `telescope.nvim`
			TelescopeSelection = { bg = colors.surface1 },

			-- Mods for `vim-matchup`
			MatchParen = { style = { "bold", "italic" } },
		}
	end,
})
