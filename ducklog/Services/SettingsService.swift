import Foundation

class SettingsService {
    static let shared = SettingsService()
    private let defaults = UserDefaults.standard
    private let settingsKey = "ducklog_settings"
    
    private init() {}
    
    func saveSettings(_ settings: SettingsModel) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings)
        defaults.set(data, forKey: settingsKey)
    }
    
    func loadSettings() -> SettingsModel {
        guard let data = defaults.data(forKey: settingsKey) else {
            return SettingsModel.default
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SettingsModel.self, from: data)
        } catch {
            return SettingsModel.default
        }
    }
} 