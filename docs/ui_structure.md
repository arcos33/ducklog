# UI Structure

## SidebarNavigationView

- Persistent sidebar for navigation (always visible on macOS, collapsible on iPad/iOS)
- Sections:
  - All Entries
  - Tags
  - (Future) Media
  - (Future) Multiple Journals
  - Trash
  - Settings
- Uses icons and text for clarity

## EntryListView

- Main pane showing a chronological list of entries for the selected context (e.g., all entries, tag, journal)
- Features:
  - Entry title
  - Content preview
  - Date/time
  - Tags
  - Status indicators
  - Linked PRs
- Search and filter bar at the top
- Selecting an entry loads it in the contextual detail/summary pane

## Contextual Detail/Summary Pane

- **Default:** Shows the Weekly Summary (list of all items worked on during the week, grouped or listed)
- **When an entry is selected:** Shows Entry Details (full content, metadata, editing, PR links, etc.)
- Returns to Weekly Summary when no entry is selected
- Clean, distraction-free writing environment

## PopoverView (Quick Entry)

- Triggered by the floating plus button
- Contains:
  - Text input for title and content
  - Tag selector
  - GitHub PR link input with status filtering
  - Entry status picker

## SettingsView

- Configures global app settings (summary template, preferences)
- Checkbox interface for selecting visible sections
- Drag-and-drop reordering of sections
- Toggle for summary template feature

## Multiplatform Adaptation

- Uses SwiftUI's NavigationSplitView for adaptive navigation
- macOS: Sidebar, entry list, and contextual detail/summary pane always visible
- iPad: Sidebar can be shown/hidden; layout adapts to split view or stacked navigation
- iOS: Sidebar becomes modal or collapsible; uses tab/stacked navigation

## Design Notes

- Inspired by Day One macOS app for familiarity and usability
- Consistent, modern UI across all Apple platforms
- Scalable for future features (media, calendar/map views, multiple journals)