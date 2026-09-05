--- Insert-mode escape combos (`jk`, `jj`) for `mini.keymap`.
---
--- `mini.keymap` combos are not mappings: each key acts immediately and really
--- lands in the buffer, so the combo has to erase itself with `<BS><BS>`. That
--- leaves a buffer that was clean marked as modified, which `better-escape.nvim`
--- used to undo with `setlocal nomodified`.
---
--- The state cannot be read inside the combo action: by the time it runs both
--- characters are already inserted, so `vim.bo.modified` is unconditionally
--- true. It is sampled on `InsertCharPre` instead, which fires *before* each
--- character is inserted -- the value from two characters back is the state from
--- before the combo began.

local M = {}

---@type table<integer, boolean[]> [before the previous char, before the one before it]
local states = {}

local did_setup = false

---@param buf integer
local function seed(buf)
	local modified = vim.bo[buf].modified

	states[buf] = { modified, modified }
end

---@param buf integer
local function sample(buf)
	local state = states[buf]
	if not state then
		return
	end

	state[2] = state[1]
	state[1] = vim.bo[buf].modified
end

--- Build a combo action that leaves 'modified' as it found it.
---@param escape string keys that leave insert mode
---@return fun(): string
function M.action(escape)
	M.setup()

	return function()
		local state = states[vim.api.nvim_get_current_buf()]
		local keys = "<BS><BS>" .. escape

		-- INFO: `state[2]` is the state from before the combo's first character.
		-- Only restore the flag when the buffer was clean back then, otherwise the
		-- buffer holds real edits and must stay modified.
		if state and state[2] == false then
			keys = keys .. "<Cmd>setlocal nomodified<CR>"
		end

		return keys
	end
end

--- Register the autocmds backing `M.action`. Called from the `mini.keymap`
--- spec, so nothing is registered when that plugin is disabled.
function M.setup()
	if did_setup then
		return
	else
		did_setup = true
	end

	local group = vim.api.nvim_create_augroup("custom/escape", { clear = true })

	vim.api.nvim_create_autocmd("InsertEnter", {
		desc = "Seed the modified state tracked for the escape combos",
		group = group,

		callback = function(args)
			seed(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("InsertCharPre", {
		desc = "Sample the modified state before each inserted character",
		group = group,

		callback = function(args)
			sample(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		desc = "Forget the modified state of a gone buffer",
		group = group,

		callback = function(args)
			states[args.buf] = nil
		end,
	})
end

return M
