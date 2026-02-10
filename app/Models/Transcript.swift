// Transcript data model

import Foundation

struct Transcript: Codable, Identifiable {
    let id: UUID
    let title: String
    let course: String
    let date: Date
    let tags: [String]
    let rawText: String
    let createdAt: Date
}
