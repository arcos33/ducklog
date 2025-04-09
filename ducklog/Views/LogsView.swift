import SwiftUI
import SwiftData

struct LogsView: View {
    @Query private var logs: [LogEntry]
    
    var body: some View {
        NavigationStack {
            List(logs) { log in
                LogRow(log: log)
            }
            .navigationTitle("Logs")
            .toolbar {
                Button(action: addLog) {
                    Label("Add Log", systemImage: "plus")
                }
            }
        }
    }
    
    private func addLog() {
        // Implement log creation
    }
}

struct LogRow: View {
    let log: LogEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(log.title)
                .font(.headline)
            Text(log.timestamp, style: .date)
                .font(.caption)
        }
    }
}

#Preview {
    LogsView()
        .modelContainer(for: LogEntry.self, inMemory: true)
} 