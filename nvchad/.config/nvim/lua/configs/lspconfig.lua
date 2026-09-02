require("nvchad.configs.lspconfig").defaults()

local map = vim.keymap.set

local servers = {
	"html",
	"csharp_ls",
	"cssls",
	"ts_ls",
	"gopls",
	-- "tailwindcss",
	-- "vtsls",
	-- "volar",
	"clangd",
	"intelephense",
	"prismals",
	"bashls",
	-- "eslint",
	"lua_ls",
	-- "elixirls",
	"jsonls",
	"rust_analyzer",
	-- "angularls",
	"pyright",
	-- "basedpyright",
	-- "dartls",
	"biome",
	-- "svelte"
	-- "kotlin_language_server"
}

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		-- vim.keymap.set
		map("n", "<leader>dh", function()
			vim.diagnostic.goto_prev()
		end)
		map("n", "<leader>dl", function()
			vim.diagnostic.goto_next()
		end)
		-- Prefer biome when attached; fall back to other LSPs (e.g. ts_ls) otherwise.
		map("n", "<leader>lf", function()
			local bufnr = vim.api.nvim_get_current_buf()
			local has_biome = false

			for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
				if client.name == "biome" then
					has_biome = true
					break
				end
			end

			vim.lsp.buf.format {
				async = true,
				filter = function(client)
					if has_biome then
						return client.name == "biome"
					end
					-- biome not attached: allow ts_ls (and any other formatters)
					return true
				end,
			}
		end)
		map("n", "gd", function()
			require("telescope.builtin").lsp_definitions()
		end)
		map("n", "<C-S-o>", function()
			require("telescope.builtin").lsp_document_symbols()
		end)
		map({ "n", "v" }, "<leader>ca", function()
			require('tiny-code-action').code_action()
		end)

		pcall(vim.keymap.del, "n", "K", { buf = args.buf })

		map("n", "K", ":Lspsaga hover_doc<cr>")
		map("n", "<leader>ra", ":Lspsaga rename<cr>")
	end,
})

-- read :h vim.lsp.config for changing options of lsp servers
