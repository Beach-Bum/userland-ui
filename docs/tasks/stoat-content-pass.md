# Stoat Content Pass Task Brief

## Branch

`claude/amazing-mccarthy-8rtqwo`

## Target files

- `experiments/userland-stoat-pure-chat.html`
- `experiments/userland-stoat-social.html`

## Reference file

Read first:

- `docs/current-userland-courier-canon.md`

## Task

Update only the written/sample content inside the Stoat clone experiments so they reflect the current Userland Courier Guild game direction.

Do **not** redesign UI yet.

## Hard constraints

Do **not** change:

- layout
- CSS architecture
- class names
- interaction model
- responsive behavior
- modal behavior
- rail/channel/chat structure
- visual style
- component structure
- Stoat clone behavior

Do change:

- channel names
- sample users
- sample messages
- embed copy
- profile text
- settings/example text if needed
- social feed posts
- fake server/community names
- old hacking/netrunner/intrusion/casino/stock placeholder language

## Current Userland canon summary

Userland is about cyberpunk occult courier guilds in a post-collapse multiverse.

Core loop:

```text
Open parcel
-> receive courier / prestige object / cargo / route / permit / cosmetic / contract lead
-> decide keep, flex, trade, auction, use, or risk
-> choose a contract
-> solve manifest puzzle: courier + cargo + route + permit + risk
-> send delivery
-> timed result returns
-> earn SEN / reputation / materials / cards / favors / card history
-> upgrade courier / craft permit / complete album / trade / flex / auction
-> repeat tomorrow
```

Relay shell sections:

- Relay
- Parcels
- Contracts
- Manifest
- Market
- Auctions
- Guilds
- Mail
- Profile
- Businesses
- Albums

Use terms and examples like:

- Relay
- courier guild
- parcel
- manifest
- contract
- cargo
- route
- permit
- customs
- SEN
- reputation
- auction
- card pull
- prestige object
- foil card
- rig cosmetic
- guild favor
- route stamp
- Gate 17
- Blackline convoy
- Red Stamp inspection
- Orla Vex
- Mei-Lan
- JADENET Dispatch
- Night Hauler
- Aura Cell
- Natural World Leak Route
- Deep Pit salvage
- Paradise Gate
- Alpine Lifeline
- Sable Customs Bridge

## Tone

It should feel like a living chat/social layer for a courier guild game, not a terminal hacking prototype.

## File-specific instructions

### `experiments/userland-stoat-pure-chat.html`

- Keep the Stoat-style app shell.
- Rename server/community examples to Userland/Relay examples.
- Rename channels to fit the Relay shell.
- Replace sample messages with:
  - courier guild chat
  - parcel-ready notifications
  - card-pull events
  - auction updates
  - manifest-risk notices
  - contract-result embeds
- Update profile modal sample text to courier/player identity.
- Keep the modal structure intact.

### `experiments/userland-stoat-social.html`

- Keep the social/community layout intact.
- Replace generic social content with:
  - card showcase posts
  - auction flex posts
  - contract result posts
  - guild recruitment posts
  - convoy posts
  - album/completion posts
  - profile activity posts

## Acceptance criteria

- Both HTML files still open directly in a browser.
- Existing interactions still work.
- The visual UI should look effectively unchanged.
- The content now reads like Userland Courier Guild.
- No UI redesign is introduced.
- No new dependencies.
- Report which files changed.
- Report any old terms that remain intentionally.

## Quick grep after edits

Search for:

```text
hack
netrunner
intrusion
casino
stock
weapon
combat
```

Remove those terms unless they are harmless comments or clearly not part of visible content. Explain any remaining instances in the summary.
