import Foundation

class SettingsViewModel: ObservableObject {
    @Published var settings: SettingsModel
    
    private let settingsService = SettingsService.shared
    
    init() {
        settings = settingsService.loadSettings()
    }
    
    func saveSettings() {
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
} 