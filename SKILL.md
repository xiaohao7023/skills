---
name: shortcut-runner
description: Execute keyboard shortcuts on macOS using AppleScript. Use when the user needs to automate key presses, simulate keyboard combinations, or trigger shortcuts in applications. Supports custom shortcut presets defined in config.json. Requires macOS Accessibility permissions.
---

# Shortcut Runner

Execute keyboard shortcuts on macOS programmatically.

## Prerequisites

### macOS Accessibility Permission (Required)

This skill requires **Accessibility** permission to simulate keyboard input.

**⚠️ Important:** If running through OpenClaw, you need to grant permission to `openclaw-gateway`.

**First-time setup:**
1. Go to **System Settings → Privacy & Security → Accessibility**
2. Click the **+** button
3. Press `Cmd+Shift+G` and type: `/Applications/OneClaw.app/Contents/MacOS/`
4. Select `openclaw-gateway` and click **Open**
5. Ensure the checkbox next to `openclaw-gateway` is **checked**

**Alternative method:**
1. Run any shortcut command
2. When system prompts "openclaw-gateway wants to control your computer"
3. Click **Open System Settings** and grant permission

**Verify permissions:**
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/check-perms.scpt
```

## Usage

### Execute a Preset Shortcut

Define shortcuts in `config.json`, then run by name:

```bash
openclaw skills run shortcut-runner --name "my-shortcut"
```

### Execute Direct Keys

Pass keys directly without config:

```bash
# Single key
openclaw skills run shortcut-runner --keys "cmd,c"

# Multiple modifiers
openclaw skills run shortcut-runner --keys "cmd,shift,4"

# With delay between presses
openclaw skills run shortcut-runner --keys "cmd,v" --delay 100
```

## Configuration

Edit `config.json` to define reusable shortcuts:

```json
{
  "shortcuts": {
    "copy": {
      "keys": ["cmd", "c"],
      "description": "Copy to clipboard"
    },
    "paste": {
      "keys": ["cmd", "v"],
      "description": "Paste from clipboard"
    },
    "screenshot": {
      "keys": ["cmd", "shift", "4"],
      "description": "Screenshot selection"
    },
    "custom": {
      "keys": ["ctrl", "alt", "k"],
      "description": "Custom shortcut example"
    }
  }
}
```

## Supported Keys

| Key | Alias |
|-----|-------|
| cmd, command, ⌘ | cmd |
| ctrl, control, ⌃ | ctrl |
| opt, option, alt, ⌥ | opt |
| shift, ⇧ | shift |
| return, enter | return |
| space | space |
| tab | tab |
| esc, escape | esc |
| delete, backspace | delete |
| a-z, 0-9 | literal |
| f1-f20 | function keys |
| up, down, left, right | arrow keys |

## Options

| Option | Description | Example |
|--------|-------------|---------|
| `--name` | Execute preset from config | `--name "copy"` |
| `--keys` | Execute keys directly | `--keys "cmd,c"` |
| `--delay` | Delay between keys (ms) | `--delay 100` |
| `--repeat` | Repeat count | `--repeat 5` |
| `--target` | Target application | `--target "Safari"` |
| `--check-perms` | Verify permissions | - |

## Examples

```bash
# Copy current selection
openclaw skills run shortcut-runner --name "copy"

# Take screenshot
openclaw skills run shortcut-runner --name "screenshot"

# Paste 3 times with delay
openclaw skills run shortcut-runner --keys "cmd,v" --repeat 3 --delay 200

# Send Ctrl+C to specific app
openclaw skills run shortcut-runner --keys "ctrl,c" --target "Terminal"
```

## Troubleshooting

### "Not authorized" error
Grant Accessibility permission in System Settings.

### Keys not working
- Ensure target application is active (use `--target` or activate manually)
- Check that key names match supported list
- Try adding `--delay 50` between keys

### Script not found
Ensure the skill is properly installed and `scripts/run-shortcut.scpt` exists.
