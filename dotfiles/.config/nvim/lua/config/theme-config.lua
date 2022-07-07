local utils = require("utils")
local constants = require("utils.constants")

local g, cmd = utils.g, utils.cmd

local c = constants.colors

-- Tokyo Night
if true then
  g.tokyonight_style = "night"
  g.tokyonight_italic_functions = true
  g.tokyonight_lualine_bold = true
  g.tokyonight_hide_inactive_statusline = true
  g.tokyonight_sidebars = { "qf", "terminal", "packer" }

  cmd([[colorscheme tokyonight]])
end

cmd("hi DiffDelete guifg=" .. c.COMMENT_GREY)

cmd(("hi MatchParen guifg=%s guibg=%s"):format("NONE", c.SPECIAL_GREY))

cmd([[hi link TelescopeMatching Constant]])
