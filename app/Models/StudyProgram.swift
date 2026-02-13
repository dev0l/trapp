// Transcript program data model

import Foundation

struct TranscriptProgram: Codable {
  var keyPoints: [String]
  var studyTasks: [String]
  var quizQuestions: [String]
  let generatedAt: Date
  var keywords: [String]? = []
}
