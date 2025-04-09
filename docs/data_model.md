# Data Model

## JournalEntry

- `id: UUID`
- `date: Date`
- `content: String`
- `tags: [String]`
- `status: String`
- `linkedPullRequest: GitHubPR?`

## GitHubPR (Planned)

- `id: String`
- `title: String`
- `description: String`
- `status: String`
- `url: URL`

## SettingsModel

- `templateSections: [String]`
- `sectionOrder: [String]`
- `summaryTemplateEnabled: Bool`