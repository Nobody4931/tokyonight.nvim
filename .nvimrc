nnoremap <silent> <leader>ca <CMD>call v:lua.project_clear()<CR>
nnoremap <silent> <leader>cb <CMD>call v:lua.project_build(0)<CR>
nnoremap <silent> <leader>cB <CMD>call v:lua.project_build(1)<CR>
nnoremap <silent> <leader>ce <CMD>call v:lua.project_run(0)<CR>
nnoremap <silent> <leader>cE <CMD>call v:lua.project_run(1)<CR>

lua << EOF
local curr_directory = vim.fn.expand(vim.fn.getcwd())
local curr_terminal = nil

local function check_terminal()
	if (not vim.api.nvim_win_is_valid(curr_terminal[1])) then return false end
	if (vim.api.nvim_win_get_buf(curr_terminal[1]) ~= curr_terminal[2]) then return false end
	return true
end

local function get_terminal()
	if (curr_terminal ~= nil) and (not check_terminal()) then
		pcall(vim.api.nvim_win_close, curr_terminal[1], true)
		pcall(vim.api.nvim_buf_delete, curr_terminal[2], { force = true })

		curr_terminal = nil
	end

	if (curr_terminal == nil) then
		local old_win = vim.api.nvim_get_current_win()
		local old_win_height = vim.api.nvim_win_get_height(old_win)

		local terminal_buf = vim.api.nvim_create_buf(false, true)
		-- for debugging purposes, shows buffer in :buffers
		--local terminal_buf = vim.api.nvim_create_buf(true, false)

		vim.cmd("split")
		vim.api.nvim_win_set_buf(0, terminal_buf)
		vim.api.nvim_win_set_height(0, math.floor(old_win_height * 0.35))
		vim.cmd("terminal powershell")

		curr_terminal = {}
		curr_terminal[1] = vim.api.nvim_get_current_win()
		curr_terminal[2] = terminal_buf
		curr_terminal[3] = vim.b.terminal_job_id

		vim.api.nvim_set_current_win(old_win)
	end

	return curr_terminal
end

_G.project_clear = function()
	local term = get_terminal()
	vim.fn.chansend(term[3], "")
	vim.fn.chansend(term[3], "")
end

_G.project_build = function(enter_insert)
	local term = get_terminal()
	vim.fn.chansend(term[3], "cd " .. curr_directory .. "; ")
	vim.fn.chansend(term[3], "node " .. vim.fn.expand("%:.") .. "\r")

	if (enter_insert ~= 0) then
		vim.api.nvim_set_current_win(term[1])
		vim.cmd("startinsert")
	end
end

_G.project_run = function(enter_insert)
	local term = get_terminal()
	vim.fn.chansend(term[3], "cd " .. curr_directory .. "; ")
	vim.fn.chansend(term[3], "node generate.js\r")

	if (enter_insert ~= 0) then
		vim.api.nvim_set_current_win(term[1])
		vim.cmd("startinsert")
	end
end
EOF
