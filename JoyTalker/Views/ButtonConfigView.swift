// ABOUTME: Configuration panel for individual button mappings.
// ABOUTME: Supports custom key recording and preset selection.

import SwiftUI

struct ButtonConfigView: View {
    let button: GamepadButton
    @ObservedObject var settings: SettingsManager
    @StateObject private var keyRecorder = KeyRecorder()

    var currentMapping: KeyMapping {
        settings.getMapping(for: button)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: button.symbol)
                    .font(.title)
                    .foregroundColor(button.color)
                Text(button.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(.top)

            Divider()

            // Current mapping
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Mapping")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(currentMapping.displayName.isEmpty ? "None" : currentMapping.displayName)
                    .font(.system(.title3, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(8)
            }

            // Record button
            Button(action: {
                if keyRecorder.isRecording {
                    keyRecorder.stopRecording()
                } else {
                    keyRecorder.startRecording { mapping in
                        settings.setMapping(mapping, for: button)
                    }
                }
            }) {
                HStack {
                    Image(systemName: keyRecorder.isRecording ? "stop.circle.fill" : "record.circle")
                    Text(keyRecorder.isRecording ? "Cancel Recording" : "Record Custom Key")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(keyRecorder.isRecording ? .red : .accentColor)

            if keyRecorder.isRecording {
                Text("Press any key or key combination...")
                    .font(.caption)
                    .foregroundColor(.orange)
            }

            // Presets
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Presets")
                    .font(.caption)
                    .foregroundColor(.secondary)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(PresetAction.allCases) { preset in
                        Button(preset.rawValue) {
                            settings.setMapping(preset.toKeyMapping(), for: button)
                        }
                        .buttonStyle(.bordered)
                        .font(.caption)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
