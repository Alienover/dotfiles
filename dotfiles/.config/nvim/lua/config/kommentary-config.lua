-- Reference
-- https://github.com/folke/dot/blob/master/config/nvim/lua/config/comments.lua

require("kommentary.config").configure_language(
    "default",
    { prefer_single_line_comments = true }
)
