---@type LazySpec
return {
	{
		"rmagatti/goto-preview",
		event = "LspAttach",
		opts = {
			default_mappings = true, -- Bind default mappings
			post_open_hook = function(bufnr)
				pcall(vim.keymap.del, "n", "q", { buffer = bufnr })

				vim.defer_fn(function()
					vim.keymap.set("n", "q", ":q<CR>", { silent = true, buffer = bufnr })
				end, 10)
			end,
		},
		references = {
			provider = "snacks",
		},
	},
}
