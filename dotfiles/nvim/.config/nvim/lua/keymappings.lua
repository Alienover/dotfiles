local utils = require("utils")
local o, cmd, expand = utils.o, utils.cmd, utils.expand

local map, imap, nmap, vmap = utils.map, utils.imap, utils.nmap, utils.vmap

--- LuaSnip plugin wrapper
---@param fn fun(ls: table)
---@return fun()
local function withLuaSnip(fn)
  return function()
    local success, ls = pcall(require, "luasnip")
    if success then
      fn(ls)
    end
  end
end

--- UFO plugin wrapper
---@param fn fun(ufo: Ufo)
---@return fun()
local function withUFO(fn)
  return function()
    local success, ufo = pcall(require, "ufo")
    if not success then
      return
    end

    return fn(ufo)
  end
end

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

nmap("<C-w>h", ":TmuxNavigateLeft<CR>", "Window Left")
nmap("<C-w>l", ":TmuxNavigateRight<CR>", "Window Right")
nmap("<C-w>j", ":TmuxNavigateDown<CR>", "Window Down")
nmap("<C-w>k", ":TmuxNavigateUp<CR>", "Window Up")

-- Buffers navigation
nmap("[[", ":bp<CR>", "[B]uffer [P]revious")
nmap("]]", ":bn<CR>", "[B]uffer [N]next")

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

-- Zoom in/out pane
nmap("zo", function()
  local var_name = "zoom_winrestcmd"
  local winnr = vim.api.nvim_get_current_win()

  ---@type string?
  local winrestcmd = vim.fn.getwinvar(winnr, var_name, "")

  if winrestcmd and #winrestcmd > 0 then
    cmd(winrestcmd)
    vim.api.nvim_win_del_var(winnr, var_name)
  else
    vim.api.nvim_win_set_var(winnr, var_name, vim.fn.winrestcmd())

    -- INFO: expand the current pane
    cmd([[resize]])
    cmd([[vertical resize]])
  end
end, "[Z]oom [O]n")

-- Toggling file finder by telescope or fzf
nmap("<C-p>", function()
  local subcmd, options = "find_files", {}
  if utils.is_inside_git_repo() then
    subcmd = "git_files"
    options["show_untracked"] = true
  end

  utils.telescope(subcmd, options)
end)

-- File browser
map({ "n", "i", "x", "t" }, "<C-f>", function()
  utils.telescope("file_browser", { path = "%:p:h", select_buffer = true })
end, "[F]ile browser")

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
end, "Smart [S]pell")

nmap("<leader>S", function()
  if o.spell then
    o.spell = false
  else
    o.spell = true
  end
end, "Toggle [S]pell")

-- Expand the current snippet or jump to the next item within the snippet
map(
  { "i", "s" },
  "<C-l>",
  withLuaSnip(function(ls)
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)
)

-- Always move to the previous item within the snippet
map(
  { "i", "s" },
  "<C-h>",
  withLuaSnip(function(ls)
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)
)

-- Selects within a list of options.
-- Useful for choice node
imap(
  "<C-j>",
  withLuaSnip(function(ls)
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end)
)

nmap("x", '"_x')

-- URL handling
-- Refer to https://sbulav.github.io/vim/neovim-opening-urls/
nmap("gx", function()
  if vim.fn.has("mac") == 1 then
    vim.fn.jobstart({ "open", vim.fn.expand("<cfile>") }, { detach = true })
  elseif vim.fn.has("unix") == 1 then
    vim.fn.jobstart({ "xdg-open", vim.fn.expand("<cfile>") }, { detach = true })
  else
    vim.notify("Error: gx is not supported on this OS!", vim.log.levels.ERROR)
    return
  end
end, "Browser link")

-- Folding
nmap(
  "zR",
  withUFO(function(ufo)
    ufo.openAllFolds()
  end),
  "Open All Folds"
)
nmap(
  "zM",
  withUFO(function(ufo)
    ufo.closeAllFolds()
  end),
  "Close All Folds"
)

nmap(
  "K",
  withUFO(function(ufo)
    local winid = ufo.peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end),
  "Peak folded lines"
)

nmap(
  "fn",
  withUFO(function(ufo)
    ufo.goNextClosedFold()
  end),
  "[F]old [N]ext"
)

nmap(
  "fp",
  withUFO(function(ufo)
    ufo.goPreviousClosedFold()
  end),
  "[F]old [P]revious"
)

for _, key in ipairs({ "gd", "gf" }) do
  for prefix, split in pairs({ s = "split", v = "vsplit" }) do
    nmap(prefix .. key, function()
      vim.cmd(split)

      vim.api.nvim_feedkeys(key, "x", false)
    end, ("%s and then %s"):format(split, key))
  end
end
