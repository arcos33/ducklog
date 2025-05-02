import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Summary Template") {
                    Text("Select which sections to include in your weekly summary and drag to reorder.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    List {
                        ForEach(viewModel.settings.sectionOrder, id: \.self) { section in
                            HStack {
                                Image(systemName: viewModel.settings.templateSections.contains(section) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        viewModel.toggleSection(section)
                                    }
                                Text(section)
                                Spacer()
                                Image(systemName: "line.horizontal.3")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onMove(perform: viewModel.moveSection)
                    }
                }
                
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
} 

