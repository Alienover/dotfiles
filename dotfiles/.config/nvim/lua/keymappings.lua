local utils = require("utils")

local w, o, cmd = utils.w, utils.o, utils.cmd

local nmap, vmap, tmap = utils.nmap, utils.vmap, utils.tmap

local t = utils.r_code

local opts = { noremap = true, silent = true }

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

function _G.zoom_toggle()
  if w.zoomed and w.zoom_winrestcmd then
    cmd([[ execute w:zoom_winrestcmd ]])
    w.zoomed = false
  else
    w.zoom_winrestcmd = vim.fn.winrestcmd()
    cmd([[resize]])
    cmd([[vertical resize]])
    w.zoomed = true
  end
  return true
end

nmap("zo", "v:lua.zoom_toggle()", { expr = true, silent = true })

function _G.smart_ctrlp()
  if utils.find_git_ancestor() then
    local options = {}
    local win_spec = utils.get_window_sepc()

    if win_spec.columns < 200 then
      table.insert(options, "theme=get_dropdown")
    end

    return t(table.concat({
      "<Cmd>",
      "Telescope find_files",
      table.concat(options, " "),
      "<CR>",
    }, " "))
  else
    return t([[<cmd>call v:lua.fzf_files()<CR>]])
  end
end

nmap("<C-p>", "v:lua.smart_ctrlp()", { expr = true, silent = true })

-- Smart toogling the spell checking
function _G.toggle_spell()
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
    return t("<Cmd>WhichKey z=<CR>")
  end

  return true
end

nmap("<leader>s", "v:lua.toggle_spell()", { expr = true, silent = true })
