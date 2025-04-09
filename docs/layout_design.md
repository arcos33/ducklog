# Layout Design

## Overview

DuckLog is envisioned with a clean and intuitive 3-column layout, optimized for macOS and future iPad support. The layout allows for quick navigation, focused journaling, and clear review of past activity.

---

## Column Breakdown

### 📅 Column 1: Timeline / Date Selector
- Displays buttons like:
  - "This Week"
  - "Last Week"
  - "Two Weeks"
  - "Custom Range"
- May evolve into a calendar picker or heatmap view
- Filters entries by selected time period
- Shows entry previews with title, content, and metadata

### 📝 Column 2: Entry List
- Shows journal entries for the selected time period
- Displays a list of:
  - Entry titles
  - Content previews
  - Status indicators
  - Tags
  - Linked PRs
  - Timestamps
- Clicking an item loads the full entry in Column 3

### 🔍 Column 3: Summary View
- Displays entries organized by template sections
- Each section shows:
  - Section title in bold
  - Relevant entries based on tags
  - Entry content and linked PRs
- Automatically updates based on selected time period
- Scrollable view with consistent spacing
- Indented entries under section headers

---

## Additional UX Notes

- Clicking the **Floating + Button** opens a Popover for quick entry creation
- The layout should be **adaptive**, collapsing columns when space is limited
- Summary View uses settings from SettingsView to determine visible sections
- Consistent typography and spacing throughout the app

---

## macOS vs iPad Considerations

- macOS: Uses full 3-column layout side-by-side
- iPad (future): Might use sidebar navigation or stacked layout depending on screen size and orientation
- Leverage SwiftUI's `NavigationSplitView` for clean and adaptive transitions 