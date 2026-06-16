require("nvim-treesitter").setup({
  auto_install = true, -- autoinstall languages that are not installed yet
  highlight = {
    enable = true
  },
  ensure_installed = {
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "markdown",
    "markdown_inline",
    "php",
    "prisma",
    "vue",
    "dart",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  folding = {
    enable = true
  }
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.prisma", "*.lua", "*.html", "*.css", "*.js", "*.ts", "*.tsx", "*.md", "*.php", "*.vue" },
  callback = function()
    vim.treesitter.start()
  end,
})
