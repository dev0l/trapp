// Transcript program display view

import SwiftUI

struct TranscriptProgramView: View {
    let program: TranscriptProgram
    let transcriptTitle: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // Key Points
                programSection(
                    title: "Key Points",
                    icon: "lightbulb",
                    tint: .indigo,
                    items: program.keyPoints
                )

                Divider()
                    .padding(.vertical, 4)

                // Study Tasks
                programSection(
                    title: "Study Tasks",
                    icon: "checklist",
                    tint: .orange,
                    items: program.studyTasks
                )

                Divider()
                    .padding(.vertical, 4)

                // Quiz Questions
                programSection(
                    title: "Quiz Questions",
                    icon: "questionmark.circle",
                    tint: .teal,
                    items: program.quizQuestions
                )

                Divider()

                Text("Generated \(program.generatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(20)
        }
        .navigationTitle("Program")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func programSection(title: String, icon: String, tint: Color, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon)
                .font(.title3.bold())
                .foregroundStyle(tint)

            if items.isEmpty {
                Text("No items generated — try a longer transcript.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1).")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 24, alignment: .trailing)
                        Text(item)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}
