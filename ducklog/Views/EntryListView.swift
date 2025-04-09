import SwiftUI

struct EntryListView: View {
    @ObservedObject var viewModel: JournalViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.filteredEntries, id: \.self) { entry in
                VStack(alignment: .leading) {
                    Text(entry.content.prefix(60))
                        .font(.headline)
                    Text(formattedTime(entry.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    viewModel.selectedEntry = entry
                }
            }
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
} 