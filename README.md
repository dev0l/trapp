# Trapp — Turn Chaos into Structure

**Transcripts become programs.**

Trapp automatically transforms your lecture transcripts, notes, and raw text into clear, actionable study plans. We leverage on-device processing to generate key points, specific study tasks, and conceptual quiz questions, giving you a structured path to mastery without compromising your privacy.

## Key Features

### 📄 Transform Notes
Import text files or paste transcripts directly to instantly generate structured study material. No more scrolling through endless walls of text.

### ✅ Actionable Programs
Break down dense information into manageable components:
-   **Key Points**: Understand core concepts quickly.
-   **Study Tasks**: Follow a step-by-step learning path.
-   **Quiz Questions**: Test your understanding with auto-generated conceptual questions.

### 🔒 Privacy First
Everything stays on your device. All processing happens locally—no cloud uploads, no data tracking. Your study materials are yours alone.

### 📚 Study Mode
Track your progress through tasks and measure your retention as you complete your program.

---

## Development & Build Instructions

For developers contributing to the project or building from source:

1.  **Open Xcode**: File > New > Project > iOS App (SwiftUI, Swift).
2.  **Setup**: Name the project **Trapp**.
3.  **Import Sources**: Replace the generated files with the contents of the `Trapp/app/` directory:
    -   Delete the auto-generated `ContentView.swift` and `TrappApp.swift`.
    -   Add all files from `app/` into the Xcode project (drag & drop, check "Copy items if needed").
4.  **Configuration**: Ensure `import Combine` is available (standard in iOS SDK).
5.  **Build & Run**: Use `⌘R` on the iOS Simulator (iOS 16+).

> **Note**: This is a minimal functional app with full CRUD capabilities and local study program generation logic. Authentication is currently implemented as a stub for future extensions.
