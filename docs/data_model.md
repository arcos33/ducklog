# Data Model

## JournalEntry

- `id: UUID` - Unique identifier for each entry
- `timestamp: Date` - When the entry was created
- `title: String` - Entry title/heading
- `content: String` - Main entry content
- `tags: [String]` - Categories for organizing entries
- `status: String` - Current state of the entry
- `linkedPR: GitHubPR?` - Optional linked GitHub pull request

## GitHubPR

- `id: String` - GitHub PR identifier
- `title: String` - PR title
- `description: String` - PR description
- `status: String` - PR status (In Progress, Done)
- `url: URL` - Link to the PR

## SettingsModel

- `templateSections: [String]` - Default sections: Achievements, Blockers, Personal, Feedback/Ideas, Team Collaboration
- `sectionOrder: [String]` - Order of sections in summary view
- `summaryTemplateEnabled: Bool` - Toggle for summary template feature

## Data Storage

- Uses SwiftData for persistent storage
- Journal entries are stored in a local database
- Settings are saved using UserDefaults
- Entries are queryable by timestamp and tags