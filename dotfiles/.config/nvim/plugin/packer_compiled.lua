-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/jiarong/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/jiarong/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/jiarong/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/jiarong/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/jiarong/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["diffview.nvim"] = {
    commands = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27config/diffview-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/diffview.nvim"
  },
  ["editorconfig-vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/editorconfig-vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27config/gitsigns-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    wants = { "plenary.nvim" }
  },
  kommentary = {
    after = { "nvim-ts-context-commentstring" },
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29config/kommentary-config\frequire\0" },
    keys = { { "", "gc" }, { "", "gcc" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/kommentary",
    wants = { "nvim-ts-context-commentstring" }
  },
  ["kwbdi.vim"] = {
    keys = { { "", "<leader>bd" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/kwbdi.vim"
  },
  ["lua-dev.nvim"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config/lualine-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/lualine.nvim"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28config/neoscroll-config\frequire\0" },
    keys = { { "", "<C-u>" }, { "", "<C-d>" }, { "", "gg" }, { "", "G" }, { "", "zz" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28config/autopairs-config\frequire\0" },
    load_after = {
      ["nvim-compe"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29config/bufferline-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
    wants = { "nvim-web-devicons" }
  },
  ["nvim-compe"] = {
    after = { "nvim-autopairs" },
    after_files = { "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24config/compe-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-compe",
    wants = { "vim-vsnip" }
  },
  ["nvim-lspconfig"] = {
    after = { "lua-dev.nvim" },
    config = { "\27LJ\2\n#\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\blsp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig",
    wants = { "lua-dev.nvim" }
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29config/treesitter-config\frequire\0" },
    loaded = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-context-commentstring"] = {
    load_after = {
      kommentary = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\nO\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\fdefault\2\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["onedark.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config/onedark-config\frequire\0" },
    loaded = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/start/onedark.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    commands = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/popup.nvim"
  },
  rnvimr = {
    commands = { "RnvimrToggle" },
    config = { "\27LJ\2\n4\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\25config/rnvimr-config\frequire\0" },
    keys = { { "", "<C-f>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/rnvimr"
  },
  ["symbols-outline.nvim"] = {
    commands = { "SymbolsOutline" },
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!config/symbol-outline-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/symbols-outline.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-fzf-native.nvim" },
    commands = { "Telescope" },
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28config/telescope-config\frequire\0" },
    keys = { { "", "<leader><space>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    wants = { "popup.nvim", "plenary.nvim", "telescope-fzf-native.nvim" }
  },
  ["vim-css-color"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-css-color"
  },
  ["vim-fugitive"] = {
    commands = { "Git" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-javascript"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript"
  },
  ["vim-jsdoc"] = {
    commands = { "JsDoc", "JsDocFormat" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-jsdoc"
  },
  ["vim-jsx"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-jsx"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-test"] = {
    commands = { "TestFile", "TestNearest" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-test"
  },
  ["vim-vsnip"] = {
    after = { "vim-vsnip-integ" },
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24config/vsnip-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    after_files = { "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ/after/plugin/vsnip_integ.vim" },
    load_after = {
      ["vim-vsnip"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28config/which-key-config\frequire\0" },
    keys = { { "", "<space>" } },
    loaded = false,
    needs_bufread = false,
    path = "/Users/jiarong/.local/share/nvim/site/pack/packer/opt/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^nvim%-web%-devicons"] = "nvim-web-devicons",
  ["^plenary"] = "plenary.nvim",
  ["^popup"] = "popup.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat)then
      to_load[#to_load + 1] = plugin_name
    end
  end

  require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29config/treesitter-config\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: onedark.nvim
time([[Config for onedark.nvim]], true)
try_loadstring("\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26config/onedark-config\frequire\0", "config", "onedark.nvim")
time([[Config for onedark.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file SymbolsOutline lua require("packer.load")({'symbols-outline.nvim'}, { cmd = "SymbolsOutline", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewClose lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file JsDoc lua require("packer.load")({'vim-jsdoc'}, { cmd = "JsDoc", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file JsDocFormat lua require("packer.load")({'vim-jsdoc'}, { cmd = "JsDocFormat", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file TSHighlightCapturesUnderCursor lua require("packer.load")({'playground'}, { cmd = "TSHighlightCapturesUnderCursor", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewFocusFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewFocusFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewToggleFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewToggleFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file DiffviewOpen lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file TestFile lua require("packer.load")({'vim-test'}, { cmd = "TestFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file RnvimrToggle lua require("packer.load")({'rnvimr'}, { cmd = "RnvimrToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file TestNearest lua require("packer.load")({'vim-test'}, { cmd = "TestNearest", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <space> <cmd>lua require("packer.load")({'which-key.nvim'}, { keys = "<lt>space>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>bd <cmd>lua require("packer.load")({'kwbdi.vim'}, { keys = "<lt>leader>bd", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader><space> <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader><lt>space>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gcc <cmd>lua require("packer.load")({'kommentary'}, { keys = "gcc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gg <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "gg", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> zz <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "zz", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> G <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "G", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gc <cmd>lua require("packer.load")({'kommentary'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-f> <cmd>lua require("packer.load")({'rnvimr'}, { keys = "<lt>C-f>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-u> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-u>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-d> <cmd>lua require("packer.load")({'neoscroll.nvim'}, { keys = "<lt>C-d>", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType typescript.jsx ++once lua require("packer.load")({'vim-jsdoc', 'vim-jsx', 'vim-javascript'}, { ft = "typescript.jsx" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'vim-jsdoc', 'vim-javascript'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'vim-jsdoc', 'vim-javascript'}, { ft = "typescript" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescriptreact ++once lua require("packer.load")({'vim-jsx', 'vim-javascript'}, { ft = "typescriptreact" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript.jsx ++once lua require("packer.load")({'vim-jsdoc', 'vim-jsx', 'vim-javascript'}, { ft = "javascript.jsx" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascriptreact ++once lua require("packer.load")({'vim-jsx', 'vim-javascript'}, { ft = "javascriptreact" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'editorconfig-vim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim', 'lualine.nvim', 'vim-css-color', 'vim-jsx', 'nvim-bufferline.lua', 'vim-javascript', 'nvim-lspconfig'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au CursorMoved * ++once lua require("packer.load")({'vim-matchup'}, { event = "CursorMoved *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-jsx/ftdetect/javascript.vim]], true)
vim.cmd [[source /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-jsx/ftdetect/javascript.vim]]
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-jsx/ftdetect/javascript.vim]], false)
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/flow.vim]], true)
vim.cmd [[source /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/flow.vim]]
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/flow.vim]], false)
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/javascript.vim]], true)
vim.cmd [[source /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/javascript.vim]]
time([[Sourcing ftdetect script at: /Users/jiarong/.local/share/nvim/site/pack/packer/opt/vim-javascript/ftdetect/javascript.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
