local Utils = require("utils")

local g, cmd = Utils.g, Utils.cmd

local tmap = Utils.tmap

local c = Utils.colors

-- If installed using Homebrew
cmd([[set rtp+=/usr/local/opt/fzf]])
local default_opts = string.format(
    "--color %s,%s,%s,%s --layout=reverse --margin=1,2 --prompt=' 🌈 ' ",
    ("fg:%s,bg:%s"):format(c.FG, c.BG),
    ("hl:%s"):format(c.PRIMARY),
    ("fg+:%s,bg+:%s,hl+:%s"):format("15", c.BG, c.DARK_YELLOW),
    ("info:%s,prompt:%s,spinner:%s,pointer:%s,marker:%s"):format(
        c.PRIMARY,
        c.PRIMARY,
        c.PRIMARY,
        c.PRIMARY,
        c.DARK_YELLOW
    )
)

-- Default fzf layout
g.fzf_layout = { window = "call v:lua._open_floating_win()" }

function _G._open_floating_win(opts)
    opts = opts or {}
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_var(buf, "signcolumn", "no")

    local height = opts.height or 30
    local width = opts.width or 90
    local col = math.floor((Utils.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        height = height,
        width = width,
        col = col,
        row = 0,
        relative = "editor",
        style = "minimal",
    })

    tmap("<ESC>", "<C-\\><C-n>:q<CR>", { buffer = buf })
end

function _G.fzf_files()
    local source = table.concat({
        "find * -path '*/.*'",
        "-prune -o -path 'node_modules'",
        "-prune -o -path '**/node_modules'",
        "-prune -o -path 'target/**'",
        "-prune -o -path 'dist'",
        "-prune -o -path '**/dist'",
        "-prune -o -type f",
        "-print -o -type l",
        "-print 2> /dev/null",
    }, " ")

    local options = table.concat({
        default_opts,
        "--preview 'if file {} | grep -v text; then file -b {}; else bat",
        "--style=changes ",
        "--color always",
        "--line-range :40 {}; fi'",
        "--preview-window bottom",
    }, " ")

    cmd(string.format(
        [[
	call fzf#run(fzf#wrap({ "source": "%s", "options": "%s" }))
    ]],
        source,
        options
    ))
end

-- Replace it with telescope fzf search in ./../keymappings.lua
-- nmap("<C-p>", "<Cmd>lua fzf_files()<CR>", {noremap = true})
