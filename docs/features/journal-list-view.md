# Journal List View

## Overview
The journal list view is a core feature of DuckLog that displays journal entries in a chronologically organized timeline. It combines elegant visual design with efficient data organization to present entries in an intuitive and engaging way.

## Key Components

### EntryListView
The main container view that organizes and displays journal entries.

#### Features
- Groups entries by month/year
- Displays entries in reverse chronological order
- Uses a clean list-based layout with section headers
- Integrates with the JournalViewModel for data management

#### Implementation Details
```swift
struct EntryListView: View {
    @ObservedObject var viewModel: JournalViewModel
    @Binding var selectedEntry: JournalEntry?
}
```

Key functionality:
- Groups entries first by month/year
- Sub-groups entries by day
- Renders entries using StackedCardsView for each day group
- Maintains selection state for navigation

### StackedCardsView
A custom view component that renders a day's entries in a card-based layout.

#### Features
- Displays entries with a consistent card design
- Shows entry timestamp, status, and content preview
- Supports tag display with horizontal scrolling
- Implements a vertical timeline for multiple entries on the same day

#### Visual Elements
- Card Background: Uses system-appropriate colors with opacity
  - Light mode: systemGray6 with 0.3 opacity
  - Dark mode: systemGray6 or gridColor
- Timeline Connector: Subtle vertical line connecting same-day entries
- Status Indicators: Color-coded status badges
  - Done: Green
  - In Progress: Blue
  - Blocked: Red

### DateSquare
A reusable component that displays a date in a square format.

#### Features
- Shows day of week abbreviation
- Displays day number
- Uses system-appropriate background colors
- Implements consistent 50x50 size
- Includes subtle border overlay

#### Implementation
```swift
struct DateSquare: View {
    let date: Date
    
    // Formatting
    - Day Name: "EEE" format, uppercase
    - Day Number: "d" format
    - Size: 50x50 points
    - Corner Radius: 8 points
}
```

## User Interaction

### Entry Selection
- Tap on any entry card to select it
- Selection updates the detail view in split view layout
- Maintains navigation state through selectedEntry binding

### Visual Feedback
- Cards use system background colors for consistency
- Status badges provide clear visual indicators
- Timeline connects related entries
- Tag display limits to 3 tags with count indicator

## Data Organization

### Grouping Logic
1. Primary grouping by month/year
2. Secondary grouping by day
3. Entries sorted in reverse chronological order within groups

### Date Formatting
- Month/Year Headers: "MMMM yyyy" format
- Time Display: "h:mm a" format
- Day Names: Abbreviated, uppercase

## Performance Considerations

### Efficient Rendering
- Uses lazy loading through List view
- Implements ID-based ForEach for stable updates
- Limits tag display to first 3 tags
- Uses appropriate text line limits for previews

### Memory Management
- Reuses DateSquare components
- Efficiently processes date formatting
- Maintains minimal state

## Accessibility

### Color Adaptability
- Supports both light and dark mode
- Uses system colors for consistency
- Implements appropriate opacity levels

### Text Sizing
- Uses system fonts with appropriate weights
- Maintains readable text sizes
- Implements proper spacing for legibility

## Related Components

### JournalViewModel
- Manages entry data and filtering
- Provides filtered and sorted entries
- Handles entry selection state

### EntryDetailView
- Displays selected entry details
- Integrates with the list view selection
- Provides editing capabilities

## Future Enhancements

### Planned Features
- Drag and drop reordering
- Pinned entries
- Advanced filtering options
- Custom tag colors
- Expanded timeline visualization

### Optimization Opportunities
- Cached date formatting
- Improved grouping performance
- Enhanced animation transitions
- Refined card interactions 