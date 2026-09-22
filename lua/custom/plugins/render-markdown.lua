return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  keys = {
    { '<leader>mp', '<cmd>RenderMarkdown toggle<CR>', desc = 'Toggle Markdown rendering' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-web-devicons' },
  opts = {},
}