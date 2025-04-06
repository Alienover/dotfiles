local utils = require("custom.utils")

local nmap, vmap = utils.nmap, utils.vmap

---@module 'ufo'
local ufo = utils.LazyRequire("ufo")

-- Modes, check `:h map-modes` for more detail
-- * normal_mode	 = "n"
-- * insert_mode	 = "i"
-- * visual_mode	 = "v"
-- * visual_block_mode	 = "x"
-- * term_mode		 = "t"
-- * command_mode	 = "c"

nmap("+", "<C-A>", "Increment")
nmap("-", "<C-X>", "Decrement")

nmap("<Tab>", ":BufferLineCycleNext<CR>", "Next Tab")
nmap("<S-Tab>", ":BufferLineCyclePrev<CR>", "Previous Tab")

-- Open  nvim terminal in split or vertical split
nmap("<C-t>", ":terminal<CR>i")

-- Move lines in <Normal> and <Visual>
-- ∆ for <Option-j> up and ˚ for <Option-k> down
nmap("∆", ":m .+1<CR>==")
nmap("˚", ":m .-2<CR>==")
vmap("∆", ":m '>+1<CR>gv=gv")
vmap("˚", ":m '<-2<CR>gv=gv")

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

-- Zoom in/out pane
nmap("zo", utils.zoom, "[Z]oom [O]n")

-- Toggling file finder by telescope or fzf
nmap("<C-p>", function()
	local subcmd, options = "find_files", {}
	local root = vim.fs.root(vim.fn.expand("%:p"), ".git")

	if root then
		subcmd = "git_files"
		options = vim.tbl_extend("force", options, {
			cwd = root,
			show_untracked = true,
		})
	end

	utils.telescope(subcmd, options)
end)

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

nmap("K", function()
	local winid = ufo.peekFoldedLinesUnderCursor()
	if winid then
		return
	end

	vim.lsp.buf.hover()
end, "Peak lines if folded")

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

-- Scrolling the signature help doc from Noice
-- * <C-d> - Scroll down
-- * <C-u> - Scroll up
utils.create_keymaps(vim.tbl_map(function(preset)
	local lhs, scroll_lines = unpack(preset)
	return {
		{ "n", "i", "s" },
		lhs,
		function()
			local noice_lsp = require("noice.lsp")

			if not noice_lsp.scroll(scroll_lines) then
				return lhs
			end
		end,
		{ expr = true },
	}
end, { { "<C-d>", 4 }, { "<C-u>", -4 } }))
