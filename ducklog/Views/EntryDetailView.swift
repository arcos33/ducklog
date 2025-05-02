import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct DateSquare: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 2) {
            Text(formattedDayName(date))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
            Text(formattedDayNumber(date))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(width: 50, height: 50)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #elseif os(macOS)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color.background
        #endif
    }
    
    private func formattedDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }
    
    private func formattedDayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

struct MarkdownText: View {
    let text: String
    @Environment(\.colorScheme) private var colorScheme
    
    private var formattedContent: [(String, MarkdownStyle)] {
        var result: [(String, MarkdownStyle)] = []
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            if line.isEmpty {
                result.append(("", .emptyLine))
                continue
            }
            
            // Headers
            if line.hasPrefix("# ") {
                result.append((line.dropFirst(2).trimmingCharacters(in: .whitespaces), .h1))
            } else if line.hasPrefix("## ") {
                result.append((line.dropFirst(3).trimmingCharacters(in: .whitespaces), .h2))
            } else if line.hasPrefix("### ") {
                result.append((line.dropFirst(4).trimmingCharacters(in: .whitespaces), .h3))
            } else if line.hasPrefix("#### ") {
                result.append((line.dropFirst(5).trimmingCharacters(in: .whitespaces), .h4))
            } else if line.hasPrefix("##### ") {
                result.append((line.dropFirst(6).trimmingCharacters(in: .whitespaces), .h5))
            } else if line.hasPrefix("###### ") {
                result.append((line.dropFirst(7).trimmingCharacters(in: .whitespaces), .h6))
            } else if line.hasPrefix("- ") || line.hasPrefix("* ") {
                result.append((line.dropFirst(2).trimmingCharacters(in: .whitespaces), .bullet))
            } else if line.hasPrefix("1. ") {
                result.append((line.dropFirst(3).trimmingCharacters(in: .whitespaces), .numbered))
            } else if line.hasPrefix("> ") {
                result.append((line.dropFirst(2).trimmingCharacters(in: .whitespaces), .quote))
            } else {
                // Process inline formatting within the line
                var currentText = ""
                var currentStyle = MarkdownStyle.body
                var inBold = false
                var inItalic = false
                var inCode = false
                var inStrikethrough = false
                
                var chars = Array(line)
                var i = 0
                
                while i < chars.count {
                    if i < chars.count - 1 {
                        // Bold
                        if chars[i] == "*" && chars[i + 1] == "*" {
                            if !currentText.isEmpty {
                                result.append((currentText, currentStyle))
                                currentText = ""
                            }
                            inBold.toggle()
                            currentStyle = inBold ? .bold : .body
                            i += 2
                            continue
                        }
                        
                        // Italic
                        if chars[i] == "_" {
                            if !currentText.isEmpty {
                                result.append((currentText, currentStyle))
                                currentText = ""
                            }
                            inItalic.toggle()
                            currentStyle = inItalic ? .italic : .body
                            i += 1
                            continue
                        }
                        
                        // Strikethrough
                        if chars[i] == "~" && chars[i + 1] == "~" {
                            if !currentText.isEmpty {
                                result.append((currentText, currentStyle))
                                currentText = ""
                            }
                            inStrikethrough.toggle()
                            currentStyle = inStrikethrough ? .strikethrough : .body
                            i += 2
                            continue
                        }
                        
                        // Inline Code
                        if chars[i] == "`" {
                            if !currentText.isEmpty {
                                result.append((currentText, currentStyle))
                                currentText = ""
                            }
                            inCode.toggle()
                            currentStyle = inCode ? .code : .body
                            i += 1
                            continue
                        }
                    }
                    
                    currentText.append(chars[i])
                    i += 1
                }
                
                if !currentText.isEmpty {
                    result.append((currentText, currentStyle))
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(formattedContent.enumerated()), id: \.offset) { index, element in
                switch element.1 {
                case .h1:
                    Text(element.0)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                case .h2:
                    Text(element.0)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 6)
                case .h3:
                    Text(element.0)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 4)
                case .h4:
                    Text(element.0)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 4)
                case .h5:
                    Text(element.0)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 4)
                case .h6:
                    Text(element.0)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.bottom, 4)
                case .bullet:
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text(element.0)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                case .numbered:
                    HStack(alignment: .top, spacing: 8) {
                        Text("1.")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text(element.0)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                case .quote:
                    HStack(alignment: .top, spacing: 8) {
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 4)
                        Text(element.0)
                            .font(.body.italic())
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 8)
                case .bold:
                    Text(element.0)
                        .font(.body.bold())
                        .foregroundColor(.primary)
                case .italic:
                    Text(element.0)
                        .font(.body.italic())
                        .foregroundColor(.primary)
                case .strikethrough:
                    Text(element.0)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .strikethrough()
                case .code:
                    Text(element.0)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(colorScheme == .dark ? Color.secondary.opacity(0.2) : Color.secondary.opacity(0.1))
                        .foregroundColor(.primary)
                        .cornerRadius(4)
                case .body:
                    Text(element.0)
                        .font(.body)
                        .foregroundColor(.primary)
                case .emptyLine:
                    Text("")
                        .font(.body)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private enum MarkdownStyle {
    case h1, h2, h3, h4, h5, h6
    case bullet, numbered, quote
    case bold, italic, strikethrough, code
    case body, emptyLine
}

// Date Info Component
private struct EntryDateInfo: View {
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formattedFullDate(date))
                .font(.title2)
                .foregroundColor(.primary)
            Text(formattedDayNameAndTime(date))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedDayNameAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Status Tag Component
private struct StatusTag: View {
    let status: EntryStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .foregroundColor(statusColor)
            .cornerRadius(12)
    }
    
    private var statusColor: Color {
        switch status {
        case .done:
            return .green
        case .inProgress:
            return .blue
        case .blocked:
            return .red
        }
    }
}

// MARK: - Header View Component
private struct EntryHeaderView: View {
    let entry: JournalEntry?
    let isNewEntry: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formattedFullDate(entry?.timestamp ?? Date()))
                .font(.title2)
                .foregroundColor(.primary)
            Text(formattedDayNameAndTime(entry?.timestamp ?? Date()))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !isNewEntry, let entry = entry {
                StatusTag(status: entry.status)
                    .padding(.top, 8)
            }
        }
    }
    
    private func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedDayNameAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, h:mm a"
        return formatter.string(from: date)
    }
}

// Editor View Component
private struct EntryEditorView: View {
    @Binding var editedContent: String
    @Binding var status: EntryStatus
    @Binding var selectedTags: Set<String>
    @FocusState.Binding var contentFocused: Bool
    let isNewEntry: Bool
    let entry: JournalEntry?
    let allTags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            TextEditor(text: $editedContent)
                .font(.body)
                .frame(minHeight: 200)
                .focused($contentFocused)
                .onAppear {
                    if !isNewEntry {
                        editedContent = entry?.content ?? ""
                    }
                    contentFocused = true
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Status")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("Status", selection: $status) {
                    ForEach(EntryStatus.allCases) { status in
                        HStack {
                            Circle()
                                .fill(statusColor(for: status))
                                .frame(width: 8, height: 8)
                            Text(status.rawValue)
                        }.tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            if !allTags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(allTags, id: \.self) { tag in
                                Toggle(isOn: Binding(
                                    get: { selectedTags.contains(tag) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedTags.insert(tag)
                                        } else {
                                            selectedTags.remove(tag)
                                        }
                                    }
                                )) {
                                    Text(tag)
                                }
                                .toggleStyle(.button)
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func statusColor(for status: EntryStatus) -> Color {
        switch status {
        case .done:
            return .green
        case .inProgress:
            return .blue
        case .blocked:
            return .red
        }
    }
}

// MARK: - Markdown Content View
private struct MarkdownContentView: View {
    let content: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        MarkdownText(text: content)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Tags View Component
private struct TagsView: View {
    let tags: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.1))
                        .foregroundColor(.accentColor)
                        .cornerRadius(4)
                }
            }
        }
    }
}

// Content View Component
private struct EntryContentView: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MarkdownContentView(content: entry.content)
            
            if !entry.tags.isEmpty {
                TagsView(tags: entry.tags)
            }
        }
    }
}

// MARK: - Main View
struct EntryDetailView: View {
    var entry: JournalEntry?
    @Environment(\.modelContext) private var modelContext
    @State private var showTrashAlert = false
    @State private var editedContent: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var contentFocused: Bool
    @ObservedObject var viewModel: JournalViewModel
    @State private var selectedTags: Set<String> = []
    @State private var status: EntryStatus = .inProgress
    
    private var isNewEntry: Bool {
        entry == nil
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        Color(UIColor.systemBackground)
        #elseif os(macOS)
        Color(NSColor.windowBackgroundColor)
        #else
        Color.background
        #endif
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top header with date and edit button
            HStack {
                EntryHeaderView(entry: entry, isNewEntry: isNewEntry)
                
                if !isNewEntry {
                    Spacer()
                    Button(isEditing ? "Done" : "Edit") {
                        handleEditingToggle()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal, 128)
            .padding(.vertical, 20)
            
            // Main content area
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if isNewEntry || isEditing {
                            TextEditor(text: $editedContent)
                                .font(.body)
                                .frame(minHeight: geometry.size.height)
                                .focused($contentFocused)
                        } else if let entry = entry {
                            MarkdownContentView(content: entry.content)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 40)
                        } else {
                            Text("Start writing...")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 40)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 128)
            }
            
            // Bottom controls
            if isNewEntry || isEditing {
                VStack(alignment: .leading, spacing: 16) {
                    // Status picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Picker("Status", selection: $status) {
                            ForEach(EntryStatus.allCases) { status in
                                HStack {
                                    Circle()
                                        .fill(statusColor(for: status))
                                        .frame(width: 8, height: 8)
                                    Text(status.rawValue)
                                }.tag(status)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Tags
                    if !viewModel.allTags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.allTags, id: \.self) { tag in
                                        Toggle(isOn: Binding(
                                            get: { selectedTags.contains(tag) },
                                            set: { isSelected in
                                                if isSelected {
                                                    selectedTags.insert(tag)
                                                } else {
                                                    selectedTags.remove(tag)
                                                }
                                            }
                                        )) {
                                            Text(tag)
                                        }
                                        .toggleStyle(.button)
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 128)
                .padding(.vertical, 20)
                .background(backgroundColor)
            }
        }
        .background(backgroundColor)
        .onChange(of: entry) { oldEntry, newEntry in
            // Reset editing state and update content when switching entries
            isEditing = false
            if let newEntry = newEntry {
                editedContent = newEntry.content
                status = newEntry.status
                selectedTags = Set(newEntry.tags)
            } else {
                editedContent = ""
                status = .inProgress
                selectedTags = []
            }
        }
        .toolbar {
            if isNewEntry {
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        saveNewEntry()
                    }
                    .keyboardShortcut(.defaultAction)
                }
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        viewModel.selectedEntry = nil
                        editedContent = ""
                    }
                }
            } else if entry != nil {
                ToolbarItem(placement: .automatic) {
                    Button(role: .destructive) {
                        showTrashAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .alert("Move to Trash?", isPresented: $showTrashAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Move to Trash", role: .destructive) {
                if let entry = entry {
                    entry.isTrashed = true
                    try? modelContext.save()
                    viewModel.selectedEntry = nil
                }
            }
        }
    }
    
    private func statusColor(for status: EntryStatus) -> Color {
        switch status {
        case .done:
            return .green
        case .inProgress:
            return .blue
        case .blocked:
            return .red
        }
    }
    
    private func handleEditingToggle() {
        if isEditing {
            // Save changes
            if let entry = entry {
                entry.content = editedContent
                entry.status = status
                entry.tags = Array(selectedTags)
                try? modelContext.save()
            }
        } else {
            // Enter editing mode
            if let entry = entry {
                editedContent = entry.content
                status = entry.status
                selectedTags = Set(entry.tags)
            }
            contentFocused = true
        }
        isEditing.toggle()
    }
    
    private func saveNewEntry() {
        guard !editedContent.isEmpty else { return }
        
        viewModel.addEntry(
            content: editedContent,
            tags: Array(selectedTags),
            status: status,
            modelContext: modelContext
        )
        
        editedContent = ""
        selectedTags = []
        status = .inProgress
        viewModel.selectedEntry = nil
    }
}

#Preview {
    let journalEntry = JournalEntry(content: "This is a sample journal entry\n\nWith some content across multiple lines to demonstrate the layout.")
    let vm = JournalViewModel()
    EntryDetailView(entry: journalEntry, viewModel: vm)
        .frame(width: 400, height: 400)
}

