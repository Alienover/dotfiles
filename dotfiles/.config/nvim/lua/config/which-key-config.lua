local Utils = require("utils")
local wk = require("which-key")

local o, g, cmd = Utils.o, Utils.g, Utils.cmd

-- Populate the vim cmd prefix and suffix
local t = function(str)
    return "<Cmd>" .. str .. "<CR>"
end

-- Populate the command for file to edit
local e = function(filepath)
    return t("e " .. filepath)
end

-- Populate the floating terminal command with presets
local ft = function(input)
    return t(
        ([[lua require"utils.floating_terminal":open({"%s", border = true })]]):format(
            input
        )
    )
end

function _G.toggle_diffview()
    if g.diffview_opened then
        g.diffview_opened = false
        cmd([[DiffviewClose]])
    else
        g.diffview_opened = true
        cmd([[DiffviewOpen]])
    end
    return true
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
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 0, 1, 0 }, -- extra window padding [top, right, bottom, left]
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
        t = { t("Telescope builtin"), "Telescope" },
        c = { t("Telescope command"), "Commands" },
        k = { t("Telescope keymaps"), "key Maps" },
        h = { t("Telescope highlights"), "Highlight Groups" },
        p = {
            name = "Packer",
            p = { t("PackerSync"), "Sync" },
            s = { t("PackerStatus"), "Status" },
            i = { t("PackerInstall"), "Install" },
            c = { t("PackerCompile"), "Compile" },
        },
    },
    w = {
        name = "Workspaces",
        p = {
            t("Telescope find_files cwd=" .. Utils.files.polaris),
            "Search Polaris",
        },
        r = {
            t("Telescope find_files cwd=" .. Utils.files.rigel),
            "Search Rigel",
        },
    },
    s = { t("split"), "Split" },
    v = { t("vsplit"), "Split vertically" },
    b = {
        name = "Buffers",
        d = { t("bd"), "Delete" },
        f = { t("bfirst"), "First" },
        l = { t("blast"), "Last" },
        n = { t("bnext"), "Next" },
        p = { t("bprevious"), "Previous" },
        s = { t("SymbolsOutline"), "Symbols outline" },
        b = { t("Telescope buffers"), "Find buffers" },
    },
    t = {
        name = "Terminal",
        [";"] = { ft("zsh"), "terminal" },
        h = { ft("htop"), "htop" },
        p = { ft("python"), "python" },
        n = { ft("node"), "node" },
        t = { t("lua require'utils.floating_terminal':toggle()"), "Toggle" },
    },
    g = {
        name = "Git",
        d = { t("lua toggle_diffview()"), "Toggle diffview" },
        c = { t("Telescope git_commits"), "Git commits" },
        f = { t("Telescope git_files"), "Git files" },
        j = { t("lua require'gitsigns'.next_hunk()"), "Next hunk" },
        k = { t("lua require'gitsigns'.prev_hunk()"), "Previous hunk" },
        p = { t("lua require'gitsigns'.preview_hunk()"), "Preview hunk" },
        b = { t("lua require'gitsigns'.blame_line()"), "Blame line" },
    },
    f = {
        name = "Files",
        r = { t("Telescope live_grep"), "Live grep" },
        f = { t("Telescope find_files"), "Find files" },
        o = { t("Telescope oldfiles"), "Recently opended" },
    },
    o = {
        name = "Open",
        v = { e(Utils.files.vim), ".vimrc" },
        z = { e(Utils.files.zsh), ".zshrc" },
        t = { e(Utils.files.tmux), ".tmux.conf" },
        n = { e(Utils.files.nvim), "init.vim" },
        k = { e(Utils.files.kitty), "kitty.conf" },
    },
    l = {
        name = "LSP",
        I = { t("LspInfo"), "Info" },
        R = { t("LspRestart"), "Restart" },
        f = { t("lua vim.lsp.buf.formatting()"), "Format" },
        q = { t("Telescope quickfix"), "Quickfix" },
        r = { t([[lua require"lspsaga.rename".rename()]]), "Rename" },
        s = { t("Telescope lsp_document_symbols"), "Document symbols" },
        d = {
            t("Telescope lsp_document_diagnostics"),
            "Document diagnostic",
        },
        n = {
            t([[lua require"lspsaga.diagnostic".lsp_jump_diagnostic_next()]]),
            "Next diagnostic",
        },
        p = {
            t([[lua require"lspsaga.diagnostic".lsp_jump_diagnostic_prev()]]),
            "Previous diagnostic",
        },
    },
    c = {
        name = "Code",
        d = { t("Lspsaga preview_definition"), "Definition" },
        a = { t("Lspsaga code_action"), "Code action" },
    },
    z = { t("ZenMode"), "Zen Mode" },
}

wk.register(key_maps, { prefix = "<space>" })
