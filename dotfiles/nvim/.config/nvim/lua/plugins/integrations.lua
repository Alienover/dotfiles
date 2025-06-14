local consts = require("custom.constants")

return {
	{ -- Client for HTTP requests
		"mistweaverco/kulala.nvim",
		keys = {
			{
				"<leader>Rs",
				function()
					require("kulala").run()
				end,
				mode = { "n", "v" },
				desc = "Send request",
			},
			{
				"<leader>Re",
				function()
					require("kulala").set_selected_env()
				end,
				desc = "Select environment",
				ft = { "http", "rest" },
			},
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
		},
	},

	{ -- Database
		"kndndrj/nvim-dbee",
		cmd = { "Dbee" },
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install()
		end,
		opts = {
			drawer = {
				window_options = {
					statuscolumn = "",
					foldcolumn = "0",
				},
				disable_help = true,
			},
		},
	},

	{ -- Tmux Navigation
		"alexghergh/nvim-tmux-navigation",
		keys = {
			{ "<C-w>h", "<CMD>NvimTmuxNavigateLeft<CR>", desc = "Focus Left Pane" },
			{ "<C-w>l", "<CMD>NvimTmuxNavigateRight<CR>", desc = "Focus Right Pane" },
			{ "<C-w>j", "<CMD>NvimTmuxNavigateDown<CR>", desc = "Focus Down Pane" },
			{ "<C-w>k", "<CMD>NvimTmuxNavigateUp<CR>", desc = "Focus Up Pane" },
		},
		opts = {
			keybindings = {
				last_active = nil,
				next = nil,
			},
		},
	},

	{ -- Markdown
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "Avante", "codecompanion" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		--- @module 'render-markdown'
		--- @type render.md.UserConfig
		opts = {
			file_types = { "markdown", "Avante", "codecompanion" },
			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/CodeBlocks
			code = {
				position = "right",
				width = "block",
				min_width = 80,
				left_pad = 2,
				language_pad = 2,
			},

			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Checkboxes
			checkbox = {
				checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
				custom = {
					important = {
						raw = "[!]",
						rendered = "󰓎 ",
						highlight = "DiagnosticWarn",
					},
				},
			},

			-- See: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Tables
			pipe_table = { preset = "round" },

			sign = { enabled = false },
		},
	},

	{ -- Obsidian
		"epwalsh/obsidian.nvim",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			string.format("BufReadPre %s/*.md", consts.files.obsidian),
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = consts.files.obsidian,
				},
			},

			new_notes_location = "0-inbox",

			ui = { enable = false },

			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "journals/daily-notes",
				-- Optional, default tags to add to each new daily note created.
				default_tags = { "daily-notes" },
			},

			-- see below for full list of options 👇
		},
	},
}
