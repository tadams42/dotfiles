local wezterm = require 'wezterm'
local act = wezterm.action

local module = {}

function module.apply_to_config(config)
	local keys_overrides = {
		-- muscle memorized keys from years of using Konsole
		{ key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackAndViewport' },

		-- with kitty keyboard protocol enabled, nightly WezTerm sends Delete as 0x08
		-- (^H), which nvim and Claude Code treat as Backspace; force legacy sequence
		{ key = 'Delete', mods = 'NONE', action = act.SendString '\x1b[3~' },

		-- Claude Code expects Shift+Enter to send CSI-u sequence for kitty keyboard protocol
		-- when Kitty terminal protocol is enable, this should not be needed
		-- { key = 'Enter', mods = 'SHIFT',      action = act.SendString('\x1b[13;2u') },
	}

	-- Merge all keybindings
	config.keys = {}
	for _, binding in ipairs(keys_overrides) do
		table.insert(config.keys, binding)
	end
end

return module
