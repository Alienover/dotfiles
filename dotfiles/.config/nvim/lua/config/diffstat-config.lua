local Utils = require "utils"

local highlight = Utils.highlight

local c = Utils.colors

M = {
    getter = nil,
    setup = nil,
    data = nil
}

local diff_types = {
    added = "DIFF_ADDED",
    removed = "DIFF_REMOVED"
}

local diff_colors = {
    [diff_types.added] = c.GREEN,
    [diff_types.removed] = c.DARK_RED
}

local block = "▧"

local function get_diffstat_blocks(added, removed)
    local sum = added + removed

    local added_blocks = math.floor((added / sum) * 5)
    local removed_blocks = math.floor((removed / sum) * 5)

    local blocks = {}

    for _ = 1, added_blocks do
        table.insert(blocks, highlight:format({name = diff_types.added, block}))
    end

    for _ = 1, removed_blocks do
        table.insert(blocks, highlight:format({name = diff_types.removed, block}))
    end

    if vim.tbl_count(blocks) < 5 then
        for _ = vim.tbl_count(blocks) + 1, 5 do
            table.insert(blocks, "%#lualine_b_normal#" .. block)
        end
    end

    return table.concat(blocks)
end

function M.setup()
    vim.cmd [[
	autocmd BufEnter * lua require"config.diffstat-config".getter()
	autocmd BufWritePost * lua require"config.diffstat-config".getter()
    ]]

    for name, color in pairs(diff_colors) do
        highlight:create(name, {fg = color, bg = c.VISUAL_GREY})
    end

    M.getter()
end

function M.getter()
    local dir = vim.fn.expand("%:h")
    local filename = vim.fn.expand("%:t")

    if dir == "" or filename == "" then
        return
    end

    local cmd = ("echo $(git -C %s diff --shortstat %s) "):format(vim.fn.expand("%:h"), vim.fn.expand("%:t"))

    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))

    f.close()

    local added = tonumber(string.match(s, "(%d+) insertion")) or 0
    local removed = tonumber(string.match(s, "(%d+) deletion")) or 0

    local stat = {}

    if added > 0 then
        table.insert(stat, highlight:format {name = diff_types.added, "+" .. added})
    end

    if removed > 0 then
        table.insert(stat, highlight:format {name = diff_types.removed, "-" .. removed})
    end

    local status = table.concat(stat, " ") .. " "

    if #status > 1 then
        return table.concat {
            "%#lualine_b_normal#",
            status,
            "%#lualine_a_normal_to_lualine_b_normal#",
            get_diffstat_blocks(added, removed)
        }
    else
        return ""
    end
end

return M
