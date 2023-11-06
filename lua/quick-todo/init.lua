local utils = require('quick-todo.utils')
local todo = require('quick-todo.todo')
local _todo_path = ''

local M = {}

--- Creates the quick-todo directory if it doesn't exist
M.setup = function()
    _todo_path = utils.get_working_directory_path() .. '/todo.txt'
end

--- Add new todo to the list for the current working directory
--- The todo input string is queried from the user
M.add = function()
    local input = vim.fn.input('Add TODO: ')
    todo.add_new(_todo_path, input)
end

--- Open the TODO popup window
M.open_ui = function()
    utils.touch_file(_todo_path)
    local lines = utils.read_file_contents(_todo_path)
    if lines == nil then
        return -- Failed to read the `todo.txt` file
    end

    local _, bufnr = utils.open_popup_window(lines)
    if bufnr == nil then
        return -- Failed to open the TODO popup window
    end

    todo.configure_buf_keymaps(bufnr)
    todo.monitor_buf_changes(_todo_path, bufnr)
end

--- Close the TODO popup window
M.close_ui = function()
    if utils.is_popup_window_open() then
        local lines = utils.close_popup_window()
        if lines ~= nil then
            utils.write_file_contents(_todo_path, lines)
        end
    end
end

--- Toggle the TODO popup window
M.toggle_ui = function()
    if utils.is_popup_window_open() then
        M.close_ui()
        return -- Closed the TODO popup window
    end
    M.open_ui()
end

--- Toggle the TODO line as done/undone
M.toggle_todo_done = function()
    if utils.is_popup_window_open() == false then
        return -- Popup window is not open
    end
    todo.toggle_buf_done()
end

return M
