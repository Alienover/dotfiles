require("catppuccin").setup({
	flavour = "mocha", -- latte, frappe, macchiato, mocha
	transparent_background = true,
	term_colors = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		lsp_saga = true,
		markdown = true,
		render_markdown = true,
		mason = true,
		noice = true,
		notify = true,
		telescope = {
			enabled = true,
		},
		treesitter = true,
		treesitter_context = true,
		which_key = true,
		diffview = true,
		flash = true,
	},
	native_lsp = {
		enabled = true,
		virtual_text = {
			errors = { "italic" },
			hints = { "italic" },
			warnings = { "italic" },
			information = { "italic" },
		},
	},
	custom_highlights = function(colors)
		return {
			FoldedVirtualText = { fg = colors.overlay0, style = { "bold", "italic" } },
			-- Replace the `underline` with `undercurl`
			DiagnosticUnderlineError = { style = { "undercurl" } },
			DiagnosticUnderlineWarn = { style = { "undercurl" } },
			DiagnosticUnderlineInfo = { style = { "undercurl" } },
			DiagnosticUnderlineHint = { style = { "undercurl" } },

			TabLineSel = { bg = colors.red },

			-- Mods for `lspsaga.nvim`
			SagaBorder = { fg = colors.surface1 },
			FloatBorder = { fg = colors.surface1 },

			-- Mods for `telescope.nvim`
			TelescopeSelection = { bg = colors.surface1 },

			-- Mods for `nvim-cmp`
			CmpItemMenu = { fg = colors.subtext0 },

			-- Mods for `vim-matchup`
			MatchParen = { style = { "bold", "italic" } },
		}
	end,
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin-mocha")
