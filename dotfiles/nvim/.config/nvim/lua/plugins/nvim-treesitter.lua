---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local ft = vim.bo.filetype
					local lang = vim.treesitter.language.get_lang(ft)

					if not lang then
						return
					end

					if vim.list_contains(require("nvim-treesitter").get_available(), lang) then
						require("nvim-treesitter").install(lang):await(function()
							if vim.treesitter.language.add(lang) then
								-- Enable Treesitter highlighting
								vim.treesitter.start(args.buf, lang)

								-- Enable Treesitter-based folding
								-- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
								-- vim.wo[0][0].foldmethod = "expr"

								-- Enable Treesitter-based indentation
								vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
							end
						end)
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true
		end,
		opts = {},
		keys = {
			{
				"[a",
				function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
				end,
			},
			{
				"]a",
				function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end,
			},
		},
	},
}
