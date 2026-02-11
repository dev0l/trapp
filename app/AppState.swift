// Root app state container

import Combine
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
            createdAt: Date(),
            program: nil
        )
        transcripts.append(transcript)
        persistence.save(transcripts)
    }

    func deleteTranscript(id: UUID) {
        transcripts.removeAll { $0.id == id }
        persistence.save(transcripts)
    }

    func updateTranscript(_ updated: Transcript) {
        guard let index = transcripts.firstIndex(where: { $0.id == updated.id }) else { return }
        transcripts[index] = updated
        persistence.save(transcripts)
    }

    func generateProgram(for transcriptId: UUID) {
        guard let index = transcripts.firstIndex(where: { $0.id == transcriptId }) else { return }
        let text = transcripts[index].rawText
        let program = ProgramGenerator.generate(from: text)
        transcripts[index].program = program
        persistence.save(transcripts)
    }
}
