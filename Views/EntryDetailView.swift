import SwiftUI

struct EntryDetailView: View {
    let entry: JournalEntry
    @State private var isEditing = false
    @State private var editedContent: String
    @State private var selectedStatus: EntryStatus
    @Environment(\.colorScheme) var colorScheme
    
    init(entry: JournalEntry) {
        self.entry = entry
        _editedContent = State(initialValue: entry.content)
        _selectedStatus = State(initialValue: entry.status)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Section
                EntryHeaderView(
                    entry: entry,
                    isEditing: $isEditing,
                    selectedStatus: $selectedStatus
                )
                .padding(.bottom, 24)
                
                // Content Section
                if isEditing {
                    TextEditor(text: $editedContent)
                        .font(.body)
                        .frame(minHeight: 300)
                } else {
                    MarkdownView(content: entry.content)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Bottom Controls (visible in edit mode)
                if isEditing {
                    EntryControlsView(
                        selectedStatus: $selectedStatus,
                        onSave: saveChanges,
                        onCancel: cancelEditing
                    )
                    .padding(.top, 24)
                }
            }
            .padding(.horizontal, 128) // Day One-style padding
            .padding(.vertical, 32)
        }
        .background(backgroundColor)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        #if os(macOS)
        return colorScheme == .dark ? Color(NSColor.windowBackgroundColor) : .white
        #else
        return colorScheme == .dark ? Color(UIColor.systemBackground) : .white
        #endif
    }
    
    private func saveChanges() {
        // TODO: Implement save functionality
        isEditing = false
    }
    
    private func cancelEditing() {
        editedContent = entry.content
        selectedStatus = entry.status
        isEditing = false
    }
}

// MARK: - Supporting Views

struct EntryHeaderView: View {
    let entry: JournalEntry
    @Binding var isEditing: Bool
    @Binding var selectedStatus: EntryStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date header using padding-based alignment
            HStack(alignment: .top, spacing: 8) {
                // Large day number
                Text(formattedDayOfMonth(entry.timestamp))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.accentColor)
                    .alignmentGuide(.top) { d in d[.top] }
                
                // Date and time stack
                VStack(alignment: .leading, spacing: 0) {
                    Text(formattedFullDate(entry.timestamp))
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(formattedDayNameAndTime(entry.timestamp))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 48) // Match the height of the large number
            }
            
            // Status indicator
            StatusIndicator(status: isEditing ? selectedStatus : entry.status)
        }
    }
}

struct EntryControlsView: View {
    @Binding var selectedStatus: EntryStatus
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Status selector
            Picker("Status", selection: $selectedStatus) {
                ForEach(EntryStatus.allCases, id: \.self) { status in
                    Label(status.rawValue, systemImage: status.iconName)
                        .foregroundColor(status.color)
                        .tag(status)
                }
            }
            .pickerStyle(.segmented)
            
            // Action buttons
            HStack {
                Button("Cancel", role: .cancel, action: onCancel)
                Button("Save", action: onSave)
                    .keyboardShortcut(.return, modifiers: .command)
            }
        }
    }
}

struct StatusIndicator: View {
    let status: EntryStatus
    
    var body: some View {
        Label(status.rawValue, systemImage: status.iconName)
            .foregroundColor(status.color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.1))
            .cornerRadius(6)
    }
}

// MARK: - Helper Functions

private func formattedDayOfMonth(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter.string(from: date)
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

// MARK: - Supporting Types

enum EntryStatus: String, CaseIterable {
    case inProgress = "In Progress"
    case done = "Done"
    case blocked = "Blocked"
    
    var color: Color {
        switch self {
        case .inProgress: return .blue
        case .done: return .green
        case .blocked: return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .inProgress: return "clock"
        case .done: return "checkmark.circle"
        case .blocked: return "exclamationmark.triangle"
        }
    }
}

struct JournalEntry {
    let id: UUID
    let timestamp: Date
    let content: String
    let status: EntryStatus
    // Add other properties as needed
}

struct MarkdownView: View {
    let content: String
    
    var body: some View {
        // TODO: Implement proper markdown rendering
        Text(content)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
} 