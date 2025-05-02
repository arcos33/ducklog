# Integration Plan

## Jira Integration (Implemented)

- Used for importing and linking Jira tickets into journal entries
- Authentication via Basic Authentication with username and API token
- Features:
  - Ticket lookup by URL or ID
  - Formatted entry creation with ticket details
  - Network status testing
  - Optional mock data mode for testing without network
- Configuration in Settings view

## GitHub API (Planned)

- Used for fetching pull requests, descriptions, and statuses
- Authentication via OAuth or personal access token
- Scope: repo, read:org

## AI Summary (Planned)

- Service TBD (OpenAI, local model, etc.)
- Input: entries filtered by time period and tag
- Output: a summarized markdown block for meetings

## Local Storage

- Markdown files stored in app sandbox
- Settings saved using UserDefaults or a lightweight database