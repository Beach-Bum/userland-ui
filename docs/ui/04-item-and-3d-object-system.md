# 04 — Item and 3D Object System

## Principle

Items are the core reward loop. Every item must be inspectable, locatable, and actionable. The 3D object is a premium feature — it rewards attention and makes items feel real. It appears at specific moments, not everywhere.

## Item Data Model

Every item in Userland has these required fields:

| Field | Type | Example | Notes |
|-------|------|---------|-------|
| `id` | string | `"item_ghost_lens_01"` | Unique, server-assigned |
| `name` | string | `"GHOST LENS"` | All-caps display name |
| `category` | enum | `lens` | One of: core, lens, port, bus, ice, skin, cache, data |
| `slot` | enum \| null | `lens` | Rig slot if equippable, null if not |
| `rarity` | enum | `rare` | One of: brk, com, tun, rare, leg, epic, mil, myth |
| `brand` | string | `"UOPT"` | Corporation/faction that made it |
| `brand_logo` | string \| null | `"uopt-logo.svg"` | Corp/faction logo asset for branding zone |
| `description` | string | `"Spectral scanner..."` | One sentence |
| `stats` | map | `{scan: 16}` | Key-value stat modifiers |
| `value` | integer | `480` | Current market value in SEN |
| `tags` | list | `["recon", "jadenet"]` | Searchable tags |
| `location` | enum | `inventory` | One of: inventory, rig, market, cache, destroyed |
| `ownership` | enum | `owned` | One of: owned, listed, trading, locked |
| `glb_ref` | string \| null | `"ghost-lens.glb"` | R2 asset path, null = placeholder |
| `lore` | string \| null | `"Jadenet surplus..."` | Optional lore snippet |
| `actions` | list | `["install","sell"]` | Available actions given current state |

## Item Presentation Levels

### 1. Collapsed (in list/row)

```
[◆] GHOST LENS                480 SEN
    Rare · UOPT · Scan +16       [▾]
```

- Category avatar dot (colored by `--clr-cat-lens`)
- Name in bold (Space Mono 13.5px)
- Subtitle: rarity · brand · primary stat
- Value in SEN on right
- Top-right expand glyph `▾`
- **No 3D preview** at this level

### 2. Peek (first expand)

Shows immediately on tap:
- Progress bar (if relevant action in progress)
- One-line context: "Listed by vex_11 · expires 12 min"
- Primary action if available: `[BID 480]`

### 3. Expanded Inline

Full inline detail without leaving the board:
- Separator line
- **3D stage thumbnail** (100-120px, square, placeholder if no GLB)
- Stat rows: seller, price, rarity, slot, stat, expires
- Up to 2 action buttons: `[BID 480]` `[OFFER]`
- If result state active: ok/fail banner

### 4. Item Inspector (Inline Dropdown)

The inspector is an **inline expansion** that drops down from the item card, not a disconnected modal. It stays visually connected to the card it belongs to — the card expands to reveal the inspector below it, pushing siblings. This keeps the player anchored in their board context.

For maximum detail (result reveals, cross-board inspection), the inspector can also appear inside a modal shell, but uses the same layout.

**Shape**: `k-card--bite-top` on the inspector panel. This shape identifies "you are inspecting something" consistently across the UI.

**Layout:**
```
┌──────────────────────────────────┐
│  GHOST LENS              [RARE] │ ← name + rarity badge
│  LENS · UOPT                    │ ← category tag + brand
├──────────────────────────────────┤
│ ┌──────────────────────────────┐ │
│ │                              │ │
│ │      3D OBJECT STAGE         │ │ ← 160px square, interactive
│ │         (square)             │ │
│ │                              │ │
│ └──────────────────────────────┘ │
│                                  │
│  ┌──────┐                        │
│  │ UOPT │  UOPT CORPORATION     │ ← corp branding zone
│  │ logo │  Jadenet Division     │    (square logo + name)
│  └──────┘                        │
│                                  │
│  Value       480 SEN             │ ← market value
│  Category    LENS                │
│  Slot        LENS                │
│  Rarity      [RARE]             │
│  Stat        Scan +16            │
│  Location    Inventory           │
│                                  │
│  "Spectral scanner from the     │
│   Jadenet surplus..."            │ ← lore snippet
│                                  │
│  [INSTALL]  [SELL]  [CLOSE]      │
└──────────────────────────────────┘
```

**Corp branding zone**: A square area (48×48 or 64×64) showing the corporation/faction logo. Uses `brand_logo` field. If no logo asset, shows brand abbreviation in a colored square using category color. This grounds every item in its lore origin.

**Value display**: Shows current market value in SEN. Updates from server. Displayed between the corp branding zone and the stat table.

**When to open:**
- `[INSPECT]` button in any context → expands inline from that card
- Tap item name in inventory list → inline expand
- `[INSPECT]` in result modal → inspector appears inside the modal
- Tap item reference in chat → opens as inline expand in chat context

**Why inline, not modal**: The inspector dropping down from the card it belongs to maintains spatial relationship. The player sees exactly where this item lives. The bite-top shape on the inspector panel makes it visually distinct from the card above while staying connected.

### 5. Result/Reward Reveal

When an item is awarded (run claim, cache open, trade accept):

**Sequence:**
1. Dark modal opens (shape: `k-card--bite-top` + `k-card--perf`)
2. 3D stage: dark background → violet glow border fades in (0.5s)
3. 3D object fades in from 90% scale to 100% (0.4s, ease-out)
4. Item name + rarity badge appear below (0.3s fade)
5. Corp branding zone appears (brand logo + name)
6. Result text: "Added to Inventory" or "Installed to CORE"
7. Value shown: "Market value: 480 SEN"
8. Action buttons: `[INSPECT]` `[INSTALL]` `[DONE]`

**MYTH items**: Full-card shimmer gradient on the result modal. The entire modal surface shimmers.

**Reduced motion:** Steps 2-4 are instant (no animation), glow border visible immediately.

### 6. Compare View

Side-by-side in a modal, used for install/swap:

```
┌──────────┐     ┌──────────┐
│ Current   │  →  │ New       │
│ BASIC OPT │     │ GHOST LNS │
│ [BRK]     │     │ [RARE]    │
│ Scan +2   │     │ Scan +16  │
│ ~20 SEN   │     │ ~480 SEN  │
└──────────┘     └──────────┘
       Net change: Scan +14
       Value diff: +460 SEN
```

## Every Claim/Reward Must Answer

After any action that produces an item, the UI must answer:

| Question | How it's answered |
|----------|-------------------|
| What did I get? | Item name + 3D stage + rarity badge |
| How rare is it? | Rarity badge (text + color) |
| What does it do? | Primary stat shown below name |
| What is it worth? | Market value in SEN |
| Who made it? | Corp branding zone (logo + name) |
| Where did it go? | Location label: "Added to Inventory" / "Installed to Rig" / "Sent to Market" / "Stored in Cache" |
| What can I do now? | Action buttons: INSPECT, INSTALL, SELL, OPEN (for cache), DONE |

If the reward is SEN (currency), show the amount and new balance. No 3D stage for currency.

## 3D / GLB Rules

### When 3D appears

| Context | 3D visible | Size | Interactive rotation |
|---------|-----------|------|---------------------|
| Collapsed card | No | — | — |
| Peek | No | — | — |
| Expanded inline | Yes, thumbnail | 100-120px square | No (static angle) |
| Item Inspector | Yes, full | 160px square | Yes (drag to rotate) |
| Reward reveal | Yes, full + animation | 160px square | Yes |
| Compare modal | No (too small) | — | — |
| Market listing expanded | Yes, thumbnail | 100px square | No |
| Rig slot expanded | Yes, thumbnail | 120px square | No |

### 3D stage rules

- **Shape**: Always square (1:1 aspect ratio). Border-radius `var(--r-nested)`.
- **Placeholder**: If `glb_ref` is null, show a category glyph icon centered on the stage with `t-micro` label "3D preview" at bottom. Stage bg uses `--clr-surface-stage`.
- **Loading**: Show stage with subtle pulse animation until GLB loads.
- **Loaded**: Render GLB with ToonHolo lighting (existing pipeline). Auto-rotate slowly (reduced-motion: static).
- **Error**: Show placeholder with "Asset unavailable" label.
- **Server truth**: The 3D viewer is client-side visual only. Item existence, ownership, stats, and location are server-authoritative. The viewer never modifies game state.

### 3D reveal glow

- Border: 2px solid `--clr-reveal` (#B5A8F2, violet)
- Glow: `box-shadow: 0 0 20px rgba(181,168,242,.3)`
- Applied only during reward reveal animation
- Removed after animation completes (item inspector shows plain stage)
- MYTH items: glow cycles through the MYTH gradient colors instead of static violet

## Inventory Location Rules

Every item has exactly one location at any time:

| Location | Where visible | Actions available |
|----------|--------------|-------------------|
| `inventory` | SOUL > inventory list | install, sell, inspect, compare |
| `rig` | SOUL > rig slots, NOW > rig card | uninstall, inspect, swap |
| `market` | MARKET > my listings | delist, inspect |
| `cache` | inventory (as cache object) | open, inspect, discard |
| `trading` | NET > active trade | cancel trade, inspect |
| `destroyed` | nowhere (removed from game) | — |

Moving an item changes its `location` server-side. The client updates the UI via LiveView push.

## Item Actions

| Action | Requires | Server event | Result |
|--------|----------|-------------|--------|
| Install | Item in inventory, matching slot empty or swap confirmed | `rig:install` | Location → rig |
| Uninstall | Item in rig slot | `rig:uninstall` | Location → inventory |
| Swap | Item in inventory, slot occupied | `rig:swap` (opens compare modal first) | Old → inventory, new → rig |
| Sell | Item in inventory | `market:sell` (set price) | Location → market |
| Buy | Item on market, enough SEN | `market:buy` (confirmation sheet) | Location → inventory (buyer), SEN transferred |
| Inspect | Any owned item, any location | Client-only (opens inline inspector) | No server event |
| Compare | Two items of same slot | Client-only (opens compare modal) | No server event |
| Open | Cache item in inventory | `cache:open` | Cache destroyed, contents → inventory, result modal |
| Discard | Item in inventory | `inventory:discard` (confirmation) | Location → destroyed |
