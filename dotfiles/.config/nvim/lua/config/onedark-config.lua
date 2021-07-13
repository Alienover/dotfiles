local Utils = require "utils"

local cmd = Utils.cmd

local c = Utils.colors

cmd [[colorscheme onedark]]

cmd("hi DiffDelete guifg=" .. c.COMMENT_GREY)
