// ABOUTME: Defines GamepadButton enum representing all buttons on the 8BitDo Micro controller.
// ABOUTME: Includes HID input mappings, visual styling, and default key assignments.

import SwiftUI

enum GamepadButton: String, CaseIterable, Identifiable {
    // Face buttons (corrected labels)
    case B = "B"
    case A = "A"
    case Y = "Y"
    case X = "X"
    // Shoulder buttons
    case L = "L"
    case R = "R"
    case ZL = "ZL"
    case ZR = "ZR"
    // D-Pad
    case dpadUp = "D-Up"
    case dpadDown = "D-Down"
    case dpadLeft = "D-Left"
    case dpadRight = "D-Right"
    // Other
    case minus = "Minus"
    case plus = "Plus"
    case home = "Home"
    case capture = "Capture"

    var id: String { rawValue }

    enum InputType {
        case byte1Mask(UInt8)
        case byte2Mask(UInt8)
        case analogDpad(axis: Int, threshold: AnalogThreshold)
    }

    enum AnalogThreshold {
        case low   // < 0x40
        case high  // > 0xC0
    }

    var inputType: InputType {
        switch self {
        // Byte 1 buttons (corrected mapping)
        case .B: return .byte1Mask(0x01)
        case .A: return .byte1Mask(0x02)
        case .Y: return .byte1Mask(0x04)
        case .X: return .byte1Mask(0x08)
        case .L: return .byte1Mask(0x10)
        case .R: return .byte1Mask(0x20)
        case .ZL: return .byte1Mask(0x40)
        case .ZR: return .byte1Mask(0x80)
        // Byte 2 buttons
        case .minus: return .byte2Mask(0x01)
        case .plus: return .byte2Mask(0x02)
        case .home: return .byte2Mask(0x10)
        case .capture: return .byte2Mask(0x20)
        // D-Pad (analog values: byte 5 = X axis, byte 7 = Y axis)
        case .dpadLeft: return .analogDpad(axis: 5, threshold: .low)
        case .dpadRight: return .analogDpad(axis: 5, threshold: .high)
        case .dpadUp: return .analogDpad(axis: 7, threshold: .low)
        case .dpadDown: return .analogDpad(axis: 7, threshold: .high)
        }
    }

    var defaultsKey: String { "buttonMapping_v3_\(self.rawValue)" }

    var defaultMapping: KeyMapping {
        switch self {
        case .R: return PresetAction.optionSpace.toKeyMapping()
        case .ZL: return PresetAction.escape.toKeyMapping()
        case .ZR: return PresetAction.enter.toKeyMapping()
        default: return .none
        }
    }

    var symbol: String {
        switch self {
        case .B: return "b.circle.fill"
        case .A: return "a.circle.fill"
        case .Y: return "y.circle.fill"
        case .X: return "x.circle.fill"
        case .L: return "l.button.roundedbottom.horizontal.fill"
        case .R: return "r.button.roundedbottom.horizontal.fill"
        case .ZL: return "zl.button.roundedtop.horizontal.fill"
        case .ZR: return "zr.button.roundedtop.horizontal.fill"
        case .dpadUp: return "arrowtriangle.up.fill"
        case .dpadDown: return "arrowtriangle.down.fill"
        case .dpadLeft: return "arrowtriangle.left.fill"
        case .dpadRight: return "arrowtriangle.right.fill"
        case .minus: return "minus.circle.fill"
        case .plus: return "plus.circle.fill"
        case .home: return "house.circle.fill"
        case .capture: return "camera.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .B: return .red
        case .A: return .green
        case .Y: return .yellow
        case .X: return .blue
        case .L, .R: return .gray
        case .ZL, .ZR: return .purple
        case .dpadUp, .dpadDown, .dpadLeft, .dpadRight: return .indigo
        case .minus, .plus: return .orange
        case .home: return .cyan
        case .capture: return .pink
        }
    }

    var shortLabel: String {
        switch self {
        case .dpadUp: return "↑"
        case .dpadDown: return "↓"
        case .dpadLeft: return "←"
        case .dpadRight: return "→"
        default: return rawValue
        }
    }
}
