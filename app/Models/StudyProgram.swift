// Transcript program data model

import Foundation

struct TranscriptProgram: Codable {
    let keyPoints: [String]
    let studyTasks: [String]
    let quizQuestions: [String]
    let generatedAt: Date
    var keywords: [String]? = []
}
