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
		---@module 'catppuccin'
		---@type CatppuccinOptions
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
			highlight_overrides = {
				mocha = function(colors)
					return {
						-- Override
						IncSearch = { link = "CurSearch" },
						FoldedVirtualText = { fg = colors.overlay0, style = { "bold", "italic" } },
						WinSeparator = { fg = colors.surface1 },
						CursorLineNr = { fg = colors.maroon },

						-- Mods for `vim-matchup`
						MatchParen = { style = { "bold", "italic" } },

						-- Mods for `flash.nvim`
						FlashLabel = { fg = colors.mantle, bg = colors.red },
					}
				end,
			},
		},
	},
}
