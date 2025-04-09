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

### 📝 Column 2: Entry List
- Shows journal entries for the selected time period
- Can display a list of:
  - Entry titles (or first few words)
  - Status indicators (e.g., "In Progress", "Done")
  - Tags
- Clicking an item loads the full entry in Column 3

### 🔍 Column 3: Entry Detail / Editor
- Displays full journal entry content
- Allows for editing, tagging, and GitHub PR linking
- May include:
  - Sectioned view (Achievements, Personal, etc.)
  - Option to collapse/expand sections

---

## Additional UX Notes

- Clicking the **Floating + Button** opens a Popover for quick entry creation
- The layout should be **adaptive**, collapsing columns when space is limited (e.g., iPad in portrait mode)
- In the future, the third column may include a **Summary View** for AI-generated summaries

---

## macOS vs iPad Considerations

- macOS: Uses full 3-column layout side-by-side
- iPad (future): Might use sidebar navigation or stacked layout depending on screen size and orientation
- Leverage SwiftUI's `NavigationSplitView` or `NavigationStack` for clean and adaptive transitions 