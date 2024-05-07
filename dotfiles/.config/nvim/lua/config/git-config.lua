local utils = require("utils")

require("git").setup({
  winbar = true,
  default_mappings = false,
  keymaps = {
    browse = "<space>go",
    open_pull_request = "<space>gP",
  },
})

local win, buf

-- Clear the existed window and buffer
local function clear()
  if win then
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  win = nil

  if buf then
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  buf = nil
end

-- Execute the git command
---@param args table<string>
local git_cmd = function(args)
  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(
    buf,
    true,
    utils.get_float_win_opts({
      border = true,
    })
  )

  vim.schedule(function()
    vim.api.nvim_win_call(win, function()
      vim.cmd.startinsert()
      local cmd = "git " .. table.concat(args, " ")

      vim.fn.termopen(cmd, {
        ["cwd"] = vim.fn.getcwd(),
      })

      for _, key in ipairs({ "<CR>", "<ESC>" }) do
        vim.keymap.set({ "n", "i" }, key, clear, {
          buffer = buf,
          noremap = true,
          silent = true,
        })
      end
    end)
  end)
end

-- INFO: overwrite the default `Git` command with cmd completion
vim.api.nvim_create_user_command("Git", function(args)
  clear()

  git_cmd(args.fargs)
end, {
  bang = true,
  nargs = "*",
  desc = "Wrapper for shell `git` command",
  complete = function(_, line)
    local l = vim.split(line, "%s+")
    local n = #l - 2

    if n == 0 then
      local args =
        vim.split(vim.fn.system({ "git", "--list-cmds=main" }), "%s+")
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[2])
      end, args)
    end
  end,
})
