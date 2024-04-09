local utils = require('quick-todo.utils')
local M = {}

M.defaults = function()
    return {
        fixed_path = utils.get_default_path(),
        use_fixed_path = false,
        width = '50',
    }
end

return M
