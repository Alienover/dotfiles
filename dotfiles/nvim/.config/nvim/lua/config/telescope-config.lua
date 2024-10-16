local utils = require("custom.utils")

local telescope = require("telescope")
local ts_actions = require("telescope.actions")

---@module "telescope-undo.actions"
local undo = utils.LazyRequire("telescope-undo.actions")

telescope.setup({
	defaults = {
		selection_caret = "  ",
		entry_prefix = "  ",

		layout_config = {
			width = 0.5,
			height = 0.5,
		},
		prompt_prefix = " 🌈 ",
		mappings = {
			i = {
				["<C-j>"] = ts_actions.move_selection_next,
				["<C-k>"] = ts_actions.move_selection_previous,
				["<Esc>"] = ts_actions.close,
			},
			n = {
				q = ts_actions.close,
			},
		},
	},
	pickers = {
		buffers = {
			path_display = { "filename_first" },
			sort_lastused = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
		undo = {
			mappings = {
				i = {
					["<cr>"] = undo.restore,
				},
			},
		},
	},
})

local extensions = { "fzf" } -- "undo", "noice" would be lazy-loaded

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
