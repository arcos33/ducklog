import Foundation
import SwiftData

@Model
final class LogEntry {
    var title: String
    var content: String
    var timestamp: Date
    var category: String
    var isPinned: Bool
    
    init(title: String = "", content: String = "", timestamp: Date = .now, category: String = "General", isPinned: Bool = false) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.category = category
        self.isPinned = isPinned
    }
} 