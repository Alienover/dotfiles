---@type LazySpec
return {
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = { enabled = true },
			},
			nes = { enabled = false },
		},
    -- stylua: ignore
		keys = {
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
				  require("sidekick.cli").select({ filter = { installed = true } })
				end,
				desc = "Select CLI",
			},
			{
				"<leader>at",
				function()
					local mode = vim.fn.mode()
					if mode == "n" then
						require("sidekick.cli").send({ msg = "{file}" })
						return
					end

					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>af",
				function() require("sidekick.cli").focus() end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			-- Example of a keybinding to open Claude directly
			{
				"<leader>ac",
				function()
				  require("sidekick.cli").toggle({ name = "claude", focus = true })
				end,
				desc = "Sidekick Toggle Claude",
			},
		},
	},
	{ -- Herdr backend for sidekick (local, see lua/util/sidekick_herdr.lua)
		"sidekick-herdr",
		virtual = true,
		cond = vim.env.HC_TERMINAL_ID ~= nil and vim.fn.executable("hc") == 1,
		opts = {
			focus = true, -- focus the agent's herdr pane where sidekick would focus its window
		},
		config = function(_, opts)
			require("util.sidekick_herdr").setup(opts)
		end,
		-- only applied while this plugin is enabled: agents become herdr panes beside nvim
		specs = {
			{
				"folke/sidekick.nvim",
				dependencies = { "sidekick-herdr" },
				opts = {
					cli = {
						mux = { backend = "herdr", create = "split" },
					},
				},
			},
		},
	},
}
