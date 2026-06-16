local map = vim.keymap.set

require("telescope").setup({
  defaults = {
    prompt_prefix = "  ",
    selection_caret = " ",
  }
})

local pickers = require("telescope.builtin")

map("n", "<leader>fp", pickers.builtin, { desc = "[S]earch Builtin [P]ickers", })
map("n", "<leader>fb", pickers.buffers, { desc = "[S]earch [B]uffers", })
map("n", "<leader>ff", pickers.find_files, { desc = "[S]earch [F]iles", })
map("n", "<leader>fw", pickers.grep_string, { desc = "[S]earch Current [W]ord", })
map("n", "<leader>fg", pickers.live_grep, { desc = "[S]earch by [G]rep", })
map("n", "<leader>fr", pickers.resume, { desc = "[S]earch [R]esume", })

map("n", "<leader>fh", pickers.help_tags, { desc = "[S]earch [H]elp", })
map("n", "<leader>fm", pickers.man_pages, { desc = "[S]earch [M]anuals", })
