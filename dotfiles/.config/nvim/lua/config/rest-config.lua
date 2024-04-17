local status_ok, rest = pcall(require, "rest-nvim")
if not status_ok then
  return
end

local config = {
  custom_dynamic_variables = {},
  -- Skip SSL verification, useful for unknown certificates
  skip_ssl_verification = false,
  result = {
    split = {
      -- Open request results in a horizontal split
      horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      in_place = true,
      -- Keep the current cursor after running
      stay_in_current_window_after_split = true,
    },
    behavior = {
      decode_url = true,
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_info = {
        url = true,
        headers = true,
        http_info = true,
        -- show the generated curl command in case you want to launch
        curl_command = true,
      },
    },
  },
}

rest.setup(config)
