vim.notify("loading config for vscode...")
local vscode = require("vscode")

local vs_action = function(action)
	return function()
		vscode.action(action)
	end
end

local options = {
	number = true,

	clipboard = "unnamed",

	shiftwidth = 2,
	tabstop = 2,
	expandtab = true,

	smartcase = true,
	ignorecase = true,
}

for opt, value in pairs(options) do
	vim.opt[opt] = value
end

-- Paste without losing the yanked content
vim.keymap.set({ "n", "v" }, "p", '"_dP')
-- Join lines without lossing the cursor position
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("i", "jk", vs_action("vscode-neovim.escape"))

vim.keymap.set("n", "<Tab>", vs_action("workbench.action.nextEditor"), { desc = "Next Tab" })
vim.keymap.set("n", "<S-Tab>", vs_action("workbench.action.previousEditor"), { desc = "Previous Tab" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yark",

	callback = function()
		vim.highlight.on_yank({})
	end,
})

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local found, lazy = pcall(require, "lazy")
if found then
	lazy.setup({
		spec = {
			{
				"echasnovski/mini.surround",
				config = function()
					require("config.surround-config")
				end,
			},
			{
				"folke/flash.nvim",
				config = function()
					require("config.flash-config")
				end,
			},

			{ -- Highlight, edit, and navigate code
				"nvim-treesitter/nvim-treesitter",
				build = ":TSUpdate",
				dependencies = {
					"nvim-treesitter/nvim-treesitter-refactor",
					"nvim-treesitter/nvim-treesitter-textobjects",
				},
				config = function()
					require("config.treesitter-config")
				end,
			},
		},
		install = {
			missing = false,
		},
		change_detection = {
			enabled = false,
			notify = false,
		},
	})
else
end
