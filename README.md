<div align="center">

# Quick TODO

Create a simple TODO list for your project quickly.


[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.6+-green.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

</div>

## Description

This plugin for [Neovim](https://neovim.io) allows you to quickly manage your tasks by creating a `todo.txt` file in your current working directory. You can then edit the TODO items without having to open the file by using the specially designed popup window.

## Features

- Creates a `todo.txt` file automatically in your current working directory. (Path is also configurable)
- Allows you to edit the TODO items without having to open the file.
- Simple and intuitive interface.
- Toggle a TODO item as done [x] or not done [ ] with a single key.

## Usage

```
lua require('quick-todo').setup() -- Setup the plugin
lua require('quick-todo').open_ui() -- Open the popup UI
lua require('quick-todo').close_ui() -- Close the popup UI
lua require('quick-todo').toggle_ui() -- Toggle the popup UI
lua require('quick-todo').toggle_todo_done() -- Toggle the TODO item as done or not done
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
    {
    'jkallio/quick-todo.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' }
    }
}
```

### Configuration

TODO:
