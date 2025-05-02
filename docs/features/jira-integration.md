# Jira Integration

## Overview

The Jira integration feature allows users to import Jira tickets directly into their journal entries. This integration streamlines the process of documenting work related to specific Jira tickets and maintains references to the original ticket.

## Features

- **Ticket Lookup**: Search for tickets by URL or ticket ID (e.g., PROJ-123)
- **Preview**: View ticket details before creating an entry
- **Formatted Entry Creation**: Generate well-formatted entries with ticket information
- **Network Testing**: Built-in connection testing to verify Jira connectivity
- **Mock Data Mode**: Option to use mock data for testing without network connection

## Configuration

Jira integration requires configuration in the Settings view:

1. **Jira Instance URL**: The base URL of your Jira instance (e.g., https://mycompany.atlassian.net)
2. **Username**: Your Jira username (typically your email address)
3. **API Token**: A token generated from your Atlassian account
4. **Use Mock Data**: Toggle for testing without a network connection

## Usage Flow

1. From the main interface, select the "Create Entry from Jira" option
2. Enter a Jira ticket URL or ID in the provided field
3. Click "Look Up Ticket" to fetch the ticket details
4. Review the ticket information in the preview
5. Click "Create Entry with Ticket" to generate a journal entry

## Entry Format

Entries created from Jira tickets follow a standardized format:

```markdown
# [Ticket Title]

### Ticket#: [Ticket Key]
### Status: [Ticket Status]

---

This entry was auto-generated from Jira ticket [Ticket Key](Ticket URL)
```

## Authentication Details

- The app uses Basic Authentication with your username and API token
- Credentials are securely stored in the app's settings
- No password is stored or transmitted

## Technical Notes

- Network requests are made asynchronously to maintain app responsiveness
- Error handling provides meaningful feedback for common issues
- The connection test feature helps diagnose configuration problems

## Limitations

- Only supports basic ticket information (title, key, status)
- Description content is not included due to formatting limitations
- Attachments and comments are not imported 