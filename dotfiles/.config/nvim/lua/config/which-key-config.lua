local Utils = require "utils"
local wk = require "which-key"

local o, g, cmd = Utils.o, Utils.g, Utils.cmd

local nmap = Utils.nmap

local r_code = Utils.r_code

local t = function(str)
    return "<Cmd>" .. str .. "<CR>"
end

local e = function(str)
    return t("e " .. str)
end

function _G.toggle_diffview()
    if g.diffview_opened then
        g.diffview_opened = false
        cmd [[DiffviewClose]]
    else
        g.diffview_opened = true
        cmd [[DiffviewOpen]]
    end
    return true
end

-- Smart toogling the spell checking
function _G.toggle_spell()
    local cursor_word = vim.fn.expand("<cword>")

    if cursor_word == "" then
        -- Toogle the spell check when hover on empty word
        if o.spell then
            o.spell = false
        else
            o.spell = true
        end
    else
        -- List suggestions when hovering on word
        return r_code(t 'lua require "which-key".show("z=", {mode = "n", auto = true})')
    end

    return true
end

nmap("<leader>s", "v:lua.toggle_spell()", {expr = true, silent = true})

o.timeoutlen = 500

wk.setup(
    {
        show_help = true,
        triggers = "auto",
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 10
            },
            presets = false
        },
        key_labels = {["<space>"] = "» Quick Actions"},
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➟", -- symbol used between a key and it's label
            group = "＋" -- symbol prepended to a group
        },
        window = {
            border = "none", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = {0, 0, 0, 0}, -- extra window margin [top, right, bottom, left]
            padding = {1, 0, 1, 0} -- extra window padding [top, right, bottom, left]
        },
        layout = {
            height = {min = 4, max = 15}, -- min and max height of the columns
            width = {min = 20, max = 50}, -- min and max width of the columns
            spacing = 5, -- spacing between columns
            align = "center" -- align columns left, center or right
        },
        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            -- this is mostly relevant for key maps that start with a native binding
            -- most people should not need to change this
            i = {"j", "k", "g"},
            v = {"j", "k", "g"}
        }
    }
)

local key_maps = {
    w = {
        name = "Workspaces",
        d = {t "lua toggle_diffview()", "Toggle diffview"},
        p = {t("Telescope find_files cwd=" .. Utils.files.polaris), "Search Polaris"},
        r = {t("Telescope find_files cwd=" .. Utils.files.rigel), "Search Rigel"}
    },
    s = {t "split", "Split"},
    v = {t "vsplit", "Split vertically"},
    b = {
        name = "Buffers",
        d = {t "bd", "Delete"},
        f = {t "bfirst", "First"},
        l = {t "blast", "Last"},
        n = {t "bnext", "Next"},
        p = {t "bprevious", "Previous"},
        s = {t "SymbolsOutline", "Symbols outline"}
    },
    t = {
        name = "Telescope",
        r = {t "Telescope live_grep", "Live grep"},
        f = {t "Telescope find_files", "Find files"},
        b = {t "Telescope buffers", "Find buffers"},
        o = {t "Telescope oldfiles", "Recently opended"},
        g = {
            name = "Git",
            c = {t "Telescope git_commits", "Git commits"},
            f = {t "Telescope git_files", "Git files"}
        }
    },
    o = {
        name = "Open",
        v = {e(Utils.files.vim), ".vimrc"},
        z = {e(Utils.files.zsh), ".zshrc"},
        t = {e(Utils.files.tmux), ".tmux.conf"},
        n = {e(Utils.files.nvim), "init.vim"},
        k = {e(Utils.files.kitty), "kitty.conf"}
    }
}

wk.register(key_maps, {prefix = "<space>"})
