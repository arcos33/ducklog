import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = JournalViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: JournalView(viewModel: viewModel)) {
                    Label("Journal", systemImage: "book")
                }
                
                NavigationLink(destination: LogsView()) {
                    Label("Logs", systemImage: "list.bullet")
                }
                
                NavigationLink(destination: TimelineView(viewModel: viewModel)) {
                    Label("Timeline", systemImage: "chart.bar")
                }
                
                NavigationLink(destination: TrashView(viewModel: viewModel)) {
                    Label("Trash", systemImage: "trash")
                }
                
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("DuckLog")
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [JournalEntry.self, LogEntry.self], inMemory: true)
} 