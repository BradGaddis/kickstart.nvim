return {
  {
    'andymass/vim-matchup',
    event = { 'BufReadPre', 'BufNewFile' },
    ft = { 'python', 'gd', 'gdscript' },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      vim.g.matchup_matchparen_deferred = 1
    end,
  },
}
