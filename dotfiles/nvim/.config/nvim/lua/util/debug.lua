-- Setup some globals for debugging (lazy-loaded)
_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end

-- Override print to use snacks for `:=` command
if vim.fn.has("nvim-0.11") == 1 then
	vim._print = function(_, ...)
		dd(...)
	end
else
	vim.print = _G.dd
end
