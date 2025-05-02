# DuckLog Documentation

## Features
- [Journal List View](features/journal-list-view.md) - Timeline-based journal entry visualization
- [Jira Integration](features/jira-integration.md) - Import Jira tickets into journal entries
- Entry Management
- Tag System
- Search and Filtering
- Data Export/Import

## Technical Documentation
- Architecture Overview
- Data Models
- View Components
- State Management
- Testing Strategy

## User Guide
- Getting Started
- Basic Usage
- Advanced Features
- Keyboard Shortcuts
- Customization

## Development
- Setup Guide
- Contributing Guidelines
- Code Style
- Release Process
- Performance Guidelines

## Maintenance
- Troubleshooting
- Known Issues
- Version History
- Security Considerations

# DuckLog Documentation Index

## Project Rules

- **Multiplatform Support:** This is a multiplatform app (macOS, iPad, iOS). All code, UI, and instructions must be compatible with multiplatform SwiftUI best practices. Platform-specific APIs (like EditButton or editMode) must be used conditionally or avoided if not available on all platforms.
- **Progress Tracking:** After every change (code, documentation, feature addition/removal, or refactor), the progress tracking in `docs/development_plan.md` must be updated to reflect the current state. The assistant must clearly indicate in their response that the tracking has been updated (e.g., "Progress tracking updated.").
- **Next Task Selection:** When asked "what do we work on next", the assistant must review the current development plan, logically determine the next most appropriate actionable task, explain the reasoning, and present the next step clearly for approval.

Welcome to the DuckLog project! DuckLog is a multiplatform journaling app (macOS, iPad, iOS) inspired by the Day One macOS journal app. All documentation and suggestions should consider multiplatform support and Day One-style design (sidebar, entry list, detail/editor pane).

Below is an overview of the documentation files available:

- [README.md](./README.md) – General overview of the app and its purpose
- [App_Flow.md](./App_Flow.md) – Step-by-step guide to how the app works
- [Feature_Plan.md](./Feature_Plan.md) – Current and future features
- [Project_Setup.md](./Project_Setup.md) – How the project is configured
- [UI_Structure.md](./UI_Structure.md) – Views and their roles
- [Data_Model.md](./Data_Model.md) – The models and data structures used
- [Trash_Feature.md](./Trash_Feature.md) – Trash management, soft delete, restore, and permanent delete
- [Settings_Structure.md](./Settings_Structure.md) – Global settings and customization
- [Integration_Plan.md](./Integration_Plan.md) – Planned API and service integrations
- [Layout Design](layout_design.md)
- [Jira Integration Flow](flow_diagrams/jira-integration-flow.md) - Detailed flow diagrams for Jira integration

Use this index to get oriented or to help AI tools understand the structure and scope of the project.