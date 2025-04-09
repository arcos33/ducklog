import SwiftUI

struct EntryDetailView: View {
    var entry: JournalEntry?
    
    var body: some View {
        Group {
            if let entry = entry {
                VStack(alignment: .leading, spacing: 8) {
                    Text(formattedTime(entry.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                    ScrollView {
                        Text(entry.content)
                            .padding(.top, 4)
                    }
                }
            } else {
                Text("Select an entry")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
} 