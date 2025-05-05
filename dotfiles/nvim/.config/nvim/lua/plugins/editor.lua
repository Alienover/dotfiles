return {
	{
		"folke/which-key.nvim",
		keys = { "<space>" },
		event = { "VeryLazy" },
		config = function()
			require("config.which-key-config")
		end,
	},

	{ -- Files browser
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				-- This will not install any breaking changes.
				-- For major updates, this must be adjusted manually.
				version = "^1.0.0",
			},
		},
		config = function()
			require("config.telescope-config")
		end,
	},

	{ -- Highlight keywords like todo, fix, and info
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
					string.format("--glob=!{%s}", table.concat({ "flow-typed", "node_modules" }, ",")),
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS):]], -- ripgrep regex
				-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		},
	},

	{ -- Snippets
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function()
			require("config.luasnip-config")
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost" },
		dependencies = "kevinhwang91/promise-async",
		config = function()
			require("config.ufo-config")
		end,
	},

	{
		"danymat/neogen",
		cmd = { "Neogen" },
		opts = {
			snippet_engine = "luasnip",
		},
	},

	{
		"stevearc/oil.nvim",
		lazy = vim.fn.argc(-1) == 0, -- load oil early when opening a file from the cmdline
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("config.oil-config")
		end,
	},
}
