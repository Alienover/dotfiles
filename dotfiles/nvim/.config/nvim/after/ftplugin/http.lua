-- INFO: Enable telescope extension
local tel_loaded, tel = pcall(require, "telescope")
if tel_loaded then
  tel.load_extension("rest")
end

-- INFO: Bind rest cmds in which-key
local wk_loaded, wk = pcall(require, "which-key")
if wk_loaded then
  ---@param preview boolean?
  local http_rest = function(preview)
    return function()
      local ok, rest = pcall(require, "rest-nvim")
      if ok then
        rest.run(preview)
      end
    end
  end

  wk.register({
    r = {
      name = "HTTP Rest Request",
      r = { http_rest(), "Send request under the cursor" },
      p = { http_rest(true), "[P]review the CURL request" },
      e = { "<CMD>Telescope rest select_env<CR>", "Select ENV file" },
    },
  })
end
