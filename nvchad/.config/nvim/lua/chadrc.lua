-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "espresso",

	hl_add = {
		NvimTreeOpenedFolderName = { fg = "green", bold = true },
		NormalNC = {
			bg = "NONE",
		},
	},
	hl_override = {
		NormalFloat = {
			bg = "NONE",
		},
		Float = {
			bg = "NONE",
		},
		LineNr = {
			fg = "yellow"
		},
		FloatBorder = {
			bg = "NONE",
			-- fg = "yellow",
		},
		Normal = {
			bg = "NONE",
		},
		NvDashAscii = {
			bg = "NONE",
			fg = "yellow",
		},
		SagaBorder = {
			fg = "NONE",
			bg = "NONE",
		},
		Todo = {
			fg = "vibrant_green",
			bg = "black2",
		},
		WinSeparator = {
			fg = "black2",
		},
		IlluminatedWordText = { bold = true, bg = 'black2', reverse = false, underline = false },
		IlluminatedWordRead = { bold = true, bg = 'black2', reverse = false, underline = false },
		IlluminatedWordWrite = { bold = true, bg = 'black2', reverse = false, underline = false },
		DiagnosticVirtualTextHint = {
			bg = "NONE",
		},
		DiagnosticVirtualTextWarn = {
			bg = "NONE",
		},
		DiagnosticVirtualTextError = {
			bg = "NONE",
		},
		DiagnosticVirtualTextInfo = {
			bg = "NONE",
		},
		TelescopeSelection = {
			bg = "green",
			fg = "darker_black"
		},
		St_gitIcons = {
			fg = "yellow",
		},
		St_supermaven = {
			fg = "green",
		}
	},
	transparency = false,
	lsp_semantic_tokens = false,
	integrations = {
		"hop",
		"trouble",
		"todo",
		"neogit",
		"vim-illuminate",
		"diffview",
	},
	enabled = false
}

-- M.colorify = {
-- 	enabled = false
-- }

M.nvdash = {
	load_on_startup = true,
	header = {
		"                            ",
		"     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
		"   ▄▀███▄     ▄██ █████▀    ",
		"   ██▄▀███▄   ███           ",
		"   ███  ▀███▄ ███           ",
		"   ███    ▀██ ███           ",
		"   ███      ▀ ███           ",
		"   ▀██ █████▄▀█▀▄██████▄    ",
		"     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
		"                            ",
		"           NvChad          ",
		"                            ",
	},
}

M.ui = {
	order = { "treeOffset", "buffers", "custom_tab", "btns" },
	modules = {
		custom_tab = function()
			local btn = require("nvchad.tabufline.utils").btn
			local fn = vim.fn
			local result, tabs = "", fn.tabpagenr "$"

			if tabs > 1 then
				for nr = 1, tabs, 1 do
					local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
					result = result .. btn(" " .. nr .. " ", tab_hl, "GotoTab", nr)
				end

				local new_tabtn = btn("  ", "TabNewBtn", "NewTab")

				return new_tabtn .. result
			end

			return ""
		end
	},
	statusline = {
		theme = "default",
		separator_style = "default",
		-- order = { "mode", "git", "custom_lsp", "lsp_msg", "diagnostics", "%=", "%=", "file", "cwd" },
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "custom_lsp", "diagnostics", "supermaven", "cwd" },
		modules = {
			custom_lsp = function()
				local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)

				if rawget(vim, "lsp") then
					for _, client in ipairs(vim.lsp.get_clients()) do
						if client.attached_buffers[bufnr] then
							return (vim.o.columns > 100 and " %#St_lsp# 󱐌 Lsp (" .. client.name .. ")") or
									" %#St_lsp# No LSP attached"
						end
					end
				end

				return " %#St_lsp#No LSP attached "
			end,
			supermaven = function()
				local ok, api = pcall(require, "supermaven-nvim.api")
				local status = false

				if ok then
					status = api.is_running()
				end

				return " %#St_supermaven#" .. (status and " " or " ") .. " "
			end
		}
	},
}

return M
