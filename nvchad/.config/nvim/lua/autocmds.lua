require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = { "http", "rest" },
  callback = function()
    vim.opt_local.commentstring = "# %s"
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.bo.swapfile = false
  end,
})
