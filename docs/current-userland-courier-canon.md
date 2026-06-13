# Current Userland Courier Guild Canon

This note is a compact source-of-truth reference for content-only passes in the `userland-ui` repository.

The fuller GDD/card-bible material may live outside this repository. When updating UI experiments here, use this file as the local canon unless a newer in-repo current-design document supersedes it.

## Core framing

**Userland is about cyberpunk occult courier guilds in a post-collapse multiverse.**

The product should feel like a living social/chat layer around couriers, parcels, contracts, cards, auctions, and guild reputation. It is not primarily a generic hacking terminal, a netrunner simulator, or a weapon/combat game.

## Core loop

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

## Relay shell sections

Use these as the current navigation/content vocabulary:

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

## Content vocabulary

Good visible terms:

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

## Example names and places

Use these as sample entities in chat/social prototypes:

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

## Stoat experiment rule

For the Stoat clone experiments, preserve the Stoat-like UI structure and only change written/sample content unless explicitly asked otherwise.

Target Stoat experiment files:

- `experiments/userland-stoat-pure-chat.html`
- `experiments/userland-stoat-social.html`

Do not change during a content-only pass:

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

Change during a content-only pass:

- channel names
- sample users
- sample messages
- embed copy
- profile text
- settings/example text when needed
- social feed posts
- fake server/community names
- outdated hacking/netrunner/intrusion/casino/stock placeholder language

## Content examples to include

Pure chat can include:

- courier guild chat
- parcel-ready notifications
- card-pull events
- auction updates
- manifest-risk notices
- contract-result embeds
- courier/player profile modal copy

Social can include:

- card showcase posts
- auction flex posts
- contract result posts
- guild recruitment posts
- convoy posts
- album/completion posts
- profile activity posts

## Deprecated framing to avoid

Avoid old visible content centered on:

- generic hacking
- netrunner-only fantasy
- Index intrusion as the main loop
- casino or stock-market placeholder language
- weapon/combat framing
- generic terminal clone language

If any old term remains, it should be harmless, internal-only, or intentionally justified in the change summary.
