import SwiftUI
import SwiftData

struct NewEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: JournalViewModel
    @State private var content = ""
    @State private var selectedTags: Set<String> = []
    @State private var selectedPR: PullRequest?
    @State private var status: EntryStatus = .inProgress
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section("Tags") {
                    if viewModel.allTags.isEmpty {
                        Text("No tags available. Add tags in Tag Management.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.allTags, id: \.self) { tag in
                            Toggle(tag, isOn: Binding(
                                get: { selectedTags.contains(tag) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedTags.insert(tag)
                                    } else {
                                        selectedTags.remove(tag)
                                    }
                                }
                            ))
                        }
                    }
                }
                
                Section("GitHub PR") {
                    // TODO: Implement GitHub PR selection
                    Text("PR Integration Coming Soon")
                }
                
                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(EntryStatus.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("💾 Creating new entry with model context: \(modelContext)")
                        viewModel.addEntry(
                            content: content,
                            tags: Array(selectedTags),
                            status: status,
                            modelContext: modelContext
                        )
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
}

#Preview {
    NewEntryView(viewModel: JournalViewModel())
        .modelContainer(for: JournalEntry.self, inMemory: true)
} 