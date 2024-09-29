local utils = require("custom.utils")
local quicker = require("quicker")

quicker.setup()

local QUICKER_CONTEXT = "__quicker_context_expanded"

local mappings = {
	{
		"<space>qc",
		function()
			if not quicker.is_open() then
				return
			end

			local bufnr = vim.api.nvim_get_current_buf()
			local expanded = vim.F.npcall(vim.api.nvim_buf_get_var, bufnr, QUICKER_CONTEXT) == 1

			if expanded then
				quicker.collapse()
			else
				quicker.expand({ before = 2, after = 2, add_to_existing = true })
			end

			vim.api.nvim_buf_set_var(bufnr, QUICKER_CONTEXT, expanded and 0 or 1)
		end,
		"Toggle [Q]uickfix [C]ontext",
	},
}

utils.create_keymaps(vim.tbl_map(function(mapping)
	local lhs, rhs, desc = unpack(mapping)

	return { "n", lhs, rhs, { buffer = true, desc = desc } }
end, mappings))
