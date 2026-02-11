// Study program data model

import Foundation

struct StudyProgram: Codable {
    let keyPoints: [String]
    let studyTasks: [String]
    let quizQuestions: [String]
    let generatedAt: Date
    var keywords: [String]? = []
}
