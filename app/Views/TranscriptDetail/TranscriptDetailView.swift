// Transcript detail and generation view

import SwiftUI

struct TranscriptDetailView: View {
    let transcript: Transcript

    var body: some View {
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

                Text("Created \(transcript.createdAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .navigationTitle(transcript.title)
        .navigationBarTitleDisplayMode(.large)
    }
}
