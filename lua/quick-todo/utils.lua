local logger = require('plenary.log')
local M = {}
local _popup_bufnr = nil
local _win_id = nil

--- Initialize the plenary logger
M.log = logger.new({
    plugin = 'quick-todo',
    level = 'info',
})

--- Returns the path for the current working directory
M.get_working_directory_path = function()
    return vim.fn.getcwd()
end

--- Creates a file in the given path if it doesn't exist
--- @param path string The path to the file
M.touch_file = function(path)
    local file = io.open(path, 'r')
    if file ~= nil then
        file:close()
        return
    end

    file = io.open(path, 'w')
    if file ~= nil then
        M.log.info('Created file: ' .. path)
        file:close()
        return
    end
    M.log.error('Failed to touch file: ' .. path)
end

--- Create a directory in the given path if it doesn't exist
--- @param path string The path to the directory
M.touch_directory = function(path)
    if vim.fn.isdirectory(path) == 1 then
        return
    end

    M.log.info('Creating directory: ' .. path)
    if vim.fn.mkdir(path, 'p') == 0 then
        M.log.error('Failed to create directory: ' .. path)
    end
end

--- Check if TODO popup window is open and valid
--- @return boolean True if the popup window is open and valid
M.is_popup_window_open = function()
    return _win_id ~= nil
        and vim.api.nvim_win_is_valid(_win_id)
        and _popup_bufnr ~= nil
        and vim.api.nvim_buf_is_valid(_popup_bufnr)
end

--- Open a popup window with the given contents
--- @param rows string[] The contents for the popup window buffer
--- @return number, number The window ID and buffer number for the popup window
M.open_popup_window = function(rows)
    M.close_popup_window()

    if rows == nil then
        rows = { '' }
    end

    _popup_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(_popup_bufnr, 0, -1, false, rows)

    local ui = vim.api.nvim_list_uis()[1]
    local width = vim.fn.max({ 40, vim.fn.round(ui.width * 0.3) })
    local height = vim.fn.max({ 10, vim.fn.round(ui.height * 0.3) })
    _win_id = vim.api.nvim_open_win(_popup_bufnr, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width - width) / 2,
        row = (ui.height - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = "-=[ TODO ]=-",
        title_pos = 'center',
        noautocmd = true,
    })
    vim.api.nvim_buf_set_option(_popup_bufnr, 'buftype', 'nofile')
    vim.api.nvim_win_set_option(_win_id, 'wrap', true)
    vim.api.nvim_win_set_option(_win_id, 'number', true)

    return _win_id, _popup_bufnr
end

--- Close the popup window
--- @return string[] The contents of the closed popup window buffer
M.close_popup_window = function()
    local rows = {}
    if _popup_bufnr ~= nil and vim.api.nvim_buf_is_valid(_popup_bufnr) then
        rows = vim.api.nvim_buf_get_lines(_popup_bufnr, 0, -1, false)
        vim.api.nvim_buf_delete(_popup_bufnr, { force = true })
    end
    _popup_bufnr = nil

    if _win_id ~= nil and vim.api.nvim_win_is_valid(_win_id) then
        vim.api.nvim_win_close(_win_id, true)
    end
    _win_id = nil
    return rows
end

--- Read file contents into a table
--- @param path string The path to the file
M.read_file_contents = function(path)
    if path == nil then
        M.log.error('Invalid path: ' .. path)
        return nil
    end

    local file = io.open(path, 'r')
    if file == nil then
        M.log.error('Failed to open file: ' .. path)
        return nil
    end

    local contents = {}
    for line in file:lines() do
        table.insert(contents, line)
    end
    file:close()
    return contents
end

--- Write the given contents to a file
--- @param path string The path to the file
--- @param lines string[] The contents to write to the file
M.write_file_contents = function(path, lines)
    if path == nil then
        M.log.error('Invalid path: ' .. path)
        return
    end

    local file = io.open(path, 'w')
    if file == nil then
        M.log.error('Failed to open file: ' .. path)
        return
    end

    for _, line in ipairs(lines) do
        if line ~= nil and #line > 0 then
            if line:sub(-1) == '\n' then
                file:write(line)
            else
                file:write(line .. '\n')
            end
        end
    end
    file:close()
end

--- Append file with the given rows
--- @param path string The path to the file
--- @param lines string[] The rows to append to the file
M.append_file = function(path, lines)
    if path == nil then
        M.log.error('Invalid path: ' .. path)
        return
    end

    local file = io.open(path, 'a')
    if file == nil then
        M.log.error('Failed to open file: ' .. path)
        return
    end

    for _, line in ipairs(lines) do
        if line ~= nil and #line > 0 then
            if line:sub(-1) == '\n' then
                file:write(line)
            else
                file:write(line .. '\n')
            end
        end
    end
    file:close()
end

--- Check if the given string starts with the given start string
M.starts_with = function(str, start)
    return str:sub(1, #start) == start
end

return M
