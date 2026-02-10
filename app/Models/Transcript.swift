// Transcript data model

import Foundation

struct Transcript: Codable, Identifiable {
    let id: UUID
    let title: String
    var date: Date?
    let rawText: String
    let createdAt: Date
}
