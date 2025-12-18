# JoyTalker Xcode Project Design

## Overview

Convert the hand-rolled JoyTalker menu bar app into a proper Xcode project with code signing and notarization support for distribution.

## Project Structure

```
joy-talker/
├── JoyTalker.xcodeproj/
├── JoyTalker/
│   ├── App/
│   │   └── JoyTalkerApp.swift
│   ├── Models/
│   │   ├── KeyMapping.swift
│   │   └── GamepadButton.swift
│   ├── Managers/
│   │   ├── SettingsManager.swift
│   │   ├── HIDManager.swift
│   │   └── KeyRecorder.swift
│   ├── Views/
│   │   ├── SettingsView.swift
│   │   ├── ControllerView.swift
│   │   └── ButtonConfigView.swift
│   ├── AppDelegate.swift
│   ├── JoyTalker.entitlements
│   ├── Info.plist
│   └── Assets.xcassets/
├── scripts/
│   ├── device_sniffer.py
│   ├── gamepad_sniffer.py
│   └── key_sniffer.py
└── README.md
```

## Configuration

- Bundle ID: `com.harperrules.joytalker`
- App Name: JoyTalker
- Deployment Target: macOS 13.0
- LSUIElement: true (menu bar only)

## Entitlements

No sandbox - app requires:
- IOKit HID access for gamepad input
- CGEvent posting for keystroke output
- Accessibility API for permission prompts

## Signing

- Signing Certificate: Developer ID Application
- Hardened Runtime: Enabled
- Notarization: via xcrun notarytool

## App Icon

SF Symbol "gamecontroller" exported as app icon.
