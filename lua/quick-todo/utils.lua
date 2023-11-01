local M = {}

local log = require('plenary.log')

-- Initialize logger
M.logger = log.new({
    plugin = 'quick-todo',
    level = 'info',
})

-- Returns the key for the current working directory
M.get_path_key = function()
    return vim.fn.getcwd()
end

return M
