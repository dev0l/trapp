// Add or edit transcript view

import SwiftUI
import UniformTypeIdentifiers

struct AddTranscriptView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    /// Pass an existing transcript to enter edit mode; nil for add mode.
    var existingTranscript: Transcript?

    @State private var title = ""
    @State private var rawText = ""
    @State private var date = Date()
    @State private var includeDate = false
    @State private var showingFileImporter = false

    private let titleLimit = 50

    private var isEditing: Bool { existingTranscript != nil }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Program title", text: $title)
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

                Section {
                    Toggle("Include date", isOn: $includeDate)
                    if includeDate {
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                }

                Section {
                    Button {
                        showingFileImporter = true
                    } label: {
                        Label("Import from File", systemImage: "doc.badge.plus")
                    }
                    .tint(.indigo)

                    TextEditor(text: $rawText)
                        .frame(minHeight: 150)
                } header: {
                    Text("Transcript Body")
                }
            }
            .navigationTitle(isEditing ? "Edit Trap" : "New Trap")
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
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: [.plainText, .rtf],
                allowsMultipleSelection: false
            ) { result in
                handleImportedFile(result)
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

    private func handleImportedFile(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else { return }
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            if url.pathExtension.lowercased() == "rtf" {
                let data = try Data(contentsOf: url)
                let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                rawText = attributed.string
            } else {
                rawText = try String(contentsOf: url, encoding: .utf8)
            }

            // Auto-fill title from filename if title is empty
            if title.isEmpty {
                let filename = url.deletingPathExtension().lastPathComponent
                title = String(filename.prefix(titleLimit))
            }
        } catch {
            // Silently fail — user can still type manually
        }
    }
}
