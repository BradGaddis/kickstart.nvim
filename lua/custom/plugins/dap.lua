return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'leoluz/nvim-dap-go',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'williamboman/mason.nvim',
    'nvim-neotest/nvim-nio',
    'jay-babu/mason-nvim-dap.nvim',
    'Jorenar/nvim-dap-disasm',
    'neoguri7/dap-lowlevel.nvim',
  },
  config = function()
    local dap = require 'dap'
    -- require('dap.ext.vscode').load_launchjs = function() end
    local ui = require 'dapui'

    require('dapui').setup {
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.1 },
            { id = 'stacks', size = 0.2 },
            { id = 'watches', size = 0.15 },
          },
          size = 0.33,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 0.35 },
            { id = 'console', size = 0.15 },
            { id = 'disassembly', size = 0.5 },
          },
          size = 0.25,
          position = 'bottom',
        },
      },
    }

    -- Register the disassembly view as a dap-ui element (shows current
    -- instruction with winbar buttons for instruction-level stepping).
    require('dap-disasm').setup { dapui_register = true }

    -- Registers/memory views (separate floating windows).
    require('dap_lowlevel').setup()

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
    end, { desc = 'Debug Wine winedbg launch' })
    vim.keymap.set('n', '<F1>', function()
      if get_godot_root() then
        require('dap').run(gdconfig)
      else
        print 'Not a Godot project'
      end
    end, { desc = 'Debug Launch Godot' })
    vim.keymap.set('n', '<F2>', dap.repl.open, { desc = 'Open DAP [R]epl' })
    vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Debug step over' })
    vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug step out' })
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug continue' })
    vim.keymap.set('n', '<F6>', dap.step_into, { desc = 'Debug step into' })
    vim.keymap.set('n', '<F7>', dap.step_back, { desc = 'Debug step back' })
    vim.keymap.set('n', '<F8>', dap.terminate, { desc = 'Debug terminate' })
    vim.keymap.set('n', '<F9>', dap.restart, { desc = 'Debug restart' })
    vim.keymap.set('n', '<LEADER>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
    vim.keymap.set('n', '<LEADER>dc', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '[D]ebug [C]onditional breakpoint' })
    vim.keymap.set('n', '<LEADER>dl', function()
      dap.toggle_breakpoint(nil, vim.fn.input 'Log point message: ')
    end, { desc = '[D]ebug [L]og point' })
    vim.keymap.set('n', '<LEADER>dr', dap.run_to_cursor, { desc = '[D]ebug [R]un to cursor' })
    vim.keymap.set('n', '<LEADER>dL', dap.run_last, { desc = '[D]ebug run [L]ast config' })
    vim.keymap.set('n', '<LEADER>dp', dap.pause, { desc = '[D]ebug [P]ause' })
    vim.keymap.set('n', '<LEADER>dd', dap.disconnect, { desc = '[D]ebug [D]isconnect' })
    vim.keymap.set('n', '<LEADER>dk', dap.up, { desc = '[D]ebug stack u[p]' })
    vim.keymap.set('n', '<LEADER>dj', dap.down, { desc = '[D]ebug stack [d]own' })
    vim.keymap.set('n', '<LEADER>du', function() ui.toggle() end, { desc = '[D]ebug [U]I toggle' })
    vim.keymap.set({ 'n', 'v' }, '<LEADER>de', function()
      require('dap.ui.widgets').hover()
    end, { desc = '[D]ebug [E]valuate under cursor' })
    vim.keymap.set('n', '<LEADER>da', function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'dap-disassembly' then
          return vim.api.nvim_win_close(win, true)
        end
      end
      vim.cmd 'DapDisasm'
    end, { desc = '[D]ebug [A]ssembly toggle' })
    vim.keymap.set('n', '<LEADER>dR', function() vim.cmd.DapLowlevelRegs() end, { desc = '[D]ebug [R]egisters' })
    vim.keymap.set('n', '<LEADER>dm', function() vim.cmd.DapLowlevelMemory() end, { desc = '[D]ebug [M]emory' })
    vim.keymap.set('n', '<LEADER>ds', function() ui.float_element 'scopes' end, { desc = '[D]ebug float [S]copes' })
    vim.keymap.set('n', '<LEADER>dt', function() ui.float_element 'breakpoints' end, { desc = '[D]ebug float [B]reakpoints' })
    vim.keymap.set('n', '<LEADER>dw', function() ui.float_element 'watches' end, { desc = '[D]ebug float [W]atches' })

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
