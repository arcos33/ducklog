import Foundation

#if DEBUG
struct MockData {
    static var sampleEntries: [JournalEntry] {
        let calendar = Calendar.current
        let now = Date()
        
        // Create entries for the last few days
        return [
            JournalEntry(
                content: """
                # My Day at the Park
                
                Today was **amazing**! I went to the park and here's what I did:
                
                - Went for a jog
                - Had a picnic lunch
                - Read a book under a tree
                
                > The weather was perfect for outdoor activities
                
                ### Activities Completed
                1. Morning exercise
                2. Work meetings
                3. Evening relaxation
                
                Some `code` I wrote today: print("Hello World")
                
                ~~Things I didn't do~~
                *Maybe tomorrow*
                """,
                tags: ["outdoors", "exercise"],
                status: .done,
                timestamp: now
            ),
            JournalEntry(
                content: "Today we're in Lava Hot Springs\nIt's been fun.",
                tags: ["travel", "vacation"],
                status: .done,
                timestamp: now
            ),
            JournalEntry(
                content: "Had a great coding session today. Finally figured out that SwiftUI layout issue that's been bugging me for days.",
                tags: ["coding", "swiftui"],
                status: .done,
                timestamp: calendar.date(byAdding: .day, value: -1, to: now)!
            ),
            JournalEntry(
                content: "Morning hike at Antelope Island\nThe views were spectacular today, and we saw several bison up close.",
                tags: ["hiking", "nature"],
                status: .done,
                timestamp: calendar.date(byAdding: .day, value: -2, to: now)!
            ),
            JournalEntry(
                content: "Started working on the new journaling app project. Excited about building something that could help people record their daily thoughts and experiences.",
                tags: ["coding", "projects"],
                status: .inProgress,
                timestamp: calendar.date(byAdding: .day, value: -5, to: now)!
            )
        ]
    }
    
    static var mockViewModel: JournalViewModel {
        let viewModel = JournalViewModel()
        viewModel.entries = sampleEntries
        viewModel.tags = [
            Tag(name: "travel"),
            Tag(name: "vacation"),
            Tag(name: "coding"),
            Tag(name: "swiftui"),
            Tag(name: "hiking"),
            Tag(name: "nature"),
            Tag(name: "projects"),
            Tag(name: "outdoors"),
            Tag(name: "exercise")
        ]
        return viewModel
    }
}
#endif 