return {
	default_env = "dev",
	environment_scope = "b",
	ui = {
		display_mode = "split",
		split_direction = "right",
		default_view = "verbose",
		winbar = false,
		default_winbar_panes = { "verbose" },
		scratchpad_default_contents = {
			"@token={{API_TOKEN}}",
			"",
			"# @name example",
			"GET {{API_URL}}/get HTTP/1.1",
			"accept: application/json",
			"authorization: Bearer {{API_TOKEN}}",
			"",
		},
	},
	global_keymaps = {
		["Send request"] = {
			"<C-CR>",
			function()
				require("kulala").run()
			end,
			mode = { "n", "v", "i" },
			ft = { "http", "rest" },
		},
		["Send all requests"] = {
			"<leader>Ra",
			function()
				require("kulala").run_all()
			end,
			mode = { "n", "v" },
			ft = { "http", "rest" },
		},
		["Replay the last request"] = {
			"<leader>Rr",
			function()
				require("kulala").replay()
			end,
			ft = { "http", "rest" },
		},
		["Open scratchpad"] = {
			"<leader>Rb",
			function()
				require("kulala").scratchpad()
			end,
		},
		["Open response"] = {
			"<leader>Ro",
			function()
				require("kulala").open()
			end,
			ft = { "http", "rest" },
		},
		["Select environment"] = {
			"<leader>Re",
			function()
				require("kulala").set_selected_env()
			end,
			ft = { "http", "rest" },
		},
		["Toggle headers/body"] = false,
	},
	kulala_keymaps = {
		["Previous tab"] = false,
		["Next tab"] = false,
		["Show headers"] = false,
		["Show body"] = false,
		["Show headers and body"] = false,
		["Show verbose"] = false,
		["Show script output"] = false,
		["Show stats"] = false,
		["Show report"] = false,
		["Show filter"] = false,
	},
	global_keymaps_prefix = "<leader>R",
	kulala_keymaps_prefix = "",
	lsp = {
		enable = true,
		keymaps = false,
	},
}
