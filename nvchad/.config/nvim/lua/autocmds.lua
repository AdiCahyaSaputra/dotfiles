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

-- vim-visual-multi overwrites insert maps; re-apply blink.cmp after exit.
autocmd("User", {
  pattern = "visual_multi_exit",
  callback = function()
    local ok_apply, apply = pcall(require, "blink.cmp.keymap.apply")
    if not ok_apply then
      return
    end

    local prefix = apply.DESC_PREFIX
    for _, mode in ipairs { "i", "s" } do
      for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
        if map.desc and vim.startswith(map.desc, prefix) then
          pcall(vim.keymap.del, mode, map.lhs, { buffer = 0 })
        end
      end
    end

    local keymap = require "blink.cmp.keymap"
    local config = require "blink.cmp.config"
    apply.keymap_to_current_buffer(keymap.get_mappings(config.keymap, "default"))
  end,
})
