local utils = require("custom.utils")

local nmap, vmap = utils.nmap, utils.vmap

-- Modes, check `:h map-modes` for more detail
-- * normal_mode	 = "n"
-- * insert_mode	 = "i"
-- * visual_mode	 = "v"
-- * visual_block_mode	 = "x"
-- * term_mode		 = "t"
-- * command_mode	 = "c"

nmap("+", "<C-A>", "Increment")
nmap("-", "<C-X>", "Decrement")

-- Increase/decrease indents without losing the selected
vmap("<", "<gv")
vmap(">", ">gv")

-- Paste without losing the yanked content
vmap("p", '"_dP')

-- Join lines without lossing the cursor position
nmap("J", "mzJ`z")

-- Navigate to next/prev and keep the cursor center
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

nmap("x", '"_x')

nmap("<leader>S", function()
	vim.o.spell = vim.o.spell == false and true or false
end, "Toggle [S]pell")

-- Toggling file finder in smart mode with Snacks.picker
nmap("<C-p>", Snacks.picker.smart)

-- File browser
nmap("<C-f>", function()
	require("oil").toggle_float()
end, "Toggle [F]ile browser")

-- Smart toggling the spell checking
nmap("<leader>s", function()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({
		initial_mode = "normal",
		layout_config = {
			width = 40,
		},
	}))
end, "[S]pell Suggestions")

-- Splitting Horizontal/Vertical after running the following cmds
-- * gd - Go to definition
-- * gf - Go to file
for _, key in ipairs({ "gd", "gf" }) do
	for prefix, split in pairs({ s = "split", v = "vsplit" }) do
		nmap(prefix .. key, function()
			vim.cmd(split)

			vim.api.nvim_feedkeys(key, "x", false)
		end, ("%s and then %s"):format(split, key))
	end
end
