local consts = require("custom.constants")

return {
	{
		"folke/flash.nvim",
		config = function()
			require("config.flash-config")
		end,
		keys = {
			{ "<c-f>", mode = "c" },
			{ "f", mode = { "n", "x" } },
			{ "F", mode = { "n", "x" } },
			{ "S", mode = { "o", "x" } },
			{ "r", mode = { "o" } },
			{ "R", mode = { "o", "x" } },
		},
	},

	{
		"@local/better_hjkl.nvim",
		event = { "CursorMoved" },
		opts = {
			escape = {
				-- Press `jk`, "kj",`jj`, "kk" to escape from insert mode
				mapping = { "jk", "kj", "jj", "kk" },
			},
			discipline = {
				excluded_filetypes = consts.special_filetypes.excluded_cowboy,
			},
		},
	},

	{
		"max397574/better-escape.nvim",
		tag = "v1.0.0",
	},

	{
		"echasnovski/mini.pairs",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			modes = { insert = true, command = true },
		},
		config = true,
	},

	{
		"echasnovski/mini.surround",
		keys = {
			{ "s", mode = { "n", "v" } },
			"ds",
			"cs",
		},
		config = function()
			require("config.surround-config")
		end,
	},

	{ -- Go forward/backward with square brackets
		"echasnovski/mini.bracketed",
		keys = { "[", "]" },
		opts = {
			comment = { suffix = "" },
			file = { suffix = "" },
			window = { suffix = "" },
			quickfix = { suffix = "" },
			yank = { suffix = "" },
			treesitter = { suffix = "" },
		},
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			["*"] = {
				RRGGBBAA = true,
				css = true,
				css_fn = true,
			},
			"!notify",
			"!lazy",
			"!markdown",
		},
	},

	{
		"nvimdev/hlsearch.nvim",
		event = "BufReadPost",
		config = true,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = true,
	},

	{
		"andymass/vim-matchup",
		event = "BufReadPre",
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		event = { "VeryLazy" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("config.treesitter-config")
		end,
	},

	{ -- Improved UI and workflow for the built-in quickfix
		"stevearc/quicker.nvim",
		ft = "qf",

		config = function()
			require("config.quicker-config")
		end,
	},

	{ -- Customized winbar with file path and document symbols
		"@local/winbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			excluded_fn = function()
				-- INFO: Display the winbar info from the diff plugin itself
				return vim.opt.diff:get()
			end,
			excluded_filetypes = consts.special_filetypes.excluded_winbar,
		},
	},

	{
		"cbochs/portal.nvim",
		keys = {
			{ "<leader>i", "<CMD>Portal jumplist forward<CR>" },
			{ "<leader>o", "<CMD>Portal jumplist backward<CR>" },
		},
		opts = {
			window_options = {
				border = "rounded",
				style = "minimal",
			},
		},
	},
}
