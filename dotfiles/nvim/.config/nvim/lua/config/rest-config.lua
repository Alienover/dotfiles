local utils = require("utils")

local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local config = require("telescope.config").values
local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")
local make_entry = require("telescope.make_entry")

local rutils = require("rest-nvim.utils")
local dotenv = require("rest-nvim.dotenv")
local rest_dotenv_parser = require("rest-nvim.parser.dotenv")

-- Fix the response formatting issue
-- See: https://github.com/rest-nvim/rest.nvim/issues/414#issuecomment-2308629381
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "xml", "html" },
  callback = function()
    vim.bo.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
})

---@alias envType 'dotenv' | 'http_client'
---@type table<envType, envType>
local env_type = {
  http_client = "http_client",
  dotenv = "dotenv",
}

local env = setmetatable({
  ---@type table<envType, envMethods>
  __manager = {},
  __context = {},
}, {
  __index = function(t, k)
    --- TODO: read `env_type` from buffer variable
    -- local _type = vim.b[0]._rest_nvim_env_type or env_type.dotenv
    local _type = env_type.http_client
    return t.__manager[_type][k]
  end,
})

function env:reset()
  self.__context = {}
end

---@param key string
---@param value any
function env:set_ctx(key, value)
  self.__context[key] = value
end

---@param key string
---@return any
function env:get_ctx(key)
  return self.__context[key]
end

--- @class envMethods
--- @field parse fun(path: string, setter?: fun(key: string, value: string)): boolean, table|nil
--- @field find fun(): string[]
--- @field previewer fun(opts: table)
--- @field select fun(selected: string)
---
---@param _type envType
---@param opts envMethods
function env:register(_type, opts)
  self.__manager[_type] = {}

  for method, handler in pairs(opts) do
    self.__manager[_type][method] = handler
  end
end

env:register(env_type.http_client, {
  parse = function(path, setter)
    local vars
    if setter == nil then
      vars = {}
      setter = function(name, value)
        vars[name] = value
      end
    end

    local s = {}
    for x in string.gmatch(path, "([^#]+)") do
      s[#s + 1] = x
    end
    local file, env_value = unpack(s)
    env_value = env_value or "dev"

    local contents = vim.fn.json_decode(vim.fn.readfile(file))

    if contents._base then
      for key, value in pairs(contents._base) do
        if key ~= "DEFAULT_HEADERS" then
          setter(key, value)
        end
      end
    end

    if contents[env_value] ~= nil then
      for key, value in pairs(contents[env_value]) do
        setter(key, value)
      end
    end

    return true, vars
  end,

  find = function()
    local envs = {}

    --- Reset env context before choosing a new one
    env:reset()
    local file = vim.fs.find("http-client.env.json", {
      upward = true,
      limit = 1,
      path = vim.fn.expand("%:p:h"),
    })[1]

    if file ~= nil then
      env:set_ctx("env_file", file)

      ---@type table<string, any>
      local contents = vim.fn.json_decode(rutils.read_file(file))

      env:set_ctx("contents", contents)

      for key, _ in pairs(contents) do
        if key ~= "_base" then
          table.insert(envs, key)
        end
      end
    end

    return envs
  end,

  previewer = function()
    return previewers.new_buffer_previewer({
      title = "Variables",
      define_preview = function(self, entry)
        local ok, vars =
          env.parse(env:get_ctx("env_file") .. "#" .. entry.value)

        if not ok then
          return
        end

        local lines = {}
        for key, value in pairs(vars) do
          table.insert(lines, string.format("%s: %s", key, value))
        end

        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        putils.ts_highlighter(self.state.bufnr, "sh")
      end,
    })
  end,

  select = function(selection)
    vim.b[0]._rest_nvim_env_file = env:get_ctx("env_file") .. "#" .. selection
  end,
})

env:register(env_type.dotenv, {
  parse = rest_dotenv_parser.parse,
  find = dotenv.find_env_files,
  previewer = config.file_previewer,
  select = dotenv.register_file,
})

local function select_env()
  local opts = {}
  opts.entry_maker = make_entry.gen_from_file(opts)

  pickers
    .new(opts, {
      prompt_title = "Select env",

      finder = finders.new_table({
        results = env.find(),
        entry_maker = make_entry.gen_from_file(),
      }),

      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection == nil then
            return
          end

          env.select(selection[1])
        end)
        return true
      end,

      previewer = env.previewer(opts),
    })
    :find()
end

utils.MockPackage("telescope._extensions.rest", function()
  ---@diagnostic disable-next-line: duplicate-set-field
  require("rest-nvim.parser.dotenv").parse = function(...)
    return env.parse(...)
  end

  return telescope.register_extension({
    exports = {
      select_env = select_env,
    },
  })
end)

utils.MockPackage("rest-nvim.script.javascript", function()
  local M = {}

  function M.load_post_req_hook(s, ctx)
    --- TODO: impl javascript runner
  end

  return M
end)
