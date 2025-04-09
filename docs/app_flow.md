# App Flow

## 1. Creating a New Journal Entry

- User clicks the **floating plus button**
- A **sheet** appears with:
  - A **text field** for the journal entry
  - Option to **select tags**
  - Ability to **link GitHub Pull Requests**
    - Filter by PR status: "In Progress", "Done"
    - Pull in PR title, description, and status
  - The **status** of the entry is selectable
- Entry is saved using SwiftData

## 2. Weekly and Timeline Views

- A **timeline/calendar view** displays entries
- Filter buttons: "Last Week", "Two Weeks", "Three Weeks"
- Entries are grouped by day using consistent **date formatting**
- Useful for preparing one-on-ones or personal reviews

## 3. Summary Template Structure (Global)

- Managed in **DuckLog > Settings**
- Users define which sections are relevant:
  - Achievements
  - Blockers
  - Personal (e.g., Medical, Vacation, PTO)
  - Feedback/Ideas
  - Team Collaboration
- Template is applied globally to all summaries
- Optional **drag-and-drop reordering** of sections
- UI supports one template with customizable sections

## 4. Summary View

- Displays entries organized by template sections
- Each section shows relevant entries based on tags
- Includes entry content and linked PRs
- Updates automatically based on selected time period

## 5. Settings View

- Users access it through `DuckLog > Settings` from the menu bar
- Main purpose is to configure global settings such as:
  - Summary Template structure (sections and order)
- Designed to scale with additional preferences in the future