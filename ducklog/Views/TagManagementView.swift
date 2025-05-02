import SwiftUI
import SwiftData

struct TagManagementView: View {
    @ObservedObject var viewModel: JournalViewModel
    @State private var renamingTag: String = ""
    @State private var isRenaming: Bool = false
    @State private var newTagName: String = ""
    @State private var selectedTag: Tag? = nil
    @State private var isAdding: Bool = false
    @State private var addTagName: String = ""
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        print("[DEBUG] TagManagementView body: tags = \(viewModel.tags.map { $0.name })")
        return VStack(alignment: .leading) {
            Text("Manage Tags")
                .font(.largeTitle)
                .padding(.bottom)
            List(selection: $selectedTag) {
                ForEach(viewModel.tags, id: \.id) { tag in
                    HStack {
                        Text(tag.name)
                            .font(.headline)
                        Spacer()
                        Text("\(usageCount(for: tag.name)) entries")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Rename") {
                            renamingTag = tag.name
                            newTagName = tag.name
                            isRenaming = true
                        }
                        .buttonStyle(.bordered)
                    }
                    .contentShape(Rectangle())
                    .background(selectedTag == tag ? Color.accentColor.opacity(0.15) : Color.clear)
                    .onTapGesture {
                        selectedTag = tag
                    }
                }
            }
            if isAdding {
                HStack {
                    TextField("New tag name", text: $addTagName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 180)
                    Button("Add") {
                        let trimmed = addTagName.trimmingCharacters(in: .whitespaces)
                        print("[DEBUG] Add button tapped with tag: \(trimmed)")
                        if !trimmed.isEmpty && !viewModel.tags.contains(where: { $0.name == trimmed }) {
                            viewModel.addTag(trimmed, modelContext: modelContext)
                            addTagName = ""
                            isAdding = false
                        }
                    }
                    .disabled(addTagName.trimmingCharacters(in: .whitespaces).isEmpty || viewModel.tags.contains(where: { $0.name == addTagName.trimmingCharacters(in: .whitespaces) }))
                    Button("Cancel") {
                        isAdding = false
                        addTagName = ""
                    }
                }
                .padding(.leading)
            }
            HStack {
                Button(action: { isAdding = true }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    if let tag = selectedTag {
                        viewModel.deleteTag(tag: tag, modelContext: modelContext)
                        selectedTag = nil
                    }
                }) {
                    Image(systemName: "minus")
                }
                .disabled(selectedTag == nil)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, 2)
            .onAppear {
                print("[DEBUG] TagManagementView onAppear: calling loadTags")
                viewModel.loadTags(modelContext: modelContext)
            }
            .sheet(isPresented: $isRenaming) {
                VStack(spacing: 16) {
                    Text("Rename Tag")
                        .font(.headline)
                    TextField("New tag name", text: $newTagName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Button("Cancel") {
                            isRenaming = false
                        }
                        Spacer()
                        Button("Save") {
                            viewModel.renameTag(oldTag: renamingTag, newTag: newTagName, modelContext: modelContext)
                            isRenaming = false
                        }
                        .disabled(newTagName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .padding()
                .frame(minWidth: 300)
            }
        }
        .padding()
    }
    
    private func usageCount(for tagName: String) -> Int {
        viewModel.entries.filter { $0.tags.contains(tagName) }.count
    }
} 