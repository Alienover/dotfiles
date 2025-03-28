return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = "v0.0.23", -- Never set this value to "*"! Never!
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",

		opts = {
			provider = "openai",
			auto_suggestions_provider = "openai",
			openai = {
				max_tokens = 4096, -- Max tokens for completion, adjust for reasoning
				api_key_name = "cmd:pass show OpenAI/API-Key", -- Command to retrieve API key
			},
			hints = { enabled = false },
		},
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",

			--- The below dependencies are optional,
			"echasnovski/mini.icons",
		},
	},
}
