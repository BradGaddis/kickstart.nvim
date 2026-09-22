vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', 'G', 'Gzz', { desc = 'Go to end and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search match centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Prev search match centered' })
vim.keymap.set('n', '<M-j>', 'i<CR><Esc>', { desc = 'split line' })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'drop overwrite into void register' })
vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open file explorer (Oil)' })
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
vim.keymap.set('n', '<M-n>', goto_next_prioritized, { desc = 'Next diagnostic (error/warn)' })
vim.keymap.set('n', '<M-p>', goto_prev_prioritized, { desc = 'Prev diagnostic (error/warn)' })

vim.keymap.set(
  'n',
  '<leader>kw',
  ':!pkill -9 -f "winedbg|windebug\\\\.exe|start\\\\.exe|services\\\\.exe|winedevice\\\\.exe|explorer\\\\.exe|plugplay\\\\.exe|svchost\\\\.exe|rpcss\\\\.exe|conhost\\\\.exe"<CR>',
  { silent = false, desc = 'Kill winedbg/wine processes' }
)

vim.keymap.set('n', '<leader>as', '<cmd>ASToggle<CR>', { desc = 'Toggle autosave' })
-- vim.keymap.set('n', '<leader>of', '<cmd>ObsidianFollowLink<CR>', { desc = 'Obsidian Follow Link' })
vim.keymap.set('n', '<leader>o', '<cmd>Obsidian<CR>', { desc = 'Obsidian Commands' })

-- Tab navigation
vim.keymap.set('n', '<leader>Tn', '<cmd>tabn<CR>', { desc = '[T]ab [N]ext' })
vim.keymap.set('n', '<leader>Tp', '<cmd>tabp<CR>', { desc = '[T]ab [P]rev' })
vim.keymap.set('n', '<leader>To', '<cmd>tabnew<CR>', { desc = '[T]ab [O]pen' })
vim.keymap.set('n', '<leader>Tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })
vim.keymap.set('n', '<leader>Tm', '<cmd>tabm<CR>', { desc = '[T]ab [M]ove' })

vim.keymap.set('n', '<leader>1', '1gt', { desc = 'Go to tab 1' })
vim.keymap.set('n', '<leader>2', '2gt', { desc = 'Go to tab 2' })
vim.keymap.set('n', '<leader>3', '3gt', { desc = 'Go to tab 3' })
vim.keymap.set('n', '<leader>4', '4gt', { desc = 'Go to tab 4' })
vim.keymap.set('n', '<leader>5', '5gt', { desc = 'Go to tab 5' })
vim.keymap.set('n', '<leader>6', '6gt', { desc = 'Go to tab 6' })
vim.keymap.set('n', '<leader>7', '7gt', { desc = 'Go to tab 7' })
vim.keymap.set('n', '<leader>8', '8gt', { desc = 'Go to tab 8' })
vim.keymap.set('n', '<leader>9', '9gt', { desc = 'Go to tab 9' })
