local ls = require("luasnip")
local utils = require("utils")

local w, o, cmd = utils.w, utils.o, utils.cmd

local map, imap, nmap, vmap, tmap =
  utils.map, utils.imap, utils.nmap, utils.vmap, utils.tmap

local opts = { noremap = true, silent = true }

-- Modes
-- * normal_mode	 = "n"
-- * insert_mode	 = "i"
-- * visual_mode	 = "v"
-- * visual_block_mode	 = "x"
-- * term_mode		 = "t"
-- * command_mode	 = "c"

-- Buffers navigation
nmap("<C-h>", ":bp<CR>", opts)
nmap("<C-l>", ":bn<CR>", opts)

-- Open  nvim terminal in split or vertival split
nmap("<C-t>", ":terminal<CR>i", opts)

-- Unfocus the terminal window
tmap("<leader><ESC>", "<C-\\><C-n>", opts)

-- Move lines in <Normal> and <Visual>
-- ∆ for <Option-j> up and ˚ for <Option-k> down
nmap("∆", ":m .+1<CR>==", opts)
nmap("˚", ":m .-2<CR>==", opts)
vmap("∆", ":m '>+1<CR>gv=gv", opts)
vmap("˚", ":m '<-2<CR>gv=gv", opts)

-- Press `jk` to escape from insert mode
imap("jk", "<ESC>", opts)

-- Increase/decrease indents without losing the selected
vmap("<", "<gv", opts)
vmap(">", ">gv", opts)

-- Paste without losing the yanked content
vmap("p", '"_dP', opts)

-- Zoom in/out pane
nmap("zo", function()
  if w.zoomed and w.zoom_winrestcmd then
    cmd([[ execute w:zoom_winrestcmd ]])
    w.zoomed = false
  else
    w.zoom_winrestcmd = vim.fn.winrestcmd()
    cmd([[resize]])
    cmd([[vertical resize]])
    w.zoomed = true
  end
end, {
  silent = true,
})

-- Smart toggling file finder by telescope or fzf
nmap("<C-p>", function()
  if utils.find_git_ancestor() then
    local options = {}
    local win_spec = utils.get_window_sepc()

    if win_spec.columns < 200 then
      table.insert(options, "theme=get_dropdown")
    end

    cmd(table.concat({
      "Telescope find_files",
      table.concat(options, " "),
    }, " "))
  else
    fzf_files()
  end
end, opts)

-- Smart toogling the spell checking
nmap("<leader>s", function()
  ---@diagnostic disable-next-line: missing-parameter
  local cursor_word = vim.fn.expand("<cword>")

  if cursor_word == "" then
    -- Toogle the spell check when hover on empty word
    if o.spell then
      o.spell = false
    else
      o.spell = true
    end
  else
    -- List suggestions when hovering on word
    cmd("WhichKey z=")
  end
end, opts)

-- Expand the current snippet or jump to the next item within the snippet
map({ "i", "s" }, "<C-l>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, opts)

-- Always move to the previous item within the snippet
map({ "i", "s" }, "<C-h>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, opts)

-- Selects within a list of options.
-- Useful for choice node
imap("<C-j>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, opts)

-- Delete buffer but keep the window
nmap("<leader>bd", function()
  local kwbdi = require("config/kwbdi-config")
  kwbdi:kill_buf_safe()
end, opts)

nmap("<leader>bD", function()
  local kwbdi = require("config/kwbdi-config")
  kwbdi:kill_buf()
end, opts)
