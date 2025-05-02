import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var grouped: [String: [JournalEntry]] {
        let calendar = Calendar.current
        let now = Date()
        
        return Dictionary(grouping: viewModel.filteredEntries) { entry in
            if calendar.isDateInToday(entry.timestamp) {
                return "Today"
            } else if calendar.isDateInYesterday(entry.timestamp) {
                return "Yesterday"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d, yyyy"
                return formatter.string(from: entry.timestamp)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(grouped.keys.sorted(by: >), id: \ .self) { day in
                    VStack(alignment: .leading, spacing: 16) {
                        Text(day)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        
                        let entries = grouped[day] ?? []
                        ForEach(entries, id: \ .self) { entry in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(formattedTime(entry.timestamp))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(entry.content)
                                    .lineLimit(2)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        TimelineView(viewModel: MockData.mockViewModel)
            .frame(width: 400, height: 600)
    }
} 


