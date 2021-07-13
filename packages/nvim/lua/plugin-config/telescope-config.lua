-- Reference
-- https://github.com/nvim-telescope/telescope.nvim

local actions = require "telescope.actions"

require("telescope").setup {
    defaults = {
        layout_config = {
            width = 0.5,
            height = 0.5
        },
        prompt_prefix = "$ ",
        mappings = {
            n = {
                q = actions.close
            }
        }
    }
}

require "telescope".load_extension "fzf"
