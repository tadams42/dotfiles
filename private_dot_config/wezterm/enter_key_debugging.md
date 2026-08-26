# Wezterm enter key debugging

## Disabled Kitty protocol

### Pressed `Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=Enter mods=NONE
wezterm_term::terminalstate::keyboard > key_down: sending "\r", Enter NONE
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=NONE
```

### Pressed `Shift + Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=RightShift mods=NONE
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=Enter mods=SHIFT
wezterm_term::terminalstate::keyboard > key_down: sending "\r", Enter SHIFT
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=SHIFT
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: SHIFT, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=RightShift mods=SHIFT
```

## Enabled Kitty protocol

### Pressed `Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=Enter mods=NONE
wezterm_term::terminalstate::keyboard > key_down: sending "\r", Enter NONE
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=NONE
```

### Pressed `Shift + Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=RightShift mods=NONE
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=Enter mods=SHIFT
wezterm_term::terminalstate::keyboard > key_down: sending "\r", Enter SHIFT
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=SHIFT
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: SHIFT, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=RightShift mods=SHIFT
```

## Enabled Kitty protocol + enabled Claude key override

### Pressed `Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=Enter mods=NONE
wezterm_term::terminalstate::keyboard > key_down: sending "\r", Enter NONE
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: NONE, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=NONE
```

### Pressed `Shift + Enter`

```log
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: NONE, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: NONE, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane DOWN key=RightShift mods=NONE
wezterm_gui::termwindow::keyevent > key_event RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: true, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: true, handled: false }) }
wezterm_gui::termwindow::keyevent > Char('\r') SHIFT -> perform SendString("\u{1b}[13;2u")
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: Char('\r'), modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(Return), modifiers: SHIFT, leds: (empty), phys_code: Some(Return), raw_code: 36, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=Enter mods=SHIFT
wezterm_gui::termwindow::keyevent > key_event KeyEvent { key: RightShift, modifiers: SHIFT, leds: (empty), repeat_count: 1, key_is_down: false, raw: Some(RawKeyEvent { key: Physical(RightShift), modifiers: SHIFT, leds: (empty), phys_code: Some(RightShift), raw_code: 62, repeat_count: 1, key_is_down: false, handled: false }) }
wezterm_gui::termwindow::keyevent > send to pane UP key=RightShift mods=SHIFT
```
