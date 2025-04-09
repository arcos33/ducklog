import Foundation

class MarkdownFileService {
    static let shared = MarkdownFileService()
    
    private let fileManager = FileManager.default
    private let journalFileName = "ducklog_journal.md"
    
    private init() {}
    
    func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveEntry(_ entry: JournalEntry) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let formattedTime = formatter.string(from: entry.timestamp)

        let markdown = """
        # \(formattedTime)
        Status: \(entry.status.rawValue)
        Tags: \(entry.tags.joined(separator: ", "))
        \(entry.linkedPR != nil ? "PR: \(entry.linkedPR!.title)" : "")
        
        \(entry.content)
        
        ---
        
        """
        
        let fileURL = getDocumentsDirectory().appendingPathComponent(journalFileName)
        
        if !fileManager.fileExists(atPath: fileURL.path) {
            try markdown.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } else {
            let handle = try FileHandle(forWritingTo: fileURL)
            handle.seekToEndOfFile()
            handle.write(markdown.data(using: .utf8)!)
            handle.closeFile()
        }
    }
    
    func loadEntries() throws -> [JournalEntry] {
        // TODO: Implement markdown parsing
        return []
    }
} 