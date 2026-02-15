vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = '[F5] Toggle undo tree' })

-- Settings and stuff
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.updatetime = 50
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.conceallevel = 2

-- Actual remaps
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'drop overwrite into void register' })
vim.keymap.set('n', '<leader>rm', function()
  local file = vim.fn.expand '%:p'
  vim.fn.system { 'rm', file }
  vim.cmd 'bdelete'
end, { desc = '[R]e[M]ove current file' })
