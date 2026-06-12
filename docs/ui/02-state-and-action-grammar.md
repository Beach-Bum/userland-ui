# 02 — State and Action Grammar

## Principle

Every object in Userland has exactly one state at any time. Every action has exactly one result. The UI communicates both without ambiguity: the player always knows what is happening, why it cannot happen, or what just happened.

## Object States

| State | CSS class | Dot color | Top-right glyph | Shimmer | Progress | What user sees (collapsed) |
|-------|-----------|-----------|-----------------|---------|----------|---------------------------|
| `idle` | `.is-idle` | gray | `—` | no | no | Dim card, no action visible |
| `available` | `.is-available` | none | `▾` | no | no | Normal card, CTA visible if action type |
| `prepping` | `.is-prepping` | lime pulse | `◠` (arc) | no | yes (indeterminate) | "PREPPING" chip, pulsing dot, cancel available |
| `running` | `.is-running` | lime solid | `●` | no | yes (determinate) | Timer/%, "RUNNING" chip, abort available |
| `cooling_down` | `.is-cooling-down` | mint | `◔` (quarter) | no | yes (countdown) | "COOLING" chip, time remaining, no actions |
| `ready_to_claim` | `.is-ready` | green blink | `✦` | yes (border) | no | "READY" chip blink, CLAIM button prominent |
| `claimed` | `.is-claimed` | green solid | `✓` | no | no | "CLAIMED ✓" chip, item result visible |
| `failed` | `.is-failed` | red | `✕` | no | no | "FAILED" chip, reason text, retry if applicable |
| `blocked` | `.is-blocked` | red | `⊘` | no | no | "BLOCKED" chip, requirement text, red left border |
| `locked` | `.is-locked` | none | `🔒` | no | no | Dim card, "LOCKED" chip, unlock requirement |
| `expired` | `.is-expired` | gray | `⏱` struck | no | no | "EXPIRED" chip, strikethrough, no actions |
| `syncing` | `.is-syncing` | sky pulse | `↻` | no | yes (scan) | "SYNCING" chip, waiting for server |

### State Transitions

```
locked → available → prepping → running → ready_to_claim → claimed
                  ↘ blocked                ↘ failed → available (retry)
                                           ↘ expired
running → cooling_down → available
```

States are **server-authoritative**. The client may optimistically show `prepping` after a tap, but must revert if the server rejects.

## Action States

Actions live on buttons/CTAs within cards. Each action has its own state independent of the object state.

| Action State | CSS class | Button appearance | Behavior |
|--------------|-----------|-------------------|----------|
| `primary_available` | `.act-primary` | Ink fill, full opacity | Tap fires server event |
| `primary_pending` | `.act-pending` | Ink fill + lime pulse border | Tap disabled, waiting for server |
| `primary_success` | `.act-success` | Green fill, "✓" replaces label briefly | Auto-reverts after 1.5s |
| `primary_failed` | `.act-failed` | Red outline, shake, error text below | Shows reason, reverts to available after 3s |
| `primary_blocked` | `.act-blocked` | Gray fill, 40% opacity | Shows tooltip/reason on tap |
| `secondary_available` | `.act-secondary` | Outline only | Tap fires secondary action |
| `destructive_confirm` | `.act-destructive` | Red fill | Only appears inside confirmation modal |

## Peek vs Expanded vs Modal — What Shows Where

| Information | Collapsed | Peek | Expanded | Modal |
|-------------|-----------|------|----------|-------|
| Title + state chip | ✓ | ✓ | ✓ | ✓ |
| Top-right glyph | ✓ | ✓ | ✓ | — |
| Progress bar | — | ✓ | ✓ | ✓ |
| Primary CTA | only if `.is-ready` | ✓ | ✓ | ✓ |
| Secondary CTA | — | — | ✓ | ✓ |
| Stats/details | — | — | ✓ | ✓ |
| 3D stage | — | — | thumbnail | full |
| Requirements list | — | — | ✓ | ✓ |
| Failure reason | — | 1-line | full | full |
| Result breakdown | — | — | ✓ | ✓ |
| Lore text | — | — | — | ✓ |
| Compare view | — | — | — | ✓ |

**Note**: "Peek" in the current inline-expand system is the first state of expansion — the first 2 lines of the `k-xd__in` content. The system does not have a separate peek UI; it's the top of the expanded content, visible before scrolling.

## Detailed State Example: Signal Relay PREP Flow

A Signal Relay card sits on the NOW board. The player taps PREP.

### 1. What server event fires?

`signal_relay:prep` with payload `{relay_id, rig_snapshot}`.

### 2. What state does the card enter?

`prepping`. CSS class `.is-prepping` added. Previous state was `available`.

### 3. What visible change confirms it started?

- State chip changes: label → "PREPPING", color → lime pulse
- State dot: gray → lime, pulsing
- Top-right glyph: `▾` → `◠` (arc)
- PREP button: ink fill → ink fill + lime pulse border, label → "PREPPING…", tap disabled
- Indeterminate progress line appears at card bottom (lime, scanning left-to-right)

### 4. What progress is shown in peek state?

- Indeterminate progress bar (animated scan line)
- Text below: "Checking rig requirements…"
- After rig check completes (server push): text updates to "Rig OK — establishing connection…" or lists failures

### 5. What can make it fail?

- **Rig incomplete**: missing required slot (e.g., no CORE part installed)
- **Heat too high**: current heat ≥ threshold for this relay
- **Relay locked**: player hasn't discovered this node
- **Relay busy**: another player already holds the relay
- **Server error**: connection timeout, server reject

### 6. How is failure explained?

Card transitions to `failed` state:
- State chip: "FAILED" in red
- Top-right glyph: `✕`
- State dot: red
- Expanded content shows failure reason:
  - "Missing LENS — install a scanner to this rig slot" + `[GO TO RIG]` button
  - "Heat at 43% — must be below 40%" + `[COOL DOWN]` button
  - "Node locked — discover via MAP scan first" + `[GO TO MAP]` button
- After 5 seconds, card auto-transitions back to `available` (PREP button re-enabled)

### 7. What happens when prep completes?

Server pushes `signal_relay:prep_complete`. Card transitions:
- `prepping` → `ready_to_claim`
- State chip: "READY" in green, blinking
- State dot: green, blinking
- Top-right glyph: `✦`
- Border shimmer: green glow pulse
- PREP button replaced by: `[CLAIM]` (primary) + `[DETAILS]` (secondary)

### 8. What action becomes available next?

`CLAIM` — primary CTA. Fires `signal_relay:claim` to server.

### 9. Where does the reward/item/result go?

Server processes claim and returns `{items: [...], sen: N, heat: N}`.
- SEN added to wallet (visible in status strip)
- Heat added to heat meter
- Items added to inventory with location `inventory`
- Cache items stay as `cache` objects with location `inventory`, openable later

Result modal shows:
- "Signal relay claimed"
- SEN earned: +120
- Heat added: +6 → 27%
- Items received: 1× JADENET CACHE (with rarity badge)
- `[INSPECT]` button on each item
- `[OPEN CACHE]` if a cache was received
- `[DONE]` closes modal, card returns to `claimed` state

### 10. How can the user inspect it?

- Tap `[INSPECT]` in result modal → opens Item Inspector modal
- Or: navigate to SOUL board → inventory → tap item row → expand inline or tap inspect
- Item Inspector shows: 3D stage, name, rarity, category, stats, lore, current location, available actions (install/sell/compare)

## Board Action Mapping

Each board has specific actions available in its action bar. These are board-level actions, not object-level.

| Board | Action bar buttons | Notes |
|-------|-------------------|-------|
| NOW | CLAIM · RUN · INSTALL | Quick actions for ready items |
| MAP | SCAN · TRAVEL · VIEW | Node interaction |
| RUNS | START · PREP · ABORT | Run lifecycle |
| SOUL | EDIT RIG · THEMES · LOG OUT | Profile management |
| MARKET | BUY · SELL · SET ALERT | Market operations |
| NET | (message input) | Chat, no action bar buttons |

Object-level actions (the specific item/run/relay) appear **inside expanded cards**, not in the board action bar.

## Server Event Naming Convention

All events follow `{domain}:{action}` format:

| Domain | Events |
|--------|--------|
| `signal_relay` | `:prep`, `:claim`, `:cancel` |
| `run` | `:start`, `:abort`, `:claim_reward` |
| `cache` | `:open`, `:discard` |
| `rig` | `:install`, `:uninstall`, `:swap` |
| `market` | `:buy`, `:sell`, `:bid`, `:offer`, `:accept`, `:decline` |
| `trade` | `:offer`, `:accept`, `:decline`, `:counter` |
| `inventory` | `:inspect`, `:move` |
| `map` | `:scan`, `:travel` |
| `soul` | `:equip_theme`, `:set_flair` |
