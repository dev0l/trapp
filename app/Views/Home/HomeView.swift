// Home screen — calm, spacious, inviting

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var appState: AppState
  @AppStorage("themeMode") private var themeMode: String = ThemeMode.trapp.rawValue
  @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
  @State private var showingSettings = false

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        Spacer()

        // Hero area
        VStack(spacing: 16) {
          Image(systemName: "waveform.and.magnifyingglass")
            .font(.system(size: 56, weight: .thin))
            .foregroundStyle(Theme.accent)

          Text("Trapp")
            .font(.largeTitle.bold())

          Text("Transcripts become programs.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }

        Spacer()

        // Quick action card
        NavigationLink(destination: TranscriptListView()) {
          HStack(spacing: 16) {
            Image(systemName: "tray.full")
              .font(.title2)
              .foregroundStyle(Theme.accent)

            VStack(alignment: .leading, spacing: 4) {
              Text("Your Traps")
                .font(.headline)
                .foregroundStyle(Theme.accent)

              Text(trapCountLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
              .font(.subheadline)
              .foregroundStyle(.tertiary)
          }
          .padding(Theme.contentPadding)
          .background(Theme.cardBackground)
          .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 24)

        Spacer()
          .frame(height: 60)
      }
      .toolbar {
        /*
        ToolbarItem(placement: .topBarTrailing) {
          Image(systemName: "person.crop.circle")
            .font(.subheadline)
            .foregroundStyle(Theme.accent)
        }
        */
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            showingSettings = true
          } label: {
            Image(systemName: "gearshape")
              .font(.subheadline)
          }
        }
      }
      .sheet(isPresented: $showingSettings) {
        settingsSheet
      }
      .sheet(isPresented: Binding(
        get: { !hasSeenOnboarding },
        set: { hasSeenOnboarding = !$0 }
      )) {
        OnboardingView()
      }
    }
  }

  // MARK: - Settings Sheet

  private var settingsSheet: some View {
    NavigationStack {
      Form {
        Section("Appearance") {
          Picker("Theme", selection: $themeMode) {
            ForEach(ThemeMode.allCases, id: \.rawValue) { mode in
              Text(mode.label).tag(mode.rawValue)
            }
          }
          .pickerStyle(.segmented)
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            showingSettings = false
          }
        }
      }
    }
    .presentationDetents([.medium])
  }

  // MARK: - Helpers

  private var trapCountLabel: String {
    let count = appState.transcripts.count
    switch count {
    case 0: return "No traps yet — start by adding one"
    case 1: return "1 trap"
    default: return "\(count) traps"
    }
  }
}
