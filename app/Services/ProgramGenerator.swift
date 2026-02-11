// Rule-based summary and program step generation

import Foundation

struct ProgramGenerator {

    /// Generate a study program from raw transcript text using deterministic heuristics.
    static func generate(from text: String) -> StudyProgram {
        let sentences = extractSentences(from: text)
        let substantive = sentences.filter { wordCount($0) >= 5 }

        let keyPoints = extractKeyPoints(from: substantive)
        let studyTasks = generateStudyTasks(from: keyPoints)
        let quizQuestions = generateQuizQuestions(from: substantive)

        return StudyProgram(
            keyPoints: keyPoints,
            studyTasks: studyTasks,
            quizQuestions: quizQuestions,
            generatedAt: Date()
        )
    }

    // MARK: - Sentence Extraction

    private static func extractSentences(from text: String) -> [String] {
        // Split on sentence-ending punctuation and newlines
        let separators = CharacterSet(charactersIn: ".!?\n")
        return text
            .components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private static func wordCount(_ text: String) -> Int {
        text.split(separator: " ").count
    }

    // MARK: - Key Points

    private static func extractKeyPoints(from sentences: [String]) -> [String] {
        // Take the longest / most substantive sentences, up to 10
        let sorted = sentences.sorted { wordCount($0) > wordCount($1) }
        let selected = Array(sorted.prefix(10))
        // Return in original order for readability
        return sentences.filter { selected.contains($0) }
    }

    // MARK: - Study Tasks

    private static func generateStudyTasks(from keyPoints: [String]) -> [String] {
        let prefixes = [
            "Review and understand: ",
            "Explain in your own words: ",
            "Summarize the concept: ",
            "Create an example for: ",
            "Connect to prior knowledge: "
        ]

        var tasks: [String] = []
        for (index, point) in keyPoints.enumerated() {
            let prefix = prefixes[index % prefixes.count]
            // Lowercase the first character of the point for natural reading
            let lowerPoint = point.prefix(1).lowercased() + point.dropFirst()
            tasks.append(prefix + lowerPoint)
            if tasks.count >= 10 { break }
        }
        return tasks
    }

    // MARK: - Quiz Questions

    private static func generateQuizQuestions(from sentences: [String]) -> [String] {
        let starters = [
            "What is the significance of ",
            "Why is it important that ",
            "How does the concept of ",
            "What would happen if ",
            "Can you explain why "
        ]

        // Pick sentences spread across the text for variety
        let step = max(1, sentences.count / 5)
        var questions: [String] = []

        for i in stride(from: 0, to: sentences.count, by: step) {
            if questions.count >= 5 { break }
            let sentence = sentences[i]
            let starter = starters[questions.count % starters.count]
            // Extract the core topic (first ~8 words) for a concise question
            let words = sentence.split(separator: " ")
            let topic = words.prefix(8).joined(separator: " ").lowercased()
            questions.append(starter + topic + "?")
        }
        return questions
    }
}
