-- Enables the experimental Lua module loader
if vim.loader then
	vim.loader.enable()
end

require("options")
require("autocmd")
require("keymaps")

require("config.lazy-config")
