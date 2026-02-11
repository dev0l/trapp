// Add or edit transcript view

import SwiftUI

struct AddTranscriptView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    /// Pass an existing transcript to enter edit mode; nil for add mode.
    var existingTranscript: Transcript?

    @State private var title = ""
    @State private var rawText = ""
    @State private var date = Date()
    @State private var includeDate = false

    private let titleLimit = 60

    private var isEditing: Bool { existingTranscript != nil }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Lecture title", text: $title)
                        .onChange(of: title) { _, newValue in
                            if newValue.count > titleLimit {
                                title = String(newValue.prefix(titleLimit))
                            }
                        }
                    Text("\(title.count)/\(titleLimit)")
                        .font(.caption2)
                        .foregroundStyle(title.count >= titleLimit ? .red : .secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } header: {
                    Text("Title")
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
            .navigationTitle(isEditing ? "Edit Transcript" : "Add Transcript")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTranscript()
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                if let existing = existingTranscript {
                    title = existing.title
                    rawText = existing.rawText
                    if let existingDate = existing.date {
                        date = existingDate
                        includeDate = true
                    }
                }
            }
        }
    }

    private func saveTranscript() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        let selectedDate = includeDate ? date : nil

        if var existing = existingTranscript {
            existing.title = trimmedTitle
            existing.rawText = trimmedBody
            existing.date = selectedDate
            appState.updateTranscript(existing)
        } else {
            appState.addTranscript(
                title: trimmedTitle,
                rawText: trimmedBody,
                date: selectedDate
            )
        }
        dismiss()
    }
}
