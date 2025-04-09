import SwiftUI
import SwiftData

struct NewEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedTags: Set<String> = []
    @State private var selectedPR: PullRequest?
    @State private var status: EntryStatus = .inProgress
    
    let availableTags = ["Code Review", "Blockers", "Achievements", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(height: 100)
                }
                
                Section("Tags") {
                    ForEach(availableTags, id: \.self) { tag in
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
                        let entry = JournalEntry(
                            title: title,
                            content: content,
                            tags: Array(selectedTags),
                            status: status
                        )
                        modelContext.insert(entry)
                        do {
                            try modelContext.save()
                            print("✅ Entry saved successfully")
                        } catch {
                            print("❌ Error saving entry: \(error)")
                        }
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
}

#Preview {
    NewEntryView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
} 