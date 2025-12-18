// ABOUTME: Main app entry point for JoyTalker menu bar application.
// ABOUTME: Defines the SwiftUI App structure with settings window scene.

import SwiftUI

@main
struct JoyTalkerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
        Window("JoyTalker", id: "settings") {
            SettingsView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 580, height: 500)
    }
}
