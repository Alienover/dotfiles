local Cowboy = require("util.cowboy")

---@module 'snacks'

-- Modes, check `:h map-modes` for more detail
-- * normal_mode	 = "n"
-- * insert_mode	 = "i"
-- * visual_mode	 = "v"
-- * visual_block_mode	 = "x"
-- * term_mode		 = "t"
-- * command_mode	 = "c"

-- Increase/decrease indents without losing the selected
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Paste without losing the yanked content
vim.keymap.set("v", "p", '"_dP')

-- Join lines without lossing the cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Navigate to next/prev and keep the cursor center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "x", '"_x')

-- Toggling file finder in smart mode with Snacks.picker
vim.keymap.set("n", "<C-p>", Snacks.picker.smart)

-- File browser
vim.keymap.set("n", "<C-f>", function()
	require("oil").toggle_float()
end, { desc = "Toggle [F]ile browser" })

-- Smart toggling the spell checking
vim.keymap.set("n", "<leader>s", function()
	Snacks.picker.spelling({
		layout = {
			preset = "select",
			layout = {
				relative = "cursor",
				row = 1.01,
				max_width = 40,
				max_height = 13,
			},
		},
	})
end, { desc = "[S]pell Suggestions" })

vim.keymap.set("n", "<leader>S", function()
	vim.o.spell = vim.o.spell == false and true or false
end, { desc = "Toggle [S]pell" })

-- * gd - Go to definition
-- * gf - Go to file
for _, key in ipairs({ "gd", "gf" }) do
	for prefix, split in pairs({ s = "split", v = "vsplit" }) do
		vim.keymap.set("n", prefix .. key, function()
			vim.cmd(split)

			vim.api.nvim_feedkeys(key, "x", false)
		end, { desc = ("%s and then %s"):format(split, key) })
	end
end

-- Better HJKL including
-- * Cowboy discipline
-- * `j`, `k` for wrapped lines
for _, key in ipairs({ "h", "j", "k", "l" }) do
	vim.keymap.set({ "n", "v" }, key, function()
		local mode = vim.api.nvim_get_mode()["mode"]

		-- INFO: check discipline when navigating in `Normal` mode
		if mode == "n" then
			if not Cowboy:check(key) then
				return ""
			end
		end

		-- INFO: remap `j` -> `gj`, `k` -> `gk` when in `Normal` or `Visual` mode
		if vim.tbl_contains({ "j", "k" }, key) and vim.tbl_contains({ "n", "v" }, mode) then
			return "g" .. key
		end

		return key
	end, { expr = true })
end
