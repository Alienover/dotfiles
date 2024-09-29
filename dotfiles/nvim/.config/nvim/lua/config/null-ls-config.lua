local null_ls = require("null-ls")

local utils = require("custom.utils")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
		null_ls.builtins.formatting.isort,

		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
		null_ls.builtins.formatting.stylua,

		null_ls.builtins.code_actions.gitsigns,
	},
})

--- INFO: override the builit-in info window
vim.api.nvim_del_user_command("NullLsInfo")
vim.api.nvim_create_user_command("NullLsInfo", function()
	require("null-ls.info").show_window()

	vim.schedule(function()
		local winnr = vim.api.nvim_get_current_win()

		vim.api.nvim_win_set_config(winnr, utils.get_float_win_opts({ border = true }))

		vim.api.nvim_set_option_value("winhl", "NullLsInfoBorder:FloatBorder", { win = winnr })
	end)
end, {})
