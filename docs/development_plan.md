# DuckLog Development Plan

> **Note:** The Weekly Summary View is the main feature—every feature should support making weekly reviews for 1:1s and team meetings fast and effective.

> **Progress Tracking:** Mark each task as complete with a checkmark (☑️) or [x] in the checkbox. Incomplete tasks use [ ] or ☐.

---

## 1. Project Foundation & Architecture
- [x] Set up SwiftUI multiplatform project (macOS, iPad, iOS targets)
- [x] Establish folder structure: Views, ViewModels, Models, Services, Assets
- [x] Set up SwiftData (or Core Data) for persistence
- [x] Set up basic navigation using NavigationSplitView (three-panel layout)

## 2. Core UI Shell
- [ ] Implement SidebarNavigationView (All Entries, Tags, Media (future), Journals (future), Trash, Settings)  
  _Sidebar currently lists entries; needs refactor to full navigation sidebar._
- [ ] Implement EntryListView (list, search/filter, selection logic)  
  _Entry list is currently in sidebar; needs to move to middle panel._
- [x] Implement Contextual Detail/Summary Pane
  - [x] Weekly Summary view (default)
  - [x] Entry Details view (on selection)

## 3. Data Model & Persistence
- [x] Define Models: JournalEntry, GitHubPR, SettingsModel
- [x] Implement SwiftData storage for entries and settings
- [x] Implement basic CRUD operations for journal entries

## 4. Entry Creation & Editing
- [x] Implement PopoverView (Quick Entry)
  - [x] Floating + button
  - [x] Modal/sheet for new entry
  - [x] Fields: title, content, tags, status, PR link
- [x] Implement entry editing in Entry Details pane

## 5. Weekly Summary Logic
- [x] Implement logic to filter and display entries for the current week
- [x] Design Weekly Summary view (grouped by day or section as needed)

## 6. Settings & Customization
- [ ] Implement SettingsView _(in progress)_
  - [x] Add summary template customization (sections, order)
  - [ ] Preferences (future: AI, GitHub, etc.)

## 7. Trash & Deletion
- [x] Implement Trash functionality
  - [x] Move entries to Trash
  - [x] Display trashed entries in Trash section
  - [x] Restore or permanently delete entries
  - [x] Trash management view (restore/delete)

## 8. Advanced Features (Iterative)
- [x] Tag management and filtering
  - [x] Tag filtering in entry list
  - [x] Tag management view (rename/delete tags)
  - [x] Tag selection UI
- [x] Entry list search bar
- [x] Entry list selection highlight (full-width, no rounded corners)
    - Switched from List to ScrollView + LazyVStack for full control over row backgrounds and spacing. This resolved the issue with system-imposed margins and ensures the selection highlight fills the entire width.
- [x] Card-style entry list UI (optional, can be further polished)
- [ ] Media attachments (future)
- [ ] Multiple journals (future)
- [ ] Calendar/Map view (future)
- [ ] GitHub API integration (future)
- [ ] AI-powered summaries (future)

## 9. Polish & Multiplatform Adaptation
- [ ] Refine adaptive layout for iPad/iOS
- [ ] Test and polish navigation transitions
- [ ] Accessibility, theming, and UX polish

## 10. Testing & Documentation
- [ ] Write unit/UI tests for core features
- [ ] Update documentation as features are implemented
    - Documented the UI change for entry list selection highlight (edge-to-edge) and the architectural switch to ScrollView + LazyVStack.
- [ ] Prepare for App Store/TestFlight submission 