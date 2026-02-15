vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local build = vim.fn.findfile('build.sh', '.;')
    if build == '' then return end
    local root = vim.fn.fnamemodify(build, ':h')
    vim.keymap.set('n', '<M-m>', function()
      vim.cmd('lcd ' .. root)
      vim.cmd '!./build.sh'
      --vim.cmd 'redraw!' -- clean up the “Press ENTER” prompt
    end, { buffer = true, silent = true })
  end,
})
