local utils = require("utils")
local constants = require("utils.constants")

local g, cmd = utils.g, utils.cmd

local c = constants.colors

local M = {}

local default_opts = table.concat({
  string.format(
    "--color=%s,%s,%s,%s",
    ("fg:%s,bg:%s"):format(c.FG, c.BG),
    ("hl:%s"):format(c.PRIMARY),
    ("fg+:%s,bg+:%s,hl+:%s"):format("15", c.BG, c.DARK_YELLOW),
    ("info:%s,prompt:%s,spinner:%s,pointer:%s,marker:%s"):format(
      c.PRIMARY,
      c.PRIMARY,
      c.PRIMARY,
      c.PRIMARY,
      c.DARK_YELLOW
    )
  ),
  "--layout=reverse",
  "--margin=1,2",
  "--prompt=' 🌈 '",
}, " ")

M.open_floating_win = function(opts)
  opts = opts or {}
  local win_spec = utils.get_window_sepc()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_var(buf, "signcolumn", "no")

  local height = opts.height or 30
  local width = opts.width or 90
  local col = math.floor((win_spec.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    height = height,
    width = width,
    col = col,
    row = 0,
    relative = "editor",
    style = "minimal",
  })
end

M.fzf_files = function()
  local source = table.concat({
    "fd --type=f --no-ignore",
    "--exclude=node_modules",
    "--exclude=dist",
    "--exclude=target",
  }, " ")

  local bat_cmd = table.concat({
    "bat",
    "--style=changes",
    "--color=always",
    "--line-range=:40",
  }, " ")

  local options = table.concat({
    default_opts,
    string.format(
      "--preview='if file {} | grep -v text; then file -b {}; else %s {}; fi'",
      bat_cmd
    ),
    "--preview-window=bottom",
  }, " ")

  cmd(string.format(
    [[
	call fzf#run(fzf#wrap({ "source": "%s", "options": "%s" }))
    ]],
    source,
    options
  ))
end

M.setup = function()
  -- Default fzf layout
  if g.fzf_layout == nil then
    g.fzf_layout = {
      window = "lua require('fzf-finder').open_floating_win()",
    }
  end

  vim.api.nvim_create_user_command("FZFFiles", function()
    M.fzf_files()
  end, { nargs = 0 })
end

return M
