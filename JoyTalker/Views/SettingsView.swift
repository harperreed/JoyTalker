// ABOUTME: Main settings window with split layout - controller visual on left, config on right.
// ABOUTME: Entry point for user interaction with button mappings.

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = SettingsManager.shared
    @State private var selectedButton: GamepadButton? = nil

    var body: some View {
        HStack(spacing: 0) {
            // Left side: Controller layout
            VStack {
                Text("8BitDo Micro")
                    .font(.headline)
                    .padding(.top)

                ControllerView(settings: settings, selectedButton: $selectedButton)
                    .padding()

                HStack {
                    Circle()
                        .fill(settings.isConnected ? .green : .gray)
                        .frame(width: 10, height: 10)
                    Text(settings.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .frame(width: 280)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Right side: Button configuration
            VStack(spacing: 0) {
                if let button = selectedButton {
                    ButtonConfigView(button: button, settings: settings)
                } else {
                    VStack {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Select a button to configure")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Divider()

                HStack {
                    Button("Reset All") {
                        for button in GamepadButton.allCases {
                            settings.setMapping(button.defaultMapping, for: button)
                        }
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding()
            }
            .frame(width: 300)
        }
        .frame(width: 580, height: 500)
    }
}
