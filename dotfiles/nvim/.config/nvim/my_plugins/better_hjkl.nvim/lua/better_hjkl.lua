local cowboy = require("cowboy")

local PKG_NAME = "better_hjkl.nvim"

--- @class HJKL_Config
--- @field presets {better_escape: boolean, discipline: string[]}
local config = {
  presets = {
    better_escape = true,
    discipline = { "h", "j", "k", "l" },
  },
}

--- @class CowboyState
--- @field enabled boolean
--- @field notify_id table?

--- @class HJKL_Context
--- @field cowboy CowboyState
local M = {
  cowboy = {
    enabled = true,
    ---@type table?
    notify_id = nil,
  },
}

function M.enable_escape()
  if M.config.presets.better_escape then
    local ok, _ = pcall(vim.api.nvim_command, "Lazy load better_escape.nvim")

    if not ok then
      vim.notify(
        string.format("[%s] failed to enable better_escape.nvim", PKG_NAME),
        vim.log.levels.WARN
      )
    end
  end
end

function M.enable_cowboy()
  if #M.config.presets.discipline == 0 then
    return
  end

  M.cowboy.enabled = true

  for _, key in ipairs(M.config.presets.discipline) do
    cowboy:register(key)
  end

  vim.api.nvim_create_user_command("CowboyToggle", function()
    cowboy:toggle(M)
  end, { desc = string.format("[%s] Toggle the Cowboy discipline", PKG_NAME) })
end

function M:enable()
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    vim.keymap.set({ "n", "v" }, key, function()
      local mode = vim.api.nvim_get_mode()["mode"]

      -- INFO: check discipline when navigating in `Normal` mode
      if mode == "n" then
        if not cowboy:check(self, key) then
          return ""
        end
      end

      -- INFO: remap `j` -> `gj`, `k` -> `gk` when in `Normal` or `Visual` mode
      if key == "j" or key == "k" then
        if mode == "n" or mode == "v" then
          return "g" .. key
        end
      end

      return key
    end, { expr = true, silent = true })
  end
end

---comment
---@param opts HJKL_Config
M.setup = function(opts)
  M.config = vim.tbl_deep_extend("force", config, opts or {})

  M.enable_escape()
  M.enable_cowboy()

  M:enable()
end

return M
