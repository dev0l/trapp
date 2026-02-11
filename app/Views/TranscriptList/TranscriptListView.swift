// Main transcript list view

import SwiftUI

struct TranscriptListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if appState.transcripts.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No transcripts yet")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Button("Add Your First Transcript") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(appState.transcripts) { transcript in
                            NavigationLink(destination: TranscriptDetailView(transcriptId: transcript.id)) {
                                VStack(alignment: .leading, spacing: 4) {
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
                                            .foregroundStyle(.green)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: deleteTranscripts)
                    }
                }
            }
            .navigationTitle("Transcripts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
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
