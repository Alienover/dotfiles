local icons = require("custom.icons")

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("config.catppuccin-config")
		end,
	},

	{ -- Icons
		"echasnovski/mini.icons",
		config = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{ -- Status Line
		"hoob3rt/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("config.lualine-config")
		end,
	},

	{ -- Tabs
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "catppuccin" },
		config = function()
			require("config.bufferline-config")
		end,
	},

	{ -- UI for messages, cmdline and the popupmenu
		"folke/noice.nvim",
		event = "VeryLazy",
		---@module 'noice'
		opts = {
			popupmenu = { enabled = false },
			notify = { enabeld = false },

			---@type NoicePresets
			presets = { inc_rename = true, lsp_doc_border = true },

			cmdline = {
				format = {
					lua = false,
					cmdline = { pattern = "^:", icon = icons.get("extended", "arrowRight"), lang = "vim" },
				},
			},

			lsp = {
				progress = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			{ "MunifTanjim/nui.nvim", module = "nui" },

			-- Progress UI for LSP and rest
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
			},
		},
	},
}
