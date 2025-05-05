require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	term_colors = true,
	integrations = {
		blink_cmp = true,
		diffview = true,
		fidget = true,
		flash = true,
		gitsigns = true,
		lsp_saga = true,
		markdown = true,
		mason = true,
		noice = true,
		render_markdown = true,
		telescope = { enabled = true },
		treesitter = true,
		treesitter_context = true,
		which_key = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
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

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin-mocha")
