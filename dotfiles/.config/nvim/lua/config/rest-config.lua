local status_ok, rest = pcall(require, "rest-nvim")
if not status_ok then
  return
end

local config = {
  -- Open request results in a horizontal split
  result_split_horizontal = false,
  -- Keep the http file buffer above|left when split horizontal|vertical
  result_split_in_place = true,
  -- Skip SSL verification, useful for unknown certificates
  skip_ssl_verification = false,
  -- Highlight request on run
  highlight = {
    enabled = true,
    timeout = 150,
  },
  result = {
    -- toggle showing URL, HTTP info, headers at top the of result window
    show_url = true,
    -- show the generated curl command in case you want to launch
    -- the same request via the terminal (can be verbose)
    show_curl_command = true,
    show_http_info = true,
    show_headers = true,
  },
  -- Jump to request line on run
  jump_to_request = false,
  env_file = ".env",
  custom_dynamic_variables = {},
  yank_dry_run = true,
}

rest.setup(config)

local cmds = {
  {
    "RestExecute",
    function()
      rest.run()
    end,
    {
      nargs = 0,
      desc = "http filetype only! Execute the HTTP request under cursor",
    },
  },
  {
    "RestExecutePreview",
    function()
      rest.run(true)
    end,
    {
      nargs = 0,
      desc = "http filetype only! Preview the request cURL command",
    },
  },
}

for _, cmd in ipairs(cmds) do
  local name, handler, opts = unpack(cmd)

  vim.api.nvim_create_user_command(name, handler, opts or {})
end
