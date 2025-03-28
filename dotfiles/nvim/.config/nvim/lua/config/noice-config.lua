local utils = require("custom.utils")

require("noice").setup({
	presets = { inc_rename = true, lsp_doc_border = true },
	cmdline = {
		format = {
			cmdline = { pattern = "^:", icon = " ", lang = "vim" },
			lua = false,
		},
	},
	notify = { enabeled = false },
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		progress = {
			enabled = false,
		},
		signature = {
			enabled = true,
			auto_open = {
				enabled = true,
				trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
				luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
				throttle = 50, -- Debounce lsp signature help request by 50ms
			},
			view = nil, -- when nil, use defaults from documentation
			---@type NoiceViewOptions
			opts = {}, -- merged with defaults from documentation
		},
		-- defaults for hover and signature help
		documentation = {
			view = "hover",
			---@type NoiceViewOptions
			opts = {
				lang = "markdown",
				replace = true,
				render = "plain",
				format = { "{message}" },
				win_options = { concealcursor = "n", conceallevel = 3 },
			},
		},
	},
	routes = {
		{
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		},
	},
})

local make_mapping = function(lhs, rhs)
	return {
		{ "n", "i", "s" },
		lhs,
		function()
			if not rhs(require("noice.lsp")) then
				return lhs
			end
		end,
		{ expr = true },
	}
end

utils.create_keymaps({
	-- Scroll down
	make_mapping("<c-d>", function(noice_lsp)
		return noice_lsp.scroll(4)
	end),
	-- Scroll up
	make_mapping("<c-u>", function(noice_lsp)
		return noice_lsp.scroll(-4)
	end),
})
