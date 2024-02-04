return {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	config = function()
		require "neorg".setup {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							work = "~/notes/work",
							home = "~/notes/home",
						}
					}
				}
			}
		}
	end
}
