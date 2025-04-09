import Foundation
import SwiftData

@objc(TagsTransformer)
final class TagsTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let tags = value as? [String] else { return nil }
        return try? JSONEncoder().encode(tags)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}

enum EntryStatus: String, Codable, CaseIterable, Identifiable {
    case inProgress = "In Progress"
    case done = "Done"
    case blocked = "Blocked"
    
    var id: String { rawValue }
}

@Model
final class JournalEntry {
    var title: String
    var content: String
    @objc dynamic var tags: [String]
    var status: EntryStatus
    var timestamp: Date
    var linkedPR: PullRequest?
    
    init(
        title: String = "",
        content: String = "",
        tags: [String] = [],
        status: EntryStatus = .inProgress,
        timestamp: Date = .now,
        linkedPR: PullRequest? = nil
    ) {
        self.title = title
        self.content = content
        self.tags = tags
        self.status = status
        self.timestamp = timestamp
        self.linkedPR = linkedPR
        
        ValueTransformer.setValueTransformer(TagsTransformer(), forName: NSValueTransformerName("TagsTransformer"))
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
