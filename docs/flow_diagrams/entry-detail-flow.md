# Entry Detail View Flow

## View Mode to Edit Mode Flow

```mermaid
graph TD
    A[View Entry] -->|Click Edit| B[Enter Edit Mode]
    B --> C[Load Current Content]
    B --> D[Load Current Status]
    B --> E[Load Current Tags]
    C --> F[Show Text Editor]
    D --> G[Show Status Selector]
    E --> H[Show Tag Controls]
    F & G & H --> I[Enable Editing]
    I -->|Click Done| J[Save Changes]
    J --> K[Update Entry]
    K --> A
```

## New Entry Flow

```mermaid
graph TD
    A[Click + Button] --> B[Show New Entry View]
    B --> C[Empty Text Editor]
    B --> D[Default Status: In Progress]
    B --> E[No Tags Selected]
    C & D & E --> F[Enable Editing]
    F -->|Click Save| G{Content Empty?}
    G -->|Yes| F
    G -->|No| H[Create New Entry]
    H --> I[Add to Journal]
    I --> J[Close Editor]
    F -->|Click Cancel| J
```

## Entry State Changes

```mermaid
stateDiagram-v2
    [*] --> ViewMode
    ViewMode --> EditMode: Click Edit
    EditMode --> ViewMode: Click Done
    EditMode --> ViewMode: Save Changes
    ViewMode --> [*]: Close Entry
    
    state EditMode {
        [*] --> Editing
        Editing --> Modified: Make Changes
        Modified --> Saving: Click Done
        Saving --> [*]: Save Complete
    }
```

## Content Update Flow

```mermaid
graph TD
    A[Edit Content] --> B{Changes Made?}
    B -->|Yes| C[Enable Save]
    B -->|No| D[Keep Current]
    C -->|Save| E[Update Model]
    E --> F[Update View]
    D --> F
```

## Status Change Flow

```mermaid
graph LR
    A[Current Status] -->|Select New| B[Update Status]
    B -->|In Progress| C[Blue Indicator]
    B -->|Done| D[Green Indicator]
    B -->|Blocked| E[Red Indicator]
    C & D & E --> F[Update Model]
    F --> G[Update View]
```

## Tag Management Flow

```mermaid
graph TD
    A[Show Tags] --> B{Has Tags?}
    B -->|Yes| C[Show Selected]
    B -->|No| D[Show Empty]
    C --> E[Enable Toggle]
    D --> E
    E -->|Select| F[Add Tag]
    E -->|Deselect| G[Remove Tag]
    F & G --> H[Update Model]
    H --> I[Update View]
```

## Component Interaction

```mermaid
graph TD
    subgraph EntryDetailView
        A[Header] --> D[Main Container]
        B[Content] --> D
        C[Controls] --> D
    end
    
    subgraph State
        E[Entry Data] --> A
        E --> B
        E --> C
        F[Edit Mode] --> B
        F --> C
    end
    
    subgraph Actions
        G[Save] --> E
        H[Edit] --> F
        I[Cancel] --> E
    end
``` 