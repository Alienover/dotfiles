local utils = require("utils")

local w, o, cmd, expand = utils.w, utils.o, utils.cmd, utils.expand

local map, imap, nmap, vmap = utils.map, utils.imap, utils.nmap, utils.vmap

local opts = { noremap = true, silent = true }

local function luasnipWrapper(fn)
  return function()
    local success, ls = pcall(require, "luasnip")
    if success then
      fn(ls)
    end
  end
end

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

-- Open  nvim terminal in split or vertical split
nmap("<C-t>", ":terminal<CR>i", opts)

-- Move lines in <Normal> and <Visual>
-- ∆ for <Option-j> up and ˚ for <Option-k> down
nmap("∆", ":m .+1<CR>==", opts)
nmap("˚", ":m .-2<CR>==", opts)
vmap("∆", ":m '>+1<CR>gv=gv", opts)
vmap("˚", ":m '<-2<CR>gv=gv", opts)

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
      table.insert(options, "theme=dropdown")
    end

    cmd(table.concat({
      "Telescope find_files",
      table.concat(options, " "),
    }, " "))
  else
    cmd("FZFFiles")
  end
end, opts)

-- Smart toggling the spell checking
nmap("<leader>s", function()
  local cursor_word = expand("<cword>")

  if cursor_word == "" then
    -- Toggle the spell check when hover on empty word
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
map(
  { "i", "s" },
  "<C-l>",
  luasnipWrapper(function(ls)
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end),
  opts
)

-- Always move to the previous item within the snippet
map(
  { "i", "s" },
  "<C-h>",
  luasnipWrapper(function(ls)
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end),
  opts
)

-- Selects within a list of options.
-- Useful for choice node
imap(
  "<C-j>",
  luasnipWrapper(function(ls)
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end),
  opts
)

nmap("x", '"_x')

-- URL handling
-- Refer to https://sbulav.github.io/vim/neovim-opening-urls/
nmap("gx", function()
  local c = ""
  if vim.fn.has("mac") == 1 then
    c = 'call jobstart(["open", expand("<cfile>")], {"detach": v:true})'
  elseif vim.fn.has("unix") == 1 then
    c = 'call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})'
  else
    vim.notify("Error: gx is not supported on this OS!", vim.log.levels.ERROR)
    return
  end

  cmd(c)
end, opts)

-- Folding
-- nmap("zR", function()
--   require("ufo").openAllFolds()
-- end, opts)
-- nmap("zM", function()
--   require("ufo").closeAllFolds()
-- end)

nmap("K", function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    cmd("Lspsaga hover_doc")
  end
end, opts)

nmap("fn", function()
  require("ufo").goNextClosedFold()
end, opts)
nmap("fp", function()
  require("ufo").goPreviousClosedFold()
end, opts)
