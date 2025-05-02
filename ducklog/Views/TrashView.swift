import SwiftUI

struct TrashView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: JournalViewModel
    @State private var showDeleteAlert: JournalEntry?
    
    var trashedEntries: [JournalEntry] {
        viewModel.entries.filter { $0.isTrashed }
    }
    
    var body: some View {
        NavigationView {
            List {
                if trashedEntries.isEmpty {
                    Text("Trash is empty.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(trashedEntries, id: \ .self) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.content)
                                .font(.headline)
                            Text(formattedTime(entry.timestamp))
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(entry.content.prefix(60))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                Button("Restore") {
                                    restore(entry)
                                }
                                .buttonStyle(.borderedProminent)
                                Button(role: .destructive) {
                                    showDeleteAlert = entry
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Trash")
            .alert("Delete Permanently?", isPresented: Binding<Bool>(
                get: { showDeleteAlert != nil },
                set: { if !$0 { showDeleteAlert = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let entry = showDeleteAlert {
                        delete(entry)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone. Are you sure?")
            }
            .onAppear {
                viewModel.loadEntries(modelContext: modelContext)
                let trashed = trashedEntries
                print("🗑️ TrashView appeared. Trashed entries count: \(trashed.count)")
                for entry in trashed {
                    print("  - \(entry.content)")
                }
            }
        }
    }
    
    private func restore(_ entry: JournalEntry) {
        entry.isTrashed = false
        do {
            try modelContext.save()
            print("♻️ Restored entry: \(entry.content)")
            viewModel.loadEntries(modelContext: modelContext)
        } catch {
            print("❌ Failed to restore entry: \(error)")
        }
    }
    
    private func delete(_ entry: JournalEntry) {
        modelContext.delete(entry)
        do {
            try modelContext.save()
            print("🗑️ Permanently deleted entry: \(entry.content)")
            viewModel.loadEntries(modelContext: modelContext)
        } catch {
            print("❌ Failed to delete entry: \(error)")
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
} 