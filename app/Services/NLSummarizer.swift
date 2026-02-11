// NLP helper using Apple's NaturalLanguage framework for signal extraction

import Foundation
import NaturalLanguage

struct NLSummarizer {

    // MARK: - Sentence Tokenization

    /// Extract sentences from text using NLTokenizer (handles abbreviations like "Dr.", "approx." correctly).
    static func extractSentences(from text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            return true
        }
        return sentences
    }

    // MARK: - Keyword Extraction

    /// Extract top keywords (nouns + named entities) ranked by frequency.
    static func extractKeywords(from text: String, limit: Int = 5) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
        tagger.string = text

        var frequency: [String: Int] = [:]
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]

        // Pass 1: Nouns via lexical class
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .word,
                             scheme: .lexicalClass,
                             options: options) { tag, range in
            if tag == .noun {
                let word = String(text[range]).lowercased()
                if word.count >= 3 { // skip trivial short words
                    frequency[word, default: 0] += 1
                }
            }
            return true
        }

        // Pass 2: Named entities (person, place, organization)
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .word,
                             scheme: .nameType,
                             options: options) { tag, range in
            if tag == .personalName || tag == .placeName || tag == .organizationName {
                let entity = String(text[range])
                if entity.count >= 2 {
                    // Named entities get a frequency boost to surface them
                    frequency[entity, default: 0] += 3
                }
            }
            return true
        }

        // Rank by frequency descending, return top N
        return frequency
            .sorted { $0.value > $1.value }
            .prefix(limit)
            .map { $0.key }
    }

    // MARK: - Language Detection

    /// Detect the dominant language of the text.
    static func detectLanguage(of text: String) -> NLLanguage? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage
    }

    // MARK: - Sentence Scoring

    /// Score sentences by information density: keyword overlap + cue-word bonus + length filtering.
    static func scoreSentences(
        _ sentences: [String],
        keywords: [String],
        language: NLLanguage?
    ) -> [(sentence: String, score: Double)] {
        let cueWords = cueWordsForLanguage(language)
        let lowercasedKeywords = keywords.map { $0.lowercased() }

        return sentences.compactMap { sentence in
            let words = sentence.split(separator: " ")
            let wordCount = words.count

            // Length penalty: ignore sentences < 5 or > 50 words
            guard wordCount >= 5, wordCount <= 50 else { return nil }

            var score = 1.0

            let lowercasedSentence = sentence.lowercased()

            // Keyword bonus: +1.0 per keyword occurrence
            for keyword in lowercasedKeywords {
                if lowercasedSentence.contains(keyword) {
                    score += 1.0
                }
            }

            // Cue-word bonus: +2.0 if sentence contains any cue word
            for cue in cueWords {
                if lowercasedSentence.contains(cue) {
                    score += 2.0
                    break // only one cue bonus per sentence
                }
            }

            return (sentence: sentence, score: score)
        }
    }

    // MARK: - Cue Words

    private static func cueWordsForLanguage(_ language: NLLanguage?) -> [String] {
        let english = [
            "important", "remember", "summary", "definition",
            "exam", "key", "critical", "essential"
        ]
        let swedish = [
            "viktigt", "tenta", "sammanfattning", "definition",
            "kom ihåg"
        ]

        guard let lang = language else { return english + swedish }

        switch lang {
        case .swedish:
            return swedish
        case .english:
            return english
        default:
            return english + swedish
        }
    }

    // MARK: - Utility

    /// Count words in a string.
    static func wordCount(_ text: String) -> Int {
        text.split(separator: " ").count
    }
}
