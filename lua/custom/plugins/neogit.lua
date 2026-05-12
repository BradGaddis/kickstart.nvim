return {

  'NeogitOrg/neogit',
  cmd = 'Neogit',
  config = function()
    require('neogit').setup {
      integrations = { snacks = true },
      disable_signs = false,
    }
  end,
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/snacks.nvim',
  },
}
