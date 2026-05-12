require 'brad.config'
require 'brad.colorimprovements'
require 'brad.build'
--require 'brad.lsp-config'

--require 'brad.launchgodot'
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ 'CursorHold', 'FocusGained', 'BufEnter', 'TermClose' }, {
  callback = function() vim.cmd 'silent! checktime' end,
})
