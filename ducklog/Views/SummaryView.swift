import SwiftUI

struct SummaryView: View {
    let entries: [JournalEntry]
    @StateObject private var settings = SettingsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(settings.settings.templateSections, id: \.self) { section in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(section)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ForEach(entries.filter { $0.tags.contains(section) }, id: \.id) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.content)
                                    .font(.body)
                                if let pr = entry.linkedPR {
                                    HStack {
                                        Image(systemName: "link")
                                        Text(pr.title)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                            }
                            .padding(.leading, 16)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    SummaryView(entries: [])
} 
