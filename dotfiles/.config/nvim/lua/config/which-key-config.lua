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
    local terminal = require("utils.floating_terminal")

    if input == nil then
      terminal:toggle()
    else
      table.insert(options, 1, input)
      terminal:open(options)
    end
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

local function toggle_diffview()
  if g.diffview_opened then
    g.diffview_opened = false
    cmd("DiffviewClose")
  else
    g.diffview_opened = true
    cmd("DiffviewOpen")
  end
end

local function toggle_diff()
  -- Don't diff this under diff view
  if g.diffview_opened then
    return
  end

  if vim.api.nvim_win_get_option(0, "diff") then
    cmd("close")
  else
    gitsigns("diffthis")()
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

local n_mappings = {
  h = {
    name = "Help",
    t = { telescope("builtin"), "Telescope" },
    c = { telescope("command"), "Commands" },
    k = { telescope("keymaps"), "key Maps" },
    h = { telescope("highlights"), "Highlight Groups" },
    l = {
      name = "Lazy Manager",
      S = { t("Lazy Sync"), "Sync" },
      s = { t("Lazy show"), "Show" },
    },
  },
  e = workspaces(constants.files.workdirs),
  s = { t("split"), "Split" },
  v = { t("vsplit"), "Split vertically" },
  b = {
    name = "Buffers",
    d = { t("KWBufDel"), "Delete" },
    D = { t("KWBufDel force"), "Force Delete" },
    f = { t("bfirst"), "First" },
    l = { t("blast"), "Last" },
    n = { t("bnext"), "Next" },
    p = { t("bprevious"), "Previous" },
    b = { telescope("buffers", { previewer = false }), "Find buffers" },
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
    D = { toggle_diffview, "Toggle diffview" },
    d = { toggle_diff, "Diff this" },
    c = { telescope("git_commits"), "Git commits" },
    f = { telescope("git_files"), "Git files" },
    j = { gitsigns("next_hunk"), "Next hunk" },
    k = { gitsigns("prev_hunk"), "Previous hunk" },
    p = { gitsigns("preview_hunk"), "Preview hunk" },
    b = { gitsigns("blame_line"), "Blame line" },
    B = { t("GitBlame"), "Blame file" },
    s = { gitsigns("select_hunk"), "Select hunk" },
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
    N = { t("NullLsInfo"), "null-ls info" },
    f = { t("LspFormat"), "Format" },
    q = { telescope("quickfix"), "Quickfix" },
    r = { ":IncRename ", "Rename" },
    s = { telescope("lsp_document_symbols"), "Document symbols" },
    D = {
      telescope("diagnostics"),
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
    t = { telescope("lsp_type_definitions"), "Type definitions" },
    a = { lspsaga("code_action"), "Code action" },
    d = { lspsaga("preview_definition"), "Definition" },
  },
  c = {
    name = "Commands",
    r = { t("RestExecute"), "Execute HTTP request" },
  },
  z = { t("ZenMode"), "Zen Mode" },
}

local v_mappings = {
  g = {
    name = "Git",
    s = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
  },
}

wk.register(n_mappings, { prefix = "<space>" })
wk.register(v_mappings, { prefix = "<space>", mode = "v" })
