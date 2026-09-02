-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_decorations = "TITLE | RESIZE"
-- config.window_decorations = "NONE"
config.window_background_opacity = 1

config.initial_cols = 100
config.initial_rows = 30
config.font_size = 16

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.color_scheme = "Jellybeans (Gogh)"

config.colors = {
	cursor_bg = '#ffffff',    -- Background color of the cursor
	cursor_fg = '#000000',    -- Background color of the cursor
	cursor_border = '#ffffff', -- Border color of the cursor
}

config.keys = {
	-- New Tab: Ctrl + T
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action.SpawnTab "CurrentPaneDomain",
	},

	-- Enter in agentic AI
	{ key = 'Enter', mods = 'SHIFT', action = wezterm.action.SendString '\n' },

	-- Close Current Tab: Ctrl + W
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentTab { confirm = true },
	},

	-- Toggle fullscreen
	{
		key = 'n',
		mods = 'SHIFT|CTRL',
		action = wezterm.action.ToggleFullScreen,
	},

	-- Split Panes
	{
		key = 'j',
		mods = 'CTRL|ALT',
		action = wezterm.action.SplitPane {
			direction = 'Down',
		},
	},
	{
		key = 'l',
		mods = 'CTRL|ALT',
		action = wezterm.action.SplitPane {
			direction = 'Right',
		},
	},

	-- Move through Panes
	{
		key = 'h',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Left',
	},
	{
		key = 'j',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Down',
	},
	{
		key = 'k',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Up',
	},
	{
		key = 'l',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.ActivatePaneDirection 'Right',
	},
	{
		key = 'E',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.PromptInputLine {
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
	},
}

-- config.background = {
-- 	{
-- 		source = {
-- 			Color = "rgba(0, 0, 0, 1)",
-- 		},
-- 		height = "100%",
-- 		width = "100%",
-- 	},
-- }

local function format_tab(tab)
	local max_length = 8

	-- Check if truncation is actually needed
	if #tab > max_length then
		return string.sub(tab, 1, max_length) .. ".."
	end
	return tab
end

wezterm.on("format-tab-title", function(tab)
	local title = tab.tab_title

	if title == "" then
		local cwd = tab.active_pane.current_working_dir
		if cwd then
			title = cwd.file_path:match("([^/]+)$")
		else
			title = "Pertamina Shell"
		end
	end

	return " " .. format_tab(title) .. " "
end)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
	options = {
		icons_enabled = true,
		theme = 'Mono Theme (terminal.sexy)',
		tabs_enabled = true,
		theme_overrides = {
		},
		section_separators = {
			left = wezterm.nerdfonts.ple_ice_waveform,
			right = wezterm.nerdfonts.ple_ice_waveform_mirrored,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_ice_waveform,
			right = wezterm.nerdfonts.ple_ice_waveform_mirrored,
		},
	},
	sections = {
		tabline_a = { 'mode' },
		tabline_b = {},
		tabline_c = {},
		tab_active = {
			'index',
			{
				'tab',
				padding = { left = 1, right = 1 },
				icons_enabled = false,
				fmt = format_tab
			},
		},
		tab_inactive = {
			'index',
			{
				'tab',
				padding = { left = 1, right = 1 },
				icons_enabled = false,
				fmt = format_tab
			},
		},
		tabline_x = {},
		tabline_y = { 'datetime' },
		tabline_z = { 'hostname' },
	},
	extensions = {},
})

tabline.setup()

-- Maximize window when WezTerm starts
-- wezterm.on("gui-startup", function(cmd)
-- 	local _tab, _pane, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():maximize()
-- end)

return config
