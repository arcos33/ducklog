import Foundation
import SwiftData
import Combine

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var selectedEntry: JournalEntry?
    @Published var filter: TimeFilter = .thisWeek
    @Published var selectedTag: String? = nil
    @Published var searchText: String = ""
    @Published var tags: [Tag] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    enum TimeFilter {
        case thisWeek
        case lastWeek
        case twoWeeks
        case customRange(Date, Date)
        case allTime
        
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
            case .allTime:
                return Date.distantPast
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
            case .allTime:
                return Date.distantFuture
            }
        }
    }
    
    func addEntry(content: String, tags: [String] = [], status: EntryStatus = .inProgress, modelContext: ModelContext) {
        print("[DEBUG] addEntry called with content: \(content), tags: \(tags)")
        let entry = JournalEntry(
            content: content,
            tags: tags,
            status: status,
            timestamp: Date()
        )
        modelContext.insert(entry)
        print("[DEBUG] Entry inserted: \(entry.content), tags: \(entry.tags)")
        do {
            try modelContext.save()
            print("[DEBUG] Entry saved successfully")
        } catch {
            print("[DEBUG] Error saving entry: \(error)")
        }
        loadEntries(modelContext: modelContext)
    }
    
    func loadEntries(modelContext: ModelContext) {
        print("[DEBUG] loadEntries called")
        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            entries = try modelContext.fetch(descriptor)
            print("[DEBUG] Loaded entries: \(entries.map { $0.content })")
        } catch {
            print("[DEBUG] Error loading entries: \(error)")
        }
    }
    
    var filteredEntries: [JournalEntry] {
        let dateFiltered = entries.filter { !$0.isTrashed && $0.timestamp >= filter.startDate && $0.timestamp <= filter.endDate }
        let tagFiltered: [JournalEntry]
        if let tag = selectedTag, !tag.isEmpty {
            tagFiltered = dateFiltered.filter { $0.tags.contains(tag) }
        } else {
            tagFiltered = dateFiltered
        }
        let searchFiltered: [JournalEntry]
        if !searchText.isEmpty {
            let lowercased = searchText.lowercased()
            searchFiltered = tagFiltered.filter {
                $0.content.lowercased().contains(lowercased) ||
                $0.tags.contains(where: { $0.lowercased().contains(lowercased) })
            }
        } else {
            searchFiltered = tagFiltered
        }
        print("🔍 Filtered entries (excluding trashed, tag: \(selectedTag ?? "none"), search: \(searchText)): \(searchFiltered.count) (from \(filter.startDate) to \(filter.endDate))")
        return searchFiltered
    }
    
    func loadTags(modelContext: ModelContext) {
        print("🔄 Loading tags...")
        let descriptor = FetchDescriptor<Tag>(sortBy: [SortDescriptor(\.name)])
        do {
            tags = try modelContext.fetch(descriptor)
            print("🏷️ Loaded \(tags.count) tags: \(tags.map { $0.name })")
        } catch {
            print("❌ Error loading tags: \(error)")
        }
    }
    
    func addTag(_ name: String, modelContext: ModelContext) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(where: { $0.name == trimmed }) else { return }
        let tag = Tag(name: trimmed)
        modelContext.insert(tag)
        do {
            try modelContext.save()
            print("🏷️ Added tag: \(trimmed)")
            loadTags(modelContext: modelContext)
        } catch {
            print("❌ Error adding tag: \(error)")
        }
    }
    
    func deleteTag(tag: Tag, modelContext: ModelContext) {
        modelContext.delete(tag)
        do {
            try modelContext.save()
            print("🗑️ Deleted tag: \(tag.name)")
            loadTags(modelContext: modelContext)
        } catch {
            print("❌ Error deleting tag: \(error)")
        }
    }
    
    var allTags: [String] {
        tags.map { $0.name }
    }
    
    func renameTag(oldTag: String, newTag: String, modelContext: ModelContext) {
        print("🔄 Renaming tag '", oldTag, "' to '", newTag, "'")
        var didUpdate = false
        for entry in entries {
            if let idx = entry.tags.firstIndex(of: oldTag) {
                var updatedTags = entry.tags
                updatedTags[idx] = newTag
                entry.tags = Array(Set(updatedTags)) // Remove duplicates if any
                didUpdate = true
            }
        }
        if didUpdate {
            do {
                try modelContext.save()
                print("✅ Tags renamed and saved.")
            } catch {
                print("❌ Error saving after tag rename: \(error)")
            }
            loadEntries(modelContext: modelContext)
        } else {
            print("ℹ️ No entries needed tag rename.")
        }
    }
    
    func deleteTag(tag: String, modelContext: ModelContext) {
        print("🗑️ Deleting tag '", tag, "' from all entries")
        var didUpdate = false
        for entry in entries {
            if entry.tags.contains(tag) {
                entry.tags = entry.tags.filter { $0 != tag }
                didUpdate = true
            }
        }
        if didUpdate {
            do {
                try modelContext.save()
                print("✅ Tag deleted and changes saved.")
            } catch {
                print("❌ Error saving after tag delete: \(error)")
            }
            loadEntries(modelContext: modelContext)
        } else {
            print("ℹ️ No entries needed tag deletion.")
        }
    }
} 
