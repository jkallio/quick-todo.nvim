local utils = require('quick-todo.utils')

local M = {}

--- Insert new TODO item to the end of the file
M.add_new = function(path, todo)
    if todo == nil or #todo == 0 then
        return
    end

    todo = '[ ] ' .. todo
    utils.append_file(path, { todo })
end

--- Configure the keymaps for the popup window
-- TODO: Maybe these keymaps should be user configurable?
M.configure_buf_keymaps = function(bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<CR>', ':lua require("quick-todo").toggle_todo_done()<CR>', {
        noremap = true,
        silent = true
    })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':lua require("quick-todo").close_ui()<CR>', {
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
end

--- Monitor changes to the popup buffer and write them to the file
M.monitor_buf_changes = function(path, bufnr)
    vim.api.nvim_buf_attach(bufnr, false, {
        -- Attach `on_lines` listener, which triggers every time a line is changed
        on_lines = function()
            local edited_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            if edited_lines ~= nil then
                -- TODO: Maybe the buffer should be written on close and not on every change?
                utils.write_file_contents(path, edited_lines)
            end
        end
    })
end

--- Toggle [ ] and [x] in the current line
M.toggle_buf_done = function()
    local line = vim.api.nvim_get_current_line()
    if line == nil or #line == 0 then
        return
    end

    if utils.starts_with(line, '[ ]') then
        line = line:gsub('%[ %]', '[x]')
        vim.api.nvim_set_current_line(line)
    elseif utils.starts_with(line, '[x]') then
        line = line:gsub('%[x%]', '[ ]')
        vim.api.nvim_set_current_line(line)
    else
        vim.api.nvim_set_current_line('[ ] ' .. line)
    end
end

return M
