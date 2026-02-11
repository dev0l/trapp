// Program generation using NaturalLanguage-based signal extraction

import Foundation
import NaturalLanguage

struct ProgramGenerator {

    /// Generate a study program from raw transcript text using NLP-based heuristics.
    static func generate(from text: String) -> StudyProgram {
        let sentences = NLSummarizer.extractSentences(from: text)
        let keywords = NLSummarizer.extractKeywords(from: text, limit: 5)
        let language = NLSummarizer.detectLanguage(of: text)

        let keyPoints = extractKeyPoints(sentences: sentences, keywords: keywords, language: language)
        let studyTasks = generateStudyTasks(from: keywords)
        let quizQuestions = generateQuizQuestions(from: keywords, sentences: sentences, language: language)

        return StudyProgram(
            keyPoints: keyPoints,
            studyTasks: studyTasks,
            quizQuestions: quizQuestions,
            generatedAt: Date(),
            keywords: keywords
        )
    }

    // MARK: - Key Points (scored sentence selection)

    private static func extractKeyPoints(
        sentences: [String],
        keywords: [String],
        language: NLLanguage?
    ) -> [String] {
        let scored = NLSummarizer.scoreSentences(sentences, keywords: keywords, language: language)

        // Take top 5-7 highest-scored unique sentences
        let topSentences = scored
            .sorted { $0.score > $1.score }
            .prefix(7)
            .map { $0.sentence }

        // Return in original order for readability
        return sentences.filter { topSentences.contains($0) }
    }

    // MARK: - Study Tasks (keyword-template approach)

    private static func generateStudyTasks(from keywords: [String]) -> [String] {
        let templates = [
            "Explain the concept of **%@** in your own words.",
            "Connect **%@** to other concepts mentioned.",
            "Summarize the importance of **%@**."
        ]

        var tasks: [String] = []
        for (index, keyword) in keywords.enumerated() {
            let template = templates[index % templates.count]
            tasks.append(String(format: template, keyword))
        }

        // If fewer than 3 keywords, pad with generic tasks from available keywords
        if tasks.isEmpty {
            tasks.append("Review the transcript and identify the main topic.")
            tasks.append("Summarize the transcript in three sentences.")
        }

        return tasks
    }

    // MARK: - Quiz Questions (keyword-focused + fallback)

    private static func generateQuizQuestions(
        from keywords: [String],
        sentences: [String],
        language: NLLanguage?
    ) -> [String] {
        var questions: [String] = []

        if keywords.count >= 3 {
            // Keyword-based focused questions
            let templates = [
                "What is the primary function of **%@**?",
                "How does **%@** relate to the main topic?",
                "Define **%@** and give an example."
            ]
            for (index, keyword) in keywords.enumerated() {
                if questions.count >= 5 { break }
                let template = templates[index % templates.count]
                questions.append(String(format: template, keyword))
            }
        } else {
            // Fallback: use top-scored sentences for fill-in-the-blank style
            let scored = NLSummarizer.scoreSentences(sentences, keywords: keywords, language: language)
            let topSentences = scored
                .sorted { $0.score > $1.score }
                .prefix(5)

            for item in topSentences {
                let words = item.sentence.split(separator: " ")
                if words.count >= 6 {
                    let halfPoint = words.count / 2
                    let firstHalf = words.prefix(halfPoint).joined(separator: " ")
                    questions.append("Complete this statement: \(firstHalf)...")
                } else {
                    questions.append("True or False: \(item.sentence)")
                }
            }

            // Always ensure at least one question
            if questions.isEmpty {
                questions.append("What is the main idea of this transcript?")
            }
        }

        return questions
    }
}
