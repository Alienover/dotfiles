---@class Features
---@field inlay_hint boolean
---@field enhanced_comment boolean
local M = setmetatable({}, {
  __index = function(_, key)
    error(string.format('Accessing invalid feature "%s"', key))
    return false
  end,
})

-- INFO: features in nightly version
local version_features = {}

for version, features in pairs(version_features) do
  for _, feature in ipairs(features) do
    M[feature] = vim.fn.has(version) == 1
  end
end

return M
