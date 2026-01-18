---@type LazySpec
return {
	{ -- Go forward/backward with square brackets
		"nvim-mini/mini.bracketed",
		keys = { "[", "]" },
		opts = {
			comment = { suffix = "" },
			file = { suffix = "" },
			window = { suffix = "" },
			quickfix = { suffix = "" },
			yank = { suffix = "" },
			treesitter = { suffix = "" },
			undo = { suffix = "u", options = { wrap = false } },
		},
	},

	{
		"echasnovski/mini.icons",
		config = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{ "nvim-mini/mini.move", event = "VeryLazy", opts = {} },

	{
		"nvim-mini/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true },
		},
	},

	{
		"nvim-mini/mini.surround",
		keys = {
			{ "s", mode = { "n", "v" } },
			"ds",
			"cs",
		},
		opts = {
			-- Whether to disable showing non-error feedback
			silent = true,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "s", -- Add surrounding in Normal and Visual modes
				delete = "ds", -- Delete surrounding
				replace = "cs", -- Replace surrounding

				-- Disabled
				find = "", -- Find surrounding (to the right)
				find_left = "", -- Find surrounding (to the left)
				highlight = "", -- Highlight surrounding
				suffix_last = "", -- Suffix to search with "prev" method
				suffix_next = "", -- Suffix to search with "next" method
			},
		},
	},
}
