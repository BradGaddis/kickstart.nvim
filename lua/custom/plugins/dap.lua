return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'leoluz/nvim-dap-go',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'williamboman/mason.nvim',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    -- require('dap.ext.vscode').load_launchjs = function() end
    local ui = require 'dapui'
    require('dapui').setup()

    -- Install LLDB (codelldb) debug adapter for Odin. Register it as `lldb`
    -- so the existing `type = 'lldb'` launch configs keep working.
    require('mason-nvim-dap').setup {
      ensure_installed = { 'codelldb' },
      automatic_installation = true,
    }

    local lldb_path = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb'
    dap.adapters.codelldb = {
      type = 'executable',
      command = lldb_path,
      name = 'codelldb',
    }
    dap.adapters.lldb = {
      type = 'executable',
      command = lldb_path,
      name = 'lldb',
    }

    local function get_godot_root() return vim.fs.root(0, { 'project.godot' }) end

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
    }

    dap.adapters.godot = {
      type = 'server',
      host = '127.0.0.1',
      port = 6006,
    }

    dap.configurations.cpp = {
      {
        name = 'Launch with gdb',
        type = 'cppdbg',
        request = 'launch',
        -- program = vim.fn.getcwd() .. '/build/debug',
        program = vim.fn.getcwd() .. '/bin/testbed',
        cwd = '${workspaceFolder}',
        command = ':w',
        stopAtEntry = false,
        MIMode = 'gdb',
        miDebuggerPath = '/usr/bin/gdb', -- change if needed
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'Enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
    }

    local gdconfig = {
      type = 'godot',
      request = 'launch',
      name = 'Launch Godot',
      project = function() return get_godot_root() end,
      launch_scene = true,
    }

    dap.configurations.gdscript = { gdconfig }

    dap.set_log_level 'DEBUG'

    dap.configurations.odin = {
      {
        name = 'Launch Odin',
        type = 'lldb',
        request = 'launch',
        program = function()
          local out = vim.fn.getcwd() .. '/bin/debug'
          local result = vim.fn.system 'make debug_build'
          if vim.v.shell_error ~= 0 then
            print('Odin build failed:\n' .. result)
            return dap.ABORT
          end
          return out
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
        console = 'integratedTerminal',
      },
    }

    -- F12 stays the same (starts winedbg + launches DAP)
    vim.keymap.set('n', '<F12>', function()
      vim.fn.system 'pkill -f winedbg'
      vim.fn.system('winedbg --gdb --port 1234 --no-start ' .. vim.fn.getcwd() .. '/build/debug.exe &')
      vim.wait(3000) -- Wait 3s for winedbg to fully start
      dap.run {
        type = 'gdb',
        name = 'Wine via winedbg',
        request = 'launch',
        program = vim.fn.getcwd() .. '/build/debug.exe',
        cwd = vim.fn.getcwd(),
        setupCommands = {
          {
            text = '-exec-continue', -- Continue AFTER DAP is connected
            ignoreFailures = false,
          },
        },
      }
    end)
    vim.keymap.set('n', '<F1>', function()
      if get_godot_root() then
        require('dap').run(gdconfig)
      else
        print 'Not a Godot project'
      end
    end)
    vim.keymap.set('n', '<F2>', dap.repl.open, { desc = 'Open DAP [R]epl' })
    vim.keymap.set('n', '<F3>', dap.step_over)
    vim.keymap.set('n', '<F4>', dap.step_out)
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F6>', dap.step_into)
    vim.keymap.set('n', '<F8>', dap.terminate)
    vim.keymap.set('n', '<F9>', dap.restart)
    vim.keymap.set('n', '<LEADER>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
    vim.keymap.set('n', '<LEADER>dc', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[D]ebug [C]onditional breakpoint' })
    vim.keymap.set('n', '<LEADER>dl', function()
      dap.toggle_breakpoint(nil, vim.fn.input 'Log point message: ')
    end, { desc = '[D]ebug [L]og point' })
    vim.keymap.set('n', '<LEADER>dr', dap.run_to_cursor, { desc = '[D]ebug [R]un to cursor' })
    vim.keymap.set('n', '<LEADER>du', function() ui.toggle() end, { desc = '[D]ebug [U]I toggle' })
    vim.keymap.set({ 'n', 'v' }, '<LEADER>de', function()
      require('dap.ui.widgets').hover()
    end, { desc = '[D]ebug [E]valuate under cursor' })

    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end
    dap.listeners.after.terminateThreads.dapui_config = function() ui.close() end
    dap.listeners.after.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.after.event_exited.dapui_config = function() ui.close() end
    dap.listeners.after.event_stopped.dapui_config = function(_, _) ui.open() end
    dap.listeners.after.disconnect.dapui_config = function() ui.close() end
    dap.listeners.after.terminate.dapui_config = function() ui.close() end
  end,
}
