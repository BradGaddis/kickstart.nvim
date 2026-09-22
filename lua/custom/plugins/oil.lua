return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name)
        -- for godot projects ignore *.uid files
        local is_godot_project = vim.fs.root(0, { 'project.godot' }) ~= nil
        if not is_godot_project then return false end
        -- ignore *.uid files introduced in godot 4.4
        if vim.endswith(name, '.uid') then return true end
        -- ignore server.pipe file
        if name == 'server.pipe' then return true end
        return false
      end,
    },
  },
  -- Optional dependencies
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}