require 'brad.helpers'

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local file = vim.fn.findfile('Makefile', '.;') or vim.fn.findfile('build.sh', '.;') or vim.fn.findfile('project.godot', '.;')
    if file == '' then
      return
    end
    local root = vim.fn.fnamemodify(file, ':h')
    local base = vim.fn.fnamemodify(file, ':t')
    vim.keymap.set('n', '<M-m>', function()
      vim.cmd ':wa'
      vim.cmd('lcd ' .. root)
      if base == 'Makefile' then
        vim.notify('Running make debug_run', vim.log.levels.INFO)
        vim.cmd '!make debug_run'
        return
      end
      if base == 'build.sh' then
        vim.notify('Building C project', vim.log.levels.INFO)
        vim.cmd '!./build.sh'
        return
      end
      if Get_Godot_Root() then
        vim.notify('Building Godot project', vim.log.levels.INFO)
        vim.cmd '!scons'
      end
    end, { buffer = true, silent = false, desc = 'Build project (make/build.sh/scons)' })
  end,
})