local wezterm = require("wezterm")

local module = {}

local F_CASKAYDIA = "CaskaydiaCove Nerd Font Mono"
local F_CODE_NEW_ROMAN = "CodeNewRoman Nerd Font Mono"
local F_FIRACODE = "FiraCode Nerd Font Mono"
local F_HACK = "Hack Nerd Font Mono"
local F_INCONSOLATA = "Inconsolata Nerd Font Mono"
local F_JETBRAINS = "JetBrainsMono Nerd Font Mono"
local F_MESLO = "MesloLGS NF"

local PRIMARY_FONT = F_HACK
local PRIMARY_FONT_SIZE = 11.0

-- Rounded powerline caps, same glyphs catppuccin-tmux uses
local ROUND_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick   -- U+E0B6
local ROUND_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick -- U+E0B4

-- Tab bar background. Fully transparent so background image shows through and tab bar
-- looks like a part of terminal canvas rather than a separate GUI element.
local BAR_BG = "rgba(0,0,0,0)"

-- Catppuccin Mocha palette
local C = {
	crust = "#11111b",
	surface0 = "#313244",
	overlay0 = "#6c7086",
	text = "#cdd6f4",
	subtext0 = "#a6adc8",
	green = "#a6e3a1",
	peach = "#fab387",
	pink = "#f5c2e7",
	blue = "#89b4fa",
}

local function setup_tab_bar(config)
	-- Retro tab bar is rendered in terminal cell grid, using config.font, which is what
	-- makes it look like a part of terminal canvas (same as tmux status line).
	-- window_frame settings (font, font_size, titlebar colors) apply only to fancy tab
	-- bar and are ignored here.
	config.use_fancy_tab_bar = false

	-- Specifies the maximum width that a tab can have in the tab bar when using retro
	-- tab mode. It is ignored when using fancy tab mode.
	config.tab_max_width = 32

	config.hide_tab_bar_if_only_one_tab = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_bar_at_bottom = false

	config.colors = {
		tab_bar = {
			background = BAR_BG,
			active_tab = { bg_color = BAR_BG, fg_color = C.text },
			inactive_tab = { bg_color = BAR_BG, fg_color = C.subtext0 },
			inactive_tab_hover = { bg_color = BAR_BG, fg_color = C.text },
		},
	}
end

-- Pill shaped segment: rounded cap, colored icon cell, text cell on surface, rounded cap
local function pill(icon, icon_bg, text, text_fg)
	return {
		{ Background = { Color = BAR_BG } },
		{ Foreground = { Color = icon_bg } },
		{ Text = ROUND_LEFT },
		{ Background = { Color = icon_bg } },
		{ Foreground = { Color = C.crust } },
		{ Text = icon .. " " },
		{ Background = { Color = C.surface0 } },
		{ Foreground = { Color = text_fg } },
		{ Text = " " .. text .. " " },
		{ Background = { Color = BAR_BG } },
		{ Foreground = { Color = C.surface0 } },
		{ Text = ROUND_RIGHT },
		{ Text = " " },
	}
end

local PROCESS_ICONS = {
	["docker"] = wezterm.nerdfonts.linux_docker,
	["docker-compose"] = wezterm.nerdfonts.linux_docker,
	["btm"] = "",
	["psql"] = "󱤢",
	["usql"] = "󱤢",
	["kuberlr"] = wezterm.nerdfonts.linux_docker,
	["ssh"] = wezterm.nerdfonts.fa_exchange,
	["ssh-add"] = wezterm.nerdfonts.fa_exchange,
	["kubectl"] = wezterm.nerdfonts.linux_docker,
	["stern"] = wezterm.nerdfonts.linux_docker,
	["nvim"] = wezterm.nerdfonts.custom_vim,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["node"] = wezterm.nerdfonts.mdi_hexagon,
	["go"] = wezterm.nerdfonts.seti_go,
	["python3"] = "",
	["zsh"] = wezterm.nerdfonts.dev_terminal,
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["git"] = wezterm.nerdfonts.dev_git,
	["lua"] = wezterm.nerdfonts.seti_lua,
	["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
	["curl"] = wezterm.nerdfonts.mdi_flattr,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["ruby"] = wezterm.nerdfonts.cod_ruby,
}

-- Basename of a pane's cwd Url, or "~" for $HOME
local function cwd_basename(url)
	if not url or not url.file_path then
		return ""
	end
	-- WezTerm cwd Urls usually end with "/" (file:///home/me/foo/), strip it first
	local path = string.gsub(url.file_path, "[/\\]+$", "")
	if path == "" then
		return "/"
	end
	if path == string.gsub(os.getenv("HOME"), "[/\\]+$", "") then
		return "~"
	end
	return (string.gsub(path, "^.*[/\\]", ""))
end

local function get_current_working_dir(tab)
	return cwd_basename(tab.active_pane and tab.active_pane.current_working_dir)
end

local function get_process(tab)
	if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
		return nil
	end

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
	-- if string.find(process_name, 'kubectl') then
	--     process_name = 'kubectl'
	-- end

	return PROCESS_ICONS[process_name] or string.format("[%s]", process_name)
end

local function setup_tab_title(config)
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local has_unseen_output = false
		if not tab.is_active then
			for _, pane in ipairs(tab.panes) do
				if pane.has_unseen_output then
					has_unseen_output = true
					break
				end
			end
		end

		local title
		if tab.tab_title and #tab.tab_title > 0 then
			-- explicitly set by `wezterm cli set-tab-title` or tab:set_title()
			title = tab.tab_title
		else
			local process = get_process(tab)
			title = process and string.format("%s %s", process, get_current_working_dir(tab)) or "[?]"
		end
		local number = tostring(tab.tab_index + 1)

		-- Like catppuccin-tmux: title on surface, tab number in colored cell on the right
		local accent = C.overlay0
		local title_fg = C.subtext0
		if tab.is_active then
			accent = C.peach
			title_fg = C.text
		elseif has_unseen_output then
			accent = C.blue
		end

		-- 2 caps + 3 spaces + number; keep room for them so caps survive truncation
		title = wezterm.truncate_right(title, math.max(1, max_width - #number - 5))

		return {
			{ Background = { Color = BAR_BG } },
			{ Foreground = { Color = C.surface0 } },
			{ Text = ROUND_LEFT },
			{ Background = { Color = C.surface0 } },
			{ Foreground = { Color = title_fg } },
			{ Text = title .. " " },
			{ Background = { Color = accent } },
			{ Foreground = { Color = C.crust } },
			{ Text = " " .. number },
			{ Background = { Color = BAR_BG } },
			{ Foreground = { Color = accent } },
			{ Text = ROUND_RIGHT },
			{ Text = " " },
		}
	end)
end

-- Right: cwd of active pane.
local function setup_tab_status_update(config)
	wezterm.on("update-status", function(window, pane)
		local dir = cwd_basename(pane:get_current_working_dir())
		window:set_right_status(wezterm.format(pill(wezterm.nerdfonts.fa_folder, C.pink, dir, C.text)))
	end)
end

local function setup_theme(config)
	-- config.color_scheme = 'Atom'
	-- config.color_scheme = 'Atom (Gogh)'
	-- config.color_scheme = 'Bamboo'
	-- config.color_scheme = 'Blazer (Gogh)'
	-- config.color_scheme = 'BlulocoDark'
	-- config.color_scheme = 'Breeze (Gogh)'
	-- config.color_scheme = 'Builtin Solarized Dark'
	config.color_scheme = "Catppuccin Mocha" -- Mocha, Macchiato, Frappe, Latte
	-- config.color_scheme = 'Espresso (Gogh)'
	-- config.color_scheme = 'Flat (Gogh)'
	-- config.color_scheme = 'Molokai (Gogh)'
	-- config.color_scheme = 'Nighty (Gogh)'
	-- config.color_scheme = 'nord'
	-- config.color_scheme = 'Nord (base16)'
	-- config.color_scheme = 'Nord (Gogh)'
	-- config.color_scheme = 'Ocean (dark) (terminal.sexy)'
	-- config.color_scheme = 'Red Planet'
	-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
	-- config.color_scheme = 'Solarized Dark (Gogh)'
	-- config.color_scheme = "Breeze"
	-- config.color_scheme = 'Monokai (dark) (terminal.sexy)'
	-- config.color_scheme = 'Monokai (terminal.sexy)'
	-- config.color_scheme = 'Monokai Dark (Gogh)'
	-- config.color_scheme = 'Monokai Pro (Gogh)'
	-- config.color_scheme = 'N0tch2k'
	-- config.color_scheme = 'N0Tch2K (Gogh)'
	-- config.color_scheme = 'Railscasts (base16)'
	-- config.color_scheme = 'Railscasts (dark) (terminal.sexy)'
	-- config.color_scheme = "Tokyo Night"
end

local function setup_background_image_and_opacity(config)
	-- config.window_background_opacity = 0.90 -- 1.0 = opaque, 0.0 = fully transparent
	-- config.text_background_opacity = 1.0 -- keep text cells crisp (default)

	-- Optional, KDE only: blur whatever is behind the window (frosted-glass look)
	-- config.wayland_window_background_blur = false

	-- WezTerm supports background images, animated GIFs, gradients, and several layers
	-- stacked on top of each other. The modern way is config.background, which takes a
	-- list of layers drawn bottom to top:
	config.background = {
		{
			source = { File = wezterm.home_dir .. "/.config/wezterm/background.jpg" },
			width = "Cover", -- scale to fill the window, like CSS background-size: cover
			height = "Cover",
			horizontal_align = "Center",
			vertical_align = "Middle",
			repeat_x = "NoRepeat",
			repeat_y = "NoRepeat",
			hsb = { brightness = 0.10 }, -- darken it heavily so text stays readable
			opacity = 1,        -- per-layer transparency (replaces window_background_opacity)
		},
	}
end

function module.apply_to_config(config)
	-- Global font
	config.font = wezterm.font({ family = PRIMARY_FONT, weight = "Regular", italic = false })
	config.font_size = PRIMARY_FONT_SIZE

	-- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
	config.default_cursor_style = "SteadyBlock"

	-- config.enable_scroll_bar = true
	config.scrollback_lines = 50000

	setup_theme(config)
	setup_tab_bar(config)
	setup_tab_title(config)
	setup_tab_status_update(config)
	setup_background_image_and_opacity(config)
end

return module
