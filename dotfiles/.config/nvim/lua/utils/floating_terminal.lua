local Utils = require("utils")

local M = {
    options = {},
    instance = nil,
    is_toggle = false,
}

local function reset()
    M.options = {}
    M.instance = nil
    M.is_toggle = false
end

-- Clear the floating terminal options and kill the window and buffer
function _G.clear_float_term(win, buf, opts)
    local force = type(opts) == "table" and opts.force or opts

    if M.is_toggle and not force then
        -- Skip the cleanup process when the window is close by toggling
        return
    end

    -- Only clear the win and buf when it's close
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, { force = true })
    end

    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    reset()
end

local function open_window(buf, args)
    local win = vim.api.nvim_open_win(
        buf,
        true,
        Utils.get_float_win_opts(vim.tbl_deep_extend("force", {
            border = true,
        }, args))
    )

    Utils.cmd(
        ("autocmd! TermClose <buffer> lua clear_float_term(%s, %s)"):format(
            win,
            buf
        )
    )

    Utils.cmd([[startinsert]])

    -- Save the opened buffer ID
    M.instance = buf
end

function M:open(args)
    -- Close the previous window and buffer
    self:close()

    -- Validate the arguments and save it
    args = args or {}
    self.options = args

    -- Extract the command and remove it from the arguments
    local cmd = args[1] or "zsh"
    args[1] = nil

    local buf = vim.api.nvim_create_buf(false, true)

    open_window(buf, args)

    vim.fn.termopen(cmd)
end

function M:toggle()
    local toggle = self.is_toggle

    -- Set new toggle value
    self.is_toggle = not toggle

    if self.instance ~= nil then
        if not toggle then
            vim.api.nvim_win_close(0, false)
            return
        else
            if self.instance and vim.api.nvim_buf_is_valid(self.instance) then
                open_window(self.instance, self.options)
                return
            end
        end
    end

    -- Open a new floating terminal as default
    self:open()
end

function M:close()
    local win = nil
    if not self.is_toggle and self.instance ~= nil then
        win = 0
    end

    clear_float_term(win, self.instance, { force = true })
end

return M
