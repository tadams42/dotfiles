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
local TAB_BAR_FONT = F_HACK
local TAB_BAR_FONT_SIZE = 9.0

local function tab_bar(config)
	-- Specifies the maximum width that a tab can have in the tab bar when using retro
	-- tab mode. It is ignored when using fancy tab mode.
	config.tab_max_width = 32
	-- config.use_fancy_tab_bar  = false

	config.hide_tab_bar_if_only_one_tab = false
	-- config.show_close_tab_button_in_tabs = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_bar_at_bottom = true

	-- -------------------------------------------------------------------------------------
	-- Configures tab bar apearance
	-- -------------------------------------------------------------------------------------
	config.window_frame = {
		-- The font used in the tab bar.
		-- Roboto Bold is the default; this font is bundled
		-- with wezterm.
		-- Whatever font is selected here, it will have the
		-- main font setting appended to it to pick up any
		-- fallback fonts you may have used there.
		-- font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" }),
		font = wezterm.font(TAB_BAR_FONT, { weight = "Regular" }),

		-- The size of the font in the tab bar...
		-- ... but only if use_fancy_tab_bar is true
		-- Default to 10.0 on Windows but 12.0 on other systems
		font_size = TAB_BAR_FONT_SIZE,

		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "#333333",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = "#333333",
	}

	config.colors = {
		tab_bar = {
			-- The color of the inactive tab bar edge/divider
			inactive_tab_edge = "#575757",
		},
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
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
	local HOME_DIR = os.getenv("HOME")

	return current_dir.file_path == HOME_DIR and "~" or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
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

local function tab_title(config)
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

		local cwd = wezterm.format({
			{ Text = get_current_working_dir(tab) },
		})

		local process = get_process(tab)
		local title = process and string.format(" %s %s ", process, cwd) or " [?] "

		if not tab.is_active then
			return {
				-- { Background = { Color = '#0b0022' } },
				-- { Foreground = { Color = '#1b1032' } },
				-- { Text = SOLID_LEFT_ARROW },

				{ Text = title },

				-- { Background = { Color = '#0b0022' } },
				-- { Foreground = { Color = '#1b1032' } },
				{ Text = SOLID_RIGHT_ARROW },
			}
		end

		if has_unseen_output then
			return {
				-- { Background = { Color = '#0b0022' } },
				-- { Foreground = { Color = '#2b2042' } },
				-- { Text = SOLID_LEFT_ARROW },

				{ Foreground = { Color = "#28719c" } },
				{ Text = title },

				-- { Background = { Color = '#0b0022' } },
				-- { Foreground = { Color = '#2b2042' } },
				{ Text = SOLID_RIGHT_ARROW },
			}
		end

		return {
			-- { Background = { Color = '#0b0022' } },
			-- { Foreground = { Color = '#2b2042' } },
			-- { Text = SOLID_LEFT_ARROW },

			{ Text = title },

			-- { Background = { Color = '#0b0022' } },
			-- { Foreground = { Color = '#2b2042' } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end)
end

local function set_theme(config)
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

function module.apply_to_config(config)
	-- Global font
	config.font = wezterm.font({ family = PRIMARY_FONT, weight = "Regular", italic = false })
	config.font_size = PRIMARY_FONT_SIZE

	-- Acceptable values are SteadyBlock, BlinkingBlock, SteadyUnderline, BlinkingUnderline, SteadyBar, and BlinkingBar.
	config.default_cursor_style = "SteadyBlock"

	config.enable_scroll_bar = true
	config.scrollback_lines = 50000

	set_theme(config)
	tab_bar(config)
	-- tab_title(config)
end

return module
