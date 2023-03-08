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

local function d(desc)
  local res = vim.deepcopy(opts)
  if desc then
    res.desc = desc
  end

  return res
end

-- Modes
-- * normal_mode	 = "n"
-- * insert_mode	 = "i"
-- * visual_mode	 = "v"
-- * visual_block_mode	 = "x"
-- * term_mode		 = "t"
-- * command_mode	 = "c"

-- Buffers navigation
nmap("<C-h>", ":bp<CR>", d("[B]uffer [P]revious"))
nmap("<C-l>", ":bn<CR>", d("[B]uffer [N]next"))

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

-- Join lines without lossing the cursor position
nmap("J", "mzJ`z", opts)

-- Navigate to next/prev and keep the cursor center
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

nmap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
nmap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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
  desc = "[Z]oom [O]n",
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
end, d("Smart [S]pell"))

nmap("<leader>S", function()
  if o.spell then
    o.spell = false
  else
    o.spell = true
  end
end, d("Toggle [S]pell"))

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

nmap("x", '"_x', opts)

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
end, d("Browser link"))

-- Folding
local function ufoWrapper(fn)
  local success, ufo = pcall(require, "ufo")
  if not success then
    return
  end

  return ufo[fn]()
end

nmap("zR", function()
  ufoWrapper("openAllFolds")
end, opts)
nmap("zM", function()
  ufoWrapper("closeAllFolds")
end, opts)

nmap("K", function()
  local winid = ufoWrapper("peekFoldedLinesUnderCursor")
  if not winid then
    cmd("Lspsaga hover_doc")
  end
end, opts)

nmap("fn", function()
  ufoWrapper("goNextClosedFold")
end, d("[F]old [N]ext"))
nmap("fp", function()
  ufoWrapper("goPreviousClosedFold")
end, d("[F]old [P]revious"))

-- Keymaps for leap.nvim
nmap("f", function()
  require("leap").leap({})
end, d("[F]ind by leap"))
nmap("F", function()
  require("leap").leap({ backward = true })
end, d("[F]ind backward by leap"))
