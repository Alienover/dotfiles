---@type LazySpec
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					require("util.debug")
				end,
			})
		end,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			gitbrowse = { enabled = true },
			input = { enabled = true },
			notifier = { sort = { "added" } },
			quickfile = { enabled = true },
			picker = {
				ui_select = false, -- Use the select from `custom/select.lua`
				layout = { preset = "telescope" },
				formatters = {
					file = {
						filename_first = true,
					},
				},
				layouts = {
					ivy = {
						layout = {
							height = 0.3,
						},
					},
					select = {
						layout = {
							max_width = 80,
						},
					},
				},
				win = {
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },

							-- Preview scorlling
							["<C-f>"] = false,
							["<C-b>"] = false,
							["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
							["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
						},
					},
				},
			},
			statuscolumn = {
				right = { "mark", "fold" },
				left = { "git" },
				folds = {
					open = true, -- show open fold icons
					git_hl = false, -- use Git Signs hl for fold icons
				},
			},
			zen = {
				toggles = {
					dim = false,
				},
			},
		},
		---@param opts snacks.Config
		config = function(_, opts)
			-- Reset the picker layouts width & height based on the current window sizing
			---@param defaults snacks.Config
			---@return snacks.Config
			local function override_win_sizing(defaults)
				local sizing = require("util").get_float_win_sizing()

				defaults.picker = vim.tbl_deep_extend("force", defaults.picker or {}, {
					layouts = {
						telescope = {
							layout = {
								width = sizing.width,
								height = sizing.height,
							},
						},
					},
				})

				defaults.styles = vim.tbl_deep_extend("force", defaults.styles or {}, {
					notification_history = {
						width = sizing.width,
						height = sizing.height,
					},
				})

				return defaults
			end

			require("snacks").setup(override_win_sizing(opts))

			vim.api.nvim_create_autocmd("VimResized", {
				desc = "Reset picker layouts when resizing",
				callback = function()
					override_win_sizing(Snacks.config)
				end,
			})
		end,
		-- stylua: ignore
		keys = {
			-- Buffers
			{
				"<space>bb",
				function()
					Snacks.picker.buffers({
						on_show	=	function() vim.cmd.stopinsert() end,
						layout	=	"ivy",
					})
				end,
				desc	=	"Find	[B]uffer"
			},
			{ "<space>bd", function() Snacks.bufdelete() end, desc = "[D]elete" },
			{ "<space>bD", function() Snacks.bufdelete.all() end, desc = "[D]elete all" },

			-- Files
			{ "<space>ff", function() Snacks.picker.files() end, desc="[F]ind [F]iles" },
			{ "<space>fr", function() Snacks.picker.grep() end, desc="Live [G]rep" },
			{ "<space>fo", function() Snacks.picker.recent() end, desc="Recently [O]pened" },

			-- Git
			{ "<space>go", function() Snacks.gitbrowse() end, desc = "[O]pen in browse", mode = { "n", "v" } },
			{ "<space>gC", function() require("util").change_cwd() end, desc="[C]hage CWD" },

			-- Notifier
			{ "<space><esc>", function() Snacks.notifier.hide() end, desc = "Clear all notifications" },
			{ "<space>hn", function() Snacks.notifier.show_history() end, desc = "Show notifier history" },

			-- Zen
			{ "<space>z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
			{ "<space>Z", function() Snacks.zen() end, desc = "[Z]en Mode" },
		},
	},
}
