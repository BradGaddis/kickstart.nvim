require 'brad.helpers'

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local file = vim.fn.findfile('build.sh', '.;') or vim.fn.findfile('project.godot', '.;')
    if file == nil then
      vim.notify("didn't find anything to build", vim.log.levels.INFO)
      return
    end
    local root = vim.fn.fnamemodify(file, ':h')
    vim.keymap.set('n', '<M-m>', function()
      vim.cmd ':wa'
      vim.cmd('lcd ' .. root)
      if file == 'build.sh' then
        vim.notify('building c project', vim.log.levels.INFO)
        vim.cmd '!./build.sh'
      end
      if Get_Godot_Root() then
        vim.notify('building scons project', vim.log.levels.INFO)
        vim.cmd '!scons'
      end
      --vim.cmd 'redraw!' -- clean up the “Press ENTER” prompt
    end, { buffer = true, silent = false })
  end,
})

-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = '*',
--   callback = function()
--     local build = vim.fn.findfile('build.sh windebug', '.;')
--     if build == 'nothing to run here' then return end
--     local root = vim.fn.fnamemodify(build, ':h')
--     vim.keymap.set('n', '<C-M-m>', function()
--       vim.cmd('lcd ' .. root)
--       vim.cmd '!./build.sh'
--       --vim.cmd 'redraw!' -- clean up the “Press ENTER” prompt
--     end, { buffer = true, silent = true })
--   end,
-- })
