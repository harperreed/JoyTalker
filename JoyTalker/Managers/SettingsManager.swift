// ABOUTME: Manages button-to-key mappings with persistence via UserDefaults.
// ABOUTME: Singleton shared across the app, publishes changes for SwiftUI observation.

import Foundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    @Published var mappings: [GamepadButton: KeyMapping] = [:]
    @Published var isConnected = false
    @Published var activeButtons: Set<GamepadButton> = []

    init() {
        loadMappings()
    }

    func loadMappings() {
        for button in GamepadButton.allCases {
            if let data = UserDefaults.standard.data(forKey: button.defaultsKey),
               let mapping = try? JSONDecoder().decode(KeyMapping.self, from: data) {
                mappings[button] = mapping
            } else {
                mappings[button] = button.defaultMapping
            }
        }
    }

    func setMapping(_ mapping: KeyMapping, for button: GamepadButton) {
        mappings[button] = mapping
        if let data = try? JSONEncoder().encode(mapping) {
            UserDefaults.standard.set(data, forKey: button.defaultsKey)
        }
        NotificationCenter.default.post(name: .mappingsChanged, object: nil)
    }

    func getMapping(for button: GamepadButton) -> KeyMapping {
        return mappings[button] ?? button.defaultMapping
    }
}

extension Notification.Name {
    static let mappingsChanged = Notification.Name("mappingsChanged")
}
