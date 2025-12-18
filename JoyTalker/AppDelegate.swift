// ABOUTME: Manages the menu bar status item and coordinates app lifecycle.
// ABOUTME: Handles accessibility permission checks and HID manager initialization.

import AppKit
import ApplicationServices

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var hidManager: HIDManager!

    func applicationDidFinishLaunching(_ notification: Notification) {
        checkAccessibility()
        setupMenuBar()

        hidManager = HIDManager { [weak self] connected, activeButtons in
            DispatchQueue.main.async {
                SettingsManager.shared.isConnected = connected
                SettingsManager.shared.activeButtons = activeButtons
                self?.updateStatusIcon(connected: connected, active: !activeButtons.isEmpty)
            }
        }
        hidManager.start()

        NotificationCenter.default.addObserver(
            forName: .mappingsChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.hidManager.updateMappings()
        }
    }

    func checkAccessibility() {
        let trusted = AXIsProcessTrusted()
        if !trusted {
            let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
            AXIsProcessTrustedWithOptions(options)
        }
    }

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "gamecontroller", accessibilityDescription: "JoyTalker")
            updateStatusIcon(connected: false, active: false)
        }

        let menu = NSMenu()

        let titleItem = NSMenuItem(title: "JoyTalker", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)

        menu.addItem(NSMenuItem.separator())

        let statusMenuItem = NSMenuItem(title: "8BitDo: Disconnected", action: nil, keyEquivalent: "")
        statusMenuItem.tag = 100
        menu.addItem(statusMenuItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Open Settings...", action: #selector(openSettings), keyEquivalent: ","))

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc func openSettings() {
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApp.activate(ignoringOtherApps: true)
    }

    func updateStatusIcon(connected: Bool, active: Bool) {
        guard let button = statusItem.button else { return }

        let symbolName = active ? "gamecontroller.fill" : "gamecontroller"
        button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "JoyTalker")

        if active {
            button.contentTintColor = .systemGreen
        } else if connected {
            button.contentTintColor = .labelColor
        } else {
            button.contentTintColor = .systemGray
        }

        if let menu = statusItem.menu, let item = menu.item(withTag: 100) {
            if connected {
                item.title = active ? "8BitDo: Active" : "8BitDo: Connected"
            } else {
                item.title = "8BitDo: Disconnected"
            }
        }
    }

    @objc func quit() {
        hidManager.stop()
        NSApplication.shared.terminate(nil)
    }
}
