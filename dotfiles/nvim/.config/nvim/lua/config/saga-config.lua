local utils = require("custom.utils")

local nmap = utils.nmap

local window_specing = utils.get_window_default_spacing()

local config = {
	ui = {
		-- currently only round theme
		colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
		kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
		border = "rounded",
	},
	finder = {
		max_height = 0.2,
		keys = {
			vsplit = "v",
			toggle_or_open = "<CR>",
		},
	},
	lightbulb = {
		enable = false,
	},
	code_action = {
		extend_gitsigns = false,
		num_shortcut = true,
		keys = {
			-- string |table type
			quit = { "q", "<ESC>" },
			exec = "<CR>",
		},
	},
	symbol_in_winbar = {
		enable = false,
	},
	floaterm = {
		height = (1 - window_specing.t * 2),
		width = (1 - window_specing.l * 2),
	},
	definition = {
		keys = {
			edit = "o",
			split = "s",
			vsplit = "v",
		},
	},
}

require("lspsaga").setup(config)

-- Definition and references
nmap("gh", ":Lspsaga finder<CR>", "LspSaga: Finder")
nmap("gp", ":Lspsaga peek_definition<CR>", "LspSaga: [G]o [P]eek")
