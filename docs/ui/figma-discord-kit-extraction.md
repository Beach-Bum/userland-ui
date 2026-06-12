# Figma Discord Kit — Extraction Report

Source: `Discord UI Kit (Community)` — fileKey `WmfzFLSggJi0jHwmhEbdKP`
Audited via Figma MCP: `get_metadata` (pages 0:1, 74:291) + `get_design_context`
(nodes 84:1901, 84:1731, 53:283, 138:623, 2:3, 84:1865).
Purpose: structural reference for the Userland chat-first prototype
(`experiments/userland-chat.html`). Structure only — zero Discord visual identity.

---

## 1. File overview

- **File name**: Discord UI Kit (Community), by Muatex
- **Pages found**: 2
  - `0:1` Assets — the component library (all reusable parts)
  - `74:291` Cover & Kit Components — cover art collages, no usable screens
- **Top-level frames on Assets (0:1)**:
  - `84:1618` Message Components (688×2489)
  - `137:1096` Modal Components (850×2571)
  - `74:285` User Components (548×1707)
  - `75:244` Server Components (580×1629)
  - `75:371` Sidebar Components (450×737)
  - `89:732` App Components (1175×1084)
  - `605:911` Frame 18 (About/Downloads — kit credits)
- **Mobile frames**: none. This is a **desktop-proportioned kit** (Title Bar 1043w,
  Message Bar 931w, sidebar profile 180×40). No mobile chat screen exists in the file.
  All mobile adaptation is ours: single column, composer pinned, tabs replace sidebar.
- **Useful for Userland**: Message Components (84:1618), Modal Components (137:1096),
  App Components' Message Bar + Title Bar (89:732), Channels rows (2:2),
  Status dots (53:126), Username grouped variants (180:786), Selector (137:758).
- **Ignore**: Server Components (banners, boost bars, voice counters), Sidebar
  Components (categories, mute/deafen), User Badges (12:734), RPC cards (182:843),
  Gift (173:546), Frame 18, both Cover frames.

## 2. Component inventory

| Component | id | Location | Variants | Auto Layout | Measured structure |
|---|---|---|---|---|---|
| **Message row** | `84:1901` Message | Message Components | no (base) | yes (row, gap 9) | avatar 35px + col(gap 5): header row(gap 6, baseline) + body. Name 11.5 semibold, time 9 muted, body 11.5 |
| **Reply / thread line** | `84:1865` Reply | Message Components | no | yes (row, gap 2, pl 18) | curved connector vector 24.5×8 → 14px mini avatar → @name 10 bold .8 + preview 9 .5 |
| **Message group header** | `180:786` Username | User Components | `Server Avatar=True/False` | yes | True = avatar+name row (group opener); False = name only (grouped follow-up) |
| **Avatar** | `53:183` User Avatar | User Components | `Outline×Status` (4) | no (layered circles) | outer ring + inner circle inset ~5.8% |
| **Status dot** | `53:126` Status | User Components | `Type` (6: Online/Mobile/Idle/DND/Streaming/Offline) × `Outline` | no | 20×20 chip on avatar corner |
| **Embed / card container** | `84:1731` Embed Container | Message Components | no (composed) | yes (col) | **left accent bar via pl 2.5 colored wrapper, r4**; inner card pt14 pb17 px13.5, col gap 6: author row(gap 6: 18px icon + 11 bold) → title 13 bold → desc 11 → fields row(gap 10, field col w140 gap 2) → divider → image 300×169 r4 → footer row(gap 6: 15px icon · 10 text · • · time) |
| **Embed text** | `84:1582` | Message Components | `Type=Title/Description/Fields` | yes | fields are 2-col inline pairs |
| **Footer/Author** | `84:1596` | Message Components | `Type×Image×Timestamp` (6) | yes | icon+text+dot+time row |
| **Action button** | `8:247` Button | Message Components | `Type` (Primary/Success/Secondary/Destructive/Link) × `Emoji` × `Hover` = 20 | yes | 50×21 min, r~3, label center |
| **Selector / context list** | `137:758` Selector | Message Components | `Seector/Context` | yes | closed 300×32; open list 300×136 |
| **Channel row** | `2:2` Channels | Server Components | `Type` (10) × `Selected` = 20 | yes (row, gap 10, px 9, py 7) | 170×28 r3: icon 13×14 + label 11.5 flex + trailing badge. Selected = filled bg + bright text; unselected = transparent + muted |
| **Channel icons** | `8:40` | Server Components | `Type` (16) | no | 13×14 glyphs |
| **Top bar** | `177:710` Title Bar | App Components | `Style=Channel/Group/Friends` | yes | 1043×36: icon + name + action icon cluster right |
| **Composer** | `53:283` Message Bar | App Components | no | yes (row, gap 12, px 13, py 9) | r7 filled bar: lead + icon 16 → flex-1 text 12 → trailing icon cluster 141w |
| **Modal** | `138:624` Modal | Modal Components | `Style` (Promotional/Form/Message/Regular/Authentication/Image) | mixed | Regular 330×159 r4, shadow 0/5/20/20%: title 15.7 → desc 11.5 w290 → button row bottom |
| **Modal buttons** | `137:249` | Modal Components | `Count 1–3 × Color` (12) | yes | left text-link (Back) + right group gap 17: text Cancel + filled primary px15 py8 r2 |
| **Input field** | `138:568` | Modal Components | `Size×Selected` (4) | yes | short 306×30 / long 306×63 |
| **Profile/member card** | `182:922` Profile | User Components | no | yes | 225×457: banner → avatar overlap → name → badges → about/roles blocks |
| **Sidebar self card** | `75:726` Sidebar Profile | Sidebar Components | no | yes | 180×40: avatar 32 + name/#tag + 3 icon buttons |
| **Notification badge** | bdot pattern on `2:6` Union (channel row trailing), voice counter `12:464` | Server Components | n/a | n/a | tiny trailing counter/dot on row; corner dot on tabs |

## 3. Variant audit (useful set)

- message/default → `84:1901`
- message/grouped → `180:785` (Server Avatar=False — no avatar, no header)
- message/reply-context → `84:1865`
- avatar/status: Online·Idle·DND·Offline (`53:119/123/124/125`)
- channel/default → `10:217…` (Selected=False)
- channel/active → `2:3…` (Selected=True, filled bg)
- channel/unread-mention → trailing Union badge on row
- button/primary·success·secondary·destructive·link × hover → `122:326–345`
- modal/regular·form·message·image → `138:619–623, 140:573`
- modal buttons/count 1–3 × primary·success·destructive → `137:248–409`
- input/short·long × selected → `138:566–575`
- selector/closed·open → `137:757/756`
- composer: single variant (`53:283`) — focus/typing states are ours to add

## 4. Layout grammar extraction

1. **Message grouping**: first message in a group carries avatar + name + time;
   consecutive messages by the same author drop the avatar and header entirely
   (Username `Server Avatar=False`) and tighten vertical rhythm. Group breaks on
   author change or time gap.
2. **Avatar column**: fixed-width left rail (35px + 9 gap) so all bodies align to
   one text column, including embeds.
3. **Name/time**: one baseline row, name strong, timestamp small + muted (11.5/9).
4. **Embeds attach to messages**: an embed is a child of the message column, not a
   sibling card — left accent bar (2.5px) carries the *source/type* meaning;
   inner card has its own header (author) → title → body → fields → media → footer.
   This is the entire GamePacket grammar.
5. **Composer**: one filled rounded bar, lead action, flex text, trailing actions;
   sits flush at the bottom with screen gutter padding.
6. **Unread/mention**: never restyles the feed — a tiny trailing dot/counter on the
   *nav row* (channel) only. Calm by default.
7. **Active filter**: filled background + brighter text on the nav row; inactive
   rows are transparent + muted. No borders.
8. **Modal structure**: title → short description → bottom action row with
   escape-as-text-link (left), cancel-as-text (right), one filled primary. One
   purpose per modal.
9. **Spacing rhythm**: tight 2–6px inside components, 9–13px component padding,
   ~16px section gutters. Radii small: r3 rows, r4 cards/modals, r7 composer.
10. **Mobile pattern (derived, kit has none)**: drop sidebars; channel rows become
    a horizontal filter strip; title bar collapses into HUD; member list omitted.

## 5. Userland mapping

| Figma component | Userland component | Keep structurally | Change visually | Notes |
|---|---|---|---|---|
| Message row `84:1901` | **MessagePacket** | avatar rail, header baseline row, body in text column | bone bubble, ink avatar ring, Space Mono | own messages mirror right |
| Embed Container `84:1731` | **GamePacket** | left accent bar, inner header/title/fields/footer order | ink keyline accent (heat-red for warnings), bone fill, kv dotted rows | accent bar = packet lane marker |
| Channel row `2:3` | **BoardFilterRow → BoardFilterTabs** | selected=filled / unselected=muted, trailing badge slot | bone fill on active tab, glyph instead of counter | rotated 90° into a strip |
| Server/channel rail | **Board/Index selector (the tab strip)** | one selected at a time, unread markers | navy strip, 6 filters | no servers metaphor |
| Message Bar `53:283` | **ActionComposer** | lead/flex/trailing row, filled rounded bar | bone pill, ink send circle | message:send |
| Button `8:247` + Selector `137:758` | **PacketQuickAction** (chips) | primary/secondary/destructive roles, hover states | k-pill roles: ink/run/trade/ghost/armed | max 2 per packet collapsed |
| Modal `138:623` + Modal Buttons | **UserlandSheet** (Item/Run/Market/Profile) | title→desc→stats→action row, cancel-as-text | flat bone bottom sheet, no shadow theatre | one purpose, never nested |
| Profile `182:922` | **ProfileSheet (SOUL)** | banner→identity→blocks order | bone, rig slots instead of roles | opens from HUD identity |
| Channel row trailing badge | **BoardGlyph** | tiny, on nav only, never in feed | glyph chars · ∴ ✦ ⌁ ▴ ■ semantically colored | calm rule kept |
| Reply `84:1865` | **cause-thread line** | the "this is a consequence of ↑" connector | dotted ink micro-line + "↳ caused by" microcopy | used on result packets |
| Username `180:785` grouped | **MessageGroup** | grouped messages drop avatar/header, tightened gap | same | group on same sender, <2min |

## 6. Rejection list

- Discord colors (blurple #5865F2, #36393f/#2f3136 dark grays, status greens) — bone/ink only
- Discord icons, badges (Nitro/Boost/Staff/Hypesquad), emoji buttons
- Server metaphor: server rails, banners, boost bars, voice/stage, categories
- Desktop-only clutter: 1043px title bar, member list, mute/deafen cluster
- Member sidebar on mobile — harms the single column
- Gift/promotional cards, RPC activity cards — no equivalent in Userland
- Decorative dividers/shadows that don't carry game meaning
