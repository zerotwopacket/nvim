return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'gruvbox-material'
		end,
	},
	{
		-- Theme inspired by Atom
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme 'onedark'
		end,
	},
}
