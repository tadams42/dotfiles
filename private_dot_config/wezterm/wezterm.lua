-- logs are in $XDG_RUNTIME_DIR/wezterm/wezterm-gui-log

local appearance = require("appearance")
local keybindings = require("keybindings")

-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Spawn a our preferred shell, in login mode
config.default_prog = { "/usr/bin/zsh", "--interactive" }

-- requires wezterm TERMINFO file to be installed:
--
-- ```
-- tempfile=$(mktemp) \
--   && curl -o "$tempfile" https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
--   && tic -x -o ~/.terminfo "$tempfile" \
--   && rm "$tempfile"
-- ```
--
-- fails to show LS colors on remote hosts when:
--   - ssh started in wezterm
--   - local shell is zsh
--   - remote shell is bash
--   - config.term is 'wezterm'
-- config.term = "wezterm"

appearance.apply_to_config(config)

keybindings.apply_to_config(config)

config.enable_kitty_keyboard = true

-- This will log key events to stderr - but WezTerm needs to be started
-- from another terminal to see it.
-- config.debug_key_events = true

-- CloseCurrentTab handler will not ask for confirmation when closing tab that is
-- running ie /usr/bin/zsh with no subprocesses spawned
-- I like closing tabs by exiting shell (CTRL+D) and not by closing terminal
-- On the other hand, accidental CTRL+W may close tab that is temporarily running shell
-- only, but is named and prepared to occasionally run oe. devserver, app shell, etc...
config.skip_close_confirmation_for_processes_named = {}

config.enable_wayland = true
-- stuff that might help with unstable Wayland sessions...
-- config.front_end = "OpenGL" -- Or "Software" if things get really weird
-- config.front_end = "WebGpu"
-- config.webgpu_preferred_adapter = { backend = "Vulkan" } -- Good for Wayland stability

-- If you open the Debug Overlay (default: CTRL + SHIFT + L) you can interactively
-- review the list with command `wezterm.gui.enumerate_gpus()`
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		config.animation_fps = 30
		break
	end
end
-- config.front_end = "OpenGL"
-- wezterm.log_info(config.front_end)

config.initial_cols = 160
config.initial_rows = 50
config.scrollback_lines = 50000

-- w = wezterm.gui.gui_windows()[1] -- GuiWin
-- p = w:active_pane() -- MuxPane
-- t = w:active_tab() -- MuxTab
--
-- p:get_dimensions()
-- {
--     "cols": 272,
--     "dpi": 96,
--     "physical_top": 0,
--     "pixel_height": 994,
--     "pixel_width": 1904,
--     "reverse_video": false,
--     "scrollback_rows": 71,
--     "scrollback_top": 0,
--     "viewport_rows": 71,
-- }
--
-- t:get_size()
-- {
--     "cols": 272,
--     "dpi": 96,
--     "pixel_height": 994,
--     "pixel_width": 1904,
--     "rows": 71,
-- }

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- and finally, return the configuration to wezterm
return config
