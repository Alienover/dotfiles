-- INFO: features in nightly version
local H = {
  features = {},
}

function H:register(feature, version)
  if type(self.features[version]) ~= "table" then
    self.features[version] = {}
  end

  table.insert(self.features[version], feature)
end

--- Register the nightly-feature beblow

-- H:register("comment", "nvim-0.10")
-- H:register("inly_hint", "nvim-0.10")

--- End of the definitions

return (function()
  --- @type table<string, boolean>
  local M = setmetatable({}, {
    __index = function(_, key)
      error(string.format('Accessing invalid feature "%s"', key))
      return false
    end,
  })

  for version, registereds in pairs(H.features) do
    for _, feature in ipairs(registereds) do
      M[feature] = vim.fn.has(version) == 1
    end
  end

  return M
end)()
