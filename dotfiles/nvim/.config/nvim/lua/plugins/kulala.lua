local utils = require("custom.utils")

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
				pickers = {
					snacks = {
						layout = function()
							local opts = utils.snacks_picker.get_picker_opts()

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
