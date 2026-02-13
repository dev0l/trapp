// Onboarding welcome sheet

import SwiftUI

struct OnboardingView: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 32) {
      Spacer()
      
      // Hero
      VStack(spacing: 16) {
        Image(systemName: "waveform.and.magnifyingglass")
          .font(.system(size: 72, weight: .thin))
          .foregroundStyle(Theme.accent)
        
        Text("Welcome to Trapp")
          .font(.largeTitle.bold())
          .multilineTextAlignment(.center)
        
        Text("Turn chaos into structure.")
          .font(.title3)
          .foregroundStyle(.secondary)
      }
      .padding(.bottom, 24)
      
      // Features
      VStack(alignment: .leading, spacing: 24) {
        featureRow(icon: "doc.text", title: "Transform Notes", description: "Paste transcripts or import text files to generate structured study plans.")
        
        featureRow(icon: "list.clipboard", title: "Actionable Programs", description: "Get key points, study tasks, and conceptual quiz questions instantly.")
        
        featureRow(icon: "lock.shield", title: "Privacy First", description: "Everything stays on your device. No cloud processing, no data tracking.")
      }
      .padding(.horizontal)
      
      Spacer()
      
      // Action
      Button {
        dismiss()
      } label: {
        Text("Get Started")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Theme.accent)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 20)
    }
    .padding(Theme.contentPadding)
  }
  
  private func featureRow(icon: String, title: String, description: String) -> some View {
    HStack(spacing: 16) {
      Image(systemName: icon)
        .font(.title.bold())
        .foregroundStyle(Theme.accent)
        .frame(width: 40)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.headline)
        Text(description)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}
