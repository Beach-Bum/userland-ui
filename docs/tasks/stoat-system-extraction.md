# Stoat System Extraction Task Brief

## Branch

`claude/amazing-mccarthy-8rtqwo`

## Purpose

Extract the full reusable system from the Stoat clone experiments before doing real UI customization.

This is a documentation and inventory pass. The goal is to understand and preserve the complete working Stoat-style chat/social system: components, metadata, tokens, spacing, CSS architecture, responsive behavior, interaction hooks, and safe extension points.

Do not redesign UI in this task.

## Source files to inspect

Primary:

- `experiments/userland-stoat-pure-chat.html`
- `experiments/userland-stoat-social.html`

Supporting local canon:

- `docs/current-userland-courier-canon.md`
- `docs/tasks/stoat-content-pass.md`

## Output file to create

Create:

- `docs/ui/stoat-system-inventory.md`

If `docs/ui/` does not exist, create it.

## Hard constraints

Do not edit the experiment HTML files in this task unless only adding a tiny comment is absolutely necessary. Prefer no changes to experiments.

Do not change:

- HTML structure
- CSS
- JS
- content
- layout
- behavior
- class names

This pass should produce documentation only.

## What to extract

### 1. File overview

For each source file, document:

- file purpose
- high-level screen/function
- whether it is chat, social, modal, settings, profile, feed, or hybrid
- key sections in document order
- whether it includes JS interactions
- whether it is mobile responsive

### 2. Design tokens

Extract all visible design tokens from CSS, including:

- color variables
- background layers
- text colors
- accent/status colors
- radius variables
- font family
- font sizes
- line heights
- spacing values
- widths
- heights
- modal dimensions
- responsive breakpoint values
- shadow/elevation values
- opacity values

Document them as a table with columns:

```text
Token / Value / Used by / Notes
```

### 3. Grid and layout system

Document:

- root app layout
- major columns and rows
- rail width
- channel/sidebar width
- chat column flex rules
- feed scroll behavior
- composer placement
- modal placement
- mobile breakpoint behavior
- drawer/collapsed behavior
- any fixed/flex/absolute positioning patterns

Include a compact ASCII diagram for each major shell.

Example style:

```text
Desktop chat shell
┌──────┬──────────────┬────────────────────────┐
│ rail │ channels     │ chat                   │
│ 64px │ 230px        │ flex:1                 │
└──────┴──────────────┴────────────────────────┘
```

### 4. Component inventory

Extract every reusable component/class group. For each component, document:

```text
Component name
Source class names
Purpose
HTML structure
Key CSS rules
States / variants
JS hooks, if any
Safe Userland extension points
Do-not-change notes
```

At minimum, cover pure chat components such as:

- AppShell
- ServerRail
- ServerRailButton
- RailSeparator
- ChannelSidebar
- ChannelHeader
- ChannelList
- ChannelGroupLabel
- ChannelRow
- PinnedUserMenu
- UserAvatar
- ChatColumn
- ChatHeader
- ConversationStart
- Feed
- Message
- GroupedMessage
- SystemMessage
- DateDivider
- Embed
- EmbedStatusVariants
- EmbedField
- EmbedActions
- Button
- ButtonVariants
- TypingIndicator
- Composer
- ComposerPlusButton
- ComposerInput
- ComposerSendButton
- Scrim
- Modal
- ProfileModal
- SettingsModal
- DetailModal
- ResponsiveChannelDrawer

Then extract all social-specific components from `userland-stoat-social.html`, whatever their names/classes are.

### 5. Interaction inventory

Document every JS interaction:

- open/close channel drawer
- click avatar/profile
- click user/account card
- click settings gear
- click modal close
- click detail buttons/cards/embeds
- composer input behavior
- send button behavior
- typing indicator behavior
- any fake navigation
- any event delegation

For each interaction, record:

```text
Trigger / Selector / Function or handler / Result / Dependencies
```

### 6. Content slots and metadata fields

Extract the visible content model implied by the HTML.

For chat, document all message/content slots:

- server/community name
- channel group labels
- channel names
- unread state
- user display name
- handle/status
- message timestamp
- message body
- system message text
- embed kicker/title/description
- embed fields
- embed actions
- profile fields
- settings sections

For social, document all feed/social slots:

- post author
- post timestamp
- post body
- attachments/cards
- reactions
- comments
- profile/social metadata
- any tabs/filters/actions

### 7. State and variant inventory

List class/state variants and their meaning, including things like:

- `.is-on`
- `.has-unread`
- `.is-grp`
- `.is-vis`
- modal wide/narrow variants
- button variants
- embed variants
- responsive open/closed drawer state

Include what visual/behavioral change each state causes.

### 8. CSS architecture map

Document the CSS organization as it currently exists:

- global reset
- variables
- app shell
- rail
- channels
- user menu
- chat column
- feed
- embeds
- composer
- modals
- profile modal
- settings modal
- responsive media queries
- social-specific sections

Do not rewrite CSS. Just map it.

### 9. Safe Userland customization plan

Add a section called:

```text
Safe Userland extension points
```

List exactly where Userland content/features should plug in without breaking the Stoat clone:

- channel data/content arrays
- message data/content arrays
- embed variants
- profile modal copy/data
- social feed post copy/data
- marketplace/auction embeds
- card pull embeds
- manifest risk embeds
- contract result embeds

Also list what should not be touched until a later design pass:

- shell layout
- responsive drawer logic
- base component class names
- modal foundation
- feed/composer mechanics
- base spacing and widths

### 10. Recommended next tasks

At the end, propose the next three tasks in order:

1. Content-only Userland pass using `docs/tasks/stoat-content-pass.md`
2. Component naming/data extraction pass if data is currently hardcoded inline
3. Visual skin/customization pass only after components and content are stable

## Acceptance criteria

- `docs/ui/stoat-system-inventory.md` exists.
- It covers both Stoat experiment files.
- It includes tokens, spacing, grid/layout, component inventory, states, interactions, content slots, and CSS architecture.
- It names safe extension points for Userland.
- It clearly separates extraction/documentation from redesign.
- No UI files are changed unless explicitly justified.
- The summary reports inspected files and any uncertainty.
