# 05 — Icon Library Rules

## Principle

Icons are glyphs, not illustrations. They follow one visual grammar: pixel-geometric, flat, consistent stroke, readable at small sizes. No mixed styles. No emoji. No random doodles.

## Grid and Construction Rules

| Property | Value | Notes |
|----------|-------|-------|
| Grid size | 16×16 base | All icons designed on 16px grid |
| Display sizes | 16, 24, 32 px | Scale linearly, no redesign per size |
| Stroke thickness | 1.5px | Matches keyline width `--key-w` |
| Corner radius | 0px (pixel-cut) | Sharp corners, chamfered where needed |
| Fill | Solid or none | No gradients, no half-tones |
| Padding | 1px inset from grid edge | Ensures clean rendering at all sizes |
| Alignment | Pixel-aligned | No sub-pixel positioning |
| Color | Single color per icon | Inherits from parent `color` or `fill` |

## Corner Language

Icons follow the same corner language as the UI kit:
- **Straight cuts**: 90° and 45° angles only
- **No curves**: except circles (dots, bullets)
- **Chamfers**: 1px diagonal cuts at select corners for the sci-fi feel
- **Pixel steps**: use 1px steps for diagonal lines (staircase, not anti-aliased)

## Fill Rules

| State | Fill | Stroke |
|-------|------|--------|
| Default | None (outline only) | `currentColor` 1.5px |
| Active | Solid fill | `currentColor` 1.5px |
| Ready | Solid fill + pulse | `--clr-state-ready` |
| Blocked | None, 40% opacity | `currentColor` 1.5px |
| Disabled | None, 30% opacity | `--clr-disabled` |

## Accent Color Usage

Icons are monochrome (inherit `color`) with these exceptions:
- **State dots**: colored by state (see 02-state-and-action-grammar.md)
- **Rarity indicator**: small colored pip can overlay icon bottom-right
- **Category avatar**: colored circle behind icon uses category color
- **Never**: multi-colored icons, gradient fills, rainbow effects

## Icon Naming Convention

```
icon-{domain}-{name}
```

Domains: `board`, `state`, `action`, `slot`, `item`, `rar`, `ui`

## Required Icons

### Board Icons (`icon-board-*`)

| Token | Glyph concept | Description |
|-------|--------------|-------------|
| `icon-board-now` | Signal pulse | Vertical bars, center tall |
| `icon-board-map` | Grid/crosshair | 4-quadrant grid with center dot |
| `icon-board-runs` | Arrow-forward | Right-pointing chevron with trail |
| `icon-board-soul` | Diamond | Rotated square (self/identity) |
| `icon-board-market` | Exchange | Two arrows opposing (↕ or ⇄) |
| `icon-board-net` | Node cluster | 3 dots connected by lines |

### State Icons (`icon-state-*`)

| Token | Glyph | Visual |
|-------|-------|--------|
| `icon-state-idle` | `—` | Horizontal dash |
| `icon-state-active` | `●` | Solid filled circle |
| `icon-state-ready` | `✦` | 4-point star |
| `icon-state-blocked` | `⊘` | Circle with diagonal line |
| `icon-state-warning` | `▲` | Triangle (pointing up) |
| `icon-state-failed` | `✕` | X cross |
| `icon-state-syncing` | `↻` | Circular arrow |
| `icon-state-locked` | `▣` | Square with inner square |
| `icon-state-expired` | `⏱` | Clock with strike |
| `icon-state-cooling` | `◔` | Quarter-filled circle |

### Action Icons (`icon-action-*`)

| Token | Glyph concept | Notes |
|-------|--------------|-------|
| `icon-action-prep` | Wrench/gear engage | Two interlocking shapes |
| `icon-action-run` | Play triangle | Right-pointing triangle |
| `icon-action-claim` | Download arrow | Arrow pointing into tray |
| `icon-action-install` | Plug-in | Arrow into slot |
| `icon-action-equip` | Snap-fit | Two pieces joining |
| `icon-action-sell` | Tag | Price tag shape |
| `icon-action-inspect` | Magnifier | Circle + handle |
| `icon-action-compare` | Split | Two columns with arrows |
| `icon-action-decode` | Unlock | Lock opening |
| `icon-action-repair` | Hammer | Angled tool |
| `icon-action-cancel` | X | Same as failed but lighter |
| `icon-action-open` | Box lid | Box with lid lifting |
| `icon-action-send` | Arrow up-right | Diagonal arrow |
| `icon-action-abort` | Stop square | Filled square |

### Rig Slot Icons (`icon-slot-*`)

| Token | Glyph concept | Represents |
|-------|--------------|------------|
| `icon-slot-core` | CPU die | Central processor |
| `icon-slot-lens` | Eye/aperture | Optics/scanner |
| `icon-slot-port` | Plug/socket | Network connection |
| `icon-slot-bus` | Highway lanes | Data routing |
| `icon-slot-ice` | Shield | Defense/firewall |
| `icon-slot-skin` | Surface/layer | Cosmetic shell |

### Item Category Icons (`icon-item-*`)

| Token | Glyph concept | Items in category |
|-------|--------------|-------------------|
| `icon-item-rigpart` | Circuit board | Equippable rig components |
| `icon-item-cache` | Sealed box | Loot containers |
| `icon-item-data` | Binary stream | Keys, signals, intel |
| `icon-item-key` | Key shape | Access tokens |
| `icon-item-relic` | Fragment | Rare/ancient objects |
| `icon-item-signal` | Wave | Signal/scan data |
| `icon-item-currency` | SEN diamond | SEN currency |
| `icon-item-material` | Crystal | Crafting materials |

### Rarity Icons (`icon-rar-*`)

Rarity uses text badges, not dedicated icons. However, each rarity level has a small **pip** that can overlay other icons:

| Token | Shape | Color |
|-------|-------|-------|
| `icon-rar-brk` | Cracked dot | gray |
| `icon-rar-com` | Solid dot | green |
| `icon-rar-tun` | Dot with ring | mint |
| `icon-rar-rare` | Diamond | yellow |
| `icon-rar-leg` | Star | violet |
| `icon-rar-epic` | Double diamond | sky |
| `icon-rar-mil` | Warning triangle | red |
| `icon-rar-myth` | Shimmer star | gradient |

### UI Icons (`icon-ui-*`)

| Token | Glyph | Use |
|-------|-------|-----|
| `icon-ui-expand` | `▾` | Expand card |
| `icon-ui-collapse` | `▴` | Collapse card |
| `icon-ui-close` | `✕` | Close modal |
| `icon-ui-menu` | `≡` | Menu/overflow |
| `icon-ui-back` | `←` | Navigate back |
| `icon-ui-settings` | Gear | Settings |
| `icon-ui-notifications` | Bell | Alerts |
| `icon-ui-more` | `···` | More options |

## Implementation Format

Icons are implemented as:
1. **Inline SVG** (preferred) — for icons embedded in components
2. **SVG sprite sheet** — for repeated icons in lists
3. **CSS pseudo-element glyphs** — for state dots and simple shapes only

**Never**: icon fonts, raster images, external CDN icon libraries.

All SVGs must:
- Use `viewBox="0 0 16 16"` base
- Use `fill="currentColor"` or `stroke="currentColor"`
- Have `aria-hidden="true"` (text label handles accessibility)
- Strip unnecessary metadata/comments

## Current Placeholder Strategy

Until the icon library is drawn, the prototype uses Unicode glyphs:
- `▾` / `▴` for expand/collapse
- `●` / `◆` / `▲` for state/category dots
- `✓` / `✕` / `⊘` for pass/fail/blocked
- `→` / `←` / `↻` for directional

These placeholders follow the naming convention and can be swapped 1:1 for SVG icons.
