// ABOUTME: Defines KeyMapping struct for storing keyboard shortcuts and PresetAction enum for quick presets.
// ABOUTME: Used throughout the app to represent button-to-key mappings.

import Foundation
import CoreGraphics

struct KeyMapping: Codable, Equatable {
    var keyCode: UInt16
    var modifiers: UInt64
    var displayName: String

    static let none = KeyMapping(keyCode: 0, modifiers: 0, displayName: "None")

    var cgModifiers: CGEventFlags {
        CGEventFlags(rawValue: modifiers)
    }
}

enum PresetAction: String, CaseIterable, Identifiable {
    case none = "None"
    case optionSpace = "Option+Space (PTT)"
    case escape = "Escape"
    case enter = "Enter"
    case tab = "Tab"
    case space = "Space"
    case cmdZ = "Cmd+Z (Undo)"
    case cmdShiftZ = "Cmd+Shift+Z (Redo)"
    case cmdC = "Cmd+C (Copy)"
    case cmdV = "Cmd+V (Paste)"
    case cmdS = "Cmd+S (Save)"
    case cmdA = "Cmd+A (Select All)"
    case cmdW = "Cmd+W (Close)"
    case upArrow = "Up Arrow"
    case downArrow = "Down Arrow"
    case leftArrow = "Left Arrow"
    case rightArrow = "Right Arrow"

    var id: String { rawValue }

    func toKeyMapping() -> KeyMapping {
        switch self {
        case .none: return .none
        case .optionSpace: return KeyMapping(keyCode: 0x31, modifiers: CGEventFlags.maskAlternate.rawValue, displayName: rawValue)
        case .escape: return KeyMapping(keyCode: 0x35, modifiers: 0, displayName: rawValue)
        case .enter: return KeyMapping(keyCode: 0x24, modifiers: 0, displayName: rawValue)
        case .tab: return KeyMapping(keyCode: 0x30, modifiers: 0, displayName: rawValue)
        case .space: return KeyMapping(keyCode: 0x31, modifiers: 0, displayName: rawValue)
        case .cmdZ: return KeyMapping(keyCode: 0x06, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .cmdShiftZ: return KeyMapping(keyCode: 0x06, modifiers: (CGEventFlags.maskCommand.rawValue | CGEventFlags.maskShift.rawValue), displayName: rawValue)
        case .cmdC: return KeyMapping(keyCode: 0x08, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .cmdV: return KeyMapping(keyCode: 0x09, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .cmdS: return KeyMapping(keyCode: 0x01, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .cmdA: return KeyMapping(keyCode: 0x00, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .cmdW: return KeyMapping(keyCode: 0x0D, modifiers: CGEventFlags.maskCommand.rawValue, displayName: rawValue)
        case .upArrow: return KeyMapping(keyCode: 0x7E, modifiers: 0, displayName: rawValue)
        case .downArrow: return KeyMapping(keyCode: 0x7D, modifiers: 0, displayName: rawValue)
        case .leftArrow: return KeyMapping(keyCode: 0x7B, modifiers: 0, displayName: rawValue)
        case .rightArrow: return KeyMapping(keyCode: 0x7C, modifiers: 0, displayName: rawValue)
        }
    }
}
