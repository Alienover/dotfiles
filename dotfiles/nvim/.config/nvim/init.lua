-- Enables the experimental Lua module loader
if vim.loader then
	vim.loader.enable()
end

require("options")
require("autocmd")
require("keymappings")

require("config.lazy-config")
