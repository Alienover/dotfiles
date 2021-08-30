require "nvim-treesitter.configs".setup {
    ensure_installed = {
        "bash",
        "css",
        "go",
        "html",
        "jsdoc",
        "python",
        "javascript",
        "jsonc",
        "lua",
        "tsx",
        "typescript"
    },
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false
    },
    indent = {enable = true},
    matchup = {enable = true},
    autopairs = {enable = true},
    playground = {enable = true},
    context_commentstring = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "∑", -- <alt-w> maps in normal mode to init the node/scope selection
            node_incremental = "∑", -- <alt-w> increment to the upper named parent
            node_decremental = "„", -- <alt-W> decrement to the previous node
            scope_incremental = "å" -- <alt-a> increment to the upper scope
        }
    }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.typescript.used_by = "javascriptflow"

table.insert(parser_config.javascript.used_by, "javascript.jsx")
parser_config.typescript.used_by = {"javascriptflow"}
