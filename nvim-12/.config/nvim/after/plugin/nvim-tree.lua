local map = vim.keymap.set

require("nvim-tree").setup()

map("n", "<leader>e", ":NvimTreeToggle<cr>", { desc = "Nvimtree: Toggle nvim-tree" })
map("n", "<leader>o", ":NvimTreeFocus<cr>", { desc = "Nvimtree: Focus nvim-tree" })
