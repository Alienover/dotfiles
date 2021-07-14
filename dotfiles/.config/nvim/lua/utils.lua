vim.cmd [[packadd nvim-lspconfig]]

local lsputil = require "lspconfig.util"

local M = {}

local map = function(mode, key, cmd, opts)
    opts = vim.tbl_deep_extend("force", {silent = true}, opts or {})

    if opts.buffer ~= nil then
        local buffer = opts.buffer
        opts.buffer = nil

        vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
    else
        vim.api.nvim_set_keymap(mode, key, cmd, opts)
    end
end

M.o = vim.o
-- Local to buffer
M.bo = vim.bo
-- Buffer-scoped variables
M.b = vim.b
-- Local to window
M.wo = vim.wo
-- Window-scoped variables
M.w = vim.w
-- Global variables
M.g = vim.g
-- Tabpage-scipe variables
M.t = vim.t
-- Vim command
M.cmd = vim.api.nvim_command

M.nmap = function(...)
    map("n", ...)
end

M.imap = function(...)
    map("i", ...)
end

M.tmap = function(...)
    map("t", ...)
end

M.vmap = function(...)
    map("v", ...)
end

M.smap = function(...)
    map("s", ...)
end

M.xmap = function(...)
    map("x", ...)
end

M.r_code = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.columns = vim.api.nvim_get_option("columns")

M.lines = vim.api.nvim_get_option("lines")

M.get_float_win_opts = function(opts)
    local l_offset, t_offset = opts.l_offset or 0.25, opts.t_offset or 0.25

    return vim.tbl_deep_extend(
        "force",
        {
            width = math.floor((1 - l_offset * 2) * M.columns),
            height = math.floor((1 - t_offset * 2) * M.lines),
            col = math.floor(l_offset * M.columns),
            row = math.floor(t_offset * M.lines)
        },
        opts[1] or {}
    )
end

M.find_git_ancestor = function()
    local pwd = os.getenv "PWD"
    return lsputil.find_git_ancestor(pwd)
end

-- Constant values

M.files = {
    vim = os.getenv "HOME" .. "/.vimrc",
    -- NeoVim initialization file
    nvim = os.getenv "HOME" .. "/.config/nvim/init.vim",
    -- Folder saved snippets
    snippets_dir = os.getenv "HOME" .. "/.config/nvim/snippets",
    -- Tmux config
    tmux = os.getenv "HOME" .. "/.tmux.conf",
    -- Kitty config
    kitty = os.getenv "HOME" .. "/.config/kitty/kitty.conf",
    -- ZSH config
    zsh = os.getenv "HOME" .. "/.zshrc",
    -- Work directories
    polaris = os.getenv "HOME" .. "/Documents/work/agent8/Polaris",
    rigel = os.getenv "HOME" .. "/Documents/work/agent8/Rigel"
}

M.colors = {
    FG = os.getenv "GUI_WHITE",
    BG = os.getenv "GUI_CURSOR_GREY",
    RED = os.getenv "GUI_RED",
    DARK_RED = os.getenv "GUI_DARK_RED",
    GREEN = os.getenv "GUI_GREEN",
    VISUAL_GREY = os.getenv "GUI_VISUAL_GREY",
    DARK_YELLOW = os.getenv "GUI_DARK_YELLOW",
    COMMENT_GREY = os.getenv "GUI_COMMENT_GREY"
}

M.highlight = {
    names = {}
}

function M.highlight:get(name)
    return self.names[name]
end

function M.highlight:set(name, hl_name)
    self.names[name] = hl_name
end

function M.highlight:has(name)
    return self.names[name] and true or false
end

function M.highlight:create(name, colors)
    local hl_name = "MyCustomHighlight_" .. name
    local command = {"highlight", hl_name}

    if self:has(name) then
        return self:get(name)
    end

    if type(colors) == "table" then
        if colors.fg then
            table.insert(command, "guifg=" .. colors.fg)
        end

        if colors.bg then
            table.insert(command, "guibg=" .. colors.bg)
        end

        M.cmd(table.concat(command, " "))

        self:set(name, hl_name)
    end

    return hl_name
end

function M.highlight:format(args)
    local prefix = ""
    if type(args) == "table" then
        if args.name ~= nil and self:has(args.name) then
            prefix = "%#" .. self:get(args.name) .. "#"
        elseif args.hl_name ~= nil then
            prefix = "%#" .. args.hl_name .. "#"
        end

        return prefix .. args[1]
    else
        return ""
    end
end

return M
