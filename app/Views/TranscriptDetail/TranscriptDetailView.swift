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
                    VStack(alignment: .leading, spacing: 20) {
                        if let date = transcript.date {
                            Label(date.formatted(date: .long, time: .omitted), systemImage: "calendar")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Divider()

                        // Program section — placed above transcript for quick access
                        if let program = transcript.program {
                            NavigationLink(destination: TranscriptProgramView(program: program, transcriptTitle: transcript.title)) {
                                Label("View Program", systemImage: "list.clipboard")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.indigo.opacity(0.1))
                                    .foregroundStyle(.indigo)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
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
                            .tint(.orange)
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
                            .tint(.indigo)
                        }

                        Divider()

                        Text(transcript.rawText)
                            .font(.body)

                        Divider()

                        Text("Created \(transcript.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(20)
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
                .alert("Regenerate Program?", isPresented: $showingRegenerateAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Regenerate", role: .destructive) {
                        appState.generateProgram(for: transcriptId)
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
                            .background(.green.opacity(0.9))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
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
