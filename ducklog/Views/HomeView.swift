import SwiftUI
import SwiftData

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: JournalView()) {
                    Label("Journal", systemImage: "book")
                }
                
                NavigationLink(destination: LogsView()) {
                    Label("Logs", systemImage: "list.bullet")
                }
                
                NavigationLink(destination: WeeklyOverviewView()) {
                    Label("Weekly Overview", systemImage: "chart.bar")
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