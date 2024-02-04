local home = os.getenv "HOME"
local jdtls_config_loc = home .. '/OpenSource/jdtls/config_linux'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/OpenSource/jdtls/workspace/' .. project_name
local jdtls_launcher = vim.fn.glob(home .. '/OpenSource/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')

local on_attach = function(client, bufnr)
  local dap = require 'dap'
  local dapui = require 'dapui'
  -- Basic debugging keymaps, feel free to change to your liking!
  vim.keymap.set('n', '<leader>db', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })

  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end



  -- local find_in_java_source_dir = function()
  --   local opts = require 'telescope.themes'.get_ivy()
  --   opts.search_dirs = {
  --     'src/main/java'
  --   }
  --   require 'telescope.builtin'.find_files(opts)
  -- end



  nmap('<leader>lt', function()
    require 'jdtls'.test_nearest_method()
  end, 'Test nearest')
  nmap('<leader>lc', function()
    require 'jdtls'.test_class()
  end, 'Test class')



  nmap('<leader>sk', function()
    local opts = require 'telescope.themes'.get_ivy()
    opts.search_dirs = {
      'src/main/java'
    }
    require 'telescope.builtin'.find_files(opts)
  end, 'Find in source dir')

  nmap('<leader>sj', function()
    local opts = require 'telescope.themes'.get_ivy()
    opts.search_dirs = {
      'src/test/java'
    }
    require 'telescope.builtin'.find_files(opts)
  end, 'Find in test dir')

  nmap('<leader>si', function()
    local opts = require 'telescope.themes'.get_ivy()
    opts.search_dirs = {
      'src/main/resources'
    }
    require 'telescope.builtin'.find_files(opts)
  end, 'Find in  resources dir')

  nmap('<leader>su', function()
    local opts = require 'telescope.themes'.get_ivy()
    opts.search_dirs = {
      'src/test/resources'
    }
    require 'telescope.builtin'.find_files(opts)
  end, 'Find in test resources dir')


  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  -- Dap UI setup
  -- For more information, see |:help nvim-dap-ui|
  dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close
end

local lombok_location = home .. "/OpenSource/lombok.jar"

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. lombok_location,
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    jdtls_launcher,
    '-configuration',
    jdtls_config_loc,
    '-data',
    workspace_dir
  },
  on_attach = on_attach,
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {
      completion = {
        importOrder = {
          'java',
          'javax',
          'com',
          'org'
        }
      }
    },
  }
}

local java_debug_path = home ..
    '/OpenSource/java-debug/' .. 'com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
local java_test_path = home .. '/OpenSource/vscode-java-test' .. '/server/*.jar'
local bundles = {
  vim.fn.glob(java_debug_path, 1)
}

config['init_options'] = {
  bundles = bundles
}

vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path, false), "\n"))

require('jdtls').start_or_attach(config)
