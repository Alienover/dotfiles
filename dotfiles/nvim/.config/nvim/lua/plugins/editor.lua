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
		},
		config = function()
			require("config.telescope-config")
		end,
	},

	{ -- Highlight keywords like todo, fix, and info
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.todo-config")
		end,
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
		"rest-nvim/rest.nvim",
		ft = { "http" },
		config = function()
			require("config.rest-config")
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
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		config = function()
			require("config.markdown-config")
		end,
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
