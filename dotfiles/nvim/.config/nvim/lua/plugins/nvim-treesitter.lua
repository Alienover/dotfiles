---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("custom/treesitter", { clear = true }),
				pattern = "*",

				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype

					local lang = vim.treesitter.language.get_lang(ft)
					if not lang then
						return
					end

					if vim.list_contains(require("nvim-treesitter").get_available(), lang) then
						require("nvim-treesitter").install(lang):await(function()
							-- Load Treesitter parser
							local added = pcall(vim.treesitter.language.add, lang)
							if not added then
								return
							end

							if vim.api.nvim_buf_is_valid(buf) then
								-- Enable Treesitter highlighting
								vim.treesitter.start(buf, lang)

								-- Enable Treesitter-based indentation
								if vim.treesitter.query.get(lang, "indents") then
									vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
								end
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
