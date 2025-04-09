# Project Setup: DuckLog

## Overview

DuckLog is a SwiftUI-based journaling application designed to help developers quickly log work-related entries, link GitHub PRs, and generate summaries for one-on-ones and retrospectives.

## Platform Support

- **Primary Target**: macOS
- **Planned Support**: iPadOS (and possibly iOS in the future)
- **Project Type**: SwiftUI Multiplatform App
- **Architecture**: Shared views and models across platforms with conditional code for platform-specific features

## Project Structure

- **Views**: UI components including TimelineView, SummaryView, SettingsView
- **ViewModels**: Business logic for Journal and Settings
- **Models**: Data structures for JournalEntry, SettingsModel
- **Services**: Data persistence and settings management
- **Assets**: App resources and icons

## Current Development Focus

- macOS UI and functionality
- Popover-based journal entry interface
- GitHub PR linking
- Customizable summary templates via Settings view
- Timeline views for filtering recent entries
- Summary view with template-based organization

## Technologies and APIs Used

- **SwiftUI**: Declarative UI framework used for building app interface
- **SwiftData**: Persistent storage for journal entries
- **UserDefaults**: Local storage for app settings
- **GitHub API (planned)**: To fetch PR information, descriptions, and statuses
- **NavigationSplitView**: For 3-column layout on macOS

## Notes

- This project is set up with future expansion in mind, but users and features are currently focused on a great macOS experience.
- Code is organized to allow easy scaling and platform adaptation down the road.
- Uses SwiftData for persistence instead of Core Data