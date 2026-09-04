local lazy = {}

-- Load options here, before lazy init while sourcing plugin modules
-- this is needed to make sure options will be correctly applied
-- after installing missing plugins
require("config.options")

-- Autocmds can be loaded lazily when not opening a file
lazy.autocmds = vim.fn.argc(-1) == 0
if not lazy.autocmds then
	require("config.autocmds")
end

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
	pattern = "VeryLazy",

	callback = function()
		-- Enable the new experimental command-line features
		require("vim._core.ui2").enable({})

		if lazy.autocmds then
			require("config.autocmds")
		end

		require("config.keymaps")
	end,
})

-- Bootstrap lazy.nvim and plugins
require("config.lazy")
