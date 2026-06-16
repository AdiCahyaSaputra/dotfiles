require("blink.cmp").setup({
  snippets = {
    preset = "luasnip"
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    documentation = {
      auto_show = true,
    },
  },
  keymap = { preset = 'enter' },
  fuzzy = {
    implementation = "lua",
  },
})
