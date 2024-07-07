---@class CowboyContext
---@field count integer
---@field timer any

local M = {}

--- comment
--- @param ctx HJKL_Context
--- @param key string
--- @return boolean
function M:check(ctx, key)
  -- INFO: bypass when it's not enabled or the key is un-registered
  if not ctx.cowboy.enabled then
    return true
  end

  if M[key] == nil then
    return true
  end

  ---@type integer
  local count = M[key].count
  local timer = M[key].timer

  -- INFO: reset counter when doing hjkl with number prefix
  if vim.v.count > 0 then
    M[key].count = 0

    timer:stop()

    return true
  end

  if count < 10 then
    -- INFO: increase counter and set timer to reset it after 2 seconds
    M[key].count = count + 1

    timer:stop()
    timer:start(2000, 0, function()
      M[key].count = 0

      timer:stop()
    end)

    return true
  else
    -- INFO: show notice
    local ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
      icon = "🤯",
      replace = ctx.cowboy.notify_id,
      keep = function()
        return count >= 10
      end,
    })

    if not ok then
      ctx.cowboy.notify_id = nil
      return true
    else
      ctx.cowboy.notify_id = id
      return false
    end
  end
end

---comment
---@param ctx HJKL_Context
function M:toggle(ctx)
  ctx.cowboy = vim.tbl_extend("force", ctx.cowboy, {
    enabled = not ctx.cowboy.enabled,
    notify_id = nil,
  })
end

---comment
---@param key string
function M:register(key)
  --- @type CowboyContext
  self[key] = {
    count = 0,
    timer = assert(vim.uv.new_timer()),
  }
end

return M
