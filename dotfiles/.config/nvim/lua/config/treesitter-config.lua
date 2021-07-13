require "nvim-treesitter.configs".setup {
    ensure_installed = {
        "bash",
        "css",
        "go",
        "html",
        "jsdoc",
        "javascript",
        "jsonc",
        "lua",
        "tsx"
    },
    highlight = {
        enable = true,
        use_languagetree = true
    },
    indent = {enable = true},
    autopairs = {enable = true},
    playground = {enable = true},
    context_commentstring = {enable = true},
    incremental_selection = {enable = true}
}
