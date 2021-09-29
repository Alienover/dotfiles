local Utils = require "utils"

local nmap, vmap = Utils.nmap, Utils.vmap

-- Reference:
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/autopairs.lua

require("nvim-autopairs").setup()

-- Mapping <CR>
-- Before        Input         After
-- ------------------------------------
-- {|}           <CR>          {
--                                 |
--                             }
require("nvim-autopairs.completion.compe").setup(
    {
        map_cr = true, --  map <CR> on insert mode
        map_complete = true -- it will auto insert `(` after select function or method item
    }
)

local autopairs_chars = {"()", "{}", "''", '""'}

for _, char in pairs(autopairs_chars) do
    local c_start = char:sub(1, 1)
    local c_end = char:sub(2, 2)
    -- TODO: Remove pairs
    nmap("siw" .. c_start, ("ciw%s<ESC>pa%s<ESC>"):format(c_start, c_end), {silent = true})
    vmap("s" .. c_start, ("s%s<ESC>pa%s<ESC>gvll"):format(c_start, c_end), {silent = true})
end
