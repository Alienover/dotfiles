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
