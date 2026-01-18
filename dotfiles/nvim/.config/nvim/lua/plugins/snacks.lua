---@type LazySpec
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			gitbrowse = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			picker = {
				ui_select = true,
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
				right = { "git", "fold" },
				folds = {
					open = true, -- show open fold icons
					git_hl = true, -- use Git Signs hl for fold icons
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
			---@return snacks.Config
			local function override_picker_layouts(defaults)
				local sizing = require("custom.utils").get_float_win_sizing()
				return vim.tbl_deep_extend("force", defaults or {}, {
					telescope = {
						layout = {
							width = sizing.width,
							height = sizing.height,
						},
					},
				})
			end

			opts.picker.layouts = override_picker_layouts(opts.picker.layouts)

			require("snacks").setup(opts)

			vim.api.nvim_create_autocmd("VimResized", {
				desc = "Reset picker layouts when resizing",
				callback = function()
					Snacks.config.picker.layouts =
						vim.tbl_deep_extend("force", Snacks.config.picker.layouts, override_picker_layouts())
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
      { "<space>fr", function() Snacks.picker.grep() end, desc="Live [G]rep" },
      { "<space>fo", function() Snacks.picker.recent() end, desc="Recently [O]pened" },

			-- Git
			{ "<space>go", function() Snacks.gitbrowse() end, desc = "[O]pen in browse", mode = { "n", "v" } },
      { "<space>gC", function() require('custom.utils').change_cwd() end, desc="[C]hage CWD" },

			-- Notifier
			{ "<space><esc>", function() Snacks.notifier.hide() end, desc = "Clear all notifications" },
			{ "<space>hn", function() Snacks.notifier.show_history() end, desc = "Show notifier history" },

			-- Zen
			{ "<space>z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
			{ "<space>Z", function() Snacks.zen() end, desc = "[Z]en Mode" },
		},
	},
}
