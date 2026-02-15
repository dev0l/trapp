// Summary data model

import Foundation

struct Summary: Codable, Identifiable {
  let id: UUID
  let transcriptId: UUID
  let bulletPoints: [String]
  let programSteps: [String]
  let createdAt: Date
}
