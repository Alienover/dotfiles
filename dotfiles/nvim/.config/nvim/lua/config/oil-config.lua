local oil = require("oil")

local utils = require("custom.utils")

local detail = false
local toggle_detail_view = function()
	detail = not detail
	if detail then
		require("oil").set_columns({
			"icon",
			"permissions",
			"size",
			"mtime",
		})
	else
		require("oil").set_columns({ "icon" })
	end
end

oil.setup(
	---@type oil.SetupOpts
	{
		-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
		-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
		default_file_explorer = true,

		-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
		delete_to_trash = false,

		win_options = {
			cursorline = true,
		},

		lsp_file_methods = {
			enabled = false,
		},
		-- Set to false to disable all of the above keymaps
		use_default_keymaps = false,
		keymaps = {
			--- Flags
			["g?"] = "actions.show_help",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
			["gs"] = "actions.change_sort",

			--- Selection
			["<CR>"] = "actions.select",
			["<C-s>"] = {
				"actions.select",
				opts = { vertical = true },
				desc = "Open the entry in a vertical split",
			},
			["<C-v>"] = {
				"actions.select",
				opts = { horizontal = true },
				desc = "Open the entry in a horizontal split",
			},
			["<C-t>"] = {
				"actions.select",
				opts = { tab = true },
				desc = "Open the entry in new tab",
			},

			--- Close
			["<C-c>"] = "actions.close",
			["<ESC>"] = "actions.close",

			--- Preview
			["<C-p>"] = "actions.preview",
			["<c-d>"] = "actions.preview_scroll_down",
			["<c-u>"] = "actions.preview_scroll_up",

			--- Misc
			["<C-l>"] = "actions.refresh",
			["<BS>"] = "actions.parent",
			["`"] = "actions.cd",

			--- Custom
			["gd"] = {
				desc = "Toggle file detail view",
				callback = toggle_detail_view,
			},
		},
		-- Configuration for the floating window in oil.open_float
		float = {
			override = function(conf)
				local win_opts = utils.get_float_win_opts()
				return vim.tbl_extend("force", conf, win_opts)
			end,
		},

		view_options = {
			is_hidden_file = function(name)
				return vim.startswith(name, ".")
			end,
		},
	}
)
