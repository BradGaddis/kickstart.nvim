local lspconfig = require 'lspconfig'
local util = lspconfig.util

-- Function to start Godot editor if LSP fails
local function start_godot_lsp_fallback()
  local root_dir = util.root_pattern 'project.godot'(vim.fn.getcwd())

  if not root_dir then
    print 'Not inside a Godot project.'
    return
  end

  -- Check if something is already listening on port 6005
  local handle = io.popen 'lsof -i :6005'
  local result = handle:read '*a'
  handle:close()

  if result ~= '' then
    print 'Godot LSP already running.'
    return
  end

  print 'Starting Godot editor for LSP...'

  -- Start Godot in background
  vim.fn.jobstart({ 'godot', '-e', '--path', root_dir }, {
    detach = true,
  })
end

start_godot_lsp_fallback()
