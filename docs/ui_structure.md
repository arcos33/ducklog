# UI Structure

## PopoverView

- Triggered by the floating plus button
- Contains:
  - Text input field for title and content
  - Tag selector for categorizing entries
  - GitHub PR link input with status filtering
  - Entry status picker

## TimelineView

- Calendar or list-based view for reviewing past entries
- Filter buttons for "Last Week", "Two Weeks", etc.
- Displays entry previews with:
  - Title
  - Content preview
  - Tags
  - Linked PRs
  - Timestamp

## SettingsView

- Configures global settings like summary template
- Checkbox interface for selecting visible sections
- Drag-and-drop reordering of sections
- Toggle for summary template feature

## SummaryView

- Displays summary of selected time period
- Uses the structure defined in SettingsView
- Features:
  - Sections organized by template categories
  - Each section shows relevant entries based on tags
  - Displays entry content and linked PRs
  - Automatically updates based on selected time period
  - Scrollable view with consistent spacing and typography
  - Section headers in bold with indented entries