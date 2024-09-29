require("nvim-treesitter.configs").setup({
	modules = {}, -- Empty to remove the warning
	ensure_installed = {
		"bash",
		"css",
		"git_config",
		"gitcommit",
		"go",
		"gomod",
		"gosum",
		"html",
		"http",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"luadoc",
		"make",
		"markdown",
		"markdown_inline",
		"python",
		"regex",
		"scss",
		"ssh_config",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"ruby",
	},
	auto_install = true,
	sync_install = false,
	ignore_install = {},
	highlight = {
		enable = true,
		use_languagetree = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "ruby" } },
	matchup = { enable = true },
	autopairs = { enable = true },
	playground = { enable = true },
	context_commentstring = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- in normal mode, start incremental selection
			node_incremental = ".", -- in visual mode, increment to the upper named parent
			node_decremental = ",", -- in visual mode, decrement to the previous named node
			scope_incremental = "grc", -- in visual mode, increment to the upper scope
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]f"] = "@function.outer",
			},
			goto_next_end = {
				["]F"] = "@function.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
			},
			goto_previous_end = {
				["[F"] = "@function.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["]a"] = "@parameter.inner",
			},
			swap_previous = {
				["[a"] = "@parameter.inner",
			},
		},
	},
	refactor = {
		highlight_definitions = {
			enable = true,
		},
		highlight_current_scope = { enable = true },
		smart_rename = {
			enable = false,
		},
		navigation = {
			enable = false,
		},
	},
})
