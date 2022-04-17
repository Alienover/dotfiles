local ls = require("luasnip")
local utils = require("utils")

local w, o, cmd = utils.w, utils.o, utils.cmd

local nmap, vmap, tmap = utils.nmap, utils.vmap, utils.tmap

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

-- Zoom in/out pane
vim.keymap.set({ "n" }, "zo", function()
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
vim.keymap.set({ "n" }, "<C-p>", function()
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
end, {
  silent = true,
})

-- Smart toogling the spell checking
vim.keymap.set({ "n" }, "<leader>s", function()
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
end, {
  silent = true,
})

-- Expand the current snippet or jump to the next item within the snippet
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, {
  silent = true,
})

-- Always move to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, {
  silent = true,
})

-- Selects within a list of options.
-- Useful for choice node
vim.keymap.set({ "i" }, "<C-j>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {
  silent = true,
})
