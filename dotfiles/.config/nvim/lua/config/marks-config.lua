local utils = require("utils")

local cmd = utils.cmd

local M = {}

local caches = {}
local marks = ""
local initialled = false

M.init = function()
  if not initialled then
    local function append_chars(r_start, r_end)
      for i = r_start, r_end, 1 do
        marks = marks .. string.char(i)
      end
    end

    -- Append 0-9
    append_chars(48, 57)
    -- Append A-Z
    append_chars(65, 90)
    -- Append a-z
    append_chars(97, 122)

    initialled = true
  end
end

M.go_def = function()
  local next = (#caches % string.len(marks)) + 1
  local mark = marks:sub(next, next)

  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)

  -- Set mark
  vim.api.nvim_buf_set_mark(0, mark, pos[1], pos[2], {})

  -- Save the bufnr and mark
  table.insert(caches, { bufnr, mark })

  -- Goto definition
  vim.lsp.buf.definition()
end

M.go_back = function()
  local item = caches[#caches]

  if item ~= nil then
    local prev_bufnr = item[1]
    local prev_mark = item[2]

    local bufnr = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_buf_get_mark(prev_bufnr, prev_mark)

    -- Switch to the target buf
    if prev_bufnr ~= bufnr then
      cmd("silent b " .. prev_bufnr)
    end

    -- Jump to the marked cursor
    vim.api.nvim_win_set_cursor(0, pos)

    -- Pop the mark
    table.remove(caches)
  else
    cmd("call feedkeys('<C-o>')")
  end
end

return M
