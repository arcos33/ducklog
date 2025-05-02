//
//  ducklogApp.swift
//  ducklog
//
//  Created by Joal.Arcos on 4/8/25.
//

import SwiftUI
import SwiftData

@main
struct ducklogApp: App {
    @State private var showSettings = false
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            JournalEntry.self,
            PullRequest.self,
            LogEntry.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsViewModel)
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
        }
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Settings...") {
                    showSettings.toggle()
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
