import Foundation
import SwiftData
import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var selectedEntry: JournalEntry?
    @Published var filter: TimeFilter = .thisWeek
    
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
        print("📝 Creating new entry with title: \(title), content: \(content), tags: \(tags)")
        let entry = JournalEntry(
            title: title,
            content: content,
            tags: tags,
            status: status,
            timestamp: Date()
        )
        modelContext.insert(entry)
        print("✅ Entry created with ID: \(entry.persistentModelID)")
        
        do {
            try modelContext.save()
            print("💾 Entry saved successfully")
        } catch {
            print("❌ Error saving entry: \(error)")
        }
        
        loadEntries(modelContext: modelContext)
    }
    
    func loadEntries(modelContext: ModelContext) {
        print("🔄 Loading entries...")
        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            entries = try modelContext.fetch(descriptor)
            print("📚 Loaded \(entries.count) entries")
            for entry in entries {
                print("  - Entry: \(entry.title), ID: \(entry.persistentModelID), Tags: \(entry.tags)")
            }
        } catch {
            print("❌ Error loading entries: \(error)")
        }
    }
    
    var filteredEntries: [JournalEntry] {
        let filtered = entries.filter { $0.timestamp >= filter.startDate && $0.timestamp <= filter.endDate }
        print("🔍 Filtered entries: \(filtered.count) (from \(filter.startDate) to \(filter.endDate))")
        return filtered
    }
} 
