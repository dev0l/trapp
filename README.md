# trapp — Transcript & Program

iOS application for transforming lecture transcripts into structured study programs.

## How to Run

1. Open Xcode → **File > New > Project** → iOS App (SwiftUI, Swift)
2. Name the project **Trapp**, create it anywhere temporary
3. Replace the generated Swift files with the contents of the `app/` directory:
   - Delete the auto-generated `ContentView.swift`
   - Add all files from `app/` into the Xcode project (drag & drop, check "Copy items if needed")
4. **Build & Run** (`⌘R`) on iOS Simulator (iOS 16+)

> **Tip:** If your Xcode project already includes the sources, just **⌘B** to rebuild after pulling changes.

## What Works

- **Transcript list** — shows all saved transcripts, or an empty-state prompt
- **Add transcript** — form with title, body text, and optional date; validates before saving
- **Local persistence** — transcripts saved as JSON in the app's Documents directory; survives app restart
- **Detail view** — tap a transcript to see its full content
- **Navigation** — full NavigationStack flow: list → add (sheet) → detail (push)

## Foundation Structure

- **TrappApp.swift** — SwiftUI app entry point
- **AppState.swift** — Root state management (ObservableObject)
- **Models/** — Data models (Transcript, Summary)
- **Views/** — SwiftUI views organized by user flow
- **Services/** — Business logic (Authentication, Persistence, Program Generation)
- **Resources/** — Localization and assets

## Status

Minimal functional app — local transcript CRUD flow complete.  
Authentication and program generation remain as stubs for future implementation.
