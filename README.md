<div align="center">

# Quick TODO

Create a simple TODO list for your project quickly.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.6+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

</div>

## Description

This plugin for [Neovim](https://neovim.io) allows you to quickly manage your tasks by creating a `todo.txt` file in your current working directory. You can then edit the TODO items without having to open the file by using the specially designed popup window.

## Features

- Creates a `todo.txt` file automatically in your current working directory. (Fixed path is also possible)
- Edit the TODO items without having to open the file.
- Simple and intuitive interface.
- Toggle a TODO item as done [x] or not done [ ] with Return key.
- Use fixed global path for the TODO file.

## Usage

```lua
local todo = require('quick-todo')
todo.setup(opts) -- Setup the plugin with optional arguments
todo.open_ui() -- Open the popup UI using default path
todo.open_ui(path) -- Open the popup UI using fixed path
todo.close_ui() -- Close the popup UI
todo.toggle_ui() -- Toggle the popup UI
todo.add() -- Add TODO entry into the default todo file
todo.add(path) -- Add TODO entry into the defined todo file
```

### Installation

Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'nvim-lua/plenary.nvim' " Required dependency
Plug 'jkallio/quick-todo.nvim'
```

Using [packer](https://github.com/wbthomason/packer.nvim)
```lua
use {
  'jkallio/quick-todo.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
```

Using [lazy](https://github.com/folke/lazy.nvim)
```lua
return {
    {
    'jkallio/quick-todo.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' }
    }
}
```

### Configuration

e.g. Using [lazy](https://github.com/folke/lazy.nvim):
```lua
return {
  'jkallio/quick-todo.nvim',
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local todo = require('quick-todo')
    todo.setup({
        -- Path to the todo file -- If not set it will be created in the current working directory.
        todo_path = '/path/to/fixed/global/todo.txt',
        -- Popup window width in percentage
        width = '50', 
    })

    vim.keymap.set('n', '<leader>ta', todo.add, { desc = 'quick-todo: Add new entry' })
    vim.keymap.set('n', '<leader>tt', todo.toggle_ui, { desc = 'quick-todo: toggle popup UI' })
    vim.keymap.set('n', '<leader>tg', function() todo.open_ui('/path/to/global/todo/file.txt') end, { desc = 'quick-todo: Open global TODO' })
  end
}
```
