local M = {
	lazy = {
		autocmds = nil,
		clipboard = nil,
	},
}

vim.uv = vim.uv or vim.loop

-- Enables the experimental Lua module loader
if vim.loader then
	vim.loader.enable()
end

-- Load options here, before lazy init while sourcing plugin modules
-- this is needed to make sure options will be correctly applied
-- after installing missing plugins
require("options")

-- Autocmds can be loaded lazily when not opening a file
M.lazy.autocmds = vim.fn.argc(-1) == 0
if not M.lazy.autocmds then
	require("autocmds")
end

-- Defer built-in clipboard handling: "xsel" and "pbcopy" can be slow
M.lazy.clipboard = vim.opt.clipboard
vim.opt.clipboard = ""

local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",

	callback = function()
		if M.lazy.autocmds then
			require("autocmds")
		end

		if M.lazy.clipboard then
			vim.opt.clipboard = M.lazy.clipboard
		end

		require("keymaps")
	end,
})

-- Bootstrap lazy.nvim and plugins
require("config.lazy-config")
