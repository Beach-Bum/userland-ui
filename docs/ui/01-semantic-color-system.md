# 01 — Semantic Color System

## Principle

Every color token has exactly one job. A card may show multiple colors only if each color occupies a different **visual layer**. No color is "decoration" — if it's visible, it communicates something specific.

## Visual Layers

A single card surface can carry colors in these layers simultaneously, because each layer is a different visual element:

| Layer | Element | What it communicates | Example |
|-------|---------|---------------------|---------|
| 1. Board accent | Header card background, tab highlight | Which board you're on | MAP header = `--clr-board-map` |
| 2. Object state | State chip, dot, progress bar | What is happening right now | Running = `--clr-state-active` |
| 3. Rarity | Rarity badge/pill text + border | How rare/valuable | RARE = `--clr-rar-rare` |
| 4. Action | CTA button fill or border | What you can do | Primary CTA = `--clr-action-primary` |
| 5. Feedback | Result banner, warning strip | What just happened | Success = `--clr-fb-ok` |
| 6. Danger | Left border, heat meter, pip | Risk or blocking condition | Heat warning = `--clr-danger` |
| 7. Disabled | Dimmed text, locked overlay | Cannot interact | Locked = `--clr-disabled` |
| 8. 3D reveal | Stage border glow | Object focus during inspect | Reveal = `--clr-reveal` |

## Color Roles

### A. Board Identity Colors

Board identity colors appear **only** on board header cards and the active tab indicator. They identify navigation context — never item state, rarity, or actions.

| Token | Hex | Board | Allowed | Forbidden |
|-------|-----|-------|---------|-----------|
| `--clr-board-now` | `#121310` (ink/black) | NOW | Header card bg, tab dot | Item color, state, rarity |
| `--clr-board-map` | `#79A8E6` (sky) | MAP | Header card bg, tab dot | Item color, state, rarity |
| `--clr-board-runs` | `#CDF263` (lime) | RUNS | Header card bg, tab dot | Item color, state, rarity |
| `--clr-board-soul` | `#B5A8F2` (violet) | SOUL | Header card bg, tab dot | Item color, state, rarity |
| `--clr-board-market` | `#F2DF4E` (yellow) | MARKET | Header card bg, tab dot | Item color, state, rarity |
| `--clr-board-net` | `#DCDDF6` (lav) | NET | Header card bg, tab dot | Item color, state, rarity |

Board colors **may** tint the action bar on their board (10% opacity bg), but must not color item cards.

### B. State Colors

State colors communicate what is happening to an object or process right now. They appear on state chips, dots, progress bars, and state text.

| Token | Hex | State | Allowed | Forbidden |
|-------|-----|-------|---------|-----------|
| `--clr-state-idle` | `#C7C4B8` (gray) | Nothing happening | State dot, chip | CTA fill, rarity |
| `--clr-state-active` | `#CDF263` (lime) | Process running | State dot, progress fill, chip | Board identity, rarity |
| `--clr-state-ready` | `#4FD645` (green) | Ready to act/claim | State dot, chip, shimmer border | Rarity, item category |
| `--clr-state-blocked` | `#F2472E` (red) | Cannot proceed | State dot, chip, left border | Rarity (except MIL) |
| `--clr-state-syncing` | `#79A8E6` (sky) | Waiting for server | State dot, chip, scan animation | Board identity |
| `--clr-state-expired` | `#C7C4B8` (gray) | Time ran out | State chip, strikethrough | Progress bar |
| `--clr-state-cooling` | `#BFEBDC` (mint) | Cooldown period | State dot, timer text | CTA fill |

### C. Rarity Colors

Rarity colors appear **only** inside rarity badges/pills and on the item card's rarity indicator. They never color entire card backgrounds.

| Token | Hex | Rarity | Visual treatment |
|-------|-----|--------|-----------------|
| `--clr-rar-brk` | `#C7C4B8` (gray) | BRK | Gray text, flicker motion |
| `--clr-rar-com` | `#4FD645` (green) | COM | Green text |
| `--clr-rar-tun` | `#BFEBDC` (mint) | TUN | Mint text |
| `--clr-rar-rare` | `#F2DF4E` (yellow) | RARE | Yellow text + border |
| `--clr-rar-leg` | `#B5A8F2` (violet) | LEG | Violet text + border |
| `--clr-rar-epic` | `#79A8E6` (sky) | EPIC | Sky text + border |
| `--clr-rar-mil` | `#F2472E` (red) | MIL | Red text + border + threat pulse |
| `--clr-rar-myth` | multi-gradient | MYTH | Animated shimmer gradient |

**Rule**: Rarity badge always includes a text label (BRK/COM/TUN/RARE/LEG/EPIC/MIL/MYTH). Color is never the only rarity signal.

### D. Item Category Colors

Category colors identify what kind of thing an item is. They appear on category tags and as subtle tints on item card accents (avatar dot, left stripe). They do **not** fill entire cards.

| Token | Hex | Category | Items |
|-------|-----|----------|-------|
| `--clr-cat-core` | `#CDF263` (lime) | CORE | Core rig parts, primary programs |
| `--clr-cat-lens` | `#F2DF4E` (yellow) | LENS | Optics, scanners, recon parts |
| `--clr-cat-port` | `#DCDDF6` (lav) | PORT | Connection, network parts |
| `--clr-cat-bus` | `#BFEBDC` (mint) | BUS | Transport, routing, heat management |
| `--clr-cat-ice` | `#79A8E6` (sky) | ICE | Defense, firewalls, shields |
| `--clr-cat-skin` | `#F2CCE3` (pink) | SKIN | Cosmetics, identity, visual mods |
| `--clr-cat-cache` | `#B5A8F2` (violet) | CACHE | Loot containers, drops |
| `--clr-cat-data` | `#C7C4B8` (gray) | DATA | Keys, signals, currency, materials |

### E. Action Colors

Action colors appear on CTA buttons and action-state indicators.

| Token | Hex | Role | Allowed | Forbidden |
|-------|-----|------|---------|-----------|
| `--clr-action-primary` | `#121310` (ink) | Primary CTA fill | Buttons: RUN, CLAIM, INSTALL, BUY | Card bg, state chip |
| `--clr-action-secondary` | `transparent` | Secondary CTA | Outlined buttons: Cancel, Details | — |
| `--clr-action-destructive` | `#F2472E` (red) | Dangerous/irreversible | Confirm buttons on risk sheets | State chips (use state-blocked) |
| `--clr-action-disabled` | `#C7C4B8` (gray) | Cannot act | Disabled button border + text | Active elements |
| `--clr-action-pending` | `#CDF263` (lime) | Action in progress | Spinner/pulse on button | — |

### F. Feedback Colors

Feedback colors appear in result banners, toasts, and inline result states.

| Token | Hex | Role |
|-------|-----|------|
| `--clr-fb-ok` | `#4FD645` (green) | Success result: run complete, claim, install |
| `--clr-fb-fail` | `#F2472E` (red) | Failure result: run failed, blocked, expired |
| `--clr-fb-warn` | `#F2DF4E` (yellow) | Warning: heat approaching, below market price |
| `--clr-fb-info` | `#79A8E6` (sky) | Neutral info: sync complete, server message |

### G. Danger / Heat

| Token | Hex | Role |
|-------|-----|------|
| `--clr-danger` | `#F2472E` (red) | Heat meter, risk border, MIL warning pip |

This is the same hex as `--clr-state-blocked` and `--clr-rar-mil` — but each appears in a different visual layer, so no ambiguity arises.

### H. Surface & Structural Colors

| Token | Hex | Role |
|-------|-----|------|
| `--clr-surface-primary` | `#FFFFFF` (paper) | Card backgrounds |
| `--clr-surface-dark` | `#0A0A0A` (black) | Dark cards, desktop frame |
| `--clr-surface-navy` | `#1B2531` (navy) | Navy cards, rig cards |
| `--clr-surface-page` | `#EDEAE0` (bone) | Page/shell background |
| `--clr-surface-stage` | `rgba(18,19,16,.06)` | 3D stage bg (light) |
| `--clr-surface-stage-dark` | `rgba(255,255,255,.08)` | 3D stage bg (dark cards) |
| `--clr-disabled` | `#C7C4B8` at 40% | Locked/unavailable elements |
| `--clr-reveal` | `#B5A8F2` (violet) | 3D reveal stage glow border |
| `--clr-sep` | `rgba(18,19,16,.15)` | Separator lines (light) |
| `--clr-sep-dark` | `rgba(255,255,255,.15)` | Separator lines (dark) |

## Collision Rules

1. **Same hex, different layer** is allowed: red can be `--clr-danger` (left border) AND `--clr-rar-mil` (rarity badge) on the same card, because they occupy different visual elements.
2. **Same hex, same layer** is forbidden: a state chip cannot be green to mean both "ready" and "COM rarity" — pick the dominant meaning and use the other layer for the second.
3. **Board color on item cards** is forbidden: board identity stays on headers and tabs only.
4. **Rarity color as card background** is forbidden: rarity lives in badges. Card backgrounds are structural (paper/black/navy) or board headers.

## Theme Remapping

Themes remap category tokens 1:1 (same role, different hue). State colors `--clr-fb-ok`, `--clr-danger`, `--clr-state-ready`, `--clr-state-blocked` are **constant** across all themes — green stays green, red stays red. This preserves safety-critical meaning.

## Migration from Current Tokens

| Current token | New semantic token | Notes |
|--------------|-------------------|-------|
| `--c-run` | `--clr-board-runs` + `--clr-state-active` + `--clr-cat-core` | Split: was doing 3 jobs |
| `--c-build` | `--clr-cat-bus` + `--clr-state-cooling` | Split |
| `--c-trade` | `--clr-board-market` + `--clr-cat-lens` | Split |
| `--c-social` | `--clr-board-net` + `--clr-cat-port` | Split |
| `--c-grow` | `--clr-board-soul` + `--clr-cat-cache` + `--clr-reveal` | Split |
| `--c-drop` | `--clr-cat-skin` | Narrowed |
| `--c-info` | `--clr-board-map` + `--clr-state-syncing` + `--clr-fb-info` | Split |
| `--c-ok` | `--clr-state-ready` + `--clr-fb-ok` + `--clr-rar-com` | Unchanged hex, explicit roles |
| `--c-heat` | `--clr-danger` + `--clr-state-blocked` + `--clr-fb-fail` + `--clr-rar-mil` | Unchanged hex, explicit roles |
