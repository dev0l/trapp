// Add new transcript view

import SwiftUI

struct AddTranscriptView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var rawText = ""
    @State private var date = Date()
    @State private var includeDate = false

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !rawText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Lecture title", text: $title)
                }

                Section("Transcript Body") {
                    TextEditor(text: $rawText)
                        .frame(minHeight: 150)
                }

                Section {
                    Toggle("Include date", isOn: $includeDate)
                    if includeDate {
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Transcript")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        appState.addTranscript(
                            title: title.trimmingCharacters(in: .whitespaces),
                            rawText: rawText.trimmingCharacters(in: .whitespaces),
                            date: includeDate ? date : nil
                        )
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
