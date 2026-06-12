# 03 — Card, Peek, Expand, Modal System

## Principle

The player never leaves a board for normal actions. All interaction happens through progressive disclosure: collapsed → peek → expanded → modal. The system decides which level based on what the action requires, not on visual preference.

## Interaction Levels

### Level 0: Collapsed

The resting state. Every card on every board starts here.

**Shows:**
- Title (item name, run name, relay name)
- State chip (idle/running/ready/blocked/etc.)
- Top-right glyph (state indicator: `▾` available, `●` running, `✦` ready, etc.)
- One visible CTA **only** if state is `ready_to_claim` (e.g., CLAIM button)
- Rarity badge if applicable
- Category avatar dot (colored by category)

**Does not show:**
- Progress bars
- Stats or details
- 3D previews
- Secondary actions
- Lore text
- Failure reasons

**Tap behavior:** Opens to peek/expanded (Level 1-2). Buttons are tappable without expanding.

### Level 1: Peek (top of inline expand)

The first reveal. This is not a separate UI — it's the first ~80px of the expanded inline content, visible immediately when the card opens.

**Shows (in addition to collapsed):**
- Progress bar (if running/prepping/cooling)
- One-line status text ("Checking rig…", "3:42 remaining", "Heat too high")
- Primary action button
- One secondary action button (optional)

**Does not show:**
- Full stat breakdown
- 3D stage
- Requirements list
- Compare view
- Lore

**Purpose:** Let the player assess and act without scrolling. Most routine actions (claim, start, cancel) complete at this level.

### Level 2: Expanded Inline

The card expands further in place, pushing siblings down. Player scrolls within the expanded content.

**Shows (in addition to peek):**
- Separator line
- Stat rows (key-value pairs)
- 3D stage thumbnail (120px height, placeholder if no GLB)
- Requirements list with pass/fail indicators
- Risk/reward preview
- Up to 2 action buttons
- Short failure explanation
- Result state (ok/fail banner) after action completes

**Does not show:**
- Full lore text
- Compare side-by-side view
- Complex multi-step flows
- Social/trade negotiation

**When to use:**
- Inspecting an item in a list
- Viewing run details
- Checking requirements before starting
- Reviewing a market listing

### Level 3: Full Modal (Sheet)

A bottom-sheet overlay. The board is visible but dimmed behind it. Used when the interaction requires focused attention, confirmation, or complex layout.

**Shows:**
- Handle bar (swipe down to close)
- Title + context subtitle
- Close button
- Full content area (scrollable)
- 3D stage (full size, 140px+)
- Compare side-by-side layouts
- Result breakdowns with item list
- Confirmation warnings
- Multiple action buttons

**When to use — exhaustive list:**

| Trigger | Sheet type | Why modal |
|---------|-----------|-----------|
| Risk action (MIL buy, high-heat equip) | Confirmation | Player must read warning |
| Run complete/claim reward | Result | Shows multiple items + where they went |
| Cache open/reveal | Result | 3D reveal animation, item inspection |
| Item install/swap | Compare | Side-by-side current vs. new |
| Market buy with consequences | Confirmation | Price + balance + heat impact |
| Trade offer (chat) | Negotiation | Two-sided comparison |
| Run prep with failures | Confirmation | Rig check results, proceed/abort |

**When NOT to use:**
- Simple claims (use expanded inline result state)
- Viewing item stats (use expanded inline)
- Starting a basic run (action bar button → prepping state)
- Navigating between boards (tab bar)
- Reading chat messages (inline)

### Level 4: Item Inspector

A specialized modal for deep item examination. Always accessible from any item reference via `[INSPECT]` button.

**Layout (top to bottom):**
1. 3D Object Stage (160px, interactive rotation if GLB loaded, placeholder if not)
2. Item name (Gamja Flower, 22px)
3. Rarity badge + category tag
4. Stat table (key-value rows)
5. Lore snippet (if available)
6. Current location ("In inventory", "Installed in CORE slot", "Listed on Market")
7. Available actions: Install · Sell · Compare · Uninstall · Close

**When to open:**
- `[INSPECT]` button in result modal
- `[INSPECT]` button in expanded item card
- Tap item name in inventory list
- Tap item reference in chat

### Level 5: Result Modal

A specialized modal shown after claim/open/complete actions.

**Must answer five questions:**
1. What did I get? → Item name + rarity + 3D stage
2. How rare is it? → Rarity badge
3. What does it do? → Stat summary
4. Where did it go? → Location label: "Added to Inventory" / "Installed to Rig" / "Sent to Market" / etc.
5. What can I do now? → `[INSPECT]` · `[INSTALL]` · `[SELL]` · `[DONE]`

**3D reveal:** If a new item is awarded, the 3D stage animates: dark → glow border → object fade-in. Reduced motion: instant appear with glow border.

## Decision Tree: Inline vs. Modal

```
Is this a risk/destructive action?
  YES → Confirmation Modal (Level 3)
  NO ↓

Does the action produce multiple results (items, stats, achievements)?
  YES → Result Modal (Level 3)
  NO ↓

Does the action require side-by-side comparison?
  YES → Compare Modal (Level 3)
  NO ↓

Does the user need to see stats/details to decide?
  YES → Expanded Inline (Level 2)
  NO ↓

Is the action a simple claim/start/cancel?
  YES → Peek (Level 1) — act right there
  NO → Expanded Inline (Level 2)
```

## Card Type System

Cards are typed by their interaction pattern. The type determines what actions are allowed and how they appear.

| Type | Attribute | Collapsed behavior | Expand behavior |
|------|-----------|-------------------|-----------------|
| `info` | `data-card-type="info"` | Read-only, no actions | Shows details, no CTAs |
| `action` | `data-card-type="action"` | May show one CTA if ready | Shows CTA(s) + details |
| `risk` | `data-card-type="risk"` | Red left border, no CTA | CTA opens confirmation modal |

## Button Placement Rules

| Button scope | Where it lives | Examples |
|-------------|---------------|----------|
| Board-level | Action bar (bottom, above tab bar) | BUY, SELL, SCAN, START |
| Object-level | Inside expanded card or peek | Install this part, Bid on this item |
| Confirmation | Inside modal sheet | BUY 1800, ACCEPT TRADE |
| Result | Inside result modal | CLAIM ALL, INSPECT, DONE |

**Rules:**
- Max 3 buttons in action bar
- Max 2 buttons in expanded card
- Max 3 buttons in modal
- Primary button always left/first
- Destructive button always rightmost and red-filled
- Cancel/close always available

## HTML Structure

### Expandable card pattern
```html
<div class="k-card" data-expand data-card-type="action"
     data-state="available" data-rarity="rare" data-category="lens">
  <span class="k-xhint">▾</span>
  <!-- collapsed content -->
  <div class="state-chip is-available">AVAILABLE</div>
  <div class="k-xd"><div><div class="k-xd__in" style="padding-top:12px">
    <!-- peek content (first ~80px) -->
    <div class="k-xd-sep"></div>
    <!-- expanded content -->
    <div class="k-xd-stage"><!-- 3D thumbnail --></div>
    <div class="k-xd-stat"><!-- stat rows --></div>
    <div class="k-xd-result"><!-- result state after action --></div>
    <!-- actions -->
  </div></div></div>
</div>
```

### Modal sheet pattern
```html
<div class="k-sheet-overlay" id="sheet-name">
  <div class="k-sheet">
    <div class="k-sheet__handle"></div>
    <div class="k-sheet__head">
      <div><!-- title + subtitle --></div>
      <button class="k-sheet__close">✕</button>
    </div>
    <div class="k-xd-sep"></div>
    <!-- content -->
    <!-- actions -->
  </div>
</div>
```

## Accessibility

- All expandable cards are keyboard-navigable (Enter/Space to toggle)
- Escape closes any open expansion or modal
- Modal traps focus when open
- State chips use `aria-label` for screen readers
- 3D stage has alt text describing the item
- Progress bars use `role="progressbar"` with `aria-valuenow`
