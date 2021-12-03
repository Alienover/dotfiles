local utils = require("utils")
local constants = require("utils.constants")

local g, cmd = utils.g, utils.cmd

local c = constants.colors

g.tokyonight_style = "night"
g.tokyonight_italic_functions = true
cmd([[colorscheme tokyonight]])

-- g.onedark_italic_function = true
-- g.onedark_sidebars = {"qf", "vista_kind", "terminal", "packer"}

-- cmd [[colorscheme onedark]]

-- g.onedark_style = "deep"
-- require "onedark".setup()

cmd("hi DiffDelete guifg=" .. c.COMMENT_GREY)

cmd(("hi MatchParen guifg=%s guibg=%s"):format("NONE", c.SPECIAL_GREY))

cmd([[hi link TelescopeMatching Constant]])
