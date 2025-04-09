//
//  ContentView.swift
//  ducklog
//
//  Created by Joal.Arcos on 4/8/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingNewEntry = false
    @Query(sort: \JournalEntry.timestamp, order: .reverse) private var entries: [JournalEntry]
    @StateObject private var viewModel = JournalViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var filteredEntries: [JournalEntry] {
        entries.filter { $0.timestamp >= viewModel.filter.startDate && $0.timestamp <= viewModel.filter.endDate }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                VStack {
                    Button("This Week") {
                        viewModel.filter = .thisWeek
                    }
                    Button("Last Week") {
                        viewModel.filter = .lastWeek
                    }
                    Button("Two Weeks") {
                        viewModel.filter = .twoWeeks
                    }
                    Button("Custom Range") {
                        // Implement custom range selection
                    }
                }
                .padding()
                List {
                    Section("Timeline") {
                        ForEach(filteredEntries) { entry in
                            TimelineEntryRow(entry: entry)
                                .onTapGesture {
                                    viewModel.selectedEntry = entry
                                }
                        }
                    }
                }
                .navigationTitle("DuckLog")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showingNewEntry = true }) {
                            Label("New Entry", systemImage: "plus")
                        }
                    }
                }
            }
        } detail: {
            if let selectedEntry = viewModel.selectedEntry {
                EntryDetailView(entry: selectedEntry)
            } else {
                Text("Select an entry")
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView()
        }
        .onAppear {
            print("📱 ContentView appeared, loading entries")
            viewModel.loadEntries(modelContext: modelContext)
        }
    }
}

struct TimelineEntryRow: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
            Text(entry.content)
                .font(.body)
                .lineLimit(2)
            if let pr = entry.linkedPR {
                HStack {
                    Image(systemName: "link")
                    Text(pr.title)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            Text(entry.timestamp, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: JournalEntry.self, inMemory: true)
}
