local utils = require('quick-todo.utils')
local _todo_path = ''

local M = {}

--- Creates the quick-todo directory if it doesn't exist
M.setup = function()
    _todo_path = utils.get_working_directory_path() .. '/todo.txt'
end

--- Add new todo to the list for the current working directory
--- The todo input string is queried from the user
M.add = function()
    local todo = vim.fn.input('Add TODO: ')
    if todo ~= nil and #todo > 0 then
        utils.append_file(_todo_path, { todo })
    end
end

--- Toggle the TODO popup window
M.toggle_ui = function()
    if utils.is_popup_window_open() then
        local lines = utils.close_popup_window()
        if lines ~= nil then
            utils.write_file_contents(_todo_path, lines)
        end
        return
    end

    utils.touch_file(_todo_path)
    local read_lines = utils.read_file_contents(_todo_path)
    if read_lines == nil then
        -- Failed to read the `todo.txt` file
        return
    end

    local win_id = utils.open_popup_window(read_lines)
    if win_id == nil then
        -- Failed to open the TODO popup window
        return
    end

    local bufnr = vim.api.nvim_win_get_buf(win_id)
    if bufnr == nil or vim.api.nvim_buf_is_valid(bufnr) == false then
        -- Failed to get valid buffer number
        utils.close_popup_window()
        return
    end

    -- TODO: Maybe these keymaps should be user configurable?
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', ':lua require("quick-todo").toggle_done()<CR>', {
        noremap = true,
        silent = true
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':lua require("quick-todo").toggle_ui()<CR>', {
        noremap = true,
        silent = true
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<A-J>', ':m .+1<CR>==', {
        noremap = true,
        silent = true
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<A-K>', ':m .-2<CR>==', {
        noremap = true,
        silent = true
    })

    -- Attach `on_lines` listener, which triggers every time a line is changed
    vim.api.nvim_buf_attach(bufnr, false, {
        on_lines = function()
            local write_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            if write_lines ~= nil then
                -- TODO: Maybe the buffer should be written on close and not on every change?
                utils.write_file_contents(_todo_path, write_lines)
            end
        end
    })
end

--- Toggle the TODO
M.toggle_done = function()
    if utils.is_popup_window_open() == false then
        return
    end

    local line = vim.api.nvim_get_current_line()
    if line == nil or #line == 0 then
        return
    end

    local function starts_with(str, start)
        return str:sub(1, #start) == start
    end

    if starts_with(line, '[ ]') then
        line = line:gsub('%[ %]', '[x]')
        vim.api.nvim_set_current_line(line)
    elseif starts_with(line, '[x]') then
        line = line:gsub('%[x%]', '[ ]')
        vim.api.nvim_set_current_line(line)
    else
        vim.api.nvim_set_current_line('[ ] ' .. line)
    end
end

return M
