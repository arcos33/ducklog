import Foundation
import SwiftData

@Model
final class Tag: Identifiable, Hashable {
    @Attribute(.unique) var name: String
    @Attribute(.unique) var id: UUID
    
    init(name: String) {
        self.name = name
        self.id = UUID()
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 