import SwiftUI
import SwiftData

struct JiraTicketImportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: JournalViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    @State private var urlOrID: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var ticket: JiraTicket?
    @State private var useMockData: Bool = false
    @State private var networkTestResult: String? = nil
    @State private var isTestingNetwork = false
    
    private var jiraService: JiraService {
        JiraService(
            baseURL: settingsViewModel.settings.jiraInstanceURL,
            username: settingsViewModel.settings.jiraUsername,
            useMockData: useMockData
        )
    }
    
    var body: some View {
        #if os(macOS)
        macOSJiraImportView
            .onAppear(perform: loadSettings)
        #else
        iOSJiraImportView
            .onAppear(perform: loadSettings)
        #endif
    }
    
    private func loadSettings() {
        // Ensure we have the latest settings
        useMockData = settingsViewModel.settings.useMockJiraData
        print("JiraTicketImportView: Mock data setting is \(useMockData)")
        print("JiraTicketImportView: Jira URL is '\(settingsViewModel.settings.jiraInstanceURL)'")
        print("JiraTicketImportView: Jira Username is '\(settingsViewModel.settings.jiraUsername)'")
    }
    
    // MARK: - Platform-specific views
    
    private var macOSJiraImportView: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Import from Jira")
                    .font(.headline)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            .padding([.horizontal, .top])
            
            // Content
            jiraImportContent
                .padding()
            
            Spacer()
            
            // Footer
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                if let ticket = ticket {
                    Button("Create Entry with Ticket") {
                        createEntryFromTicket(ticket)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .frame(width: 500, height: 400)
    }
    
    private var iOSJiraImportView: some View {
        NavigationStack {
            ScrollView {
                jiraImportContent
                    .padding()
            }
            .navigationTitle("Import from Jira")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if let ticket = ticket {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create Entry") {
                            createEntryFromTicket(ticket)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Common content
    
    @ViewBuilder
    private var jiraImportContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            let jiraURLEmpty = settingsViewModel.settings.jiraInstanceURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            
            if jiraURLEmpty && !useMockData {
                // Show warning if Jira URL not configured and not using mock data
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    Text("Jira instance URL not configured. Please set it in Settings.")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(8)
            } else {
                // Force hide the mock data banner - temporary fix
                if false && useMockData {
                    HStack {
                        Image(systemName: "laptopcomputer.trianglebadge.exclamationmark")
                            .foregroundColor(.orange)
                        Text("Using Mock Data - No network connection required")
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter a Jira URL or ticket ID (e.g., PROJ-123)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Paste Jira URL or Ticket ID", text: $urlOrID)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            loadTicket()
                        }
                    
                    if !useMockData {
                        Text("Current Jira instance: \(settingsViewModel.settings.jiraInstanceURL)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 16) {
                    Button("Look Up Ticket") {
                        loadTicket()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(urlOrID.isEmpty || isLoading || settingsViewModel.settings.jiraInstanceURL.isEmpty)
                    
                    // Test connection button
                    Button("Test Network") {
                        testNetworkConnection()
                    }
                    .buttonStyle(.bordered)
                    .disabled(isTestingNetwork)
                }
                .frame(maxWidth: .infinity)
                
                // Show test results if available
                if isTestingNetwork {
                    HStack {
                        ProgressView()
                            .padding(.trailing, 8)
                        Text("Testing network connection...")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                } else if let testResult = networkTestResult {
                    VStack(alignment: .leading) {
                        Text("Network Test Result:")
                            .font(.headline)
                        
                        Text(testResult)
                            .foregroundColor(testResult.contains("SUCCESS") ? .green : .red)
                            .padding()
                            .background(
                                (testResult.contains("SUCCESS") ? Color.green : Color.red)
                                .opacity(0.1)
                            )
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                } else if let errorMessage = errorMessage {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Error")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        
                        Text(errorMessage)
                            .foregroundColor(.primary)
                            
                        // Troubleshooting tips
                        Text("Troubleshooting:")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Check your internet connection")
                            Text("• Verify your Jira URL in Settings")
                            Text("• Make sure your API token is correct")
                            Text("• Try using just the ticket ID (e.g., PROJ-123)")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                } else if let ticket = ticket {
                    ticketPreview(ticket)
                    
                    // Add Create Entry button
                    Button(action: {
                        createEntryFromTicket(ticket)
                    }) {
                        HStack {
                            Image(systemName: "plus.square.fill")
                            Text("Create Entry with Ticket")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
            }
        }
    }
    
    private func ticketPreview(_ ticket: JiraTicket) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(ticket.key)
                    .font(.system(.body, design: .monospaced))
                    .padding(4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                Text(ticket.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ticket.statusType.color.opacity(0.2))
                    .foregroundColor(ticket.statusType.color)
                    .cornerRadius(8)
            }
            
            Text(ticket.title)
                .font(.headline)
            
            if !ticket.description.isEmpty {
                ScrollView {
                    Text(ticket.description)
                        .font(.body)
                        .lineLimit(10)
                }
                .frame(maxHeight: 150)
            }
            
            Link("Open in Jira", destination: ticket.url)
                .padding(.top, 8)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func loadTicket() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let ticketID: String
                
                // Handle both URLs and direct ticket IDs
                if urlOrID.contains("/") {
                    guard let parsedID = jiraService.parseTicketIDFromURL(urlOrID) else {
                        throw NSError(domain: "JiraServiceError", code: 400, userInfo: [
                            NSLocalizedDescriptionKey: "Invalid URL format. Could not extract ticket ID."
                        ])
                    }
                    ticketID = parsedID
                } else {
                    ticketID = urlOrID
                }
                
                let fetchedTicket = try await jiraService.fetchTicket(byID: ticketID)
                
                await MainActor.run {
                    self.ticket = fetchedTicket
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error fetching ticket: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
    
    private func createEntryFromTicket(_ ticket: JiraTicket) {
        // Create a JournalEntry with the ticket data
        let content = """
        # \(ticket.title)
        
        ### Ticket#: \(ticket.key)
        ### Status: \(ticket.status)
        
        ---
        
        This entry was auto-generated from Jira ticket [\(ticket.key)](\(ticket.url.absoluteString))
        """
        
        let status = ticket.statusType.entryStatus
        
        viewModel.addEntry(
            content: content,
            tags: ["Jira", ticket.key],
            status: status,
            modelContext: modelContext
        )
        
        dismiss()
    }
    
    private func testNetworkConnection() {
        isTestingNetwork = true
        networkTestResult = nil
        
        Task {
            let result = await jiraService.testNetworkConnection()
            
            await MainActor.run {
                networkTestResult = result
                isTestingNetwork = false
            }
        }
    }
}

#Preview {
    JiraTicketImportView(viewModel: JournalViewModel())
        .environmentObject(SettingsViewModel())
} 
