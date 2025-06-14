return {
	{
		"yetone/avante.nvim",
		optional = false,
		keys = { { "<leader>at", "<CMD>AvanteToggle<CR>" } },
		cmd = { "AvanteAsk", "AvanteToggle", "AvanteEdit" },
		version = false,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",

		opts = {
			provider = "openai",
			auto_suggestions_provider = "openai",
			providers = {
				openai = {
					max_tokens = 4096, -- Max tokens for completion, adjust for reasoning
					api_key_name = "cmd:pass show OpenAI/API-Key", -- Command to retrieve API key
				},
			},
			web_search_engine = {
				provider = "google",
				providers = {
					tavily = {
						api_key_name = "cmd:pass show Tavily/API-Key", -- Command to retrieve API key
					},
					google = {
						api_key_name = "cmd:pass show Google-Custom-Search/API-Key",
						engine_id_name = "cmd:pass show Google-Custom-Search/Engine-ID",
					},
				},
			},
			hints = { enabled = false },
			behaviour = {
				auto_suggestions = true,
			},
		},
		config = function(_, opts)
			require("avante").setup(opts)

			-- Fix the border highlights
			vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", { link = "WinSeparator" })

			-- Hide the horizontal separator
			local palette = require("catppuccin.palettes").get_palette("mocha")
			vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", { fg = palette.base })
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",

			--- The below dependencies are optional,
			"echasnovski/mini.icons",
		},
	},
	{
		"olimorris/codecompanion.nvim",
		event = { "VeryLazy" },
		keys = {
			{ "<leader>cc", "<CMD>CodeCompanionChat Toggle<CR>", mode = "n", desc = "CodeCompanion: Toggle Chat" },
			{ "<leader>cA", "<CMD>CodeCompanionActions<CR>", mode = "n", desc = "CodeCompanion: Actions" },
			{ "<leader>cH", "<CMD>CodeCompanionHistory<CR>", mode = "n", desc = "CodeCompanion: Chat Histories" },
			{
				"<leader>ca",
				"<CMD>CodeCompanionChat Add<CR>",
				mode = "v",
				desc = "Add the selected content to the current chat buffer",
			},
		},
		opts = {
			strategies = {
				chat = {
					adapter = "openai",
				},
				inline = {
					adapter = "openai",
				},
				cmd = {
					adapter = "openai",
				},
			},
			adapters = {
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						env = {
							api_key = "cmd:pass show OpenAI/API-Key",
						},
					})
				end,
				tavily = function()
					return require("codecompanion.adapters").extend("tavily", {
						env = {
							api_key = "cmd:pass show Tavily/API-Key",
						},
					})
				end,
			},
			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
					opts = {
						show_default_actions = true, -- Show the default actions in the action palette?
						show_default_prompt_library = true, -- Show the default prompt library in the action palette?
					},
				},
				window = { border = "rounded" }, -- Consistent border style
				chat = { window = { width = 120 } }, -- Added line for chat width
			},
			extensions = {
				history = {
					enabled = true,
					opts = {
						---When chat is cleared with `gx` delete the chat from history
						delete_on_clearing_chat = true,
						chat_filter = function(chat_data)
							return chat_data.cwd == vim.fn.getcwd()
						end,
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			--other plugins
			"ravitemer/codecompanion-history.nvim",
		},
	},
}
