require 'brad.config'
require 'brad.colorimprovements'
require 'brad.build'
--require 'brad.lsp-config'

--require 'brad.launchgodot'
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ 'CursorHold', 'FocusGained', 'BufEnter', 'TermClose' }, {
  callback = function() vim.cmd 'silent! checktime' end,
})

-- vim.keymap.set('n', '<M-Tab>', '<cmd>NeoCodeium toggle<cr>', { desc = 'Toggle NeoCodeium' })
--
-- vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
