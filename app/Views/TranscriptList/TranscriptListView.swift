// Main trap list view

import SwiftUI

struct TranscriptListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if appState.transcripts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "tray")
                            .font(.system(size: 48))
                            .foregroundStyle(.indigo.opacity(0.5))
                        Text("No traps yet")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Button("Add Your First Trap") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.indigo)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(appState.transcripts) { transcript in
                            NavigationLink(destination: TranscriptDetailView(transcriptId: transcript.id)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(transcript.title)
                                        .font(.headline)
                                    if let date = transcript.date {
                                        Text(date, style: .date)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(transcript.rawText)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                    if transcript.program != nil {
                                        Label("Program generated", systemImage: "checkmark.seal.fill")
                                            .font(.caption2)
                                            .foregroundStyle(.indigo)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteTranscripts)
                    }
                }
            }
            .navigationTitle("Traps")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.indigo)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTranscriptView()
                    .environmentObject(appState)
            }
        }
    }

    private func deleteTranscripts(at offsets: IndexSet) {
        for index in offsets {
            let transcript = appState.transcripts[index]
            appState.deleteTranscript(id: transcript.id)
        }
    }
}
