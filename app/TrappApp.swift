// Trapp iOS App entry point

import SwiftUI

@main
struct TrappApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            TranscriptListView()
                .environmentObject(appState)
        }
    }
}
