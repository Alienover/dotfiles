local icons = require("custom.icons")

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		init = function()
			-- setup must be called before loading
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
		build = function()
			vim.cmd("CatppuccinCompile")
		end,
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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("config.lualine-config")
		end,
	},

	{ -- Tabs
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "catppuccin" },
		opts = function(_, opts)
			return vim.tbl_extend("force", opts, {
				-- Integrate the Catppuccin theme
				highlights = require("catppuccin.groups.integrations.bufferline").get(),
				options = {
					-- Styling
					mode = "tabs",
					indicator = { style = "underline" },
					separator_style = { "", "" },

					-- Flags
					show_close_icon = false,
					show_buffer_close_icons = false,
					always_show_bufferline = true,

					-- LSP diagnostics
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count)
						return "(" .. count .. ")"
					end,
				},
			})
		end,
	},

	{ -- UI for messages, cmdline and the popupmenu
		"folke/noice.nvim",
		event = "VeryLazy",
		---@module 'noice'
		---@type NoiceConfig
		opts = {
			---@type NoicePresets
			presets = {
				inc_rename = true,
				lsp_doc_border = true,
				long_message_to_split = true, -- long messages will be sent to a split
			},

			cmdline = {
				format = {
					cmdline = { pattern = "^:", icon = icons.get("extended", "arrowRight"), lang = "vim" },
				},
			},

			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},

			routes = {
				{
					filter = {
						event = "notify",
						find = "No information available",
					},
					opts = { skip = true },
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			{ "MunifTanjim/nui.nvim", module = "nui" },
		},
	},
}
