-- This plugin is for creating a quick TODO list in a special file
-- stored in user application data directory.
local todo_file_path = vim.fn.stdpath('data') .. '/quick-todo.json'
local utils = require('quick-todo.utils')
local logger = utils.logger

local M = {}

-- Creates the quick-todo.json file if it doesn't exist
M.setup = function()
    local file = io.open(todo_file_path, 'r')
    if file ~= nil then
        file:close()
    else
        file = io.open(todo_file_path, 'w')
        if file == nil then
            logger.error('Error creating quick-todo.json file')
        else
            file:write('{}')
            file:close()
            logger.info('Created file ' .. todo_file_path)
        end
    end
end

-- Returns the full contents of the quick-todo.json file
local function read_todo_file_contents()
    local file = io.open(todo_file_path, 'r')
    if file == nil then
        logger.error('Error opening quick-todo.json file for reading')
        return nil
    end

    local file_contents = file:read('*a')
    file:close()

    local json_data = vim.fn.json_decode(file_contents)

    if json_data == nil then
        logger.error('Error decoding quick-todo.json file')
        return nil
    end

    return json_data
end

-- Write json_data to the quick-todo.json file
local function write_todo_file_contents(json_data)
    local file = io.open(todo_file_path, 'w')
    if file == nil then
        logger.error('Error opening quick-todo.json file for writing')
        return
    end

    file:write(vim.fn.json_encode(json_data))
    file:close()
    logger.info('Updated ' .. todo_file_path)
end

-- Add new todo to the list for the current working directory
-- The title is queried from the user
M.add = function()
    local json_data = read_todo_file_contents()
    if json_data == nil then
        logger.error('Error getting quick-todo.json file contents')
        return
    end

    local key = utils.get_path_key()
    if json_data[key] == nil then
        logger.info('Creating new todo list for ' .. key)
        json_data[key] = {}
    end

    local title = vim.fn.input('Add TODO: ')
    local new_todo = { done = false, title = title }
    table.insert(json_data[key], new_todo)

    write_todo_file_contents(json_data)
end

return M
