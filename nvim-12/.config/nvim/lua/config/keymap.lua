local map = vim.keymap.set

map("n", "<ESC>", ":nohlsearch<cr>", { desc = "General: Clear highlight search", nowait = true })
map("n", "<A-j>", "<C-d>zz", { desc = "General: Scroll down + center screen", nowait = true })
map("n", "<A-k>", "<C-u>zz", { desc = "General: Scroll up + center screen", nowait = true })
map("n", "sv", ":vsplit<cr><C-w>l", { desc = "General: Vertical split", nowait = true })
map("n", "ss", ":split<cr><C-w>j", { desc = "General: Horizontal split", nowait = true })
map("n", "<leader>w", ":w<cr>", { desc = "General: Save the file", nowait = true })
map("v", "<A-j>", "<C-d>zz", { desc = "General: Scroll down + center screen", nowait = true })
map("v", "<A-k>", "<C-u>zz", { desc = "General: Scroll up + center screen", nowait = true })
map("i", "jk", "<ESC>", { desc = "General: Escape insert mode" })
map("n", "te", ":tabedit<cr>", { desc = "Tabufline: New Tab" })
map("n", "<Tab>", ":tabnext<cr>", { desc = "Tabufline: Next Tab" })
map("n", "<S-Tab>", ":tabprevious<cr>", { desc = "Tabufline: Previous Tab" })

map("n", "<C-h>", "<C-w>h", { desc = "General: Switch split focus" })
map("n", "<C-j>", "<C-w>j", { desc = "General: Switch split focus" })
map("n", "<C-k>", "<C-w>k", { desc = "General: Switch split focus" })
map("n", "<C-l>", "<C-w>l", { desc = "General: Switch split focus" })
