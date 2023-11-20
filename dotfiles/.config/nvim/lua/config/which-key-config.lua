local utils = require("utils")
local constants = require("utils.constants")
local wk = require("which-key")

local o, g, cmd = utils.o, utils.g, utils.cmd

local config = {
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
}

o.timeoutlen = 500

wk.setup(config)

-- Populate the vim cmd prefix and suffix
---@param str string
---@param opts table|nil
local t = function(str, opts)
  return function()
    local silent = (opts and opts.silent) or false
    if silent then
      vim.F.npcall(cmd, str)
    else
      cmd(str)
    end
  end
end

-- Populate the command for file to edit
---@param filepath string
local e = function(filepath)
  return t("e " .. filepath)
end

--- Telescope wrapper with theme flag based on the window sizing
---@param sub_cmd string
---@param opts table|nil
local telescope = function(sub_cmd, opts)
  return function()
    utils.telescope(sub_cmd, opts)
  end
end

local workspaces = function(base)
  -- Scan the certain workspace
  local plenary = require("plenary.scandir")
  local dirs = plenary.scan_dir(base, { depth = 1, only_dirs = true })

  -- Default config
  local maps = {
    name = ("%s Edison"):format(constants.icons.ui.Email),
    O = {
      telescope("find_files", {
        cwd = constants.files.work_config,
        prompt_title = "Search\\ Config",
      }),
      "Search [O]ther Config",
    },
  }

  -- Set the first letter of the folder as the trigger key
  for _, v in pairs(dirs) do
    local dir = string.match(v, "/([^/]+)$")
    local key, rest = string.sub(dir, 1, 1), string.sub(dir, 2)

    if maps[key] == nil then
      key = string.lower(key)
    else
      key = string.upper(key)
    end

    maps[key] = {
      telescope("find_files", {
        cwd = v,
        no_ignore = true,
        prompt_title = ("Search " .. dir):gsub(" ", "\\ "),
      }),
      string.format("Search [%s]%s", string.upper(key), rest),
    }
  end

  return maps
end

local gitsigns = function(sub_cmd)
  return t("Gitsigns " .. sub_cmd)
end

local lspsaga = function(sub_cmd)
  return t("Lspsaga " .. sub_cmd)
end

-- Populate the floating terminal command with presets
local terminal = function(input)
  return lspsaga("term_toggle " .. (input or ""))
end

local neorg = function(sub_cmd)
  return t("Neorg " .. sub_cmd)
end

local toggle_diffview = function()
  if g.diffview_opened then
    local curr_tabid = vim.api.nvim_get_current_tabpage()
    local tabidx, tabid = nil, nil

    -- INFO: Find the tab id and index with buffer whose name is starting with "diffview://"
    for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        local bufnr = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(bufnr)

        if string.match(name, "^diffview://") ~= nil then
          tabidx = i
          tabid = tab
          break
        end
      end
    end

    if tabid ~= nil and curr_tabid ~= tabid then
      -- INFO: Focus back when the current tab is not the one with diff view
      cmd("tabnext " .. tabidx)
    else
      g.diffview_opened = false
      cmd("DiffviewClose")
    end
  else
    g.diffview_opened = true
    cmd("DiffviewOpen")
  end
end

--- @param curr_file boolean|nil
---@return function
local toggle_file_diff = function(curr_file)
  return function()
    if vim.bo.filetype == "DiffviewFileHistory" then
      cmd("tabclose")
    else
      cmd("DiffviewFileHistory" .. (curr_file == true and " %" or ""))
    end
  end
end

local n_mappings = {
  h = {
    name = "Help",
    t = { telescope("todo-comments"), "[T]odo Comments" },
    T = { telescope("builtin"), "[T]elescope" },
    c = { telescope("commands"), "[C]ommands" },
    k = { telescope("keymaps"), "[K]ey Maps" },
    h = { telescope("highlights"), "[H]ighlight Groups" },
    n = { telescope("noice"), "[N]oice history" },
    m = { t("Mason"), "[M]ason Manager" },
    l = {
      name = "Lazy Manager",
      S = { t("Lazy Sync"), "[S]ync Plugins" },
      s = { t("Lazy show"), "[S]how Plugins" },
    },
    u = { telescope("undo"), "[U]ndo tree" },
    ["?"] = { telescope("help_tags"), "Help doc" },
  },
  e = workspaces(constants.files.workdirs),
  b = {
    name = "Buffers",
    d = { t("KWBufDel"), "[D]Delete" },
    D = { t("KWBufDel!"), "Force [D]elete" },
    b = {
      telescope(
        "buffers",
        { previewer = false, sort_mru = true, ignore_current_buffer = true }
      ),
      "Find [B]uffers",
    },
    n = { t("tabnew"), "[N]ew Tab" },
  },
  t = {
    name = "Terminal",
    [";"] = { terminal(os.getenv("SHELL") or "zsh"), "[T]erminal" },
    h = { terminal("htop"), "[H]top" },
    p = { terminal("python"), "[P]ython" },
    n = { terminal("node"), "[N]ode" },
    t = { terminal(), "[T]oggle" },
  },
  g = {
    name = "Git",
    d = { toggle_diffview, "Toggle [D]iffview" },
    c = { telescope("git_commits"), "Git [C]ommits" },
    C = { utils.change_cwd, "[C]hange Current Working Dir" },
    f = { telescope("git_files"), "Git [F]iles" },
    j = { gitsigns("next_hunk"), "Next hunk" },
    k = { gitsigns("prev_hunk"), "Previous hunk" },
    p = { gitsigns("preview_hunk"), "Preview hunk" },
    b = { gitsigns("blame_line"), "[B]lame line" },
    B = { t("GitBlame"), "[B]lame file" },
    s = { telescope("git_status"), "Git [S]tatus" },
    h = { toggle_file_diff(true), "Current File [H]istory" },
    H = { toggle_file_diff(), "File [H]istory" },
    o = { "[O]pen in browse" },
    P = { "Open [P]ull request of current branch" },
  },
  f = {
    name = "Files",
    r = { telescope("live_grep"), "Live G[r]ep" },
    f = {
      telescope("find_files", { no_ignore = false, hidden = true }),
      "[F]ind files",
    },
    o = { telescope("oldfiles"), "Recently [O]pend" },
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
    I = { t("LspInfo"), "[I]nfo" },
    R = { t("LspRestart"), "[R]estart" },
    N = { t("NullLsInfo"), "[N]ull-ls Info" },
    f = { t("ConformFormat", { silent = true }), "[F]ormat" },
    r = { ":IncRename ", "[R]ename" },
    s = { telescope("lsp_document_symbols"), "Document [S]ymbols" },
    D = {
      telescope("diagnostics"),
      "Document [D]iagnostic",
    },
    n = {
      lspsaga("diagnostic_jump_next"),
      "[N]ext diagnostic",
    },
    p = {
      lspsaga("diagnostic_jump_prev"),
      "[P]revious diagnostic",
    },
    t = { telescope("lsp_type_definitions"), "[T]ype dDfinitions" },
    a = { lspsaga("code_action"), "Code [A]ction" },
    d = { lspsaga("peek_definition"), "[D]efinition" },
  },
  c = {
    name = "Commands",
    r = { t("RestExecute"), "Execute HTTP request" },
  },
  z = { t("ZenMode"), "[Z]en Mode" },
  ["/"] = {
    telescope("current_buffer_fuzzy_find"),
    "Fuzzily search in current buffer",
  },
  n = {
    name = "[N]eorg mode",
    h = { neorg("workspace home"), "[H]ome" },
    w = { neorg("workspace work"), "[W]ork" },
    i = { neorg("inject-metadata"), "[I]nject Metadata" },
    u = { neorg("update-metadata"), "[U]pdate Metadata" },
    s = { neorg("sync-parsers"), "[S]ync Parsers" },
    I = { neorg("index"), "back to [I]ndex" },
    E = { neorg("return"), "[E]xit neorg mode" },
  },
}

local v_mappings = {
  g = {
    name = "Git",
    s = { gitsigns("stage_hunk"), "[S]tage hunk" },
    u = { gitsigns("undo_stage_hunk"), "[U]ndo staged hunk" },
    o = { "[O]pen in browse" },
  },
}

wk.register(n_mappings, { prefix = "<space>" })
wk.register(v_mappings, { prefix = "<space>", mode = "v" })

-- Treesitter keymaps
wk.register({
  a = { "Swap next param" },
  A = { "Swap previous param" },
}, {
  prefix = "<leader>",
})

wk.register({
  m = { "[M]ove to start of next func" },
  M = { "[M]ove to end of next func" },
}, { prefix = "]" })

wk.register({
  m = { "[M]ove to start of previous func" },
  M = { "[M]ove to end of previous func" },
}, { prefix = "[" })

-- Neorg GTD keymaps
wk.register({
  t = {
    name = "GTD",
    d = "Mark task as [D]one",
    u = "Mark task as [U]ndone",
    p = "Mark task as [P]ending",
    c = "Mark task as [C]ancel",
    i = "Mark task as [I]mportant",
    h = "Mark task as on [H]old",
    r = "Mark task as [R]ecurring",
  },
}, { prefix = "g" })
