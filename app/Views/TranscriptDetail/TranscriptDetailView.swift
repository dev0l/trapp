// Transcript detail and generation view

import SwiftUI

struct TranscriptDetailView: View {
    @EnvironmentObject var appState: AppState
    let transcriptId: UUID

    @State private var showingEditSheet = false

    /// Live lookup so edits propagate immediately.
    private var transcript: Transcript? {
        appState.transcripts.first { $0.id == transcriptId }
    }

    var body: some View {
        Group {
            if let transcript = transcript {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let date = transcript.date {
                            Label(date.formatted(date: .long, time: .omitted), systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        Text(transcript.rawText)
                            .font(.body)

                        Divider()

                        // Program section
                        if let program = transcript.program {
                            NavigationLink(destination: StudyProgramView(program: program, transcriptTitle: transcript.title)) {
                                Label("View Study Program", systemImage: "list.clipboard.fill")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.blue.opacity(0.1))
                                    .foregroundStyle(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Button {
                                appState.generateProgram(for: transcriptId)
                            } label: {
                                Label("Generate Study Program", systemImage: "sparkles")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        Divider()

                        Text("Created \(transcript.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                }
                .navigationTitle(transcript.title)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
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
            } else {
                Text("Transcript not found")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
