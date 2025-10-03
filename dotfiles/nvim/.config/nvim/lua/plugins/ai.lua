---@type LazySpec
return {
	{
		"yetone/avante.nvim",
		enabled = false,
		keys = { { "<leader>at", "<CMD>AvanteToggle<CR>" } },
		cmd = { "AvanteAsk", "AvanteToggle", "AvanteEdit" },
		version = false,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",

		opts = {
			-- provider = "claude",
			-- auto_suggestions_provider = "claude",
			providers = {
				openai = {
					max_tokens = 4096, -- Max tokens for completion, adjust for reasoning
					api_key_name = "cmd:pass show OpenAI/API-Key", -- Command to retrieve API key
				},
				claude = {
					api_key_name = "cmd:pass show Anthropic/API-Key",
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

			--- Blink.cmp completion source
			{ "Kaiser-Yang/blink-cmp-avante", ft = "AvanteInput" },
		},
	},
	{
		"olimorris/codecompanion.nvim",
		enabled = false,
		keys = {
			{ "<leader>cc", "<CMD>CodeCompanionChat Toggle<CR>", mode = "n", desc = "CodeCompanion: Toggle Chat" },
			{ "<leader>cA", "<CMD>CodeCompanionActions<CR>", mode = "n", desc = "CodeCompanion: Actions" },
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
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
				cmd = {
					adapter = "anthropic",
				},
			},
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = "cmd:pass show Anthropic/API-Key",
						},
					})
				end,
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
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"coder/claudecode.nvim",
		enabled = false,
		dependencies = { "folke/snacks.nvim" },
		opts = {},
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
    -- stylua: ignore
		keys = {
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select() end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>at",
				function()
					local mode = vim.fn.mode()
					if mode == "n" then
						require("sidekick.cli").send({ msg = "{file}" })
						return
					end

					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>af",
				function() require("sidekick.cli").focus() end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
}
