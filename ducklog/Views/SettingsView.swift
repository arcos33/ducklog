import SwiftUI
import KeychainAccess

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingJiraKey = false
    @State private var jiraApiKey = ""
    @State private var isJiraKeySet = false
    @State private var showingSavedStatus = false
    @State private var selectedTab = 0
    @State private var jiraInstanceURLInput = ""
    @State private var showingJiraURLSavedStatus = false
    @State private var isEditingJiraURL = false
    @State private var jiraUsernameInput = ""
    @State private var showingJiraUsernameSavedStatus = false
    @State private var isEditingJiraUsername = false
    @Environment(\.presentationMode) private var presentationMode
    
    private let tabs = ["General", "Sync", "Journals", "Appearance", "Security", "About"]
    
    var body: some View {
        #if os(macOS)
        macOSSettingsView
        #else
        iOSSettingsView
        #endif
    }
    
    // MARK: - Platform-specific views
    
    private var macOSSettingsView: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            
            // Tab Selector
            HStack(spacing: 20) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Image(systemName: tabIcon(for: index))
                            .font(.system(size: 20))
                        Text(tabs[index])
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .accentColor : .gray)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(selectedTab == index ? Color.accentColor.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = index
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            .background(Color.secondary.opacity(0.1))
            
            Divider()
            
            // Content Area
            ScrollView {
                settingsContent
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            checkForExistingJiraToken()
        }
    }
    
    private var iOSSettingsView: some View {
        List {
            Section {
                #if os(iOS)
                Picker("Category", selection: $selectedTab) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Label(tabs[index], systemImage: tabIcon(for: index))
                            .tag(index)
                    }
                }
                .pickerStyle(.navigationLink)
                #else
                // Alternative for macOS
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        selectedTab = index
                    }) {
                        Label(tabs[index], systemImage: tabIcon(for: index))
                    }
                    .buttonStyle(.plain)
                }
                #endif
            }
            
            settingsContent
        }
        .navigationTitle("Settings")
        .onAppear {
            checkForExistingJiraToken()
        }
    }
    
    // MARK: - Common content
    
    @ViewBuilder
    private var settingsContent: some View {
        switch selectedTab {
        case 0: // General
            generalSettings
        case 1: // Sync
            Text("Sync settings coming soon")
                .foregroundColor(.secondary)
        case 2: // Journals
            journalsSettings
        case 3: // Appearance
            appearanceSettings
        case 4: // Security
            securitySettings
        case 5: // About
            aboutSettings
        default:
            EmptyView()
        }
    }
    
    private var generalSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            #if os(macOS)
            Toggle("Show Menu Bar Entry", isOn: .constant(true))
                .disabled(true)
            
            HStack {
                Text("Global Menu Bar Shortcut")
                Spacer()
                Text("⌘+⌥+D")
                    .foregroundColor(.secondary)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(4)
            }
            #endif
            
            Toggle("Auto Add Location", isOn: .constant(true))
            Toggle("Auto-apply Point of Interest", isOn: .constant(true))
            Toggle("Create Tags from Hashtags", isOn: .constant(true))
            Toggle("Show Timezone", isOn: .constant(true))
            Toggle("Auto-play Video", isOn: .constant(true))
            
            HStack {
                Text("Show Daily Prompt")
                Spacer()
                Menu("None") {
                    Text("Every Day")
                    Text("Weekdays")
                    Text("None")
                }
                .frame(width: 150)
            }
        }
    }
    
    private var journalsSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary Template")
                .font(.headline)
            
                    Text("Select which sections to include in your weekly summary and drag to reorder.")
                        .font(.caption)
                        .foregroundColor(.secondary)
            
            #if os(macOS)
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
            .frame(height: 160)
            .listStyle(.plain)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(6)
            #else
            ForEach(viewModel.settings.sectionOrder, id: \.self) { section in
                Toggle(isOn: Binding(
                    get: { viewModel.settings.templateSections.contains(section) },
                    set: { isOn in
                        if isOn {
                            if !viewModel.settings.templateSections.contains(section) {
                                viewModel.settings.templateSections.append(section)
                                viewModel.saveSettings()
                            }
                        } else {
                            viewModel.settings.templateSections.removeAll { $0 == section }
                            viewModel.saveSettings()
                        }
                    }
                )) {
                    Text(section)
                }
            }
            .onMove(perform: viewModel.moveSection)
            #endif
        }
    }
    
    private var appearanceSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Theme")
                .font(.headline)
            
            Toggle("Dark Mode", isOn: $isDarkMode)
            
            Divider()
            
            Text("Text Size")
                .font(.headline)
            
            HStack {
                Text("A").font(.system(size: 12))
                Slider(value: .constant(0.5))
                Text("A").font(.system(size: 24))
            }
        }
    }
    
    private var securitySettings: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Jira Integration")
                .font(.title3)
                .bold()
                .padding(.bottom, 4)
            
            // JIRA URL SECTION
            VStack(alignment: .leading, spacing: 12) {
                Text("Jira Instance URL")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !viewModel.settings.jiraInstanceURL.isEmpty && !isEditingJiraURL {
                    // Display the saved URL with update button
                    HStack {
                        Text(viewModel.settings.jiraInstanceURL)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                        Spacer()
                        Button(action: {
                            jiraInstanceURLInput = viewModel.settings.jiraInstanceURL
                            isEditingJiraURL = true
                        }) {
                            Label("Update URL", systemImage: "pencil")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Label("URL configured", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                } else {
                    // Edit field with save button
                    HStack {
                        TextField("https://yourcompany.atlassian.net", text: $jiraInstanceURLInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .onAppear {
                                if isEditingJiraURL {
                                    jiraInstanceURLInput = viewModel.settings.jiraInstanceURL
                                }
                            }
                        
                        Button("Cancel") {
                            isEditingJiraURL = false
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Save") {
                            viewModel.updateJiraInstanceURL(jiraInstanceURLInput)
                            showingJiraURLSavedStatus = true
                            isEditingJiraURL = false
                            
                            // Hide saved status after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showingJiraURLSavedStatus = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(jiraInstanceURLInput.isEmpty)
                    }
                    
                    if showingJiraURLSavedStatus {
                        Label("URL Saved", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Text("Base URL of your Jira instance without paths or ticket IDs")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
            
            // JIRA USERNAME SECTION
            VStack(alignment: .leading, spacing: 12) {
                Text("Jira Username / Email")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !viewModel.settings.jiraUsername.isEmpty && !isEditingJiraUsername {
                    // Display the saved username with update button
                    HStack {
                        Text(viewModel.settings.jiraUsername)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                        Spacer()
                        Button(action: {
                            jiraUsernameInput = viewModel.settings.jiraUsername
                            isEditingJiraUsername = true
                        }) {
                            Label("Update Email", systemImage: "pencil")
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Label("Email configured", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.subheadline)
                } else {
                    // Edit field with save button
                    HStack {
                        TextField("user@example.com", text: $jiraUsernameInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            #endif
                            .onAppear {
                                if isEditingJiraUsername {
                                    jiraUsernameInput = viewModel.settings.jiraUsername
                                }
                            }
                        
                        Button("Cancel") {
                            isEditingJiraUsername = false
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Save") {
                            viewModel.settings.jiraUsername = jiraUsernameInput
                            UserDefaults.standard.set(jiraUsernameInput, forKey: "jiraUsername")
                            viewModel.saveSettings()
                            showingJiraUsernameSavedStatus = true
                            isEditingJiraUsername = false
                            
                            // Hide saved status after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showingJiraUsernameSavedStatus = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(jiraUsernameInput.isEmpty)
                    }
                    
                    if showingJiraUsernameSavedStatus {
                        Label("Email Saved", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Text("Email address used for Jira authentication")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
            
            // API TOKEN SECTION
            VStack(alignment: .leading, spacing: 12) {
                Text("Jira API Token")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if isJiraKeySet {
                    // Credential status when already saved
                    HStack {
                        Label("API Token saved to Keychain", systemImage: "checkmark.shield")
                            .foregroundColor(.green)
                            .font(.subheadline)
                        Spacer()
                    }
                    
                    HStack {
                        Text("••••••••••••••••••••")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            isJiraKeySet = false
                            showingJiraKey = true
                            jiraApiKey = JiraTokenManager.getToken() ?? ""
                        }) {
                            Label("Update", systemImage: "pencil")
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            deleteJiraToken()
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    // Input field when not yet saved
                    HStack {
                        if showingJiraKey {
                            TextField("Jira API Token", text: $jiraApiKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled()
                                .textContentType(.password)
                        } else {
                            SecureField("Jira API Token", text: $jiraApiKey)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocorrectionDisabled()
                        }
                        
                        Button(action: {
                            showingJiraKey.toggle()
                        }) {
                            Image(systemName: showingJiraKey ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button("Cancel") {
                            isJiraKeySet = true
                            showingJiraKey = false
                            jiraApiKey = ""
                        }
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            if !jiraApiKey.isEmpty {
                                saveJiraToken(jiraApiKey)
                                isJiraKeySet = true
                                showingSavedStatus = true
                                
                                // Hide saved status after 2 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showingSavedStatus = false
                                }
                            }
                        }) {
                            Text("Save to Keychain")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(jiraApiKey.isEmpty)
                    }
                    
                    if showingSavedStatus {
                        Label("Saved to Keychain", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                
                Text("Used to connect and fetch issues from your Jira instance")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
            
            Spacer()
            
            // DEVELOPER MODE SECTION
            VStack(alignment: .leading, spacing: 12) {
                Text("Developer Mode")
                    .font(.headline)
                    .foregroundColor(.primary)
                    
                Toggle("Use Mock Jira Data (No Network)", isOn: Binding(
                    get: { viewModel.settings.useMockJiraData },
                    set: { viewModel.settings.useMockJiraData = $0; viewModel.saveSettings() }
                ))
                
                Text("Enable this to use offline sample data when network access is restricted")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
        .padding(.vertical)
    }
    
    private var aboutSettings: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Build")
                Spacer()
                Text("2025.05.02")
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            Text("Made with ❤️ by DuckLog Team")
                .foregroundColor(.secondary)
        }
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "gearshape"
        case 1: return "arrow.triangle.2.circlepath.circle"
        case 2: return "book"
        case 3: return "textformat.size"
        case 4: return "lock"
        case 5: return "info.circle"
        default: return "questionmark"
        }
    }
    
    // MARK: - Jira Token Methods
    
    private func checkForExistingJiraToken() {
        if let token = JiraTokenManager.getToken(), !token.isEmpty {
            isJiraKeySet = true
        }
        
        // Check if Jira URL is set
        isEditingJiraURL = viewModel.settings.jiraInstanceURL.isEmpty
        isEditingJiraUsername = viewModel.settings.jiraUsername.isEmpty
    }
    
    private func saveJiraToken(_ token: String) {
        JiraTokenManager.save(token: token)
    }
    
    private func deleteJiraToken() {
        JiraTokenManager.deleteToken()
        isJiraKeySet = false
        jiraApiKey = ""
    }
}

#Preview {
    SettingsView()
} 

