// Local persistence using FileManager and JSON

import Foundation

struct PersistenceService {

  private static let fileName = "transcripts.json"

  private var fileURL: URL {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent(Self.fileName)
  }

  func save(_ transcripts: [Transcript]) {
    do {
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      let data = try encoder.encode(transcripts)
      try data.write(to: fileURL, options: .atomic)
    } catch {
      print("[PersistenceService] Save failed: \(error)")
    }
  }

  func load() -> [Transcript] {
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
      return []
    }
    do {
      let data = try Data(contentsOf: fileURL)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode([Transcript].self, from: data)
    } catch {
      print("[PersistenceService] Load failed: \(error)")
      return []
    }
  }
}
