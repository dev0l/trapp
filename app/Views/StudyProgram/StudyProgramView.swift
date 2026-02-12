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
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // Key Points
                editableSection(
                    title: "Key Points",
                    icon: "lightbulb",
                    tint: Theme.keyPoints,
                    items: $program.keyPoints
                )

                Divider()
                    .padding(.vertical, 4)

                // Study Tasks
                editableSection(
                    title: "Study Tasks",
                    icon: "checklist",
                    tint: Theme.studyTasks,
                    items: $program.studyTasks
                )

                Divider()
                    .padding(.vertical, 4)

                // Quiz Questions
                editableSection(
                    title: "Quiz Questions",
                    icon: "questionmark.circle",
                    tint: Theme.quiz,
                    items: $program.quizQuestions
                )

                Divider()

                Text("Generated \(program.generatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(Theme.contentPadding)
        }
        .navigationTitle("Program")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            appState.updateProgram(for: transcriptId, program: program)
        }
    }

    @ViewBuilder
    private func editableSection(title: String, icon: String, tint: Color, items: Binding<[String]>) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon)
                .font(.title3.bold())
                .foregroundStyle(tint)

            if items.wrappedValue.isEmpty {
                Text("No items — tap + to add one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(items.wrappedValue.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1).")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 24, alignment: .trailing)

                        TextField("Edit item", text: items[index], axis: .vertical)
                            .font(.subheadline)
                            .lineLimit(1...5)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                var updated = items.wrappedValue
                                updated.remove(at: index)
                                items.wrappedValue = updated
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
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
        }
    }
}
