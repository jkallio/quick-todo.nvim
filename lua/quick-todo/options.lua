local utils = require('quick-todo.utils')
local M = {}

M.defaults = function()
    return {
        todo_path = utils.get_working_directory_path() .. '/todo.txt',
        width = '50',
    }
end

return M
