local M = {}

---@type table
---@diagnostic disable-next-line: assign-type-mismatch
M.icons = require("utils.icons")

M.LOCAL_PLUGINS_FOLDER = vim.fn.stdpath("config") .. "/my_plugins"

M.files = {
  vim = os.getenv("HOME") .. "/.vimrc",
  -- NeoVim initialization file
  nvim = os.getenv("XDG_CONFIG_HOME") .. "/nvim/init.lua",
  -- Folder saved snippets
  snippets = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets",
  -- Tmux config
  tmux = os.getenv("HOME") .. "/.tmux.conf",
  -- Kitty config
  kitty = os.getenv("XDG_CONFIG_HOME") .. "/kitty/kitty.conf",
  -- ZSH config
  zsh = os.getenv("XDG_CONFIG_HOME") .. "/zsh/.zshrc",
  -- Yabai config
  yabai = os.getenv("XDG_CONFIG_HOME") .. "/yabai/yabairc",
  -- SKHD config
  skhd = os.getenv("XDG_CONFIG_HOME") .. "/skhd/skhdrc",
  -- Dotfiles folder
  dotfiles = os.getenv("HOME") .. "/src/dotfiles",
  -- Work relatives
  work_config = os.getenv("EDISON_REPO_DIR") .. "/../others",
  workdirs = os.getenv("EDISON_REPO_DIR"),
}

M.colors = {
  RED = os.getenv("GUI_RED"),
  BLACK = os.getenv("GUI_BLACK"),
  GREEN = os.getenv("GUI_GREEN"),
  PRIMARY = os.getenv("GUI_BLUE"),
  BG = os.getenv("GUI_BACKGROUND"),
  FG = os.getenv("GUI_FOREGROUND"),
  DARK_RED = os.getenv("GUI_DARK_RED"),
  DARK_YELLOW = os.getenv("GUI_DARK_YELLOW"),
  VISUAL_GREY = os.getenv("GUI_VISUAL_GREY"),
  COMMENT_GREY = os.getenv("GUI_COMMENT_GREY"),
  SPECIAL_GREY = os.getenv("GUI_SPECIAL_GREY"),
}

M.filetype_mappings = setmetatable({
  jsonc = "JSON with comments",
  txt = "Plain Text",
  sql = "SQL",
}, {
  __index = function(_, key)
    return key
  end,
})

local os_name = vim.loop.os_uname().sysname

M.os = {
  is_mac = os_name == "Darwin",
  is_linux = os_name == "Linux",
  is_windows = os_name == "Windows_NT",
  is_wsl = vim.fn.has("wsl") == 1,
}

M.special_filetypes = {
  excluded_winbar = {
    "git",
    "help",
    "packer",
    "rnvimr",
    "noice",
    "DiffviewFiles",
    "DiffviewFileHistory",
  },
  close_by_q = {
    "qf",
    "fzf",
    "man",
    "git",
    "help",
    "lspinfo",
    "httpResult",
    "startuptime",
    "null-ls-info",
    "git.nvim",
    "query",
  },
}

M.window_sizing = {
  md = {
    width = 250,
    height = 65,
  },
}

---@type table<string, "LSP" | "FORMATTER" | "LINTER">
M.external_types = {
  lsp = "LSP",
  formatter = "FORMATTER",
  linter = "LINTER",
}

---@class External
---@field LSP? boolean
---@field FORMATTER? boolean
---@field LINTER? boolean
---@field mason? string
---@field config_file? string
--
---@type table<string, External>
M.ensure_externals = {
  -- INFO: LSP
  html = {
    [M.external_types.lsp] = true,
    mason = "html-lsp",
  },
  cssls = {
    [M.external_types.lsp] = true,
    mason = "css-lsp",
  },
  vimls = {
    [M.external_types.lsp] = true,
    mason = "vim-language-server",
  },
  bashls = {
    [M.external_types.lsp] = true,
    mason = "bash-language-server",
  },
  pyright = {
    [M.external_types.lsp] = true,
    mason = "pyright",
  },
  tailwindcss = {
    [M.external_types.lsp] = true,
    mason = "tailwindcss-language-server",
  },
  flow = {
    [M.external_types.lsp] = true,
    config_file = "lsp.flow-lsp",
  },
  jsonls = {
    [M.external_types.lsp] = true,
    mason = "json-lsp",
    config_file = "lsp.json-lsp",
  },
  tsserver = {
    [M.external_types.lsp] = true,
    mason = "typescript-language-server",
    config_file = "lsp.ts-lsp",
  },
  gopls = {
    [M.external_types.lsp] = true,
    mason = "gopls",
    config_file = "lsp.go-lsp",
  },
  lua_ls = {
    [M.external_types.lsp] = true,
    mason = "lua-language-server",
    config_file = "lsp.lua-lsp",
  },

  -- INFO: Formatters
  stylua = {
    [M.external_types.formatter] = true,
    mason = "stylua",
  },
  isort = {
    [M.external_types.formatter] = true,
    mason = "isort",
  },
  black = {
    [M.external_types.formatter] = true,
    mason = "black",
  },
  prettier = {
    [M.external_types.formatter] = true,
    mason = "prettier",
  },

  -- INFO: Linters
  eslint = {
    [M.external_types.linter] = true,
  },
}

return M
