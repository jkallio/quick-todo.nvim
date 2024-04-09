local utils = require('quick-todo.utils')
local todo = require('quick-todo.todo')
local options = require('quick-todo.options')
local _opts = {}
local _current_path = nil

local M = {}

--- Creates the quick-todo directory if it doesn't exist
M.setup = function(opts)
    _opts = options.defaults()
    for k,v in pairs(opts) do _opts[k] = v end
end

--- Add new todo to the list for the current working directory
--- The todo input string is queried from the user
M.add = function(args)
    _current_path = utils.get_default_path()
    if _opts.use_fixed_path or (args and args.use_fixed_path) then
        _current_path = _opts.fixed_path
    end

    local input = vim.fn.input('Add TODO: ')
    todo.add_new(_current_path, input)
end

--- Open the TODO popup window
M.open_ui = function(args)
    _current_path = utils.get_default_path()
    if _opts.use_fixed_path or (args and args.use_fixed_path) then
        _current_path = _opts.fixed_path
    end
    M.open_ui_with_path({path=_current_path })
end

-- Open the TODO popup window with specific path
M.open_ui_with_path = function(args)
    _current_path = args.path
    utils.touch_file(_current_path)
    local lines = utils.read_file_contents(_current_path)
    if lines == nil then
        return -- Failed to read the `todo.txt` file
    end

    local _, bufnr = utils.open_popup_window(_opts.width, lines)
    if bufnr == nil then
        return -- Failed to open the TODO popup window
    end

    todo.configure_buf_keymaps(bufnr)
    todo.monitor_buf_changes(_current_path, bufnr)
end

--- Close the TODO popup window
M.close_ui = function()
    _current_path = _current_path or utils.get_default_path()
    if utils.is_popup_window_open() then
        local lines = utils.close_popup_window()
        if lines ~= nil then
            utils.write_file_contents(_current_path, lines)
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
