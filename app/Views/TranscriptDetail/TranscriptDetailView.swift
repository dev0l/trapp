// Transcript detail and generation view

import SwiftUI

struct TranscriptDetailView: View {
  @EnvironmentObject var appState: AppState
  let transcriptId: UUID

  @State private var showingEditSheet = false
  @State private var showingRegenerateAlert = false
  @State private var showRegenerateBanner = false

  /// Live lookup so edits propagate immediately.
  private var transcript: Transcript? {
    appState.transcripts.first { $0.id == transcriptId }
  }

  var body: some View {
    Group {
      if let transcript = transcript {
        ScrollView {
          VStack(alignment: .leading, spacing: Theme.sectionSpacing) {
            if let date = transcript.date {
              Label(date.formatted(date: .long, time: .omitted), systemImage: "calendar")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            Divider()

            // Program section — placed above transcript for quick access
            if let program = transcript.program {
              NavigationLink(destination: TranscriptProgramView(transcriptId: transcriptId, program: program)) {
                Label("View Program", systemImage: "list.clipboard")
                  .font(.headline)
                  .padding()
                  .frame(maxWidth: .infinity)
                  .background(Theme.accent.opacity(Theme.buttonFillOpacity))
                  .foregroundStyle(Theme.accent)
                  .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
              }

              Button {
                showingRegenerateAlert = true
              } label: {
                Label("Regenerate", systemImage: "arrow.trianglehead.2.counterclockwise")
                  .font(.subheadline)
                  .padding(.vertical, 8)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.bordered)
              .tint(Theme.secondary)
            } else {
              Button {
                appState.generateProgram(for: transcriptId)
              } label: {
                Label("Generate Program", systemImage: "sparkles")
                  .font(.headline)
                  .padding()
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.borderedProminent)
            }

            Divider()

            Text(transcript.rawText)
              .font(.body)

            Divider()

            Text("Created \(transcript.createdAt.formatted(date: .abbreviated, time: .shortened))")
              .font(.caption)
              .foregroundStyle(.tertiary)
          }
          .padding(Theme.contentPadding)
        }
        .navigationTitle(transcript.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Image(systemName: "person.crop.circle")
              .foregroundStyle(Theme.accent)
          }
          ToolbarItem(placement: .primaryAction) {
            Button("Edit") {
              showingEditSheet = true
            }
          }
        }
        .sheet(isPresented: $showingEditSheet) {
          AddTranscriptView(existingTranscript: transcript)
            .environmentObject(appState)
        }
        .alert("Regenerate Program?", isPresented: $showingRegenerateAlert) {
          Button("Cancel", role: .cancel) { }
          Button("Regenerate", role: .destructive) {
            HapticManager.shared.play(.medium)
            appState.generateProgram(for: transcriptId)
            HapticManager.shared.notify(.success)
            showRegenerateBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              withAnimation { showRegenerateBanner = false }
            }
          }
        } message: {
          Text("This will replace the current program with a freshly generated one.")
        }
        .overlay(alignment: .top) {
          if showRegenerateBanner {
            Label("Program regenerated", systemImage: "checkmark.circle.fill")
              .font(.subheadline.bold())
              .padding()
              .frame(maxWidth: .infinity)
              .background(Theme.success.opacity(Theme.bannerOpacity))
              .foregroundStyle(.white)
              .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
              .padding(.horizontal)
              .transition(.move(edge: .top).combined(with: .opacity))
          }
        }
        .animation(.easeInOut, value: showRegenerateBanner)
      } else {
        Text("Trap not found")
          .foregroundStyle(.secondary)
      }
    }
  }
}
