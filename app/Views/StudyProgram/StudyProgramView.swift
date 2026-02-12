// Transcript program display + edit view

import SwiftUI

struct TranscriptProgramView: View {
    @EnvironmentObject var appState: AppState
    let transcriptId: UUID

    /// Local working copy — saved back on disappear.
    @State private var program: TranscriptProgram

    init(transcriptId: UUID, program: TranscriptProgram) {
        self.transcriptId = transcriptId
        self._program = State(initialValue: program)
    }

    var body: some View {
        List {
            // Key Points
            editableSection(
                title: "Key Points",
                icon: "lightbulb",
                tint: Theme.keyPoints,
                items: $program.keyPoints
            )

            // Study Tasks
            editableSection(
                title: "Study Tasks",
                icon: "checklist",
                tint: Theme.studyTasks,
                items: $program.studyTasks
            )

            // Quiz Questions
            editableSection(
                title: "Quiz Questions",
                icon: "questionmark.circle",
                tint: Theme.quiz,
                items: $program.quizQuestions
            )

            // Footer
            Section {
                Text("Generated \(program.generatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Program")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                EditButton()
            }
        }
        .onDisappear {
            appState.updateProgram(for: transcriptId, program: program)
        }
    }

    @ViewBuilder
    private func editableSection(title: String, icon: String, tint: Color, items: Binding<[String]>) -> some View {
        Section {
            if items.wrappedValue.isEmpty {
                Text("No items — tap + to add one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(items.wrappedValue.indices, id: \.self) { index in
                    TextField(title, text: items[index], axis: .vertical)
                        .font(.subheadline)
                        .lineLimit(1...5)
                }
                .onDelete { offsets in
                    withAnimation {
                        var updated = items.wrappedValue
                        updated.remove(atOffsets: offsets)
                        items.wrappedValue = updated
                    }
                }
                .onMove { source, destination in
                    var updated = items.wrappedValue
                    updated.move(fromOffsets: source, toOffset: destination)
                    items.wrappedValue = updated
                }
            }

            Button {
                withAnimation {
                    items.wrappedValue.append("")
                }
            } label: {
                Label("Add", systemImage: "plus.circle")
                    .font(.subheadline)
                    .foregroundStyle(tint)
            }
        } header: {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
        }
    }
}
