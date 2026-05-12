vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'G', 'Gzz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<M-j>', 'i<CR><Esc>', { desc = 'split line' })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'drop overwrite into void register' })
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<C-:>', ':w', { desc = 'Save file' })
vim.keymap.set('n', '<leader>rm', function()
  local file = vim.fn.expand '%:p'
  vim.fn.system { 'rm', file }
  vim.cmd 'bdelete'
end, { desc = '[R]e[M]ove current file' })
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = '[F5] Toggle undo tree' })
local function goto_next_prioritized()
  local diagnostics = vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.ERROR } })
  if #diagnostics > 0 then
    vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
  else
    vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN }
  end
end

local function goto_prev_prioritized()
  local diagnostics = vim.diagnostic.get(0, { severity = { vim.diagnostic.severity.ERROR } })
  if #diagnostics > 0 then
    vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
  else
    vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN }
  end
end

-- Keymaps
vim.keymap.set('n', '<M-n>', goto_next_prioritized)
vim.keymap.set('n', '<M-p>', goto_prev_prioritized)

vim.keymap.set(
  'n',
  '<leader>kw',
  ':!pkill -9 -f "winedbg|windebug\\\\.exe|start\\\\.exe|services\\\\.exe|winedevice\\\\.exe|explorer\\\\.exe|plugplay\\\\.exe|svchost\\\\.exe|rpcss\\\\.exe|conhost\\\\.exe"<CR>',
  { silent = false }
)
