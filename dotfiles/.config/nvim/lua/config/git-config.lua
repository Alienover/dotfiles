require("git").setup({
  default_mappings = false,
  keymaps = {
    browse = "<space>go",
    open_pull_request = "<space>gP",
  },
})

-- INFO: overwrite the default `Git` command with cmd completion
vim.api.nvim_create_user_command(
  "Git",
  'lua require("git.cmd").cmd(<f-args>)',
  {
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
  }
)
