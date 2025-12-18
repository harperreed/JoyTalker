# JoyTalker

A macOS menu bar app that maps 8BitDo Micro controller buttons to keyboard shortcuts.

## Features

- Visual controller layout showing all buttons
- Configurable button-to-key mappings
- Custom key recording with modifier support
- D-pad support
- Real-time button highlighting
- Persistent settings via UserDefaults

## Requirements

- macOS 13.0 or later
- 8BitDo Micro controller (in Switch/gamepad mode)

## Installation

1. Download the latest release from [Releases](../../releases)
2. Unzip and drag JoyTalker to Applications
3. Launch the app
4. Grant Accessibility permission when prompted
5. Connect your 8BitDo Micro in gamepad mode

## Development

### Prerequisites

- Xcode 15+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

### Build

```bash
# Generate Xcode project
xcodegen generate

# Open in Xcode
open JoyTalker.xcodeproj
```

### Python Utilities

The `scripts/` folder contains Python utilities for debugging HID input:

```bash
# Setup
uv sync

# Sniff gamepad input
uv run scripts/gamepad_sniffer.py
```

## License

MIT
