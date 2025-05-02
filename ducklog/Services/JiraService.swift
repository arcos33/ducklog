import Foundation
import SwiftUI

// MARK: - Models for Jira data
struct JiraTicket {
    var id: String
    var key: String
    var title: String
    var description: String
    var status: String
    var url: URL
    
    var statusType: JiraStatusType {
        let lowercaseStatus = status.lowercased()
        
        if lowercaseStatus.contains("done") || 
           lowercaseStatus.contains("closed") || 
           lowercaseStatus.contains("resolved") || 
           lowercaseStatus.contains("complete") {
            return .done
        } else if lowercaseStatus.contains("block") || 
                  lowercaseStatus.contains("impediment") ||
                  lowercaseStatus.contains("stuck") {
            return .blocked
        } else {
            return .inProgress
        }
    }
}

enum JiraStatusType {
    case inProgress
    case done
    case blocked
    
    var entryStatus: EntryStatus {
        switch self {
        case .inProgress: return .inProgress
        case .done: return .done
        case .blocked: return .blocked
        }
    }
    
    var color: Color {
        switch self {
        case .inProgress: return .blue
        case .done: return .green
        case .blocked: return .red
        }
    }
}

// Models for decoding Jira API response
struct JiraAPIResponse: Decodable {
    let id: String
    let key: String
    let fields: Fields
    
    struct Fields: Decodable {
        let summary: String
        let status: Status
        let description: Description?
        
        struct Status: Decodable {
            let name: String
        }
        
        struct Description: Decodable {
            let content: [Content]?
            
            struct Content: Decodable {
                let content: [TextContent]?
                
                struct TextContent: Decodable {
                    let text: String?
                }
            }
        }
    }
}

// MARK: - Jira Service
class JiraService {
    private let baseURL: String
    private let username: String
    
    private var headers: [String: String] {
        let credentials = "\(username):\(apiToken)"
        guard let credentialsData = credentials.data(using: .utf8) else {
            return ["Content-Type": "application/json"]
        }
        
        let base64Credentials = credentialsData.base64EncodedString()
        return [
            "Authorization": "Basic \(base64Credentials)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    private var apiToken: String {
        JiraTokenManager.getToken() ?? ""
    }
    
    private var useMockData: Bool
    
    init(baseURL: String, username: String = "", useMockData: Bool = false) {
        // Ensure baseURL doesn't end with a slash
        if baseURL.hasSuffix("/") {
            self.baseURL = String(baseURL.dropLast())
        } else {
            self.baseURL = baseURL
        }
        self.username = username.isEmpty ? UserDefaults.standard.string(forKey: "jiraUsername") ?? "" : username
        self.useMockData = useMockData
    }
    
    func fetchTicket(byID ticketID: String) async throws -> JiraTicket {
        // Force log the mock data status
        print("JiraService fetchTicket - useMockData: \(useMockData)")
        
        // Force disable mock mode - temporary fix
        let actuallyUseMockData = false
        
        if actuallyUseMockData {
            // Return mock data instead of making a network request
            print("Using mock data for ticket: \(ticketID)")
            return createMockTicket(for: ticketID)
        }
        
        print("Attempting real network request for ticket: \(ticketID)")
        
        guard !baseURL.isEmpty else {
            throw NSError(domain: "JiraServiceError", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "Jira instance URL not configured. Please set it in Settings."
            ])
        }
        
        guard !apiToken.isEmpty else {
            throw NSError(domain: "JiraServiceError", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "API token not found. Please set it in Settings."
            ])
        }
        
        // Format the URL correctly - ensure it has https:// prefix but doesn't duplicate it
        var formattedBaseURL = baseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if formattedBaseURL.lowercased().hasPrefix("https://") {
            // Already has https prefix
        } else if formattedBaseURL.lowercased().hasPrefix("http://") {
            // Has http prefix - leave as is (though not recommended)
        } else {
            // Add https prefix
            formattedBaseURL = "https://" + formattedBaseURL
        }
        
        // Remove any trailing slashes from base URL
        while formattedBaseURL.hasSuffix("/") {
            formattedBaseURL = String(formattedBaseURL.dropLast())
        }
        
        // Clean up the ticket ID (remove any URL parts if a full URL was pasted)
        var cleanTicketID = ticketID.trimmingCharacters(in: .whitespacesAndNewlines)
        if let extractedID = parseTicketIDFromURL(cleanTicketID) {
            cleanTicketID = extractedID
        }
        
        print("Formatted base URL: \(formattedBaseURL)")
        print("Clean ticket ID: \(cleanTicketID)")
        
        // Construct the API URL
        let apiURL = "\(formattedBaseURL)/rest/api/3/issue/\(cleanTicketID)"
        print("Requesting API URL: \(apiURL)")
        
        guard let url = URL(string: apiURL) else {
            throw NSError(domain: "JiraServiceError", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid URL format: \(apiURL)"
            ])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "JiraServiceError", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "Invalid response from server."
                ])
            }
            
            print("Jira API response status code: \(httpResponse.statusCode)")
            
            // Check for specific HTTP status codes
            switch httpResponse.statusCode {
            case 200..<300:
                // Success - continue processing
                break
            case 401, 403:
                throw NSError(domain: "JiraServiceError", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "Authentication failed. Please check your API token."
                ])
            case 404:
                throw NSError(domain: "JiraServiceError", code: 404, userInfo: [
                    NSLocalizedDescriptionKey: "Ticket not found. Please check the ticket ID."
                ])
            default:
                throw NSError(domain: "JiraServiceError", code: httpResponse.statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"
                ])
            }
            
            let decoder = JSONDecoder()
            let jiraResponse = try decoder.decode(JiraAPIResponse.self, from: data)
            
            // Construct a clean browse URL
            let browseURL = "\(formattedBaseURL)/browse/\(jiraResponse.key)"
            guard let ticketURL = URL(string: browseURL) else {
                throw NSError(domain: "JiraServiceError", code: 400, userInfo: [
                    NSLocalizedDescriptionKey: "Could not create browse URL"
                ])
            }
            
            // Extract description safely
            let description = jiraResponse.fields.description?.content?.first?.content?.first?.text ?? ""
            
            return JiraTicket(
                id: jiraResponse.id,
                key: jiraResponse.key,
                title: jiraResponse.fields.summary,
                description: description,
                status: jiraResponse.fields.status.name,
                url: ticketURL
            )
        } catch let urlError as URLError {
            // Handle network-specific errors
            let errorMessage: String
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "Not connected to the internet. Please check your connection."
            case .cannotFindHost, .cannotConnectToHost:
                errorMessage = "Cannot connect to Jira server. Please verify the Jira URL in Settings."
            case .timedOut:
                errorMessage = "Connection timed out. Please try again."
            default:
                errorMessage = "Network error: \(urlError.localizedDescription)"
            }
            
            throw NSError(domain: "JiraServiceError", code: urlError.code.rawValue, userInfo: [
                NSLocalizedDescriptionKey: errorMessage,
                NSUnderlyingErrorKey: urlError
            ])
        } catch {
            // Re-throw with more context if it's not already a custom error
            if (error as NSError).domain == "JiraServiceError" {
                throw error
            } else {
                throw NSError(domain: "JiraServiceError", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to process Jira ticket: \(error.localizedDescription)",
                    NSUnderlyingErrorKey: error
                ])
            }
        }
    }
    
    func parseTicketIDFromURL(_ urlString: String) -> String? {
        // Extract ticket ID from a URL like https://yourjira.atlassian.net/browse/PROJ-123
        guard let url = URL(string: urlString),
              url.pathComponents.count > 1 else {
            return nil
        }
        
        // Look for a component that matches the Jira ticket pattern (letters-numbers)
        for component in url.pathComponents {
            // Match pattern like PROJ-123
            let pattern = #"^[A-Z]+-\d+$"#
            if let _ = component.range(of: pattern, options: .regularExpression) {
                return component
            }
        }
        
        return nil
    }
    
    // MARK: - Mock Data
    
    private func createMockTicket(for ticketID: String) -> JiraTicket {
        // Use the ticket ID to create a predictable but seemingly unique mock ticket
        let domain = baseURL.isEmpty ? "company.atlassian.net" : baseURL
        let ticketKey = ticketID.contains("-") ? ticketID : "MOCK-\(ticketID)"
        
        let statuses = ["In Progress", "Done", "Blocked", "To Do", "In Review"]
        let statusIndex = abs(ticketKey.hash) % statuses.count
        let status = statuses[statusIndex]
        
        // Create a realistic-looking description
        let descriptions = [
            "Need to implement the user authentication flow according to the new design specs.",
            "Fix rendering issues when the user switches between light and dark mode.",
            "Optimize database queries for the user dashboard to improve performance.",
            "Update API endpoints to use the new versioning scheme.",
            "Implement offline caching for better user experience during network disruptions."
        ]
        let descriptionIndex = abs((ticketKey + "desc").hash) % descriptions.count
        
        // Create a title based on the ticket ID
        let titles = [
            "Implement \(ticketKey) feature",
            "Fix bug in \(ticketKey.split(separator: "-").first?.lowercased() ?? "module")",
            "Update documentation for \(ticketKey)",
            "Performance optimization for \(ticketKey.split(separator: "-").first?.lowercased() ?? "component")",
            "UX improvements in \(ticketKey)"
        ]
        let titleIndex = abs((ticketKey + "title").hash) % titles.count
        
        return JiraTicket(
            id: String(abs(ticketKey.hash)),
            key: ticketKey,
            title: titles[titleIndex],
            description: descriptions[descriptionIndex],
            status: status,
            url: URL(string: "https://\(domain)/browse/\(ticketKey)")!
        )
    }
    
    // MARK: - Network Testing
    
    func testNetworkConnection() async -> String {
        print("Testing basic network connectivity...")
        
        // Try a simple public URL
        let testURL = "https://httpbin.org/get"
        
        guard let url = URL(string: testURL) else {
            return "Error: Could not create URL"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return "Error: Invalid response type"
            }
            
            print("Test connection status code: \(httpResponse.statusCode)")
            
            if (200..<300).contains(httpResponse.statusCode) {
                let responseString = String(data: data, encoding: .utf8) ?? "No data"
                return "SUCCESS: Network connection works! Status: \(httpResponse.statusCode)\nResponse preview: \(responseString.prefix(100))..."
            } else {
                return "Error: Bad status code \(httpResponse.statusCode)"
            }
        } catch {
            print("Test connection failed with error: \(error.localizedDescription)")
            return "ERROR: Network test failed: \(error.localizedDescription)"
        }
    }
} 