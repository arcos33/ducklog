import SwiftUI

struct WeeklyOverviewView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var grouped: [String: [JournalEntry]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return Dictionary(grouping: viewModel.filteredEntries) {
            formatter.string(from: $0.timestamp)
        }
    }
    
    var body: some View {
        ScrollView {
            ForEach(grouped.keys.sorted(), id: \ .self) { day in
                Section(header: Text(day).font(.headline)) {
                    let entries = grouped[day] ?? []
                    ForEach(entries, id: \ .self) { entry in
                        VStack(alignment: .leading) {
                            Text(formattedTime(entry.timestamp))
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(entry.content)
                                .lineLimit(2)
                            Divider()
                        }
                    }
                }
                .padding(.bottom, 8)
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