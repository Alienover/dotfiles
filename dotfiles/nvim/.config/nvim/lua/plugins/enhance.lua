local consts = require("custom.constants")

return {
	{ -- Navigate with labels
		"folke/flash.nvim",
		opts = {
			prompt = {
				enabled = false,
			},
			modes = {
				char = {
					jump_labels = true,
				},
				search = {
					enabled = false,
				},
			},
		},
		keys = {
			{
				"<c-f>",
				function()
					require("flash").toggle()
				end,
				mode = "c",
				desc = "Toggle Flash Search",
			},
			{
				"S",
				function()
					require("flash").treesitter()
				end,
				mode = { "o", "x" },
				desc = "Flash Treesitter",
			},
			{
				"R",
				function()
					require("flash").treesitter_search()
				end,
				mode = { "o", "x" },
				desc = "Treesitter Search",
			},
			{ "f", mode = { "n", "x" } },
			{ "F", mode = { "n", "x" } },
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
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true },
		},
	},

	{
		"echasnovski/mini.surround",
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
				update_n_lines = "", -- Update `n_lines`
				suffix_last = "", -- Suffix to search with "prev" method
				suffix_next = "", -- Suffix to search with "next" method
			},
		},
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
		opts = {},
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
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
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			keys = {
				{
					">",
					function()
						require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
					end,
					desc = "Expand quickfix context",
				},
				{
					"<",
					function()
						require("quicker").collapse()
					end,
					desc = "Collapse quickfix context",
				},
			},
		},
	},

	{ -- Customized winbar with file path and document symbols
		"@local/winbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "echasnovski/mini.icons" },
		opts = {
			excluded_fn = function()
				-- INFO: Exclude those non-exsited files
				return not vim.uv.fs_stat(vim.fn.expand("%:p"))
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

	{
		"echasnovski/mini.move",
		event = "VeryLazy",
		opts = {},
	},
}
