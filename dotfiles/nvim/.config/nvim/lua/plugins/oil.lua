---@type LazySpec
return {
	{
		"stevearc/oil.nvim",
		lazy = vim.fn.argc(-1) == 0, -- load oil early when opening a file from the cmdline
		cmd = { "Oil" },
		-- Optional dependencies
		dependencies = { "nvim-mini/mini.icons" },
		config = function()
			local oil = require("oil")

			local detail = false

			--- @param opts snacks.picker.proc.Config
			--- @type snacks.picker.finder
			local function directories_finder(opts, ctx)
				local cwd = opts.cwd or vim.uv.cwd()

				return require("snacks.picker.source.proc").proc({
					cmd = "fd",
					args = { "--type", "d", "--exclude", ".git", "--hidden", ".", cwd },
					notify = not opts.live,
					transform = function(item)
						item.cwd = cwd
						item.file = item.text:sub(#cwd + 2)
					end,
				}, ctx)
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
						--- Toggle files/folders detail
						["gd"] = {
							desc = "Toggle file detail view",
							callback = function()
								detail = not detail
								if detail then
									require("oil").set_columns({
										"permissions",
										"size",
										"mtime",
										"icon",
									})
								else
									require("oil").set_columns({ "icon" })
								end
							end,
						},
						--- Use fzf to enter directory
						["gf"] = {
							desc = "Toggle fzf directories search under CWD",
							callback = function()
								local cwd = oil.get_current_dir()
								cwd = Snacks.git.get_root(cwd) or cwd

								Snacks.picker.pick({
									layout = "ivy",
									preview = "directory",
									title = "Oil: Open directory",
									finder = function(opts, ctx)
										opts.cwd = cwd
										return directories_finder(opts, ctx)
									end,
									confirm = function(picker, item)
										picker:close()

										oil.open_float(item.text)
									end,
								})
							end,
						},
					},
					-- Configuration for the floating window in oil.open_float
					float = {
						override = function(conf)
							local win_opts = require("custom.utils").get_float_win_opts()
							return vim.tbl_extend("force", conf, win_opts)
						end,
					},
				}
			)
		end,
	},
}
