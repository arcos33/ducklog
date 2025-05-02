# Project Setup: DuckLog

## Overview

DuckLog is a SwiftUI-based, multiplatform journaling application designed to help developers quickly log work-related entries, link GitHub PRs, and generate summaries for one-on-ones and retrospectives. The app's design is inspired by the Day One journal macOS app, featuring a sidebar, entry list, and detail/editor pane for a modern, intuitive experience.

## Platform Support

- **Primary Target**: macOS
- **Planned Support**: iPadOS and iOS (multiplatform from the start)
- **Project Type**: SwiftUI Multiplatform App
- **Architecture**: Shared views and models across platforms with conditional code for platform-specific features
- **Design**: Day One-inspired layout (sidebar navigation, entry list, detail/editor pane)

## Project Structure

- **Views**: UI components including SidebarNavigationView, EntryListView, EntryDetailView, SettingsView
- **ViewModels**: Business logic for Journal, Entry, and Settings
- **Models**: Data structures for JournalEntry, SettingsModel, GitHubPR
- **Services**: Data persistence, settings management, and (future) API integrations
- **Assets**: App resources and icons

## Current Development Focus

- macOS UI and functionality (with multiplatform codebase)
- Sidebar navigation, entry list, and detail/editor pane
- Popover-based journal entry interface
- GitHub PR linking
- Customizable summary templates via Settings view
- Adaptive layout for all Apple platforms

## Technologies and APIs Used

- **SwiftUI**: Declarative UI framework for building multiplatform interfaces
- **SwiftData**: Persistent storage for journal entries
- **UserDefaults**: Local storage for app settings
- **GitHub API (planned)**: To fetch PR information, descriptions, and statuses
- **NavigationSplitView**: For adaptive, multiplatform navigation (sidebar, entry list, detail/editor)

## Notes

- All code and features are designed to be multiplatform-ready (macOS, iPad, iOS)
- The project is organized for easy scaling and platform adaptation
- Uses SwiftData for persistence instead of Core Data
- Design and navigation are inspired by the Day One macOS app for familiarity and usability