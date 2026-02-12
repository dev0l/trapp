// Trapp iOS App entry point

import SwiftUI

@main
struct TrappApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.trapp.rawValue

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appState)
                .tint(Theme.accent)
                .preferredColorScheme(currentTheme.colorScheme)
        }
    }

    private var currentTheme: ThemeMode {
        ThemeMode(rawValue: themeMode) ?? .trapp
    }
}
