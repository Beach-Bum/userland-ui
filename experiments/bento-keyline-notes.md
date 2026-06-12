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

Keyline (the signature "sticker" edge): **1.5px line, 3px offset** outside the
fill, following the radius. All cards on the desktop black frame; opt-in on
phone (CTAs, white-on-light rows).

Corners (rev 2): surfaces use a VERY SMALL radius — cards/rows/bubbles/device
cards r8 · nested/stage/cells/swatches r6 · bars (tab/action/ticker) and
tickets r10 · desktop frame r12 · phone hardware shell 44 / screen 32, notch
pill · controls stay round (pills 999, chips/avatars/badges circular).

Shape options on top of the default radius:

- **Sci-fi bite (`k-bite-tr`)** — recessed top-right corner, 64×22, r12 inner
  corner, r12 entry fillets; the shell color shows through.
- **45° cuts (`cut`, `cut-t`, `cut-b`, `cut-x`, `cut-tr`)** — clip-path
  chamfers @14 (statement corner @22) for hero/statement surfaces; pair with
  `k-edge`/`k-edge-lt` hairlines since outlines can't follow clip-path.
- **Interlock (`k-tab-t`)** — the lower card raises an 88×14 plateau tab (r10
  shoulders, r12 base fillets) into a 20px shell band; the gap stays thin (6)
  over the plateau. Position via `--tabx` (56% default / 18% alt), fill via
  `--tabc`. Used to chain causally-linked cards (run→cache→part, rig stack).
- **Ticket tear (`k-perf`)** — 2px dotted line with 15px diamond notches.

Type (Inter / neo-grotesque, tabular numerals): numerals 64/44/34 @ w800,
−3% tracking, lh 0.95 · title 17/700 · body 14/500/1.45 · label 11 caps +8% ·
micro 9.5 caps +14%.

Controls: pill buttons h48/40/30 (px 22/18/14, border 1.5) · icon chips 34/44 ·
outline tag h26 · rows h56 r8 · tab bar + action bar h60 r10 · progress h8
r999 · chart bars max-w 26 r 3/3/0/0 · toggle 46×27 knob 19 · badge circle
62 · theme swatch 64×44 r6 · desktop nav = connected pill chain (−10px
overlap, outlines fuse at the junctions).

Modal / ticket edges: sheet = raised tab 58%×52 r10 (handle 44×5 inside)
flowing through a **concave fillet r12** into a stepped body corner r10 — the
sci-fi "bitten" top-right. Ticket perforation = 2px dotted tear line with
**15px diamond notches** (45°-rotated squares in the shell color) cut into
both edges, full-bleed. Ticket card r10, halves split by the perforation:
glyph + corp tag above, name + vertical serial below.

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

Palette: ink #121310 · black #0A0A0A · navy #1B2531 / #141C26 · paper #FFF ·
bone #EDEAE0 · green #4FD645 · lime #CDF263 · mint #BFEBDC · yellow #F2DF4E ·
pink #F2CCE3 · lavender #DCDDF6 · violet #B5A8F2 · sky #79A8E6 · red #F2472E ·
gray #C7C4B8.

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

Screens (three-zone contract, phone canonical): NOW command center · RIG
vertical six-slot stack (CORE→LENS→PORT→BUS→ICE→SKIN chained by interlock
tabs) · MARKET stocks/listings (bite-corner stocks card) · NET chat with
inline item cards · SOUL profile/achievements/donor · two theme demo screens
(Dusk, Midnight). Desktop: same kit recomposed on a 12-col bento in the black
keyline frame with the connected pill nav chain. Breakpoints: 390 canonical /
≥768 two-col / ≥1100 full bento + optional detail rail.

## Revisions

- **Rev 2 (2026-06-12, consolidated owner pass):** gutters 12/16 → 6/8 (thin
  shell lines, cards nearly touch); surfaces moved to very small radius r8
  (nested 6, bars 10, frame 12); exact plateau-tab interlock replaces the
  floating joint; sci-fi bite corner added as a shape option (used on the
  sheet step and MARKET stocks card); 45° cut options retained as statement
  shapes; connected pill nav kept; phone hardware slimmed to 44/32; two new
  themes (DUSK/MP156, MIDNIGHT/MP206) with gradient fills.
- **Rev 1 (2026-06-11):** stepped-tab sheet + ticket perforation edges.
- **Rev 0 (2026-06-11):** initial bento keyline kit.
