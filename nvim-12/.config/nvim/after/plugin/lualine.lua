local function custom_lsp()
  local bufnr = vim.api.nvim_get_current_buf()

  for _, client in ipairs(vim.lsp.get_clients()) do
    local attached_buffers = client.attached_buffers

    if attached_buffers and attached_buffers[bufnr] then
      if vim.o.columns > 100 then
        return client.name .. " says ->"
      else
        return "LSP Attached"
      end
    end
  end

  return "No LSP"
end

-- local function supermaven_status()
--   local ok, api = pcall(require, "supermaven-nvim.api")
--
--   if not ok then
--     return "SuperMaven: N/A"
--   end
--
--   return api.is_running()
--       and "SuperMaven: ON"
--       or "SuperMaven: OFF"
-- end


require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },

    lualine_b = {
      "branch",
    },

    lualine_c = {
      "diff",
      custom_lsp,
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
      },
    },

    lualine_x = {
      -- supermaven_status,
      "encoding",
      "filetype",
    },

    lualine_y = {
      "filename",
    },

    lualine_z = {
      function()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
    },
  },
})
