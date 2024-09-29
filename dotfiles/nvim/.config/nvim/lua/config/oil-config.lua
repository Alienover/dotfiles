local oil = require("oil")
local oil_util = require("oil.util")

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
			["<C-h>"] = {
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

local og_open_preview = oil.open_preview

---@diagnostic disable-next-line: duplicate-set-field
oil.open_preview = function(opts, callback)
	--- HACK: Modify method to show preview content
	--- - detach the preview buffer from LSP, to avoid LSP
	--- - disable the `winbar`
	local modify_preview = function()
		local preview_win = oil_util.get_preview_win()
		if not preview_win then
			return
		end

		--- INFO: Disable `winbar` to avoid error `not enough room`
		vim.api.nvim_set_option_value("winbar", nil, { win = preview_win })

		local entry = oil.get_cursor_entry()
		if entry and entry.type == "file" then
			local preview_buf = vim.api.nvim_win_get_buf(preview_win)

			--- INFO: Refer to https://github.com/stevearc/oil.nvim/blob/1360be5fda9c67338331abfcd80de2afbb395bcd/lua/oil/init.lua#L538-L543
			--- `oil_preview_buffer` is a mark for those new buffers which are created for preview only
			local is_oil_preview_buf = vim.b[preview_buf].oil_preview_buffer or false

			if is_oil_preview_buf then
				--- INFO: Detach all the LSP clients related to the preview buffer
				vim.schedule(function()
					local clients = vim.lsp.get_clients({ bufnr = preview_buf })
					for _, client in ipairs(clients) do
						if client and client.attached_buffers[preview_buf] then
							pcall(vim.lsp.buf_detach_client, preview_buf, client.id)
						end
					end
				end)
			end
		end
	end

	og_open_preview(opts, function(...)
		modify_preview()

		if callback then
			callback(...)
		end
	end)
end
