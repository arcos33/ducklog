import Foundation
import SwiftData
import Combine

@Observable
class JournalViewModel {
    var entries: [JournalEntry] = []
    var selectedEntry: JournalEntry?
    var filter: TimeFilter = .thisWeek
    
    private var cancellables = Set<AnyCancellable>()
    
    enum TimeFilter {
        case thisWeek
        case lastWeek
        case twoWeeks
        case customRange(Date, Date)
        
        var startDate: Date {
            let calendar = Calendar.current
            let now = Date()
            switch self {
            case .thisWeek:
                return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            case .lastWeek:
                return calendar.date(byAdding: .day, value: -7, to: now)!
            case .twoWeeks:
                return calendar.date(byAdding: .day, value: -14, to: now)!
            case .customRange(let start, _):
                return start
            }
        }
        
        var endDate: Date {
            let calendar = Calendar.current
            let now = Date()
            switch self {
            case .thisWeek, .lastWeek, .twoWeeks:
                return now
            case .customRange(_, let end):
                return end
            }
        }
    }
    
    func addEntry(title: String = "", content: String, tags: [String] = [], status: EntryStatus = .inProgress, modelContext: ModelContext) {
        let entry = JournalEntry(
            title: title,
            content: content,
            tags: tags,
            status: status,
            timestamp: Date()
        )
        modelContext.insert(entry)
        loadEntries(modelContext: modelContext)
    }
    
    func loadEntries(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            entries = try modelContext.fetch(descriptor)
            print("Loaded entries: \(entries.count)")
        } catch {
            print("Error loading entries: \(error)")
        }
    }
    
    var filteredEntries: [JournalEntry] {
        let filtered = entries.filter { $0.timestamp >= filter.startDate && $0.timestamp <= filter.endDate }
        print("Filtered entries: \(filtered.count)")
        return filtered
    }
} 
