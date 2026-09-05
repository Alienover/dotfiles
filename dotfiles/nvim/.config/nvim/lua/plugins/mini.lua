---@type LazySpec
return {
	{
		"nvim-mini/mini.icons",
		config = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{ "nvim-mini/mini.move", event = "VeryLazy", opts = {} },

	{
		"nvim-mini/mini.keymap",
		-- INFO: not `InsertEnter`: terminal mode is entered through
		-- `TermEnter`/`TermOpen`, so that trigger would leave the `t` combo dead
		-- until the first insert-mode entry
		event = "VeryLazy",
		config = function()
			local map_combo = require("mini.keymap").map_combo
			local escape = require("util.escape")

			-- INFO: combos are not mappings. Each key acts immediately and really
			-- lands in the buffer, so the typed characters have to be removed
			-- explicitly with `<BS><BS>`. `util.escape` restores 'modified' when
			-- the buffer was clean before the combo.
			local opts = { delay = vim.o.timeoutlen }

			map_combo("i", "jk", escape.action("<Esc>"), opts)
			map_combo("i", "jj", escape.action("<Esc>"), opts)

			-- INFO: terminal buffers have no meaningful 'modified' state
			map_combo("t", "jk", "<BS><BS><C-\\><C-n>", opts)
		end,
	},

	{
		"nvim-mini/mini.pairs",
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {
			modes = { insert = true, command = true },
		},
	},

	{
		"nvim-mini/mini.surround",
		keys = {
			{ "s", mode = { "n", "v" } },
			"ds",
			"cs",
		},
		opts = {
			-- Whether to disable showing non-error feedback
			silent = true,

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "s", -- Add surrounding in Normal and Visual modes
				delete = "ds", -- Delete surrounding
				replace = "cs", -- Replace surrounding

				-- Disabled
				find = "", -- Find surrounding (to the right)
				find_left = "", -- Find surrounding (to the left)
				highlight = "", -- Highlight surrounding
				suffix_last = "", -- Suffix to search with "prev" method
				suffix_next = "", -- Suffix to search with "next" method
			},
		},
	},
}
