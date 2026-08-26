# Keys stuff

## Konsole

Clear Scrollback and Reset -> `CTRL + SHIFT + K`
Copy                       -> `CTRL + SHIFT + C`
Paste                      -> `CTRL + SHIFT + V`
Find                       -> `CTRL + SHIFT + F`
Move Tab Left              -> `CTRL + ALT + LEFT`
Move Tab Right             -> `CTRL + ALT + RIGHT`
Prev/Next Tab              -> `CTRL + PgUp/PgDown` (`Shift + Left / Right`)
Paste Selection            -> `CTRL + Shift + Ins`

## ZSH

Ctrl + k  - Cut till end
Ctrl + w  - Cut previous word
Alt + t   - Swap current word with previous
Ctrl + y  - Paste
Ctrl + l  - Clear screen
Ctrl + xx - Toggle between the start of line and current cursor position
CTRL + A  - Move the cursor to the beginning of the line
CTRL + E  - Move the cursor to the end of the line

clear-screen (`^L` `ESC-^L`) (`^L`) (`^L`) - Clear the screen and redraw the prompt

ZSH ViMode?

## Wezterm

```sh
wezterm show-keys --lua > /tmp/default_keytables.lua
```

```lua
local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },

    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },

    { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'f', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
  },

  key_tables = {
    copy_mode = {
    },
    search_mode = {
    },
  }
}
```

## Enter key setup in various messaging apps

### Wanted behavior

Enter       - insert new line
Shift+Enter - send
Ctrl+Enter  - leave it to something else
Alt+Enter   - leave it to something else

### WhatsApp (in browser)

| key         | context            | action          |
| ----------- | ------------------ | --------------- |
| Enter       | message text input | insert new line |
| Shift+Enter | message text input | send message    |
| Ctrl+Enter  | message text input | send message    |

### Slack

| key         | context            | action          |
| ----------- | ------------------ | --------------- |
| Enter       | code block         | insert new line |
| Enter       | message text input | insert new line |
| Shift+Enter | code block         | send message    |
| Ctrl+Enter  | message text input | send message    |

### Gemini (in browser)

| key         | context            | action          |
| ----------- | ------------------ | --------------- |
| Enter       | message text input | insert new line |
| Shift+Enter | message text input | insert new line |
| Ctrl+Enter  | message text input | send message    |

### Claude

| key         | context            | action                       |
| ----------- | ------------------ | ---------------------------- |
| Enter       | message text input | send message                 |
| Shift+Enter | message text input | new line                     |
| Ctrl+Enter  | message text input | blocked, doesn't do anything |

Main problem is that `Enter` key can't be unbound, relevant GH bug reports below.

- [#22626](https://github.com/anthropics/claude-code/issues/22626)
  - most relevant one, exactly describes situation

- other, somewhate related bub reports and feature requests
  - [#22719](https://github.com/anthropics/claude-code/issues/22719)
  - [#9177](https://github.com/anthropics/claude-code/issues/9177)
  - [#24914](https://github.com/anthropics/claude-code/issues/24914)


Ideal config in `~/.claude/keybindings.json`:

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+g": null,
        "ctrl+e": "chat:externalEditor",
        "enter": null,
        "shift+enter": "chat:submit"
      }
    }
  ]
}
```
