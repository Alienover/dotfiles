local utils = require("custom.utils")
local icons = require("custom.icons")
local constants = require("custom.constants")

local wk = require("which-key")

local WK_DEFAULT_PREFIX = "<space>"

wk.setup({
  ---@type false | "classic" | "modern" | "helix"
  preset = false,

  ---@type wk.Win.opts
  win = {
    width = vim.o.columns > 200 and 0.4 or 0.6,
    col = 0.5,
    ---@type 'none' | 'rounded'
    border = "none",
  },
  layout = {
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 5, -- spacing between columns
  },

  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "", -- symbol used between a key and it's label
    group = "＋", -- symbol prepended to a group
  },
  show_help = true,
  disable = {
    -- disable WhichKey for certain buf types and file types.
    ft = {},
    bt = {},
  },
  triggers = {
    { WK_DEFAULT_PREFIX, mode = { "n", "v" } },
    { "<leader>", mode = { "n", "v" } },
    { "[", mode = { "n" } },
    { "]", mode = { "n" } },
  },
})

-- Populate the vim cmd prefix and suffix
---@param str string
---@param opts table|nil
local t = function(str, opts)
  return function()
    local silent = (opts and opts.silent) or false
    if silent then
      vim.F.npcall(vim.cmd, str)
    else
      vim.cmd(str)
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
  if vim.fn.isdirectory(base) == 0 then
    return {}
  end

  local WORKSPACE_PREFIX = "e"

  local maps = {
    O = {
      telescope("find_files", {
        cwd = constants.files.work_config,
        prompt_title = "Search\\ Config",
      }),
      desc = "Search [O]ther Config",
    },
  }

  -- Scan the certain workspace
  local dirs = {}

  local dir_getter = vim.fs.dir(base, { depth = 1 })
  while true do
    local dir, typ = dir_getter()

    if not dir then
      break
    end

    if typ == "directory" then
      table.insert(dirs, dir)
    end
  end

  -- Set the first letter of the folder as the trigger key
  for _, v in pairs(dirs) do
    local dir =
      vim.fs.normalize(vim.fs.joinpath(base, "." .. constants.os_sep .. v))

    local key, rest = string.sub(v, 1, 1), string.sub(v, 2)

    if maps[key] == nil then
      key = string.lower(key)
    else
      key = string.upper(key)
    end

    maps[key] = {
      telescope("find_files", {
        cwd = dir,
        no_ignore = true,
        prompt_title = ("Search " .. v):gsub(" ", "\\ "),
      }),
      desc = string.format("Search [%s]%s", string.upper(key), rest),
    }
  end

  --- @type wk.Spec
  local output = {
    {
      WORKSPACE_PREFIX,
      group = "Edison",
      icon = icons.get("filetype", "mail"),
    },
  }

  for key, mapping in pairs(maps) do
    table.insert(
      output,
      vim.tbl_extend(
        "keep",
        { WORKSPACE_PREFIX .. key, unpack(mapping) },
        mapping
      )
    )
  end

  return output
end

local gitsigns = function(sub_cmd)
  return string.format(":Gitsigns %s<CR>", sub_cmd)
end

local lspsaga = function(sub_cmd)
  return t("Lspsaga " .. sub_cmd)
end

-- Populate the floating terminal command with presets
local terminal = function(input)
  return lspsaga("term_toggle " .. (input or ""))
end

local toggle_diffview = function()
  local is_opened = vim.g.diffview_opened or vim.o.filetype == "DiffviewFiles"
  if is_opened then
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
      vim.cmd("tabnext " .. tabidx)
    else
      vim.g.diffview_opened = false
      vim.cmd("DiffviewClose")
    end
  else
    utils.change_cwd()

    vim.g.diffview_opened = true
    vim.cmd("DiffviewOpen")
  end
end

--- @param curr_file boolean|nil
---@return function
local toggle_file_diff = function(curr_file)
  return function()
    if vim.bo.filetype == "DiffviewFileHistory" then
      vim.cmd("tabclose")
    else
      utils.change_cwd()
      vim.cmd("DiffviewFileHistory" .. (curr_file == true and " %" or ""))
    end
  end
end

local toggle_inlay_hint = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({
    bufnr = bufnr,
  })

  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end

--- comment
--- @param mappings wk.Spec
--- @param trigger string?
local function withTrigger(mappings, trigger)
  trigger = trigger or WK_DEFAULT_PREFIX

  for idx, mapping in ipairs(mappings) do
    if idx == 1 and type(mapping) == "string" then
      mappings[idx] = trigger .. mapping
    elseif type(mapping) == "table" then
      mappings[idx] = withTrigger(mapping, trigger)
    else
      mappings[idx] = mapping
    end
  end

  return mappings
end

--- INFO: Help
wk.add(withTrigger({
  {
    "h",
    group = "Help",
    { "ht", telescope("todo-comments"), desc = "[T]odo Comments" },
    { "hT", telescope("builtin"), desc = "[T]elescope" },
    { "hc", telescope("commands"), desc = "[C]ommands" },
    { "hk", telescope("keymaps"), desc = "[K]ey Maps" },
    { "hh", telescope("highlights"), desc = "[H]ighlight Groups" },
    { "hn", telescope("notify"), desc = "[N]otify history" },
    { "hN", telescope("noice"), desc = "[N]oice history" },
    { "hm", t("Mason"), desc = "[M]ason Manager" },
    {
      "hl",
      name = "Lazy Manager",
      { "hlS", t("Lazy sync"), desc = "[S]ync Plugins" },
      { "hls", t("Lazy show"), desc = "[S]how Plugins" },
    },
    { "hu", telescope("undo"), desc = "[U]ndo tree" },
    { "h?", telescope("help_tags"), desc = "Help doc" },
  },

  { "z", t("ZenMode"), desc = "Zen Mode" },

  {
    "/",
    telescope("current_buffer_fuzzy_find"),
    desc = "Search",
  },
}))

--- INFO: Buffer
wk.add(withTrigger({
  { "b", group = "Buffer" },
  { "bd", t("KWBufDel"), desc = "[D]Delete" },
  { "bD", t("KWBufDel!"), desc = "Force [D]elete" },
  {
    "bb",
    telescope("buffers", {
      previewer = false,
      sort_mru = true,
      sort_lastused = false,
      initial_mode = "normal",
      theme = "dropdown",
    }),
    desc = "Find [B]uffers",
  },
  { "bn", t("tabnew"), desc = "[N]ew Tab" },
}))

--- INFO: Terminal
wk.add(withTrigger({
  { "t", group = "Terminal" },
  { "t;", terminal(os.getenv("SHELL") or "zsh"), desc = "[T]erminal" },
  { "th", terminal("htop"), desc = "[H]top" },
  { "tp", terminal("python"), desc = "[P]ython" },
  { "tn", terminal("node"), desc = "[N]ode" },
  { "tt", terminal(), desc = "[T]oggle" },
}))

--- INFO: Git
wk.add(withTrigger({
  {
    "g",
    group = "Git",
    mode = "n",
    { "gd", toggle_diffview, desc = "Toggle [D]iffview" },
    { "gc", telescope("git_commits"), desc = "Git [C]ommits" },
    { "gC", utils.change_cwd, desc = "[C]hange Current Working Dir" },
    { "gf", telescope("git_files"), desc = "Git [F]iles" },
    { "gj", gitsigns("next_hunk"), desc = "Next hunk" },
    { "gk", gitsigns("prev_hunk"), desc = "Previous hunk" },
    { "gp", gitsigns("preview_hunk"), desc = "Preview hunk" },
    { "gb", gitsigns("blame_line"), desc = "[B]lame line" },
    { "gB", t("GitBlame"), desc = "[B]lame file" },
    { "gs", telescope("git_status"), desc = "Git [S]tatus" },
    { "gh", toggle_file_diff(true), desc = "Current File [H]istory" },
    { "gH", toggle_file_diff(), desc = "File [H]istory" },
    { "go", desc = "[O]pen in browse" },
    { "gP", desc = "Open [P]ull request of current branch" },
    { "gr", gitsigns("reset_hunk"), desc = "[R]eset Hunk" },
    { "gR", gitsigns("reset_buffer"), desc = "[R]eset buffer" },
  },

  {
    "g",
    group = "Git",
    mode = "v",
    { "gs", gitsigns("stage_hunk"), desc = "[S]tage selected hunk" },
    { "gu", gitsigns("undo_stage_hunk"), desc = "[U]ndo staged hunk" },
    { "go", desc = "[O]pen in browse" },
    { "gr", gitsigns("reset_hunk"), desc = "[R]eset selected hunk" },
  },
}))

--- INFO: Files Operation
wk.add(withTrigger({
  { "f", group = "Files" },
  { "fr", telescope("live_grep"), desc = "Live G[r]ep" },
  {
    "ff",
    telescope("find_files", { no_ignore = true, hidden = true }),
    desc = "[F]ind files",
  },
  { "fo", telescope("oldfiles"), desc = "Recently [O]pend" },
}))

--- INFO: Open File
wk.add(withTrigger({
  { "o", group = "Open" },
  {
    "od",
    telescope("git_files", { cwd = constants.files.dotfiles }),
    desc = "dotfiles",
  },
  { "ov", e(constants.files.vim), desc = ".vimrc" },
  { "oz", e(constants.files.zsh), desc = ".zshrc" },
  { "ot", e(constants.files.tmux), desc = ".tmux.conf" },
  { "on", e(constants.files.nvim), desc = "init.lua" },
  { "ok", e(constants.files.kitty), desc = "kitty.conf" },
  { "oa", e(constants.files.aerospace), desc = "aerospace.toml" },
}))

--- INFO: LSP
wk.add(withTrigger({
  { "l", group = "LSP" },
  { "lI", t("LspInfo"), desc = "[I]nfo" },
  { "lR", t("LspRestart"), desc = "[R]estart" },
  { "lN", t("NullLsInfo"), desc = "[N]ull-ls Info" },
  { "lf", t("ConformFormat", { silent = true }), desc = "[F]ormat" },
  { "ls", telescope("lsp_document_symbols"), desc = "Document [S]ymbols" },
  { "lD", telescope("diagnostics"), desc = "Document [D]iagnostic" },
  { "ln", lspsaga("diagnostic_jump_next"), desc = "[N]ext diagnostic" },
  { "lp", lspsaga("diagnostic_jump_prev"), desc = "[P]revious diagnostic" },
  { "lt", telescope("lsp_type_definitions"), desc = "[T]ype dDfinitions" },
  { "la", lspsaga("code_action"), desc = "Code [A]ction" },
  { "ld", lspsaga("peek_definition"), desc = "[D]efinition" },
  { "lh", toggle_inlay_hint, desc = "Toggle Inlay [H]int" },
}))

--- INFO: Workspace
wk.add(withTrigger(workspaces(constants.files.workdirs)))

wk.add(withTrigger({
  {
    "r",
    group = "HTTP Rest",
    cond = function()
      return vim.bo.filetype == "http"
    end,
    { "rc", t("Rest curl copy"), desc = "[C]opy the request as Curl command" },
    { "rr", t("Rest run"), desc = "Send request under the cursor" },
    {
      "re",
      telescope("rest", { "select_env" }),
      desc = "Select env",
    },
    {
      "rE",
      telescope("rest", { "select_env_type" }),
      desc = "Select env_type (http-client or .env)",
    },
  },
}))

--- INFO: Treesitter keymaps
wk.add(withTrigger({
  { "a", desc = "Swap next param" },
  { "m", desc = "[M]ove to start of next func" },
  { "M", desc = "[M]ove to end of next func" },
}, "]"))

wk.add(withTrigger({
  { "a", desc = "Swap previous param" },
  { "m", desc = "[M]ove to start of previous func" },
  { "M", desc = "[M]ove to end of previous func" },
}, "["))
