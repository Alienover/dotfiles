local utils = require("utils")
local constants = require("utils.constants")

local g, cmd = utils.g, utils.cmd

local c = constants.colors

g.tokyonight_style = "night"
g.tokyonight_italic_functions = true
g.tokyonight_lualine_bold = true

cmd([[colorscheme tokyonight]])

cmd("hi DiffDelete guifg=" .. c.COMMENT_GREY)

cmd(("hi MatchParen guifg=%s guibg=%s"):format("NONE", c.SPECIAL_GREY))

cmd([[hi link TelescopeMatching Constant]])
