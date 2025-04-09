# Feature Plan

## Core Features

- **Floating Plus Button**: Launches a popover window for quick journal entry creation.
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
  - The selected template structure will define the layout of the **summary view**
  - Sections may be reordered via drag-and-drop
  - Future-friendly: backend structure allows for adding support for multiple templates later
- **Timeline / Calendar View**:
  - Buttons to filter entries by timeframe ("Last Week", "Two Weeks", "Three Weeks")
  - Helps with weekly reviews and one-on-ones
- **Search Bar**: For quick entry lookup
- **AI Summaries (Planned)**:
  - Generates summaries based on tags and selected entry template
  - Useful for one-on-one meetings or weekly wrap-ups

## Settings View

- Central place for configuring global app behavior
- Includes:
  - Summary Template layout customization
  - (Future) AI settings
  - (Future) Default tags or GitHub preferences
- Accessible via the app's top menu: `DuckLog > Settings`

## Notes

- The template layout is currently a single global structure per user
- Future versions may support multiple layouts