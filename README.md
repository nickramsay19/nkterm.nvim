# nkterm.nvim
> Nicholas Ramsay

A very uncomplicated terminal for nvim.

## Usage
```
:NkTermToggle
```

To bind a key to `:NkTermToggle` in both normal and terminal mode, use the following:
```lua
vim.keymap.set({'n', 't'}, '<C-,>', [[<C-\><C-n>:NkTermToggle<CR>]], { noremap = true })
```

## Installation

### Packer
```lua
use 'nickramsay19/nkterm.nvim'
```
