// Home screen — calm, spacious, inviting

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                // Hero area
                VStack(spacing: 16) {
                    Image(systemName: "waveform.and.magnifyingglass")
                        .font(.system(size: 56, weight: .thin))
                        .foregroundStyle(.indigo)

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
                            .foregroundStyle(.indigo)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Traps")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(trapCountLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)

                Spacer()
                    .frame(height: 60)
            }
        }
    }

    private var trapCountLabel: String {
        let count = appState.transcripts.count
        switch count {
        case 0: return "No traps yet — start by adding one"
        case 1: return "1 trap"
        default: return "\(count) traps"
        }
    }
}
