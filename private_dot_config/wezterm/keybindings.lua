local wezterm = require 'wezterm'
local act = wezterm.action

local module = {}

function module.apply_to_config(config)
	local keys_overrides = {
		-- muscle memorized keys from years of using Konsole
		{ key = 'K',      mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackAndViewport' },

		-- with kitty keyboard protocol enabled, nightly WezTerm sends Delete as 0x08
		-- (^H), which nvim and Claude Code treat as Backspace; force legacy sequence
		{ key = 'Delete', mods = 'NONE',       action = act.SendString '\x1b[3~' },

		-- PgUp/PgDn: full-screen apps (nvim, less, htop) still get the key. At the
		-- shell prompt, PgUp enters copy mode and moves the cursor a page up; PgDn
		-- scrolls down. Keeps zsh from paging through history.
		{ key = 'PageUp', mods = 'NONE', action = wezterm.action_callback(function(window, pane)
			if pane:is_alt_screen_active() then
				window:perform_action(act.SendKey { key = 'PageUp' }, pane)
			else
				window:perform_action(act.ActivateCopyMode, pane)
				window:perform_action(act.CopyMode { MoveByPage = -1 }, pane)
			end
		end) },
		{ key = 'PageDown', mods = 'NONE', action = wezterm.action_callback(function(window, pane)
			if pane:is_alt_screen_active() then
				window:perform_action(act.SendKey { key = 'PageDown' }, pane)
			else
				window:perform_action(act.ScrollByPage(1), pane)
			end
		end) },
	}

	-- Merge all keybindings
	config.keys = {}
	for _, binding in ipairs(keys_overrides) do
		table.insert(config.keys, binding)
	end
end

return module
