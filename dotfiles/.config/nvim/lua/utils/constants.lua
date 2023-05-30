local M = {}

M.icons = require("utils.icons")

M.LOCAL_PLUGINS_FOLDER = vim.fn.stdpath("config") .. "/lua/local_plugins"

M.local_plugins = {
  kwbdi = M.LOCAL_PLUGINS_FOLDER .. "/kwbdi.nvim",
  winbar = M.LOCAL_PLUGINS_FOLDER .. "/winbar.nvim",
  fzf = M.LOCAL_PLUGINS_FOLDER .. "/fzf-finder.nvim",
  marks = M.LOCAL_PLUGINS_FOLDER .. "/lsp-marks.nvim",
}

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

return M
