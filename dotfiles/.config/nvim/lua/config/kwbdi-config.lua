-- Refer to https://github.com/vim-scripts/kwbdi.vim/blob/master/plugin/kwbdi.vim
-- The behaviour details:
--
--     * The window layout must be kept in all circumstances.
--     * If there is an alternate buffer must be showing that.
--     * If there is not alternate buffer then must be showing the preious buffer.
--     * If there is no alternate nor previous buffer (it is the only buffer) must show an empty buffer.

local utils = require("utils")

local cmd = utils.cmd

local M = {
  bufnr = 0,
  buf_count = 0,
  empty_buf = 0,
}

function M:init()
  self.bufnr = vim.api.nvim_get_current_buf()
  self.buf_count = 0
  self.empty_buf = 0

  -- Couting all the editable buffers
  for _, i in pairs(vim.api.nvim_list_bufs()) do
    if
      vim.fn.buflisted(i) == 1 and vim.api.nvim_buf_get_option(i, "modifiable")
    then
      self.buf_count = self.buf_count + 1
    end
  end
end

function M:kill_buf_safe()
  if vim.api.nvim_buf_get_option(self.bufnr, "modified") then
    error("[Error] No write since last change for buffer " .. self.bufnr)
    return
  end

  self:kill_buf()
end

function M:kill_buf()
  -- Initial necessary variables
  self:init()

  -- Move current buffer to the alternate one in all the window
  for _, i in pairs(vim.api.nvim_list_wins()) do
    vim.api.nvim_win_call(i, function()
      M:move()
    end)
  end

  -- Delete the current buffer
  if vim.fn.buflisted(self.bufnr) == 1 then
    cmd("silent bd! " .. self.bufnr)
  end

  -- Go back to the current window
  local winnr = vim.api.nvim_get_current_win()
  cmd("normal " .. winnr .. "<c-w><c-w>")
end

-- This function will be run for each window
function M:move()
  local curr_buf = vim.api.nvim_get_current_buf()
  if curr_buf ~= self.bufnr then
    return
  end

  local prevbuf = vim.fn.bufnr("#")

  -- Only one buffer
  if self.buf_count <= 1 then
    -- Create a new empty buffer if there's no alternate
    if self.empty_buf == 0 then
      self.empty_buf = vim.api.nvim_create_buf(true, true)
    end

    -- Focus the alternate
    cmd("silent b! " .. self.empty_buf)
  elseif
    prevbuf > 0
    and vim.fn.buflisted(prevbuf) == 1
    and prevbuf ~= self.bufnr
  then
    -- Focus the previous buffer if it's available
    cmd("silent b! " .. prevbuf)
  else
    -- Focus to the next bufer
    cmd("silent bp!")
  end
end

return M
