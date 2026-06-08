# userland-ui — Deck UI

Design-system workshop for the **userland Deck** — a mobile-first, cyberpunk
"deck OS" terminal component system. This repo is where deck screens are
designed and calibrated as **standalone HTML** before being ported into the
runnable game.

- **This repo (`Beach-Bum/userland-ui`)** — the design system: `deck.css`,
  standalone screen previews, and component references. No toolchain, no build.
- **The game (`Beach-Bum/userland`)** — a Phoenix app (Elixir / LiveView /
  Postgres / Tailwind v4 + daisyUI) where approved screens land as real
  components and LiveViews.

## Workflow

Build each screen as a **standalone HTML file first** (real `deck.css` inlined +
Tailwind Play CDN + Google Fonts) so it previews instantly in any browser with
no toolchain or deploy. Once a screen is approved, port it into the Phoenix app:

1. **Prototype** — author `screens/NN-name.html`. Iterate on chrome, layout,
   spacing, and glow in the browser. Don't wait on the app build.
2. **Calibrate** — tune the tokens in `deck.css` (green hue, glow strength,
   border weight, chamfer size, font weight/spacing, tile proportions).
3. **Port** — move the markup into the Phoenix app:
   - tokens/classes → `assets/css/deck.css`
   - primitives → `lib/userland_web/components/deck_components.ex`
   - the screen → a LiveView under `lib/userland_web/live/`
   - wire a dev route (e.g. `/dev/deck/<name>`)

The Phoenix-side reference copy of the primitives lives in
[`components/deck_components.ex`](components/deck_components.ex).

## Previewing

Open any file in `screens/` directly in a browser — e.g. `screens/01-mail.html`.
Everything needed (CSS, fonts, Tailwind) loads from the file or a CDN. No server
required (an internet connection is needed for the CDN + fonts).

## Design system (`.dk`, token-driven)

Everything is scoped under `.dk` and driven by CSS custom properties, so screens
stay consistent and re-skinnable. See [`deck.css`](deck.css).

### Palette (green phosphor terminal)

| Token | Value | Role |
| --- | --- | --- |
| `--dk-bg` | `#070a08` | screen background |
| `--dk-fg` | `#b9e7cb` | primary text / lines (phosphor green) |
| `--dk-fg-dim` | `#6f9a80` | secondary text |
| `--dk-line` | `rgba(168,224,190,.42)` | hairline borders |
| `--dk-bright` | `#cdf6dc` | active / inverted fill |
| `--dk-ink` | `#05130b` | text on the bright fill |
| `--dk-amber` | `#f4b91f` | engineering accent |
| `--dk-glow` | `rgba(150,230,180,.45)` | green text glow |

### Type

- **Rajdhani** — UI, labels, headings (`--dk-font`)
- **Share Tech Mono** — codes, IDs (`--dk-mono`)

Loaded via Google Fonts (closest free match to the reference). **Self-host for
production.** To swap to a supplied font, change the token — nothing else.

### Effects

1px borders, a slight green text glow, CRT scanlines + vignette
(`.dk-scan`), and a chamfered clip-path utility (`.dk-chamfer` /
`.dk-frame--chamfer`). `prefers-reduced-motion` is respected.

### Primitives

Each is a CSS class set in `deck.css` with a matching Phoenix wrapper in
`components/deck_components.ex`:

| CSS | Phoenix | What it is |
| --- | --- | --- |
| `.dk` + `.dk-scan` | `deck_screen` | full-screen CRT shell |
| `.dk-bar` | `deck_bar` | segmented header bar |
| `.dk-seclabel` | `deck_section_label` | `[A]` chip + caption |
| `.dk-tile` | `deck_tile` | square option card (`--active` = inverted bright fill) |
| `.dk-tier` | `deck_tier` | tier button (T1–T4) |
| `.dk-msg` | `deck_message` | read / message panel |
| `.dk-footbar` | `deck_footbar` | status footer |

## Screens

| # | Screen | Status |
| --- | --- | --- |
| 01 | Netwire mail terminal | ✅ [`screens/01-mail.html`](screens/01-mail.html) |
| 02 | Store + item cards (stats grid, sockets, amber accent bar) | ⏳ |
| 03 | Message-reader (chamfered tabs, list + content) | ⏳ |
| 04 | Medical tablets (rounded + notched bezels, graphs/readouts) | ⏳ |
| 05 | Store + global-trade (BLUE variant; ticker + candlestick chart) | ⏳ |

## Reference & rules

The visual reference is a set of Cyberpunk-2077 UI screens. **Recreate the
chrome / layout / spacing / glow exactly, but with original userland /
Mindscape content** — no CDPR text, corps, items, or assets (their license +
userland's IP-FIREWALL forbid copying). Logos are supplied separately.
