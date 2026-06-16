local map = vim.keymap.set
local del_map = vim.keymap.del
local lsp_servers = {
  lua_ls = {
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) }, },
  },
  html = {},
  intelephense = {},
  jsonls = {},
  prismals = {},
  pyright = {},
  cssls = {},
  ts_ls = {}
}

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})

for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,

    on_attach = function(_, bufnr)
      local opts = {
        silent = true
      }

      map("n", "<leader>dh", function()
        vim.diagnostic.jump({ count = -1 })
      end, opts)
      map("n", "<leader>dl", function()
        vim.diagnostic.jump({ count = 1 })
      end, opts)
      map("n", "<leader>lf", function()
        vim.lsp.buf.format { async = true }
      end, opts)
      map("n", "gd", function()
        require("telescope.builtin").lsp_definitions()
      end, opts)
      map("n", "<leader>fo", function()
        require("telescope.builtin").lsp_document_symbols()
      end, opts)

      map({ "n", "v" }, "<leader>ca", ":Lspsaga code_action<cr>", opts)

      pcall(del_map, "n", "K", { buf = bufnr, silent = true })

      map("n", "K", ":Lspsaga hover_doc<cr>", opts)
      map("n", "<leader>ra", ":Lspsaga rename<cr>", opts)
    end,
  })
end
