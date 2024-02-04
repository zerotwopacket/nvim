return {
	{
		'williamboman/mason.nvim',
	},
	{
		'williamboman/mason-lspconfig.nvim',
		config = function()
			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end

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
			end

			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			require('mason').setup()
			require('mason-lspconfig').setup()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. They will be passed to
			--  the `settings` field of the server config. You must look up that documentation yourself.
			--
			--  If you want to override the default filetypes that your language server will attach to you can
			--  define the property 'filetypes' to the map in question.
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				tsserver = {},
				html = { filetypes = { 'html', 'twig', 'hbs' } },
				cssls = { filetypes = { 'css', 'scss', 'less' } },
				emmet_ls = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
				yamlls = {
				},
				ansiblels = {
				},
			}
			--
			-- Setup neovim lua configuration
			require('neodev').setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require 'mason-lspconfig'

			mason_lspconfig.setup {
				ensure_installed = vim.tbl_keys(servers),
			}

			mason_lspconfig.setup_handlers {
				function(server_name)
					require('lspconfig')[server_name].setup {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					}
				end,
			}
		end
	},
	{
		'folke/neodev.nvim',
	},
	{
		{ 'j-hui/fidget.nvim', opts = {} },
	},
	{
		'neovim/nvim-lspconfig',
	},
	{
		'mfussenegger/nvim-jdtls'
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			-- Creates a beautiful debugger UI
			'rcarriga/nvim-dap-ui',

			-- Installs the debug adapters for you
			-- 'williamboman/mason.nvim',
			-- 'jay-babu/mason-nvim-dap.nvim',

			-- Add your own debuggers here
			-- 'leoluz/nvim-dap-go',
		},
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'
			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
			vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
			vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
			vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
			vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
			vim.keymap.set('n', '<leader>B', function()
				dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
			end, { desc = 'Debug: Set Breakpoint' })

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
	}
}
