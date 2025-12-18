// ABOUTME: Handles USB HID communication with the 8BitDo Micro gamepad via IOKit.
// ABOUTME: Parses input reports, detects button presses, and emits keyboard events via CGEvent.

import Foundation
import IOKit
import IOKit.hid
import CoreGraphics

class HIDManager {
    static let vendorID = 0x057E
    static let productID = 0x2009

    private var manager: IOHIDManager?
    private var device: IOHIDDevice?
    private var buttonStates: [GamepadButton: Bool] = [:]
    private var buttonMappings: [GamepadButton: KeyMapping] = [:]

    private var statusCallback: (Bool, Set<GamepadButton>) -> Void

    init(statusCallback: @escaping (Bool, Set<GamepadButton>) -> Void) {
        self.statusCallback = statusCallback
        for button in GamepadButton.allCases {
            buttonStates[button] = false
        }
        updateMappings()
    }

    func updateMappings() {
        for button in GamepadButton.allCases {
            buttonMappings[button] = SettingsManager.shared.getMapping(for: button)
        }
    }

    func start() {
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        guard let manager = manager else { return }

        let matching: [String: Any] = [
            kIOHIDVendorIDKey as String: HIDManager.vendorID,
            kIOHIDProductIDKey as String: HIDManager.productID
        ]
        IOHIDManagerSetDeviceMatching(manager, matching as CFDictionary)

        let context = Unmanaged.passUnretained(self).toOpaque()

        IOHIDManagerRegisterDeviceMatchingCallback(manager, { context, result, sender, device in
            guard let context = context else { return }
            let this = Unmanaged<HIDManager>.fromOpaque(context).takeUnretainedValue()
            this.deviceConnected(device)
        }, context)

        IOHIDManagerRegisterDeviceRemovalCallback(manager, { context, result, sender, device in
            guard let context = context else { return }
            let this = Unmanaged<HIDManager>.fromOpaque(context).takeUnretainedValue()
            this.deviceDisconnected(device)
        }, context)

        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }

    func stop() {
        for button in GamepadButton.allCases {
            if buttonStates[button] == true {
                releaseKey(for: button)
            }
        }
        if let manager = manager {
            IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
        }
    }

    private func deviceConnected(_ device: IOHIDDevice) {
        self.device = device
        print("8BitDo connected!")
        statusCallback(true, [])

        let context = Unmanaged.passUnretained(self).toOpaque()
        IOHIDDeviceRegisterInputReportCallback(
            device,
            UnsafeMutablePointer<UInt8>.allocate(capacity: 64),
            64,
            { context, result, sender, type, reportID, report, reportLength in
                guard let context = context else { return }
                let this = Unmanaged<HIDManager>.fromOpaque(context).takeUnretainedValue()
                this.handleReport(report, length: reportLength)
            },
            context
        )
    }

    private func deviceDisconnected(_ device: IOHIDDevice) {
        for button in GamepadButton.allCases {
            if buttonStates[button] == true {
                releaseKey(for: button)
                buttonStates[button] = false
            }
        }
        self.device = nil
        print("8BitDo disconnected!")
        statusCallback(false, [])
    }

    private func handleReport(_ report: UnsafeMutablePointer<UInt8>, length: CFIndex) {
        guard length >= 8 else { return }

        let byte1 = report[1]
        let byte2 = report[2]
        var activeButtons: Set<GamepadButton> = []

        for button in GamepadButton.allCases {
            var isPressed = false

            switch button.inputType {
            case .byte1Mask(let mask):
                isPressed = (byte1 & mask) != 0
            case .byte2Mask(let mask):
                isPressed = (byte2 & mask) != 0
            case .analogDpad(let axis, let threshold):
                let value = report[axis]
                switch threshold {
                case .low:
                    isPressed = value < 0x40
                case .high:
                    isPressed = value > 0xC0
                }
            }

            let wasPressed = buttonStates[button] ?? false

            if isPressed && !wasPressed {
                buttonStates[button] = true
                pressKey(for: button)
            } else if !isPressed && wasPressed {
                buttonStates[button] = false
                releaseKey(for: button)
            }

            if isPressed {
                activeButtons.insert(button)
            }
        }

        statusCallback(true, activeButtons)
    }

    private func pressKey(for button: GamepadButton) {
        guard let mapping = buttonMappings[button], mapping != .none else { return }
        guard let source = CGEventSource(stateID: .hidSystemState) else { return }

        if let event = CGEvent(keyboardEventSource: source, virtualKey: mapping.keyCode, keyDown: true) {
            if mapping.modifiers != 0 {
                event.flags = mapping.cgModifiers
            }
            event.post(tap: .cghidEventTap)
            print("⬇️ \(button.rawValue) → \(mapping.displayName)")
        }
    }

    private func releaseKey(for button: GamepadButton) {
        guard let mapping = buttonMappings[button], mapping != .none else { return }
        guard let source = CGEventSource(stateID: .hidSystemState) else { return }

        if let event = CGEvent(keyboardEventSource: source, virtualKey: mapping.keyCode, keyDown: false) {
            if mapping.modifiers != 0 {
                event.flags = mapping.cgModifiers
            }
            event.post(tap: .cghidEventTap)
        }
        print("⬆️ \(button.rawValue) released")
    }
}
