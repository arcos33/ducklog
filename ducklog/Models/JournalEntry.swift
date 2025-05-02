import Foundation
import SwiftData

enum EntryStatus: String, Codable, CaseIterable, Identifiable {
    case inProgress = "In Progress"
    case done = "Done"
    case blocked = "Blocked"
    
    var id: String { rawValue }
}

@Model
final class JournalEntry {
    var content: String
    private var _tags: String?
    var tags: [String] {
        get {
            guard let tagsString = _tags,
                  let data = Data(base64Encoded: tagsString) else { 
                print("📦 No tags data found")
                return [] 
            }
            if let decodedTags = try? JSONDecoder().decode([String].self, from: data) {
                print("📦 Decoded tags: \(decodedTags)")
                return decodedTags
            } else {
                print("❌ Failed to decode tags from data")
                return []
            }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                _tags = data.base64EncodedString()
                print("📦 Encoded tags: \(newValue) -> \(_tags ?? "nil")")
            } else {
                print("❌ Failed to encode tags")
                _tags = nil
            }
        }
    }
    var status: EntryStatus
    var timestamp: Date
    var linkedPR: PullRequest?
    var isTrashed: Bool
    
    init(
        content: String = "",
        tags: [String] = [],
        status: EntryStatus = .inProgress,
        timestamp: Date = .now,
        linkedPR: PullRequest? = nil,
        isTrashed: Bool = false
    ) {
        self.content = content
        self.status = status
        self.timestamp = timestamp
        self.linkedPR = linkedPR
        self.isTrashed = isTrashed
        
        // Initialize _tags after all other properties
        if let data = try? JSONEncoder().encode(tags) {
            self._tags = data.base64EncodedString()
        } else {
            self._tags = nil
        }
        
        // Now it's safe to print
        print("📦 Initialized entry with tags: \(tags) -> \(self._tags ?? "nil")")
    }
}

@Model
final class PullRequest {
    var title: String
    var url: URL
    var status: PRStatus
    
    init(title: String, url: URL, status: PRStatus) {
        self.title = title
        self.url = url
        self.status = status
    }
}

enum PRStatus: String, Codable {
    case inProgress = "In Progress"
    case done = "Done"
    case blocked = "Blocked"
} 