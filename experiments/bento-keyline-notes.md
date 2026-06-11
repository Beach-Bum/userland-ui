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
| radius 0, 1px borders, no cards        | radii 999/40/26/16, bento cards |
| 8×14 fixed terminal cell grid          | free 4px-base bento grid   |
| all-caps mono                          | grotesk, sentence case + caps labels |
| left-to-right decode transitions       | not implemented here       |

Preserved from the canon: six boards in locked order (NOW MAP RUNS SOUL MARKET
NET), server-authoritative client rule, rarity ladder with **MIL replacing
ILLEGAL**, real 96-item catalogue names/corps/stats, category-driven motion,
reduced-motion requirement, glyph-field backgrounds, no pay-to-win donor rule.

## Exact measurements

Spacing — base unit 4px:

| Token        | Value | Use                          |
|--------------|-------|------------------------------|
| gutter       | 12px  | phone card gap               |
| gutter-desk  | 16px  | desktop bento gap            |
| pad          | 20px  | card padding, phone          |
| pad-desk     | 24px  | card padding, desktop        |
| screen inset | 12px  | phone screen padding         |

Keyline (the signature "sticker" edge): **1.5px line, 3px offset** outside the
fill, following the radius. All cards on the desktop black frame; opt-in on
phone (CTAs, white-on-light rows).

Radii: pill 999 · frame 40 · card 26 (desk 24) · nested/stage 16 · phone shell
54 / screen 42 · header card tops 34 · chips circular.

Type (Inter / neo-grotesque, tabular numerals): numerals 64/44/34 @ w800,
−3% tracking, lh 0.95 · title 17/700 · body 14/500/1.45 · label 11 caps +8% ·
micro 9.5 caps +14%.

Controls: pill buttons h48/40/30 (px 22/18/14, border 1.5) · icon chips 34/44 ·
outline tag h26 · stadium rows h56 · tab bar + action bar h60 r24 · progress
h8 · chart bars max-w 26 r 10/10/4/4 · joint tab 38×18 r9 · toggle 46×27 knob
19 · sheet handle 44×5 · badge circle 62 · theme swatch 64×44 r14.

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
modal/sheet, chat bubble, profile card, achievement badge, market listing,
timer card, settings row, theme selector, donor card. Plus ticker, connectors
(joint tab / dot rail), progress, chart.

Screens (three-zone contract, phone canonical): NOW command center · RIG
vertical six-slot stack (CORE→LENS→PORT→BUS→ICE→SKIN with joint connectors) ·
MARKET stocks/listings · NET chat with inline item cards · SOUL profile/
achievements/donor. Desktop: same kit recomposed on a 12-col bento in the
black keyline frame (replicates reference shot 1 structurally). Breakpoints:
390 canonical / ≥768 two-col / ≥1100 full bento + optional detail rail.
