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
	}
}
