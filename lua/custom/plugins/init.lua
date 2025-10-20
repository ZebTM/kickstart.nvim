-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = true,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'leoluz/nvim-dap-go',
      'williambomoan/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('dapui').setup()
      require('dap-go').setup()

      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>gb', dap.run_to_cursor)

      -- Eval var under cursor
      vim.keymap.set('n', '<space>?', function()
        require('dapui').eval(nil, { enter = true })
      end)

      vim.keymap.set('n', '<F1>', dap.continue)
      vim.keymap.set('n', '<F2>', dap.step_into)
      vim.keymap.set('n', '<F3>', dap.step_over)
      vim.keymap.set('n', '<F4>', dap.step_out)
      vim.keymap.set('n', '<F5>', dap.step_back)
      vim.keymap.set('n', '<F6>', dap.restart)

      -- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#dotnet
      local dotnet_debugget = '/home/zacharybrown/debugProtocols/netcoredbg/netcoredbg'

      -- C#
      dap.adapters.coreclr = {
        type = 'executable',
        command = dotnet_debugget,
        args = { '--interpreter=vscode' },
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'launch - netcorebg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
        },
      }
      -- Launch Json Support
      require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs' }, ['pwa-node'] = { 'typescript', 'javascript', 'svelte' } })
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }

      require('dap').configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
      }

      dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { 'js-debug-adapter' },
      }

      dap.adapters.firefox = {
        type = 'executable',
        command = 'node',
        args = { '/home/zacharybrown/debugProtocols/vscode-firefox-debug/dist/adapter.bundle.js' },
      }

      dap.configurations.typescript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Node app',
          address = 'localhost',
          port = 5173,
          cwd = '${workspaceFolder}',
          restart = true,
        },
        {
          name = 'Debug with Firefox',
          type = 'firefox',
          request = 'launch',
          reAttach = true,
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}/src',
          firefoxExecutable = '/usr/bin/firefox',
        },
      }
    end,
  },
  {
    'nvim-neotest/nvim-nio',
  },
  {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  },
}
