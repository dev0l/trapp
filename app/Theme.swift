// Centralized design tokens — edit here, propagates everywhere

import SwiftUI

// MARK: - Theme Mode

enum ThemeMode: String, CaseIterable {
  case trapp = "trapp"
  case system = "system"

  var label: String {
    switch self {
    case .trapp: return "Trapp"
    case .system: return "System"
    }
  }

  var colorScheme: ColorScheme? {
    switch self {
    case .trapp: return .dark
    case .system: return nil
    }
  }
}

// MARK: - Design Tokens

struct Theme {

  // Colors — Primary
  static let accent       = Color.indigo
  static let secondary    = Color.orange
  static let success      = Color.green

  // Colors — Section tints
  static let keyPoints    = Color.indigo
  static let studyTasks   = Color.orange
  static let quiz         = Color.teal

  // Colors — Surfaces
  static let cardBackground = Color(red: 0.157, green: 0.157, blue: 0.157) // #282828

  // Layout
  static let cornerRadius: CGFloat = 14
  static let buttonRadius: CGFloat = 10
  static let sectionSpacing: CGFloat = 20
  static let contentPadding: CGFloat = 20

  // Opacity
  static let buttonFillOpacity: Double = 0.1
  static let bannerOpacity: Double = 0.9
}
