import Foundation

struct SettingsModel: Codable {
    var templateSections: [String]
    var sectionOrder: [String]
    var summaryTemplateEnabled: Bool
    
    static let defaultSections = [
        "Achievements",
        "Blockers",
        "Personal",
        "Feedback/Ideas",
        "Team Collaboration"
    ]
    
    static var `default`: SettingsModel {
        SettingsModel(
            templateSections: defaultSections,
            sectionOrder: defaultSections,
            summaryTemplateEnabled: true
        )
    }
} 