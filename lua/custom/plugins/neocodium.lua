-- add this to the file where you setup your other plugins:
return {
  'monkoose/neocodeium',
  event = 'VeryLazy',
  config = function()
    local neocodeium = require 'neocodeium'
    neocodeium.setup()
    vim.keymap.set('i', '<A-f>', neocodeium.accept)
    vim.keymap.set({ 'n', 'i' }, '<A-g>', '<cmd>NeoCodeium toggle<cr>', { desc = 'Toggle NeoCodeium' })
  end,
}
