// Transcript data model

import Foundation

struct Transcript: Codable, Identifiable {
  let id: UUID
  var title: String
  var date: Date?
  var rawText: String
  let createdAt: Date
  var program: TranscriptProgram?
}
