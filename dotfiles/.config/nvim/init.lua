require("options")
require("autocmd")
require("keymappings")

-- Reference:
-- https://github.com/folke/dot/blob/ed60f5b26ec8b7b938969024a16f4537d9ae5c6c/config/nvim/init.lua
-- No need to load this immediately, since we have packer_compiled
-- vim.defer_fn(function()
--   require("packer_plugins")
-- end, 0)

require("utils.lazy").setup("plugins")
