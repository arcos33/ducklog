# Layout Design

## Overview

DuckLog is designed as a multiplatform journaling app (macOS, iPad, iOS), with its primary design inspiration drawn from the Day One journal macOS app. The interface focuses on clarity, ease of navigation, and a modern, native feel across all Apple platforms.

---

## Main Layout Structure (Day One-Inspired)

### 1. Sidebar Navigation
- Located on the left, always visible on macOS, collapsible on iPad/iOS
- Provides access to:
  - All Entries
  - Tags
  - Media
  - Journals
  - Trash
  - Settings
- Uses icons and text for clear navigation

### 2. Entry List Pane
- Displays a chronological list of journal entries
- Groups entries by month and year
- Shows for each entry:
  - Title (first line of content)
  - Preview of content
  - Time
  - Status indicator (color-coded)
  - Tags (if any)
- Supports search and filtering
- Date-based navigation (This Week, Custom Range, Show All)

### 3. Entry Detail Pane
- Document-style layout with generous margins (128pt horizontal padding)
- Three distinct sections:
  1. **Header**
     - Date and time (Month D, YYYY format)
     - Day of week and time
     - Status indicator
     - Edit/Done button
  2. **Content Area**
     - Full-height scrollable content
     - Markdown rendering in view mode
     - Text editor in edit mode
     - Top-aligned with proper spacing
  3. **Bottom Controls** (in edit mode)
     - Status selector with visual indicators
     - Tag selection interface
     - Save/Cancel actions for new entries

---

## ASCII Diagram

```
+----------------+--------------------------+--------------------------------+
|   SIDEBAR      |      ENTRY LIST         |        ENTRY DETAIL            |
|----------------|--------------------------|--------------------------------|
| - All Entries  | May 2025                | May 1, 2025                    |
| - Tags         |   THU 1                 | Thursday, 9:26 PM              |
| - Media        |   - Meeting notes       | [In Progress]                  |
| - Journals     |   - Testing markdown    |                                |
| - Trash        |   - Another entry       | # Meeting with backend team    |
| - Settings     |                         | - discussed things             |
|                | April 2025              | - **YELLED** at customer...    |
|                |   SUN 27                |                                |
|                |   - My new entry        | `thebest.swift`               |
|                |                         |                                |
|                |                         | [Status & Tags Controls]        |
+----------------+--------------------------+--------------------------------+
```

---

## Design Elements

### Typography
- System fonts for native feel
- Clear hierarchy:
  - Title: `.title2`
  - Subtitle: `.subheadline`
  - Content: `.body`
  - Controls: `.caption`

### Colors
- Platform-specific background colors
- Status colors:
  - In Progress: Blue
  - Done: Green
  - Blocked: Red
- Proper contrast and opacity for status indicators

### Spacing
- Generous horizontal padding (128pt) for optimal reading
- Consistent vertical spacing
- Clear section separation

---

## Multiplatform Considerations

### macOS
- Three-column layout always visible
- Native window background colors
- Keyboard shortcuts
- Mouse-optimized controls

### iPad
- Adaptive three-column layout
- Collapsible sidebar
- Touch-optimized controls
- Split view support

### iOS
- Stack navigation
- Modal presentation for detail view
- Bottom sheet for quick entry
- Touch-optimized interface

---

## Implementation Notes

### SwiftUI Components
- `NavigationSplitView` for main layout
- `ScrollView` with `GeometryReader` for content
- Platform-specific color adaptations
- Markdown rendering support

### State Management
- Entry selection
- Edit mode handling
- Content updates
- Status and tag management

### Future Considerations
- Media attachment support
- Location and weather integration
- Multiple journal support
- Extended markdown capabilities 