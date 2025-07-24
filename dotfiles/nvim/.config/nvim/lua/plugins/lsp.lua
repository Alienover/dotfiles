return {
	{
		"nvimdev/lspsaga.nvim",
		event = { "LspAttach" },
		cmd = { "Lspsaga" },
		config = function()
			require("config.saga-config")
		end,
	},

	{
		"smjonas/inc-rename.nvim",
		event = "LspAttach",
		keys = {
			{
				"<space>lr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				desc = "Inc [R]ename",
				expr = true,
			},
		},
		opts = {},
	},

	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre" },
		priority = 10,
		config = function()
			require("config.null-ls-config")
		end,
	},

	{
		"williamboman/mason.nvim",
		cmd = { "Mason" },
		build = ":MasonUpdate",
		config = function()
			require("config.mason-config")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("lsp")
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
