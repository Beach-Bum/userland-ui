# 08 — Implementation Contract

## Principle

Every component has a defined interface, allowed states, and clear usage rules. Phoenix/LiveView owns game state. React/Three owns 3D rendering only. CSS owns visual language. No client state decides game truth.

## Component Definitions

### BoardShell

The outermost container for a board screen. Manages the three-zone layout.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `board` (atom: `:now \| :map \| :runs \| :soul \| :market \| :net`), `player` (player struct) |
| **States** | N/A (structural) |
| **Slots** | `header` (zone 1), `content` (zone 2), `actions` (zone 3) |
| **CSS class** | `.k-phone__screen` (phone), `.dk-grid` (desktop) |
| **Allowed children** | BentoCard, ActionBar, TabBar, StatusStrip |
| **Use when** | Wrapping any board view |
| **Don't use** | Inside other components, nested |

### BentoCard

The universal card container. Handles expand/collapse, state visualization, card typing.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `card_type` (`:info \| :action \| :risk`), `state` (object state atom), `rarity` (atom), `category` (atom), `expandable` (boolean) |
| **States** | All 12 object states via `.is-{state}` classes |
| **Slots** | `collapsed` (always visible), `peek` (first expand content), `detail` (full expand), `result` (post-action state) |
| **CSS class** | `.k-card` + color modifier + `[data-expand]` + `[data-card-type]` + `[data-state]` |
| **Allowed children** | StateChip, RarityBadge, ActionButton, ProgressLine, ObjectStage3D, stat rows |
| **Use when** | Any game object display (item, run, relay, achievement, cache) |
| **Don't use** | Header cards (those are board identity, not game objects) |

**Data attributes:**
```html
<div class="k-card"
     data-expand
     data-card-type="action"
     data-state="available"
     data-rarity="rare"
     data-category="lens"
     data-board="market">
```

### CardPeek

Not a separate component — it's the first section of the expand content inside BentoCard. Defined as a convention: the first ~80px of `.k-xd__in` content is the peek zone.

| Property | Detail |
|----------|--------|
| **Convention** | First child(ren) of `.k-xd__in` before the first `.k-xd-sep` |
| **Contains** | Progress bar, status text, primary CTA |
| **Max height** | ~80px (2 lines + 1 button) |

### InlineExpand

The expand/collapse mechanism. Already implemented as CSS grid-template-rows animation.

| Property | Detail |
|----------|--------|
| **CSS class** | `.k-xd` (wrapper), `.k-xd__in` (inner content) |
| **States** | `.is-open` on parent `[data-expand]` toggles `grid-template-rows: 0fr → 1fr` |
| **JS** | Click handler on `[data-expand]`, one-open-at-a-time, escape/swipe close |
| **Use when** | Any BentoCard with `expandable: true` |
| **Don't use** | Header cards, structural cards, modals |

### ModalShell

The bottom-sheet overlay container.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `id` (string), `variant` (`:default \| :dark \| :risk`), `title` (string), `subtitle` (string) |
| **States** | `.is-vis` (visible/open) |
| **Slots** | `content`, `actions` |
| **CSS class** | `.k-sheet-overlay` + `.k-sheet` + variant (`.k-sheet--dark`, `.k-sheet--risk`) |
| **Allowed children** | Any content, ActionButton, ObjectStage3D, compare layouts |
| **Use when** | Confirmations, results, comparisons, deep detail |
| **Don't use** | Simple item inspection (use inline expand), navigation |

### ItemInspector

Specialized modal for item examination. Built on ModalShell.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `item` (item struct with all fields from doc 04) |
| **States** | ModalShell states |
| **Slots** | N/A (structured layout) |
| **CSS class** | `.k-sheet` + `.k-inspector` |
| **Layout** | 3D stage → name → rarity + category → stats → lore → location → actions |
| **Use when** | `[INSPECT]` button tapped from any context |
| **Don't use** | Quick item preview (use inline expand) |

### ResultModal

Specialized modal for post-action results. Built on ModalShell.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `result_type` (`:success \| :failure`), `items` (list), `sen_change` (integer), `heat_change` (integer), `achievement_progress` (map) |
| **States** | ModalShell states + result type |
| **CSS class** | `.k-sheet--dark` + `.k-result` |
| **Layout** | Result banner → items with rarity/location → SEN/heat summary → actions |
| **Use when** | Run complete, cache open, trade complete |
| **Don't use** | Simple claims that don't produce multiple items |

### ConfirmModal

Specialized modal for risk confirmations. Built on ModalShell.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `action` (string), `consequences` (list of strings), `confirm_label` (string), `risk_level` (`:normal \| :high`) |
| **States** | ModalShell states |
| **CSS class** | `.k-sheet--risk` (if high risk) |
| **Layout** | Warning → details → consequences → confirm/cancel |
| **Use when** | MIL item purchase, high-heat actions, discard, abort |
| **Don't use** | Safe/reversible actions |

### ProgressLine

A 4px-tall progress bar.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `value` (0-100), `variant` (`:determinate \| :indeterminate \| :scan`), `color` (state color token) |
| **States** | Animating or static |
| **CSS class** | `.k-progress` |
| **Use when** | Inside peek/expanded/modal for running/prepping processes |
| **Don't use** | Collapsed cards, idle items |

### StateChip

A small pill showing current object state.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `state` (object state atom), `blinking` (boolean) |
| **CSS class** | `.state-chip` + `.is-{state}` |
| **Visual** | Colored dot + uppercase label: "RUNNING", "READY", "BLOCKED" |
| **Use when** | Inside any BentoCard that has a non-idle state |
| **Don't use** | Board headers, structural elements |

### RarityBadge

A text badge showing item rarity.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `rarity` (atom) |
| **CSS class** | `.k-rar` + `.k-rar--{rarity}` |
| **Visual** | Colored text: "BRK", "COM", "TUN", "RARE", "LEG", "EPIC", "MIL", "MYTH" |
| **Rule** | Always includes text label. Color alone is never the only signal. |
| **Use when** | Any item display at any level |

### BoardGlyph

State indicator icon in the tab bar or nav.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `board` (atom), `has_activity` (boolean), `activity_type` (`:running \| :ready \| :alert`) |
| **CSS class** | `.board-dot` + `.has-activity` |
| **Visual** | Small dot next to board name, colored by activity type, blinking if active |
| **Use when** | Tab bar, desktop nav |

### ActionButton

A CTA button following the action state system.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `label` (string), `action` (server event string), `action_state` (action state atom), `variant` (`:primary \| :secondary \| :destructive`) |
| **States** | `.act-primary`, `.act-pending`, `.act-success`, `.act-failed`, `.act-blocked`, `.act-secondary`, `.act-destructive` |
| **CSS class** | `.k-pill` + variant + action state |
| **Use when** | Any interactive CTA |

### ObjectStage3D

3D viewer container for GLB rendering. This is the React island boundary.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `glb_ref` (string \| null), `category` (atom for entry animation), `interactive` (boolean), `size` (`:sm \| :md \| :lg`) |
| **States** | Loading, loaded, error, placeholder |
| **CSS class** | `.k-xd-stage` + `.k-stage--{size}` |
| **Sizes** | sm: 100px (inline), md: 120px (expanded), lg: 160px (inspector/reveal) |
| **Use when** | Expanded item cards, inspector, reveal modal |
| **Don't use** | Collapsed cards, lists, tab bar |
| **Rule** | Client-side visual only. Server owns item truth. |

### Icon

Pixel-geometric glyph following doc 05 rules.

| Property | Detail |
|----------|--------|
| **Props/assigns** | `name` (icon token string), `size` (16 \| 24 \| 32), `state` (`:default \| :active \| :blocked \| :disabled`) |
| **CSS class** | `.icon` + `.icon--{size}` + `.icon--{state}` |
| **Format** | Inline SVG, `viewBox="0 0 16 16"`, `fill="currentColor"` |

## State Classes

Applied to BentoCard or any stateful container:

| Class | Object state | Dot | Glyph | Shimmer | Progress |
|-------|-------------|-----|-------|---------|----------|
| `.is-idle` | idle | gray | `—` | no | no |
| `.is-available` | available | none | `▾` | no | no |
| `.is-prepping` | prepping | lime pulse | `◠` | no | indeterminate |
| `.is-running` | running | lime solid | `●` | no | determinate |
| `.is-cooling-down` | cooling_down | mint | `◔` | no | countdown |
| `.is-ready` | ready_to_claim | green blink | `✦` | yes (border) | no |
| `.is-claimed` | claimed | green solid | `✓` | no | no |
| `.is-failed` | failed | red | `✕` | no | no |
| `.is-blocked` | blocked | red | `⊘` | no | no |
| `.is-locked` | locked | none | `🔒` | no | no |
| `.is-expired` | expired | gray | `⏱` | no | no |
| `.is-syncing` | syncing | sky pulse | `↻` | no | scan |

## Attention Classes

Applied alongside state classes to control animation budget:

| Class | Visual | When applied |
|-------|--------|--------------|
| `.attn-none` | No animation | idle, claimed, expired |
| `.attn-dot` | Quiet dot blink | prepping, running |
| `.attn-shimmer` | Border glow pulse | ready_to_claim (max 1 per screen) |
| `.attn-alert` | Red pulse | MIL threat, heat critical |
| `.attn-sync` | Scan animation | syncing |

## Data Attributes

| Attribute | Values | Purpose |
|-----------|--------|---------|
| `data-board` | `now \| map \| runs \| soul \| market \| net` | Board context for color/behavior |
| `data-state` | Object state enum | Current object state |
| `data-rarity` | Rarity enum | Item rarity |
| `data-category` | Category enum | Item/rig category |
| `data-action-state` | Action state enum | Current CTA state |
| `data-card-type` | `info \| action \| risk` | Card interaction pattern |
| `data-expand` | (presence) | Card is expandable |

## Implementation Rules

### Server Authority

```
CLIENT may:               SERVER must:
- Show optimistic UI       - Validate all actions
- Animate transitions      - Own item locations
- Render 3D models         - Own SEN balances
- Cache display data       - Own heat calculations
                           - Own run results
                           - Own rarity/drops
                           - Own trade resolution
```

All state changes flow: **user tap → LiveView event → server process → server push → client update**.

The client may show `.is-prepping` optimistically on tap, but must revert to `.is-available` if the server rejects.

### Technology Boundaries

| Layer | Technology | Owns |
|-------|-----------|------|
| Game state | Phoenix/LiveView | All server events, state transitions, data |
| UI shell | LiveView templates | Board layouts, cards, modals, navigation |
| Visual language | CSS | Colors, spacing, animation, responsive |
| 3D rendering | React + Three.js (island) | GLB loading, rotation, lighting |
| Realtime updates | LiveView PubSub | Server-pushed state changes |

### What React/Three.js May NOT Do

- Decide item ownership
- Store game state
- Fire game events directly (must go through LiveView)
- Modify card states
- Open/close modals
- Navigate between boards

### LiveView Event Flow

```elixir
# Client sends
def handle_event("signal_relay:prep", %{"relay_id" => id}, socket) do
  case GameServer.prep_relay(socket.assigns.player, id) do
    {:ok, relay} ->
      {:noreply, assign(socket, relay: relay)}  # state → :prepping
    {:error, reason} ->
      {:noreply, put_flash(socket, :error, reason)}  # state → :failed
  end
end

# Server pushes
def handle_info({:relay_ready, relay}, socket) do
  {:noreply, assign(socket, relay: relay)}  # state → :ready_to_claim
end
```

### CSS Class Contract Example

A complete card in production:

```html
<div class="k-card is-running attn-dot"
     data-expand
     data-card-type="action"
     data-state="running"
     data-rarity="rare"
     data-category="core"
     data-board="runs"
     phx-click="toggle_expand"
     phx-value-id="run_123">
  <span class="k-xhint">●</span>
  <div class="state-chip is-running">RUNNING</div>
  <div class="k-row__name">Quick Hack</div>
  <div class="k-row__sub">Old Hospital · 3:42</div>
  <div class="k-xd"><div><div class="k-xd__in">
    <div class="k-progress is-running"><i style="width:64%"></i></div>
    <p class="t-micro">ETA 2 min · Heat +6</p>
    <div class="k-xd-sep"></div>
    <div class="k-xd-stat">...</div>
    <button class="k-pill k-pill--sm act-secondary"
            phx-click="run:abort"
            phx-value-id="run_123">ABORT</button>
  </div></div></div>
</div>
```

## File Structure (Production)

```
lib/userland_web/
  components/
    bento_card.ex          # BentoCard component
    state_chip.ex          # StateChip component
    rarity_badge.ex        # RarityBadge component
    action_button.ex       # ActionButton component
    progress_line.ex       # ProgressLine component
    modal_shell.ex         # ModalShell component
    item_inspector.ex      # ItemInspector component
    result_modal.ex        # ResultModal component
    confirm_modal.ex       # ConfirmModal component
    board_glyph.ex         # BoardGlyph component
    icon.ex                # Icon component
    object_stage_3d.ex     # ObjectStage3D (React island mount)
  live/
    board_live.ex          # Board shell + tab routing
    now_live.ex            # NOW board
    map_live.ex            # MAP board
    runs_live.ex           # RUNS board
    soul_live.ex           # SOUL board
    market_live.ex         # MARKET board
    net_live.ex            # NET board
assets/
  css/
    bento-keyline.css      # Full token + component CSS
  js/
    hooks/
      expand.js            # Inline expand hook
      object_stage.js      # React/Three island mount
      sheet.js             # Modal sheet hook
  react/
    ObjectStage3D.tsx      # 3D viewer React component
```
