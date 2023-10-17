require("nvim-treesitter.configs").setup({
  modules = {}, -- Empty to remove the warning
  ensure_installed = {
    "vim",
    "help",
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
    "regex",
    "markdown",
    "markdown_inline",
    "norg",
  },
  auto_install = true,
  sync_install = false,
  ignore_install = {},
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
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
  refactor = {
    highlight_definitions = {
      enable = true,
    },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = false,
    },
    navigation = {
      enable = false,
    },
  },
})
