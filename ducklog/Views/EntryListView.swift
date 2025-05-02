import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct EntryListView: View {
    @ObservedObject var viewModel: JournalViewModel
    @Binding var selectedEntry: JournalEntry?
    
    private var groupedEntries: [(String, [(Date, [JournalEntry])])] {
        // First group by month/year
        let monthGrouped = Dictionary(grouping: viewModel.filteredEntries) { entry in
            formatMonthYearHeader(entry.timestamp)
        }
        
        // Then for each month, group entries by day
        let monthsWithDayGroups = monthGrouped.mapValues { entries in
            let dayGrouped = Dictionary(grouping: entries) { entry in
                Calendar.current.startOfDay(for: entry.timestamp)
            }
            return dayGrouped.sorted { $0.key > $1.key }
        }
        
        return monthsWithDayGroups.sorted { $0.key > $1.key }
    }
    
    var body: some View {
        List {
            ForEach(groupedEntries, id: \.0) { (monthYear, dayGroups) in
                Section(header: Text(monthYear)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .textCase(nil)
                ) {
                    ForEach(dayGroups, id: \.0) { (dayDate, entries) in
                        StackedCardsView(entries: entries.sorted(by: { $0.timestamp > $1.timestamp }), selectedEntry: $selectedEntry)
                            .listRowSeparator(.hidden)
                    }
                }
                .textCase(nil)
            }
        }
        .listStyle(.plain)
    }
    
    private func formatMonthYearHeader(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct StackedCardsView: View {
    let entries: [JournalEntry]
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedEntry: JournalEntry?
    
    private var cardBackgroundColor: Color {
        #if os(iOS)
        return colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemGray6).opacity(0.3)
        #elseif os(macOS)
        return colorScheme == .dark ? Color(NSColor.gridColor) : Color(NSColor.gridColor).opacity(0.15)
        #else
        return colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)
        #endif
    }
    
    private var timelineColor: Color {
        colorScheme == .dark ? .gray.opacity(0.3) : .gray.opacity(0.2)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Date square and timeline
            VStack(spacing: 8) {
                DateSquare(date: entries.first?.timestamp ?? Date())
                
                if entries.count > 1 {
                    Rectangle()
                        .fill(timelineColor)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 4)
                }
            }
            
            // Entries
            VStack(spacing: 12) {
                ForEach(entries) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(formatTime(entry.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(entry.status.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(statusColor(for: entry.status).opacity(0.1))
                                .foregroundColor(statusColor(for: entry.status))
                                .cornerRadius(4)
                        }
                        
                        if let title = entry.content.components(separatedBy: .newlines).first?.trimmingCharacters(in: .whitespaces),
                           !title.isEmpty {
                            Text(title)
                                .font(.headline)
                                .lineLimit(1)
                        }
                        
                        let contentPreview = entry.content
                            .components(separatedBy: .newlines)
                            .dropFirst()
                            .joined(separator: " ")
                            .trimmingCharacters(in: .whitespaces)
                        
                        if !contentPreview.isEmpty {
                            Text(contentPreview)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        if !entry.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 4) {
                                    ForEach(entry.tags.prefix(3), id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.accentColor.opacity(0.1))
                                            .foregroundColor(.accentColor)
                                            .cornerRadius(4)
                                    }
                                    if entry.tags.count > 3 {
                                        Text("+\(entry.tags.count - 3)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(cardBackgroundColor)
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedEntry = entry
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
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

#Preview {
    NavigationStack {
        EntryListView(
            viewModel: MockData.mockViewModel,
            selectedEntry: .constant(nil)
        )
    }
}
