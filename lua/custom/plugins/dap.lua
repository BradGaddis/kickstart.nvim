return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'leoluz/nvim-dap-go',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'williamboman/mason.nvim',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require 'dap'
    -- require('dap.ext.vscode').load_launchjs = function() end
    local ui = require 'dapui'
    require('dapui').setup()

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

    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb-multiarch',
      args = { '-i', 'dap', '-ex', 'target remote localhost:1234' }, -- Remove -ex continue
      options = {
        initialize_timeout_sec = 30,
        disconnect_timeout_sec = 30,
        terminate_timeout_sec = 30,
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
      local root = get_godot_root()
      if root then
        require('dap').run(gdconfig)
      else
        require('dap').continue()
      end
    end)
    vim.keymap.set('n', '<F3>', dap.step_over)
    vim.keymap.set('n', '<F4>', dap.step_out)
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F6>', dap.step_into)
    vim.keymap.set('n', '<F7>', dap.step_back)
    vim.keymap.set('n', '<F8>', dap.terminate)
    vim.keymap.set('n', '<F9>', dap.reverse_continue)
    vim.keymap.set('n', '<LEADER>bs', dap.set_breakpoint, { desc = '[B]reakpoint [S]et' })
    vim.keymap.set('n', '<LEADER>bt', dap.toggle_breakpoint, { desc = '[B]reakpoint [T]oggle' })
    vim.keymap.set('n', '<LEADER>bl', dap.toggle_breakpoint, { desc = '[B]reakpoint [L]ist' })
    vim.keymap.set('n', '<LEADER>bc', dap.toggle_breakpoint, { desc = '[B]reakpoint [C]lear' })
    -- vim.keymap.set('n', '<LEADER>br', dap.toggle_breakpoint, { desc = '[B]reakpoint [T]oggle' })
    vim.keymap.set('n', '<LEADER>bb', dap.toggle_breakpoint, { desc = 'Quick breakpoint toggle. Can free the other keymap if desired.' })

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
