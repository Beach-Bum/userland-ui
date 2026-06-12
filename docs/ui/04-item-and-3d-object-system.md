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
| `description` | string | `"Spectral scanner..."` | One sentence |
| `stats` | map | `{scan: 16}` | Key-value stat modifiers |
| `tags` | list | `["recon", "jadenet"]` | Searchable tags |
| `location` | enum | `inventory` | One of: inventory, rig, market, cache, destroyed |
| `ownership` | enum | `owned` | One of: owned, listed, trading, locked |
| `glb_ref` | string \| null | `"ghost-lens.glb"` | R2 asset path, null = placeholder |
| `lore` | string \| null | `"Jadenet surplus..."` | Optional lore snippet |
| `actions` | list | `["install","sell"]` | Available actions given current state |

## Item Presentation Levels

### 1. Collapsed (in list/row)

```
[◆] GHOST LENS                    480
    Rare · UOPT · Scan +16         [▾]
```

- Category avatar dot (colored by `--clr-cat-lens`)
- Name in bold (Space Mono 13.5px)
- Subtitle: rarity · brand · primary stat
- Price or action indicator on right
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
- **3D stage thumbnail** (100-120px, placeholder if no GLB)
- Stat rows: seller, price, rarity, slot, stat, expires
- Up to 2 action buttons: `[BID 480]` `[OFFER]`
- If result state active: ok/fail banner

### 4. Item Inspector (Modal)

Full dedicated inspection. Opened via `[INSPECT]` from anywhere.

**Layout:**
```
┌─────────────────────────────┐
│  ═══ handle ═══             │
│  GHOST LENS           [✕]   │
│  Rare · UOPT                │
│─────────────────────────────│
│ ┌─────────────────────────┐ │
│ │                         │ │
│ │    3D OBJECT STAGE      │ │
│ │       (160px)           │ │
│ │                         │ │
│ └─────────────────────────┘ │
│                             │
│  Category    LENS           │
│  Slot        LENS           │
│  Rarity      [RARE]         │
│  Brand       UOPT           │
│  Stat        Scan +16       │
│  Location    Inventory      │
│                             │
│  "Spectral scanner from the │
│   Jadenet surplus..."       │
│                             │
│  [INSTALL]  [SELL]  [CLOSE] │
└─────────────────────────────┘
```

### 5. Result/Reward Reveal

When an item is awarded (run claim, cache open, trade accept):

**Sequence:**
1. Dark modal opens
2. 3D stage: dark background → violet glow border fades in (0.5s)
3. 3D object fades in from 90% scale to 100% (0.4s, ease-out)
4. Item name + rarity badge appear below (0.3s fade)
5. Result text: "Added to Inventory" or "Installed to CORE"
6. Action buttons: `[INSPECT]` `[INSTALL]` `[DONE]`

**Reduced motion:** Steps 2-4 are instant (no animation), glow border visible immediately.

### 6. Compare View

Side-by-side in a modal, used for install/swap:

```
┌──────────┐     ┌──────────┐
│ Current   │  →  │ New       │
│ BASIC OPT │     │ GHOST LNS │
│ [BRK]     │     │ [RARE]    │
│ Scan +2   │     │ Scan +16  │
└──────────┘     └──────────┘
       Net change: Scan +14
```

## Every Claim/Reward Must Answer

After any action that produces an item, the UI must answer:

| Question | How it's answered |
|----------|-------------------|
| What did I get? | Item name + 3D stage + rarity badge |
| How rare is it? | Rarity badge (text + color) |
| What does it do? | Primary stat shown below name |
| Where did it go? | Location label: "Added to Inventory" / "Installed to Rig" / "Sent to Market" / "Stored in Cache" |
| What can I do now? | Action buttons: INSPECT, INSTALL, SELL, OPEN (for cache), DONE |

If the reward is SEN (currency), show the amount and new balance. No 3D stage for currency.

## 3D / GLB Rules

### When 3D appears

| Context | 3D visible | Size | Interactive rotation |
|---------|-----------|------|---------------------|
| Collapsed card | No | — | — |
| Peek | No | — | — |
| Expanded inline | Yes, thumbnail | 100-120px | No (static angle) |
| Item Inspector | Yes, full | 160px | Yes (drag to rotate) |
| Reward reveal | Yes, full + animation | 160px | Yes |
| Compare modal | No (too small) | — | — |
| Market listing expanded | Yes, thumbnail | 100px | No |
| Rig slot expanded | Yes, thumbnail | 120px | No |

### 3D stage rules

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
| Inspect | Any owned item, any location | Client-only (opens inspector) | No server event |
| Compare | Two items of same slot | Client-only (opens compare modal) | No server event |
| Open | Cache item in inventory | `cache:open` | Cache destroyed, contents → inventory, result modal |
| Discard | Item in inventory | `inventory:discard` (confirmation) | Location → destroyed |
