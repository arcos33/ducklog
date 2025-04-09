import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = JournalViewModel()
    @State private var showingAddEntry = false
    @State private var showingCustomRange = false
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("This Week") {
                        viewModel.filter = .thisWeek
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Custom Range") {
                        showingCustomRange = true
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
                List(viewModel.filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        VStack(alignment: .leading) {
                            Text(entry.title)
                                .font(.headline)
                            Text(entry.content)
                                .font(.subheadline)
                                .lineLimit(2)
                            HStack {
                                ForEach(entry.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                            Text(entry.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingCustomRange) {
                CustomRangeView(
                    startDate: $customStartDate,
                    endDate: $customEndDate,
                    isPresented: $showingCustomRange
                ) {
                    viewModel.filter = .customRange(customStartDate, customEndDate)
                }
            }
            .onAppear {
                viewModel.loadEntries(modelContext: modelContext)
            }
        }
    }
}

struct CustomRangeView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isPresented: Bool
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            }
            .navigationTitle("Custom Range")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var tags: [String] = []
    @State private var newTag = ""
    var viewModel: JournalViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
                
                Section(header: Text("Tags")) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                    }
                    .onDelete { indexSet in
                        tags.remove(atOffsets: indexSet)
                    }
                    
                    HStack {
                        TextField("New Tag", text: $newTag)
                        Button("Add") {
                            if !newTag.isEmpty {
                                tags.append(newTag)
                                newTag = ""
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addEntry(
                            title: title,
                            content: content,
                            tags: tags,
                            status: .inProgress,
                            modelContext: modelContext
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EntryDetailView: View {
    let entry: JournalEntry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(entry.title)
                    .font(.title)
                
                Text(entry.content)
                    .font(.body)
                
                HStack {
                    ForEach(entry.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                
                Text(entry.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Entry Details")
    }
} 