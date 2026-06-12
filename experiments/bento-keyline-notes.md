# KIT-B "Bento Keyline" — UI experiment notes

**Status: EXPERIMENT — NOT PRODUCTION.** Owner-directed test (Ned, 2026-06-11).
Production game UI remains `.dk` per `docs/strategy/DIRECTION-OVERRIDE-2026-06-10.md`
in `Beach-Bum/userland`. Do not port anything from this kit without owner sign-off.

## What this is

A test of the bento / keyline / pill visual system (from four owner-supplied
reference shots: neo-brutalist dashboard, fitness app, marketing report, hiking
app) applied to Userland game content, using the "Game Design & Interface Repair
Plan — Main Branch / 3D Library / UI Kit Sync" doc as the product brief.

Open `bento-keyline-kit.html` in any browser. Standalone, no toolchain, no JS.

## Conflict record (required by repo rules)

This kit contradicts the locked master-plan rails in `Beach-Bum/userland`:

| Rail (locked)                          | This experiment            |
|----------------------------------------|----------------------------|
| radius 0, 1px borders, no cards        | r8 surfaces + sci-fi/cut shape options, round controls, bento cards |
| 8×14 fixed terminal cell grid          | free 4px-base bento grid   |
| all-caps mono                          | grotesk, sentence case + caps labels |
| left-to-right decode transitions       | not implemented here       |

Preserved from the canon: six boards in locked order (NOW MAP RUNS SOUL MARKET
NET), server-authoritative client rule, rarity ladder with **MIL replacing
ILLEGAL**, real 96-item catalogue names/corps/stats, category-driven motion,
reduced-motion requirement, glyph-field backgrounds, no pay-to-win donor rule.

## Exact measurements

Spacing — base unit 4px:

| Token        | Value | Use                                |
|--------------|-------|------------------------------------|
| gutter       | 6px   | phone card gap — thin shell line   |
| gutter-desk  | 8px   | desktop bento gap                  |
| pad          | 20px  | card padding, phone                |
| pad-desk     | 24px  | card padding, desktop              |
| screen inset | 10px  | phone screen padding               |
| corner cut   | 14px  | 45° chamfer size for cut-* options |

Keyline (1.5px line, 3px offset) lives on **controls and the desktop frame
only** — cards are flat, separated by the thin shell gap, so adjacent lines
can never collide at 6/8 gutters. Same-color-on-same-color rows use an
on-edge border instead: `.k-line` (1.5px ink) / `.k-line-lt` (1px 22% white).

Pixel-perfect rule: every sculpted junction — plateau tab, centered pinch,
sheet fillet, bite corner — is a **single-path inline SVG** (`.k-platop`,
`.k-pinch`, `.k-fil`, `.k-bitefx`). No CSS radial-gradient fillets, no
stacked pseudo-elements: one continuous path means no fringes, slivers, or
hairline seams at any zoom or DPR.

Corners (rev 2): surfaces use a VERY SMALL radius — cards/rows/bubbles/device
cards r8 · nested/stage/cells/swatches r6 · bars (tab/action/ticker) and
tickets r10 · desktop frame r12 · phone hardware shell 44 / screen 32, notch
pill · controls stay round (pills 999, chips/avatars/badges circular).

Shape options on top of the default radius:

- **Sci-fi bite (`k-bite-tr` + `.k-bitefx` SVG)** — recessed top-right
  corner, 66×22, r10 entry + r12 inner fillets in one path; shell shows
  through.
- **45° cuts (`cut`, `cut-t`, `cut-b`, `cut-x`, `cut-tr`)** — clip-path
  chamfers @14 (statement corner @22) for hero/statement surfaces; pair with
  `k-edge`/`k-edge-lt` hairlines since outlines can't follow clip-path.
- **Interlock (`k-tab-t` + `.k-platop` SVG)** — the lower card raises a
  112×18 plateau tab (r10 shoulders, r12 flares, 1px overlap into the card)
  into the shell band; the gap stays thin over the plateau. Position via
  `--tabx` (56% default / 18% alt), fill via `--tabc`. Chains causally-linked
  cards (run→cache→part, rig stack).
- **Pinch (`.k-pinch` SVG)** — the centered middle connector: an 84×30 shell
  blob notching 12px into both cards with flares riding their edges; placed
  between cards, margin −18 auto. Use where the link is mutual rather than
  directional (achievement chains, paired cards).
- **Ticket tear (`k-perf`)** — 2px dotted line with 15px diamond notches.

Type (rev 4): **Gamja Flower 400** carries display — numerals 68/48/36
(lh ≤.95), card titles 22, device names 18, page h1 58. **Space Mono**
carries body and small copy — body 13.5/1.55, label 11 caps +5%, micro 9.5
caps +8%, pills 12/10, tab bar 9.5; tabular by nature.

Controls: pill buttons h48/40/30 (px 22/18/14, border 1.5) · icon chips 34/44 ·
outline tag h26 · rows h56 r8 · tab bar + action bar h60 r10 · progress h8
r999 · chart bars max-w 26 r 3/3/0/0 · toggle 46×27 knob 19 · badge circle
62 · theme swatch 64×44 r6 · desktop nav = connected pill chain (−10px
overlap, outlines fuse at the junctions).

Modal / ticket edges: sheet = raised tab 58%×46 r10 (handle 44×5 inside)
flowing through a **concave r12 SVG fillet** into a stepped body corner r10 —
the sci-fi "bitten" top-right. The modal is the reference feel for the whole
kit: flat, crisp, tight. Ticket perforation = 2px dotted tear line with
**15px diamond notches** (45°-rotated squares in the shell color) cut into
both edges, full-bleed. Ticket card r10, section padding 12/16, halves split
by the perforation: glyph + corp tag above, name + vertical serial below.

Themes: a theme is a CSS-variable swap; MIL red stays constant as a state
color. **DUSK / MP156**: Baby Blossom #FAEFE9, Onion White #E2D5C2, Creamy
Peach #F4A384, Grey Carmine #7A5063, Obsidian Plum #4A2C3F, Blue Loneliness
#486D83 — gradients carmine→peach and plum→blue. **MIDNIGHT / MP206**:
Cheviot #F6F2E8, Grape Mist #C5C0C9, Isotonic Water #DDFF55, Pacific Panorama
#C0D6EA, Neptune's Wrath #11425D, Midnight Dreams #002233 — gradients
midnight→grape→isotonic and neptune→pacific. Default theme gradients:
violet→pink, navy→sky. Gradients are static surface fills for hero / timer /
decode moments; text color follows the contrast ratios printed on the source
palettes.

Palette is SEMANTIC (rev 4) — components reference category tokens, themes
remap categories 1:1, roles never change:

| Token      | Default (hex)     | Category                          |
|------------|-------------------|-----------------------------------|
| --c-run    | lime #CDF263      | RUN · actions, CTAs, active       |
| --c-build  | mint #BFEBDC      | BUILD · rig, install, parts       |
| --c-trade  | yellow #F2DF4E    | TRADE · market, SEN, tickets      |
| --c-social | lavender #DCDDF6  | SOCIAL · net, chat, crew          |
| --c-grow   | violet #B5A8F2    | GROW · soul, achievements         |
| --c-drop   | pink #F2CCE3      | DROP · caches, loot, claims       |
| --c-info   | sky #79A8E6       | INFO · system chrome, action bar  |
| --c-ok     | green #4FD645     | state · positive/COM — constant   |
| --c-heat   | red #F2472E       | state · danger/MIL — constant     |

Surfaces: ink #121310 · black #0A0A0A · navy #1B2531/#141C26 · paper #FFF ·
bone #EDEAE0 · gray (BRK) #C7C4B8. Rarity rides the category palette
(RARE=trade-yellow, EPIC=info-sky, LEG=grow-violet…) except MIL/COM which
pin to the constant state colors.

Live state (rev 4): every active surface narrates itself — pulsing state dot
(OK green; RUN-color when ready; gray when idle) + caps label of what it is
doing + counting percentage + 4px progress line. Mechanics: `--p` is a
registered `@property <integer>` set inline on the card with class `.k-go`;
a keyframe animates it 0→target in 2.2s and a CSS counter renders the
number (`.k-pct`). Reduced motion strips the animation and shows final
values instantly. States: `.is-ready` (100%, blinking label), `.is-idle`
(dim, 0%).

Rarity → fill: BRK gray (flicker) · COM green · TUN mint · RARE yellow · LEG
violet · EPIC sky · MIL red (threat pulse) · MYTH animated multi-gradient
shimmer. Rarity text pill always accompanies the color.

Category → motion: CORE bloom · LENS sweep · PORT handshake · BUS route · ICE
blade · SKIN shimmer. Subtle in lists, stronger in detail/decode. All motion
behind `prefers-reduced-motion`.

## Coverage

All 17 brief-§9 primitives: app shell, board nav (pill chain + tab bar), status
strip, action bar, card, device card, 3D device card (stage r16 = 3D library
mount point; glyph rigs are placeholders — model library untouched), list row,
modal/sheet (sci-fi stepped tab + ticket perforation), chat bubble, profile
card, achievement badge, market listing, timer card, settings row, theme
selector, donor card. Plus run ticket, ticker, interlock tabs, dot rail,
bite corners, 45° cut options, gradient fills, two alternate themes,
progress, chart.

Screens (three-zone contract, phone canonical): all six boards — NOW command
center · MAP world navigation with glyph-field map, discovered/locked nodes,
scan target, lore hint · RUNS jobs board with active run timer, available/locked
runs list, requirement checks (OK/FAIL), last result card · RIG vertical
six-slot stack (CORE→LENS→PORT→BUS→ICE→SKIN chained by interlock tabs) ·
MARKET stocks/listings (bite-corner stocks card) · NET chat with inline item
cards · SOUL profile/achievements/donor · two theme demo screens (Dusk,
Midnight). Desktop: same kit recomposed on a 12-col bento in the black
keyline frame with the connected pill nav chain. Breakpoints: 390 canonical /
≥768 two-col / ≥1100 full bento + optional detail rail.

## Revisions

- **Rev 6 (2026-06-12):** inline expand system complete — all 6 expandable cards
  use grid-template-rows 0fr→1fr wrapper pattern; three card types added
  (info/action/risk with distinct visual treatment); 3 more market listings
  (action, risk with MIL warning, info delisted); SOUL achievements made
  expandable with reward/tier/unlock stats; rig slot card with 3D stage
  placeholder in SOUL; SOUL action bar added; 6 modal sheet examples
  (run prep, run complete/claim, item install compare, market buy confirm
  with risk warning, cache reveal, chat trade offer); result states
  (ok/fail) stay inside expanded panels; sheet overlay slides from bottom
  with escape/tap-outside close; risk cards get red left border + warning
  pip; reduced motion on all new animations.

- **Rev 5 (2026-06-12):** all six boards complete — added MAP phone screen
  (glyph-field map, discovered/locked/scan-target nodes, lore hint, SCAN/
  TRAVEL/VIEW action bar) and RUNS phone screen (active run with live timer,
  available/locked runs list, run requirements with OK/FAIL checks, last
  result card with loot summary, START/PREP/ABORT action bar). Section note
  updated from "Five boards" to "All six boards plus rig detail".

- **Rev 4 (2026-06-12):** type voice — Gamja Flower for display headings/subs
  (numerals, titles, device names), Space Mono for body and small copy;
  palette made semantic (category tokens RUN/BUILD/TRADE/SOCIAL/GROW/DROP/
  INFO + constant OK/HEAT states; themes remap categories 1:1); live-state
  system added (`.k-go`/`--p`/`.k-live`/`.k-pct`): pulsing dot, activity
  label, counting % and progress line on NOW, RIG, MARKET, timer, sheet,
  desktop, theme heroes + a dedicated bench; RIG header recolored to BUILD
  mint, NET header to SOCIAL lavender.
- **Rev 3 (2026-06-12, pixel-perfect pass):** all sculpted junctions redrawn
  as single-path inline SVG (plateau `.k-platop`, new centered pinch
  `.k-pinch`, sheet fillet `.k-fil`, bite `.k-bitefx`) — kills the gradient
  fringes, slivers, and hairline seams; centered middle connector restored
  alongside the plateau (connectors bench + SOUL); card keylines removed
  (controls/frame only, `.k-line` borders for same-color rows) so lines
  can't collide at 6/8 gutters; modal tightened (tab 46, paddings 12–18)
  while keeping its feel as the kit-wide reference.
- **Rev 2 (2026-06-12, consolidated owner pass):** gutters 12/16 → 6/8 (thin
  shell lines, cards nearly touch); surfaces moved to very small radius r8
  (nested 6, bars 10, frame 12); exact plateau-tab interlock replaces the
  floating joint; sci-fi bite corner added as a shape option (used on the
  sheet step and MARKET stocks card); 45° cut options retained as statement
  shapes; connected pill nav kept; phone hardware slimmed to 44/32; two new
  themes (DUSK/MP156, MIDNIGHT/MP206) with gradient fills.
- **Rev 1 (2026-06-11):** stepped-tab sheet + ticket perforation edges.
- **Rev 0 (2026-06-11):** initial bento keyline kit.
