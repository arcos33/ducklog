# Entry Detail View

## Overview

The Entry Detail View is a core component of DuckLog that provides a focused, document-style interface for viewing and editing journal entries. Inspired by Day One's design, it emphasizes readability and a clean writing environment.

## Layout Structure

### Header Section
- Date and time display (Month D, YYYY format)
- Day of week and time
- Status indicator (In Progress, Done, Blocked)
- Edit/Done button in the top-right corner

### Content Area
- Generous horizontal padding (128pt) for optimal reading width
- Markdown content rendering in view mode
- Full-height text editor in edit mode
- Top-aligned content with proper spacing
- Supports rich text formatting through markdown

### Bottom Controls (Edit Mode)
- Status selector with visual indicators
- Tag selection interface
- Save/Cancel buttons for new entries

## Key Features

### View Mode
- Clean, document-style layout
- Markdown rendering with proper styling
- Status indicator
- Edit button for quick transitions

### Edit Mode
- Full-height text editor
- Status selection with color indicators
- Tag management
- Save/Cancel actions

## Markdown Support

### Supported Elements
- Headers (H1-H6)
- Lists (bulleted and numbered)
- Blockquotes
- Bold and italic text
- Code blocks
- Links

### Styling
- Proper spacing between elements
- Consistent typography
- Color-coded syntax

## Platform Adaptations

### macOS
- Native window background colors
- Platform-specific keyboard shortcuts
- Native control styles

### iOS/iPadOS
- Adaptive layout
- Touch-optimized controls
- iOS-specific background colors

## Implementation Details

### View Structure
```swift
struct EntryDetailView {
    // Main sections
    - Header (EntryHeaderView)
    - Content Area (ScrollView + MarkdownView/TextEditor)
    - Bottom Controls (Status + Tags)
}
```

### Key Components
1. **EntryHeaderView**
   - Date formatting
   - Status display
   - Edit button

2. **MarkdownContentView**
   - Markdown rendering
   - Proper spacing
   - Document-style layout

3. **Bottom Controls**
   - Status selection
   - Tag management
   - Action buttons

### State Management
- Editing state
- Content updates
- Status changes
- Tag selection

## User Interactions

### Viewing
1. Select entry from list
2. View rendered markdown content
3. See status and metadata
4. Click Edit to make changes

### Editing
1. Click Edit button
2. Modify content in text editor
3. Update status/tags
4. Save changes

### Creating New Entries
1. Click + button
2. Enter content
3. Set status and tags
4. Save new entry

## Design Considerations

### Layout
- 128pt horizontal padding for optimal reading width
- Proper vertical spacing between sections
- Clear visual hierarchy

### Typography
- System fonts for native feel
- Proper size hierarchy
- Consistent line spacing

### Colors
- Platform-specific background colors
- Status-specific accent colors
- Proper contrast ratios

## Future Enhancements

### Planned Features
- [ ] Media attachments
- [ ] Location tagging
- [ ] Weather information
- [ ] Custom templates
- [ ] Extended markdown support

### Accessibility
- [ ] Voice over support
- [ ] Dynamic type
- [ ] Keyboard navigation
- [ ] High contrast support 