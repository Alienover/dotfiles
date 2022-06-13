local utils = require("utils")
local constants = require("utils.constants")
local wk = require("which-key")

local o, g, cmd = utils.o, utils.g, utils.cmd

-- Populate the vim cmd prefix and suffix
local t = function(str)
  return function()
    cmd(str)
  end
end

-- Populate the command for file to edit
local e = function(filepath)
  return t("e " .. filepath)
end

-- Populate the floating terminal command with presets
local ft = function(input)
  return function()
    local options = { border = true }
    local terminal = require("utils/floating_terminal")

    if input == nil then
      terminal:toggle()
    else
      table.insert(options, 1, input)
      terminal:open(options)
    end
  end
end

local function toggle_diffview()
  if g.diffview_opened then
    g.diffview_opened = false
    cmd("DiffviewClose")
  else
    g.diffview_opened = true
    cmd("DiffviewOpen")
  end
end

local function telescope(sub_cmd, opts)
  return function()
    local options = {}

    for k, v in pairs(opts or {}) do
      table.insert(options, ("%s=%s"):format(k, v))
    end

    local win_spec = utils.get_window_sepc()

    if win_spec.columns < 200 then
      table.insert(options, "theme=dropdown")
    end

    cmd(table.concat({
      "Telescope",
      sub_cmd,
      table.concat(options, " "),
    }, " "))
  end
end

local function workspaces(base)
  -- Scan the certain workspace
  local plenary = require("plenary.scandir")
  local dirs = plenary.scan_dir(base, { depth = 1, only_dirs = true })

  -- Default config
  local config = {
    name = ("%s Edison"):format(constants.icons.ui.Email),
    O = {
      telescope("find_files", {
        cwd = constants.files.work_config,
        prompt_title = "Search\\ Config",
      }),
      "Search Config",
    },
  }

  -- Set the first letter of the folder as the trigger key
  for _, v in pairs(dirs) do
    local dir = string.match(v, "/([^/]+)$")
    local key = string.sub(dir, 1, 1)

    if config[key] == nil then
      key = string.lower(key)
    end

    config[key] = {
      telescope("find_files", {
        cwd = v,
        no_ignore = true,
        prompt_title = ("Search " .. dir):gsub(" ", "\\ "),
      }),
      "Search " .. dir,
    }
  end

  return config
end

local function gitsigns(sub_cmd)
  return t("Gitsigns " .. sub_cmd)
end

local function lspsaga(sub_cmd)
  return t("Lspsaga " .. sub_cmd)
end

local function buffer_delete(force)
  return function()
    local kwdbi = require("local_plugins.kwdbi")
    if force == true then
      kwdbi:kill_buf()
    else
      kwdbi:kill_buf_safe()
    end
  end
end

o.timeoutlen = 500

wk.setup({
  show_help = true,
  triggers = "auto",
  plugins = {
    spelling = {
      enabled = true,
      suggestions = 10,
    },
    presets = false,
  },
  key_labels = { ["<space>"] = "» Quick Actions" },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➟", -- symbol used between a key and it's label
    group = "＋", -- symbol prepended to a group
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 1, 0, 1, 0 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 2, max = 15 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 5, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k", "g" },
    v = { "j", "k", "g" },
  },
})

local key_maps = {
  h = {
    name = "Help",
    t = { telescope("builtin"), "Telescope" },
    c = { telescope("command"), "Commands" },
    k = { telescope("keymaps"), "key Maps" },
    h = { telescope("highlights"), "Highlight Groups" },
    p = {
      name = "Packer",
      p = { t("PackerSync"), "Sync" },
      s = { t("PackerStatus"), "Status" },
      i = { t("PackerInstall"), "Install" },
      c = { t("PackerCompile"), "Compile" },
    },
  },
  e = workspaces(constants.files.workdirs),
  s = { t("split"), "Split" },
  v = { t("vsplit"), "Split vertically" },
  b = {
    name = "Buffers",
    d = { buffer_delete(), "Delete" },
    D = { buffer_delete(true), "Force Delete" },
    f = { t("bfirst"), "First" },
    l = { t("blast"), "Last" },
    n = { t("bnext"), "Next" },
    p = { t("bprevious"), "Previous" },
    b = { telescope("buffers"), "Find buffers" },
  },
  t = {
    name = "Terminal",
    [";"] = { ft("zsh"), "terminal" },
    h = { ft("htop"), "htop" },
    p = { ft("python"), "python" },
    n = { ft("node"), "node" },
    t = { ft(), "Toggle" },
  },
  g = {
    name = "Git",
    d = { toggle_diffview, "Toggle diffview" },
    c = { telescope("git_commits"), "Git commits" },
    f = { telescope("git_files"), "Git files" },
    j = { gitsigns("next_hunk"), "Next hunk" },
    k = { gitsigns("prev_hunk"), "Previous hunk" },
    p = { gitsigns("preview_hunk"), "Preview hunk" },
    b = { gitsigns("blame_line"), "Blame line" },
  },
  f = {
    name = "Files",
    r = { telescope("live_grep"), "Live grep" },
    f = { telescope("find_files"), "Find files" },
    o = { telescope("oldfiles"), "Recently opended" },
  },
  o = {
    name = "Open",
    d = {
      telescope("git_files", { cwd = constants.files.dotfiles }),
      "dotfiles",
    },
    v = { e(constants.files.vim), ".vimrc" },
    z = { e(constants.files.zsh), ".zshrc" },
    t = { e(constants.files.tmux), ".tmux.conf" },
    n = { e(constants.files.nvim), "init.vim" },
    k = { e(constants.files.kitty), "kitty.conf" },
    y = { e(constants.files.yabai), "yabairc" },
    s = { e(constants.files.skhd), "skhdrc" },
  },
  l = {
    name = "LSP",
    I = { t("LspInfo"), "Info" },
    R = { t("LspRestart"), "Restart" },
    f = { t("lua vim.lsp.buf.formatting()"), "Format" },
    q = { telescope("quickfix"), "Quickfix" },
    r = { lspsaga("rename"), "Rename" },
    s = { telescope("lsp_document_symbols"), "Document symbols" },
    d = {
      telescope("lsp_document_diagnostics"),
      "Document diagnostic",
    },
    n = {
      lspsaga("diagnostic_jump_next"),
      "Next diagnostic",
    },
    p = {
      lspsaga("diagnostic_jump_prev"),
      "Previous diagnostic",
    },
  },
  c = {
    name = "Code",
    d = { lspsaga("preview_definition"), "Definition" },
    a = { lspsaga("code_action"), "Code action" },
  },
  z = { t("ZenMode"), "Zen Mode" },
}

wk.register(key_maps, { prefix = "<space>" })
