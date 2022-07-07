require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "css",
    "go",
    "html",
    "jsdoc",
    "python",
    "javascript",
    "json",
    "jsonc",
    "lua",
    "tsx",
    "typescript",
    "http",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  matchup = { enable = true },
  autotag = { enable = true },
  autopairs = { enable = true },
  playground = { enable = true },
  context_commentstring = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "∑", -- <alt-w> maps in normal mode to init the node/scope selection
      node_incremental = "∑", -- <alt-w> increment to the upper named parent
      node_decremental = "ß", -- <alt-s> decrement to the previous node
      scope_incremental = "å", -- <alt-a> increment to the upper scope
    },
  },
  refactor = {
    highlight_definitions = {
      -- Replace it with vim-illuminate
      enable = false,
    },
    smart_rename = {
      enable = false,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "gnd",
        -- list_definitions = "gnD",
        -- list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
})
