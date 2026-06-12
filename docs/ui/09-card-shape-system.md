# 09 — Card Shape System

## Principle

Card shape is meaning. Every modal, sheet, and special card uses a consistent shape modifier from a fixed vocabulary. Shapes identify the type of interaction — a player learns to recognize a ticket card or a bite-corner modal the same way they recognize a button color. No freeform shapes. No one-off silhouettes.

All sculpted junctions are single-path inline SVGs — no gradient fringes, no element seams, no multi-part constructions.

## Shape Vocabulary

Seven shape modifiers. Each is a CSS class applied to `.k-card` or `.k-sheet`, or a standalone SVG connector element. Multiple shapes can combine on the same element.

### 1. Bite Top (`k-card--bite-top`)

A recessed notch in the top-right corner. The sci-fi "bitten" corner from the kit. Uses an SVG path child (`.k-bitefx`) for seamless fillets. Shell color shows through the recess.

**Identity**: Modals, sheets, high-value surfaces. The signature Userland shape.

**Visual**: 76×34px recessed corner, r10 entry curve + r12 inner fillets. Single SVG path.

**Use for**:
- Modal sheets (confirmation, result, inspector)
- Statement cards (hero, premium reveal)
- MARKET stocks card

**Do not use for**:
- List rows
- Chat bubbles
- Tab bars

```html
<div class="k-card k-card--bite-top">
  <svg class="k-bitefx" width="76" height="34" viewBox="0 0 76 34" aria-hidden="true">
    <path d="M0 0 Q10 0 10 10 Q10 22 22 22 L64 22 Q76 22 76 34 L76 0 Z"/>
  </svg>
  <!-- content -->
</div>
```

### 2. Tab Top (`k-card--tab-top`)

A plateau tab rising from the card's top edge into the gap above. Uses an SVG path child (`.k-platop`). Chains causally-linked cards: this card is a consequence of the one above.

**Identity**: Causal chains, sequential outcomes. "This follows from that."

**Visual**: 112×18px plateau, r10 shoulders, r12 flares, 1px overlap into card. Position via `--tabx` (default 56%), fill via `--tabc`.

**Use for**:
- Rig slot chains (CORE → LENS → PORT → BUS → ICE → SKIN)
- Run → reward → item chains
- Causal sequences on any board

**Do not use for**:
- Independent cards
- Modals (use bite-top instead)
- Cards that can appear in any order

```html
<div class="k-card k-card--tab-top" style="--tabc:var(--clr-cat-bus)">
  <svg class="k-platop" width="112" height="18" viewBox="0 0 112 18" aria-hidden="true">
    <path d="M0 18 Q12 18 12 10 Q12 0 22 0 L90 0 Q100 0 100 10 Q100 18 112 18 Z"/>
  </svg>
  <!-- content -->
</div>
```

### 3. Pinch (`k-pinch`)

A centered shell-colored blob that sits in the gap between two cards, notching into both. Bridges causally-linked pairs. Not a card modifier — it's a standalone SVG connector element placed between two cards in a stack.

**Identity**: Cause → effect bridge. "This produced that."

**Visual**: 84×30px blob, flares riding both card edges with r8 shoulders. Shell color. Negative margin (-18px auto) overlaps both cards.

**Use for**:
- Run complete → cache earned
- Action → result pairs
- Any two-card cause/effect bridge

**Do not use for**:
- Long chains (use tab-top for 3+ cards)
- Independent cards
- Modal internals

```html
<div class="k-stack">
  <div class="k-card" style="background:var(--clr-state-active)">
    <span class="t-label">Run complete</span>
  </div>
  <svg class="k-pinch" width="84" height="30" viewBox="0 0 84 30" aria-hidden="true">
    <path d="M0 12 Q14 12 14 8 Q14 0 22 0 L62 0 Q70 0 70 8 Q70 12 84 12
             L84 18 Q70 18 70 22 Q70 30 62 30 L22 30 Q14 30 14 22 Q14 18 0 18 Z"/>
  </svg>
  <div class="k-card" style="background:var(--clr-cat-drop)">
    <span class="t-label">Cache earned</span>
  </div>
</div>
```

### 4. Ticket (`k-card--ticket`)

A perforation line splits the card into two halves. 2px dotted tear line with 15px diamond notches (rotated 45°) cut into both edges. The top half is the label/identity zone; the bottom half is the detail/serial zone.

**Identity**: Tradeable items, transferable objects, market listings. "This is a bearer instrument."

**Visual**: Horizontal perforation at ~60% height. Diamond notches (45°-rotated 15px squares) in shell color. Card r10.

**Use for**:
- Market listing detail cards
- Trade offer cards (in chat)
- Run tickets / entry passes
- Cache claim tickets
- Reward cards

**Do not use for**:
- Settings rows
- Navigation
- Status-only cards

```html
<div class="k-card k-card--ticket">
  <div class="k-ticket__top">
    <!-- glyph + corp tag + rarity -->
  </div>
  <div class="k-perf"></div>
  <div class="k-ticket__bottom">
    <!-- name + serial + stats -->
  </div>
</div>
```

### 5. Underplate (`k-card--underplate`)

A second surface layer visible beneath the main card, offset 4px down and 4px right. Creates depth without shadow. The underplate color communicates category or rarity.

**Identity**: Premium items, stacked/layered content. "There's more here than the surface."

**Visual**: Pseudo-element behind the card, same border-radius, offset (4px, 4px), colored by `--underplate-color` (defaults to gray).

**Use for**:
- MYTH and LEG rarity item cards
- Item inspector cards (underplate colored by category)
- Premium/donor content
- Stacked inventory items (showing quantity)

**Do not use for**:
- Standard list items
- Modals (they already have the overlay)
- Status/progress cards

```html
<div class="k-card k-card--underplate" style="--underplate-color:var(--clr-rar-leg)">
  <!-- content -->
</div>
```

### 6. Notch Side (`k-card--notch-side`)

Triangle cutouts along the left edge. Like punch-card alignment notches. Communicates "this card connects to a system" — it's a component, not standalone.

**Identity**: Rig parts, installed components, system-connected elements.

**Visual**: 3 small triangle notches cut into the left edge via clip-path. Each triangle is 10px deep with ~4% card height spacing. Shell color shows through.

**Use for**:
- Rig slot cards (installed parts)
- System connection cards
- Component cards that "plug in" to something larger

**Do not use for**:
- Standalone items
- Market listings
- Chat/social

```html
<div class="k-card k-card--notch-side">
  <!-- content -->
</div>
```

### 7. Perforation (`k-perf`)

A horizontal tear line (without the ticket split). Used as a visual separator within a card, not a shape modifier on the card itself. The perforation says "these two zones are related but separable."

**Identity**: Detachable sections, claim zones, before/after splits.

**Visual**: 2px dotted line + 15px diamond notches (rotated 45°) at both edges. Full-bleed across the card.

**Use for**:
- Separating claim zone from detail zone within a card
- Before/after splits in result cards
- Dividing header from body in ticket cards (combined with `k-card--ticket`)

```html
<div class="k-card">
  <div><!-- top content --></div>
  <div class="k-perf"></div>
  <div><!-- bottom content --></div>
</div>
```

## Shape Combinations

Shapes can combine. Valid combinations:

| Combination | Meaning | Example |
|------------|---------|---------|
| `bite-top` + `underplate` | Premium modal with depth | MYTH item inspector |
| `ticket` + `underplate` | High-value tradeable | LEG market listing |
| `tab-top` + `notch-side` | Installed rig component in chain | Rig slot in sequence |
| `ticket` + `perf` | Standard ticket layout | Run entry ticket |
| `bite-top` + `perf` | Modal with detachable section | Result modal with claim zone |

**Invalid combinations:**
- `bite-top` + `tab-top` — conflicting top edges
- `ticket` + `notch-side` — too many edge treatments
- `underplate` + `notch-side` — clip-path kills the underplate pseudo-element

## Connectors vs. Shapes

Connectors are standalone SVG elements placed *between* cards. Shapes are modifiers *on* cards.

| Element | Type | CSS class | Placement |
|---------|------|-----------|-----------|
| Pinch | Connector | `.k-pinch` | Between two cards in a stack |
| Tab-top | Shape | `.k-card--tab-top` | On the lower card |
| Bite-top | Shape | `.k-card--bite-top` | On the card itself |
| Ticket/perf | Shape | `.k-card--ticket` / `.k-perf` | On/inside the card |

**When to use pinch vs. tab-top:**
- **Pinch**: Two-card pairs with a strong cause→effect relationship. The connector blob is the visual metaphor for "these two things are directly linked."
- **Tab-top**: Chains of 3+ cards where each step follows from the previous. The plateau tab says "I grew from the card above."

## Shape-to-Context Mapping

| Context | Default shape | Why |
|---------|--------------|-----|
| Modal / confirmation sheet | `bite-top` | Signature modal identity |
| Item inspector (inline) | `bite-top` or plain | Consistent with modal DNA |
| Result modal | `bite-top` + `perf` | Claim zone below perforation |
| Market listing detail | `ticket` | Bearer instrument feel |
| Trade offer in chat | `ticket` | Transferable object |
| Rig slot (installed) | `notch-side` + `tab-top` | Plugged-in component in chain |
| Rig slot (empty) | `notch-side` | Plug point, nothing connected |
| MYTH/LEG premium card | `underplate` | Depth = value |
| Run entry | `ticket` | Pass/entry metaphor |
| Run→cache result | `pinch` connector | Cause→effect bridge |
| Achievement card | `tab-top` | Linked to achievement chain |
| Cache (sealed) | plain | Simple container |
| Cache (opened) | `perf` | Split open |
| Settings row | plain | No special shape needed |
| Chat bubble | plain | Clean, simple |

## CSS Implementation

```css
/* ── BITE TOP ── */
.k-card--bite-top { position: relative; }
.k-card--bite-top > .k-bitefx {
  position: absolute; top: 0; right: 0; display: block; z-index: 1;
}
.k-bitefx path { fill: var(--shell, var(--clr-surface-page)); }

/* ── TAB TOP ── */
.k-card--tab-top { position: relative; margin-top: 16px; }
.k-card--tab-top > .k-platop {
  position: absolute; top: -17px; left: var(--tabx, 56%); display: block;
}
.k-platop path { fill: var(--tabc, var(--paper)); }

/* ── PINCH CONNECTOR ── */
.k-pinch {
  display: block; position: relative; z-index: 2;
  margin: -18px auto;
}
.k-pinch path { fill: var(--shell, var(--clr-surface-page)); }

/* ── TICKET ── */
.k-card--ticket { border-radius: var(--r-bar); padding: 0; overflow: visible; }
.k-ticket__top { padding: 16px 20px 12px; }
.k-ticket__bottom { padding: 12px 20px 16px; }

/* ── PERFORATION ── */
.k-perf {
  position: relative; height: 0;
  border-top: 2px dotted rgba(18,19,16,.45);
}
.k-perf::before, .k-perf::after {
  content: ''; position: absolute; top: -8.5px;
  width: 15px; height: 15px;
  transform: rotate(45deg);
  background: var(--shell, var(--clr-surface-page));
}
.k-perf::before { left: -8.5px; }
.k-perf::after  { right: -8.5px; }

/* ── UNDERPLATE ── */
.k-card--underplate { position: relative; z-index: 1; }
.k-card--underplate::after {
  content: ''; position: absolute; inset: 0;
  border-radius: var(--r-card);
  background: var(--underplate-color, var(--clr-state-idle));
  transform: translate(4px, 4px);
  z-index: -1;
}

/* ── NOTCH SIDE ── */
.k-card--notch-side {
  clip-path: polygon(
    0 0, 100% 0, 100% 100%, 0 100%,
    0 72%, 10px 68%, 0 64%,
    0 52%, 10px 48%, 0 44%,
    0 32%, 10px 28%, 0 24%
  );
}
```

## Shape in the Component System

The `BentoCard` component accepts a `shape` prop:

```elixir
<.bento_card shape={:bite_top} state={:ready} rarity={:rare}>
  <:collapsed>...</:collapsed>
  <:detail>...</:detail>
</.bento_card>
```

Valid values: `:plain`, `:bite_top`, `:tab_top`, `:ticket`, `:underplate`, `:notch_side`, `:perf`

Multiple shapes via list: `shape={[:ticket, :underplate]}`

The `pinch` connector is not a card shape — it's a separate element placed between cards:

```elixir
<.bento_card>...</.bento_card>
<.pinch_connector />
<.bento_card>...</.bento_card>
```
