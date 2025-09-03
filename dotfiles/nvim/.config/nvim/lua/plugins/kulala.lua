---@type LazySpec
return {
	{ -- Client for HTTP requests
		"mistweaverco/kulala.nvim",
		ft = { "http", "rest" },
		opts = {
			global_keymaps = true,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
			lsp = { enable = false },
			ui = {
				max_response_size = 500 * 1024, -- 500 Kb
				pickers = {
					snacks = {
						layout = function()
							local opts = require("custom.utils").snacks_picker.get_picker_opts()

							return vim.tbl_deep_extend(
								"force",
								require("snacks.picker").config.layout("telescope"),
								opts.layouts.telescope
							)
						end,
					},
				},
			},
		},
	},
}
