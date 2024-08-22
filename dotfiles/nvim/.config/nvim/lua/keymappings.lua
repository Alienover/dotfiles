local utils = require("utils")
local consts = require("utils.constants")
local o = utils.o

local map, nmap, vmap = utils.map, utils.nmap, utils.vmap

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

nmap("x", '"_x')

nmap("<leader>S", function()
  o.spell = o.spell == false and true or false
end, "Toggle [S]pell")

-- Zoom in/out pane
nmap("zo", utils.zoom, "[Z]oom [O]n")

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
  require("telescope.builtin").spell_suggest(
    require("telescope.themes").get_cursor({
      initial_mode = "normal",
      layout_config = {
        width = 40,
      },
    })
  )
end, "[S]pell Suggestions")

-- URL handling
-- Refer to https://sbulav.github.io/vim/neovim-opening-urls/
nmap("gx", function()
  local file = vim.fn.expand("<cfile>")
  local open_cmd = nil
  if consts.os.is_mac then
    open_cmd = { "open", file }
  elseif consts.os.is_linux then
    open_cmd = { "xdg-open", file }
  end

  if open_cmd == nil then
    vim.notify("Error: gx is not supported on this OS!", vim.log.levels.ERROR)
    return
  end

  vim.system(open_cmd, { text = true }, function(out)
    if out.code ~= 0 then
      local err_msg = table.concat({
        "Failed to open with the message:",
        vim.trim(out.stdout),
        vim.trim(out.stderr),
      }, "\n")
      vim.notify(err_msg, vim.log.levels.WARN)
    end
  end)
end, "Browser link")

nmap("K", function()
  local status_ok, ufo = pcall(require, "ufo")
  if status_ok then
    local winid = ufo.peekFoldedLinesUnderCursor()
    if winid then
      return
    end
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
