-- Explicit blink.cmp opts on top of nvchad.blink.lazyspec.
-- Re-diff against require("nvchad.blink.config") after NvChad/ui updates.

dofile(vim.g.base46_cache .. "blink")

return {
	snippets = { preset = "luasnip" },
	cmdline = { enabled = true },
	appearance = { nerd_font_variant = "normal" },
	fuzzy = { implementation = "prefer_rust" },
	sources = { default = { "lsp", "snippets", "buffer", "path" } },

	keymap = {
		preset = "default",
		-- Accept with Enter; <C-y> remains from the default preset as a VM-safe accept.
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
	},

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = { border = "single" },
		},
		menu = require("nvchad.blink").menu,
	},
}
