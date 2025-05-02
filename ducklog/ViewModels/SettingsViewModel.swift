import Foundation

class SettingsViewModel: ObservableObject {
    @Published var settings: SettingsModel
    
    private let settingsService = SettingsService.shared
    
    init() {
        settings = settingsService.loadSettings()
        print("SettingsViewModel initialized with Jira URL: '\(settings.jiraInstanceURL)'")
        print("SettingsViewModel initialized with Jira Username: '\(settings.jiraUsername)'")
    }
    
    func saveSettings() {
        print("Saving settings: useMockJiraData = \(settings.useMockJiraData)")
        print("Saving settings: jiraInstanceURL = '\(settings.jiraInstanceURL)'")
        print("Saving settings: jiraUsername = '\(settings.jiraUsername)'")
        try? settingsService.saveSettings(settings)
    }
    
    func moveSection(from source: IndexSet, to destination: Int) {
        settings.sectionOrder.move(fromOffsets: source, toOffset: destination)
        saveSettings()
    }
    
    func toggleSection(_ section: String) {
        if settings.templateSections.contains(section) {
            settings.templateSections.removeAll { $0 == section }
        } else {
            settings.templateSections.append(section)
        }
        saveSettings()
    }
    
    func updateJiraInstanceURL(_ url: String) {
        settings.jiraInstanceURL = url
        saveSettings()
    }
} 