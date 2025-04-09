# Project Setup: DuckLog

## Overview

DuckLog is a SwiftUI-based journaling application designed to help developers quickly log work-related entries, link GitHub PRs, and generate summaries for one-on-ones and retrospectives.

## Platform Support

- **Primary Target**: macOS
- **Planned Support**: iPadOS (and possibly iOS in the future)
- **Project Type**: SwiftUI Multiplatform App
- **Architecture**: Shared views and models across platforms with conditional code for platform-specific features

## Project Structure

- **Shared**: Common logic, views, and models
- **macOS**: Mac-specific entry point and any platform-unique views or behavior
- **iPadOS (future)**: To be added when needed
- App targets can be managed via the Xcode project navigator and `DuckLogApp.swift` files per platform

## Current Development Focus

- macOS UI and functionality
- Popover-based journal entry interface
- GitHub PR linking
- Customizable summary templates via Settings view
- Timeline views for filtering recent entries

## Technologies and APIs Used

- **SwiftUI**: Declarative UI framework used for building app interface
- **Markdown**: Entries are saved as markdown files locally
- **GitHub API (planned)**: To fetch PR information, descriptions, and statuses
- **LocalStorage**: To manage user settings like summary templates
- **Drag-and-Drop (planned)**: For reordering sections in the template settings
- **AI Summary (planned)**: Future integration for automated weekly summaries

## Notes

- This project is set up with future expansion in mind, but users and features are currently focused on a great macOS experience.
- Code is organized to allow easy scaling and platform adaptation down the road.