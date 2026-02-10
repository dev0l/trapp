// Root app state container

import SwiftUI

class AppState: ObservableObject {

    @Published var transcripts: [Transcript] = []

    private let persistence = PersistenceService()

    init() {
        loadTranscripts()
    }

    func loadTranscripts() {
        transcripts = persistence.load()
    }

    func addTranscript(title: String, rawText: String, date: Date?) {
        let transcript = Transcript(
            id: UUID(),
            title: title,
            date: date,
            rawText: rawText,
            createdAt: Date()
        )
        transcripts.append(transcript)
        persistence.save(transcripts)
    }
}
