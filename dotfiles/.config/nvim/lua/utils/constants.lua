local M = {}

---@param var string
---@param default? string
---@return string
local getenv = function(var, default)
  default = default or ""
  return os.getenv(var) or default or ""
end

---@type table
---@diagnostic disable-next-line: assign-type-mismatch
M.icons = require("utils.icons")

M.LOCAL_PLUGINS_FOLDER = vim.fn.stdpath("config") .. "/my_plugins"

M.files = {
  vim = getenv("HOME") .. "/.vimrc",
  -- NeoVim initialization file
  nvim = getenv("XDG_CONFIG_HOME") .. "/nvim/init.lua",
  -- Folder saved snippets
  snippets = getenv("XDG_CONFIG_HOME") .. "/nvim/snippets",
  -- Tmux config
  tmux = getenv("HOME") .. "/.tmux.conf",
  -- Kitty config
  kitty = getenv("XDG_CONFIG_HOME") .. "/kitty/kitty.conf",
  -- ZSH config
  zsh = getenv("XDG_CONFIG_HOME") .. "/zsh/.zshrc",
  -- Yabai config
  yabai = getenv("XDG_CONFIG_HOME") .. "/yabai/yabairc",
  -- SKHD config
  skhd = getenv("XDG_CONFIG_HOME") .. "/skhd/skhdrc",
  -- Dotfiles folder
  dotfiles = getenv("HOME") .. "/src/dotfiles",
  -- Work relatives
  work_config = getenv("EDISON_REPO_DIR") .. "/../others",
  workdirs = getenv("EDISON_REPO_DIR"),
}

M.colors = {
  RED = getenv("GUI_RED"),
  BLACK = getenv("GUI_BLACK"),
  GREEN = getenv("GUI_GREEN"),
  PRIMARY = getenv("GUI_BLUE"),
  BG = getenv("GUI_BACKGROUND"),
  FG = getenv("GUI_FOREGROUND"),
  DARK_RED = getenv("GUI_DARK_RED"),
  DARK_YELLOW = getenv("GUI_DARK_YELLOW"),
  VISUAL_GREY = getenv("GUI_VISUAL_GREY"),
  COMMENT_GREY = getenv("GUI_COMMENT_GREY"),
  SPECIAL_GREY = getenv("GUI_SPECIAL_GREY"),
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
    "httpResult",
    "terminal",
  },
  close_by_q = {
    "qf",
    "fzf",
    "man",
    "git",
    "help",
    "lspinfo",
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
  taplo = {
    [M.external_types.lsp] = true,
    mason = "taplo",
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
  jsonlint = {
    [M.external_types.linter] = true,
    mason = "jsonlint",
  },
}

return M
