//
//  ContentView.swift
//  ducklog
//
//  Created by Joal.Arcos on 4/8/25.
//

import SwiftUI
import SwiftData

enum SidebarSection: String, CaseIterable, Identifiable {
    case allEntries = "All Entries"
    case tags = "Tags"
    case media = "Media"
    case journals = "Journals"
    case trash = "Trash"
    case settings = "Settings"
    
    var id: String { self.rawValue }
}

struct ContentView: View {
    @StateObject private var viewModel = JournalViewModel()
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var selectedSidebarSection: SidebarSection? = .allEntries
    @State private var showingCustomRange = false
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var showingNewEntry = false
    @State private var showSettings = false
    @Query(sort: \JournalEntry.timestamp, order: .reverse) private var entries: [JournalEntry]
    
    var filteredEntries: [JournalEntry] {
        entries.filter { $0.timestamp >= viewModel.filter.startDate && $0.timestamp <= viewModel.filter.endDate }
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(SidebarSection.allCases, selection: $selectedSidebarSection) { section in
                if section == .settings {
                    Label(section.rawValue, systemImage: icon(for: section))
                        .onTapGesture {
                            showSettings = true
                        }
                } else {
                    NavigationLink(value: section) {
                        Label(section.rawValue, systemImage: icon(for: section))
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("DuckLog")
            .toolbar(id: "sidebarToolbar") {
                ToolbarItem(id: "newEntry", placement: .primaryAction) {
                    Button(action: {
                        showingNewEntry = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(id: "settings", placement: .automatic) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .onChange(of: selectedSidebarSection) { oldValue, newValue in
                if newValue == .settings {
                    // Reset to previous selection and show settings as sheet instead
                    selectedSidebarSection = oldValue
                    showSettings = true
                }
            }
        } content: {
            // Entry List Panel
            switch selectedSidebarSection {
            case .allEntries:
                VStack(spacing: 0) {
                    // Search bar
                    TextField("Search entries...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.top, .horizontal])

                    HStack {
                        Button("This Week") {
                            viewModel.filter = .thisWeek
                        }
                        .buttonStyle(.bordered)
                        Button("Custom Range") {
                            showingCustomRange = true
                        }
                        .buttonStyle(.bordered)
                        Button("Show All") {
                            viewModel.filter = .allTime
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding([.top, .horizontal])

                    // Tag filter bar
                    let tags = viewModel.allTags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                Button(action: {
                                    viewModel.selectedTag = tag
                                }) {
                                    Text(tag)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(viewModel.selectedTag == tag ? Color.accentColor.opacity(0.2) : Color.clear)
                                        .foregroundColor(viewModel.selectedTag == tag ? .accentColor : .primary)
                                        .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                            if viewModel.selectedTag != nil {
                                Button("Clear") {
                                    viewModel.selectedTag = nil
                                }
                                .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                    EntryListView(
                        viewModel: viewModel,
                        selectedEntry: $viewModel.selectedEntry
                    )
                }
            case .tags:
                TagManagementView(viewModel: viewModel)
            case .media:
                Text("Media View Coming Soon")
            case .journals:
                Text("Journals View Coming Soon")
            case .trash:
                TrashView(viewModel: viewModel)
            case .settings:
                // This case should never be reached due to our onChange handler
                Text("Settings are available via the gear icon")
            case .none:
                Text("Select a section")
            }
        } detail: {
            // Contextual Detail/Summary/Settings Panel
            EntryDetailView(entry: viewModel.selectedEntry, viewModel: viewModel)
        }
        .accentColor(.blue)
        .sheet(isPresented: $showingCustomRange) {
            CustomRangeView(
                startDate: $customStartDate,
                endDate: $customEndDate,
                isPresented: $showingCustomRange
            ) {
                viewModel.filter = .customRange(customStartDate, customEndDate)
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(viewModel: viewModel)
                .environmentObject(settingsViewModel)
        }
        .sheet(isPresented: $showSettings) {
            #if os(macOS)
            SettingsView()
                .environmentObject(settingsViewModel)
                .frame(width: 600, height: 500)
            #else
            NavigationStack {
                SettingsView()
                    .environmentObject(settingsViewModel)
            }
            #endif
        }
        .onAppear {
            print("📱 ContentView appeared, loading entries")
            viewModel.loadEntries(modelContext: modelContext)
            viewModel.loadTags(modelContext: modelContext)
        }
        #if os(iOS)
        .toolbarRole(.browser)
        #endif
    }
    
    private func icon(for section: SidebarSection) -> String {
        switch section {
        case .allEntries: return "tray.full"
        case .tags: return "tag"
        case .media: return "photo.on.rectangle"
        case .journals: return "book"
        case .trash: return "trash"
        case .settings: return "gear"
        }
    }
}

struct TimelineEntryRow: View {
    let entry: JournalEntry
    
    private var entryTitle: String {
        // Extract the first line as the title
        if let firstLine = entry.content.components(separatedBy: .newlines).first?.trimmingCharacters(in: .whitespaces),
           !firstLine.isEmpty {
            return firstLine
        }
        return "Untitled Entry"
    }
    
    private var contentPreview: String {
        let lines = entry.content.components(separatedBy: .newlines)
        if lines.count > 1 {
            return lines.dropFirst().joined(separator: " ").trimmingCharacters(in: .whitespaces)
        }
        return entry.content
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entryTitle)
                .font(.system(size: 18, weight: .bold))
            Text(contentPreview)
                .font(.system(size: 16, weight: .regular))
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
