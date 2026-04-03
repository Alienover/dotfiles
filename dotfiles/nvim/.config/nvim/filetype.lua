-- Custom filetypes
vim.filetype.add({
	extension = {
		json = "jsonc",
		tmux = "tmux",
		http = "http",
		sql = "sql",
	},
	filename = {
		[".gitignore"] = "conf",
		[".env"] = "dosini",
		config = "dosini",
		Brewfile = "ruby",
	},
	pattern = {
		[".env.*"] = "dosini",
	},
})
