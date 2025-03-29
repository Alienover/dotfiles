local Cowboy = require("cowboy")

local PKG_NAME = "better_hjkl.nvim"

--- @class EscapeConfig
--- @field enabled boolean
--- @field mapping string[]

--- @class DisciplineConfig
--- @field enabled boolean
--- @field keys string[]
--- @field excluded_filetypes string[]

--- @class HJKL_Config
--- @field escape EscapeConfig
--- @field discipline DisciplineConfig
local config = {
  escape = {
    enabled = true,
    mapping = { "jk" },
  },
  discipline = {
    enabled = true,
    keys = { "h", "j", "k", "l" },
    excluded_filetypes = {},
  },
}

--- @class HJKL_Context
--- @field cowboy CowboyState?
--- @field config HJKL_Config
local M = {
  cowboy = nil,
}

function M:enable_escape()
  if M.config.escape.enabled then
    local ok, escape = pcall(require, "better_escape")

    if ok then
      escape.setup({ mapping = self.config.escape.mapping })
    else
      vim.notify(
        string.format("[%s] failed to load better-escape.nvim", PKG_NAME),
        vim.log.levels.WARN
      )
    end
  end
end

function M:enable_cowboy()
  self.cowboy = Cowboy:new(self.config)

  vim.api.nvim_create_user_command("CowboyToggle", function()
    self.cowboy:toggle()
  end, { desc = string.format("[%s] Toggle the Cowboy discipline", PKG_NAME) })
end

function M:enable()
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set({ "n", "v" }, key, function()
      local mode = vim.api.nvim_get_mode()["mode"]

      -- INFO: check discipline when navigating in `Normal` mode
      if mode == "n" then
        if self.cowboy and not self.cowboy:check(key) then
          return ""
        end
      end

      -- INFO: remap `j` -> `gj`, `k` -> `gk` when in `Normal` or `Visual` mode
      if
        vim.tbl_contains({ "j", "k" }, key)
        and vim.tbl_contains({ "n", "v" }, mode)
      then
        return "g" .. key
      end

      return key
    end, { expr = true, silent = true })
  end
end

--- comment
--- @param opts HJKL_Config
M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", config, opts or {})

  M:enable_escape()
  M:enable_cowboy()

  M:enable()
end

return M
