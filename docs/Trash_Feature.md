# Trash Feature Documentation

## Overview
The Trash feature allows users to soft-delete journal entries, moving them to a Trash section instead of permanently deleting them immediately. Users can review, restore, or permanently delete trashed entries at any time.

## Implementation
- Each `JournalEntry` has an `isTrashed: Bool` property (default: `false`).
- Moving an entry to Trash sets `isTrashed = true` and saves the change.
- Trashed entries are excluded from the main journal list and all filtered views.
- The `TrashView` lists all entries where `isTrashed == true`.
- Users can restore entries (set `isTrashed = false`) or permanently delete them (remove from model context).
- The Trash view is accessible from the main menu.

## Usage
- To move an entry to Trash: Open the entry detail and tap "Move to Trash". Confirm the action.
- To view trashed entries: Open the Trash section from the main menu.
- To restore: Tap "Restore" on a trashed entry in TrashView.
- To permanently delete: Tap "Delete" and confirm in TrashView.

## Related Documentation
- [Data_Model.md](./Data_Model.md)
- [UI_Structure.md](./UI_Structure.md)
- [App_Flow.md](./App_Flow.md) 