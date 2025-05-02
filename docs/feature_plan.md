# Feature Plan

## Core Features (Day One-Inspired)

- **Sidebar Navigation**: Persistent sidebar for navigation (journals, tags, media, settings)
- **Entry List Pane**: Chronological list of entries for the selected context (journal, tag, etc.)
- **Entry Detail/Editor Pane**: Full view and editing of the selected entry, with metadata and PR links
- **Floating Plus Button**: Quick entry creation via modal or sheet
- **Popover Entry Interface**:
  - Text field for journaling
  - Tag selection (e.g., "Code Review", "Bug Fix")
  - GitHub PR linking with filtered status options and auto-filled details
  - Entry status selection: "In Progress", "Done"
- **Global Entry Template Customization**:
  - Accessible in `DuckLog > Settings`
  - Users can toggle sections like:
    - Achievements
    - Blockers
    - Personal (e.g., Medical, Vacation, PTO)
    - Feedback/Ideas
    - Team Collaboration
  - Sections may be reordered via drag-and-drop
  - Template structure defines summary view layout
- **Search Bar**: For quick entry lookup
- **Adaptive Layout**: Uses SwiftUI NavigationSplitView for multiplatform support (macOS, iPad, iOS)

## Planned Features

- **Media Attachments**: Add images, files, or audio to entries
- **Calendar View**: Browse entries by date (calendar picker or timeline)
- **Multiple Journals**: Support for organizing entries into separate journals
- **AI Summaries**: Generates summaries based on tags and selected entry template (for meetings, reviews)
- **Map View**: (Future) Browse entries by location
- **Enhanced Multiplatform Support**: Consistent experience across macOS, iPad, and iOS
- **GitHub API Integration**: Fetch PR information, descriptions, and statuses

## Settings View

- Central place for configuring global app behavior
- Includes:
  - Summary Template layout customization
  - (Future) AI settings
  - (Future) Default tags or GitHub preferences
- Accessible via the app's top menu: `DuckLog > Settings`

## Notes

- All features are designed with multiplatform support in mind (macOS, iPad, iOS)
- The template layout is currently a single global structure per user
- Future versions may support multiple layouts and advanced customization