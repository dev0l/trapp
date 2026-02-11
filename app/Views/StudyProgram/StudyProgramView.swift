// Study program display view

import SwiftUI

struct StudyProgramView: View {
    let program: StudyProgram
    let transcriptTitle: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Key Points
                programSection(
                    title: "Key Points",
                    icon: "lightbulb.fill",
                    items: program.keyPoints
                )

                Divider()

                // Study Tasks
                programSection(
                    title: "Study Tasks",
                    icon: "checklist",
                    items: program.studyTasks
                )

                Divider()

                // Quiz Questions
                programSection(
                    title: "Quiz Questions",
                    icon: "questionmark.circle.fill",
                    items: program.quizQuestions
                )

                Divider()

                Text("Generated \(program.generatedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .navigationTitle("Study Program")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func programSection(title: String, icon: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.title3.bold())

            if items.isEmpty {
                Text("No items generated — try a longer transcript.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 8) {
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
