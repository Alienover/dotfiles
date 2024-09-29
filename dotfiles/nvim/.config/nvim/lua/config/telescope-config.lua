-- Reference
-- https://github.com/nvim-telescope/telescope.nvim
local telescope = require("telescope")
local ts_actions = require("telescope.actions")

---@type function
---@param method string
local undo = function(method)
	local undo_actions = vim.F.npcall(require, "telescope-undo.actions")
	if undo_actions then
		return undo_actions[method]
	end
end

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
					["<cr>"] = undo("restore"),
				},
			},
		},
	},
})

local extensions = { "fzf" } -- "undo", "noice" would be lazy-loaded

for _, ext in ipairs(extensions) do
	telescope.load_extension(ext)
end
