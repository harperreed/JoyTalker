// ABOUTME: Visual representation of the 8BitDo Micro controller with interactive buttons.
// ABOUTME: Shows real-time button activation state and allows selection for configuration.

import SwiftUI

struct ControllerView: View {
    @ObservedObject var settings: SettingsManager
    @Binding var selectedButton: GamepadButton?

    var body: some View {
        VStack(spacing: 16) {
            // Shoulder buttons
            HStack(spacing: 60) {
                VStack(spacing: 4) {
                    ControllerButton(button: .ZL, settings: settings, selectedButton: $selectedButton)
                    ControllerButton(button: .L, settings: settings, selectedButton: $selectedButton)
                }
                VStack(spacing: 4) {
                    ControllerButton(button: .ZR, settings: settings, selectedButton: $selectedButton)
                    ControllerButton(button: .R, settings: settings, selectedButton: $selectedButton)
                }
            }

            // Main body
            HStack(spacing: 30) {
                // Left side: D-Pad
                VStack(spacing: 2) {
                    ControllerButton(button: .dpadUp, settings: settings, selectedButton: $selectedButton)
                    HStack(spacing: 2) {
                        ControllerButton(button: .dpadLeft, settings: settings, selectedButton: $selectedButton)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                        ControllerButton(button: .dpadRight, settings: settings, selectedButton: $selectedButton)
                    }
                    ControllerButton(button: .dpadDown, settings: settings, selectedButton: $selectedButton)
                }

                // Right side: Face buttons (Nintendo layout)
                VStack(spacing: 2) {
                    ControllerButton(button: .X, settings: settings, selectedButton: $selectedButton)
                    HStack(spacing: 2) {
                        ControllerButton(button: .Y, settings: settings, selectedButton: $selectedButton)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 30, height: 30)
                            .cornerRadius(4)
                        ControllerButton(button: .A, settings: settings, selectedButton: $selectedButton)
                    }
                    ControllerButton(button: .B, settings: settings, selectedButton: $selectedButton)
                }
            }

            // Center buttons
            HStack(spacing: 20) {
                ControllerButton(button: .minus, settings: settings, selectedButton: $selectedButton)
                ControllerButton(button: .home, settings: settings, selectedButton: $selectedButton)
                ControllerButton(button: .capture, settings: settings, selectedButton: $selectedButton)
                ControllerButton(button: .plus, settings: settings, selectedButton: $selectedButton)
            }
        }
    }
}

struct ControllerButton: View {
    let button: GamepadButton
    @ObservedObject var settings: SettingsManager
    @Binding var selectedButton: GamepadButton?

    var isActive: Bool {
        settings.activeButtons.contains(button)
    }

    var isSelected: Bool {
        selectedButton == button
    }

    var hasMapping: Bool {
        settings.getMapping(for: button) != .none
    }

    var body: some View {
        Button(action: {
            selectedButton = button
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isActive ? button.color : (hasMapping ? button.color.opacity(0.3) : Color.gray.opacity(0.2)))
                    .frame(width: 30, height: 30)

                Text(button.shortLabel)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(isActive ? .white : (hasMapping ? button.color : .secondary))
            }
        }
        .buttonStyle(.plain)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isActive ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isActive)
    }
}
