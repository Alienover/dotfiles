local oil = require("oil")

local utils = require("custom.utils")
local finders = require("custom.finders")

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

local open_directory = function()
	local cwd = oil.get_current_dir()
	cwd = Snacks.git.get_root(cwd) or cwd

	Snacks.picker.pick({
		layout = "ivy",
		preview = "directory",
		title = "Oil: Open directory",
		finder = function(opts, ctx)
			opts.cwd = cwd

			return finders.directories(opts, ctx)
		end,
		confirm = function(picker, item)
			picker:close()

			oil.open_float(item.file)
		end,
	})
end

oil.setup(
	---@type oil.SetupOpts
	{
		win_options = { cursorline = true },

		lsp_file_methods = { enabled = false },

		keymaps = {
			--- Close
			["q"] = "actions.close",

			--- Preview
			["<c-d>"] = "actions.preview_scroll_down",
			["<c-u>"] = "actions.preview_scroll_up",

			--- Misc
			["l"] = "actions.select",
			["h"] = "actions.parent",
			["<BS>"] = "actions.parent",
			["`"] = "actions.cd",

			--- Custom
			["gd"] = {
				desc = "Toggle file detail view",
				callback = toggle_detail_view,
			},
			["gf"] = {
				desc = "Toggle fzf directories search under CWD",
				callback = open_directory,
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
