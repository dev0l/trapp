# trapp — Transcript & Program

iOS application for transforming lecture transcripts into structured study programs.

## How to Run

1. Open Xcode → **File > New > Project** → iOS App (SwiftUI, Swift)
2. Name the project **Trapp**, create it anywhere temporary
3. Replace the generated Swift files with the contents of the `app/` directory:
   - Delete the auto-generated `ContentView.swift` and `TrappApp.swift`
   - Add all files from `app/` into the Xcode project (drag & drop, check "Copy items if needed")
   - **Note:** also add `import Combine` is already included in `AppState.swift`
4. **Build & Run** (`⌘R`) on iOS Simulator (iOS 16+)

> **Tip:** If your Xcode project already includes the sources, just **⌘B** to rebuild after pulling changes.

## What Works

- **Transcript list** — shows all saved transcripts, or an empty-state prompt
- **Add transcript** — form with title (60 char limit with counter), body text, and optional date
- **Edit transcript** — tap a transcript → Edit button → modify and save
- **Delete transcript** — swipe left on any list item to delete
- **Local persistence** — transcripts saved as JSON in Documents directory; survives app restart
- **Detail view** — tap a transcript to see its full content
- **Program generation** — deterministic heuristic: extracts key points, study tasks, and quiz questions
- **Study program view** — view generated program with numbered sections
- **Navigation** — full NavigationStack flow: list → add (sheet) / detail (push) → edit (sheet) / program (push)

## Foundation Structure

- **TrappApp.swift** — SwiftUI app entry point
- **AppState.swift** — Root state management (ObservableObject)
- **Models/** — Data models (Transcript, StudyProgram, Summary)
- **Views/** — SwiftUI views organized by user flow
- **Services/** — Business logic (ProgramGenerator, Persistence, Authentication stub)
- **Resources/** — Localization and assets

## Status

Minimal functional app with full CRUD and study program generation.  
Authentication remains as a stub for future implementation.
