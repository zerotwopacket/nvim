-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	"numToStr/FTerm.nvim",
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
		config = function()
			vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
			vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
		end
	},
	{
		dir = "~/Lab/nvim-plugins/scratch-buffer/",
		name = "scratch-buffer",
		config = function()
			--			require("scratch-buffer").setup()
		end
	},
	{
		"phaazon/hop.nvim",
		branch = "v2",
		config = function()
			local hop = require "hop"
			hop.setup { keys = "etovxqpdygfblzhckisuran" }
			vim.keymap.set('n', '<Leader>jw', '<CMD>HopWord<CR>')
			vim.keymap.set('n', '<Leader>jf', '<CMD>HopChar1<CR>')
		end
	}
}
