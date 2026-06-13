# Stoat System Inventory

A documentation-and-inventory pass over the two Stoat-clone experiments. The goal
is to capture the complete working chat/social system — components, tokens,
spacing, CSS architecture, responsive rules, interaction hooks, and safe
extension points — **before** any real UI customization.

This is documentation only. No experiment HTML/CSS/JS/content/class names were
changed to produce it.

Source files inspected:

- `experiments/userland-stoat-pure-chat.html` (593 lines)
- `experiments/userland-stoat-social.html` (1439 lines)

Supporting docs read:

- `docs/current-userland-courier-canon.md`
- `docs/tasks/stoat-content-pass.md`
- `docs/tasks/stoat-system-extraction.md`
- `docs/ui/stoat-pure-ui-map.md`, `docs/ui/stoat-structure-map.md` (prior structure maps)

> Line numbers below refer to the files as of this pass. They are anchors for
> humans, not contracts; classes and structure are the stable reference.

---

## 1. File overview

### `experiments/userland-stoat-pure-chat.html`

| Aspect | Value |
|---|---|
| Purpose | Minimal Stoat/Discord-style **chat skeleton** — proves a game chat can live in a normal chat shell |
| High-level function | One server, a channel list, one chat column, three modal types |
| Type | **Chat + modal** (chat-primary; profile/settings/detail modals) |
| JS interactions | Yes — single delegated click handler, send + canned reply, modal shell |
| Mobile responsive | Yes — one breakpoint at `max-width:720px` (rail hides, channel list becomes a drawer) |

Key sections in document order:

1. `<style>` — reset, `:root` tokens, app shell, rail, channels, user menu, chat column, feed, messages, embeds, buttons, composer, modal layer, profile modal, settings modal, detail modal, responsive (lines 7–217)
2. App shell markup: `.rail` → `.chans` → `.chat` (lines 221–260)
3. `.scrim` modal mount (line 263)
4. `<script>`: data (`USERS`, `CHANNELS`, `MSGS`), render (`renderChans`, `renderFeed`, `renderEmbed`), modal shell (`openModal`/`closeModal`/`MODALS`), event delegation, `send()` (lines 265–591)

### `experiments/userland-stoat-social.html`

| Aspect | Value |
|---|---|
| Purpose | Full Stoat/Discord-style **social game shell** built on top of the chat skeleton |
| High-level function | Multi-server rail, primary nav + rooms + DMs, chat view **and** page views (Home/Contacts/Requests/Market/Contracts), 17 modal renderers, slash commands, composer panels |
| Type | **Hybrid** — chat + social pages + feed cards + 17 modals + settings + profile + rig/inventory |
| JS interactions | Yes — large delegated click handler, slash-command + panel menus, packet insertion, view switching, context menus |
| Mobile responsive | Yes — same single breakpoint at `max-width:720px` |

Key sections in document order:

1. `<style>` — same spine as chat plus: pages, filters, card grid, runcard, contact, stockrow, player plates, composer panels/emotes, tabs, rig slot rows, stat grid, inventory rows, message context menu (lines 7–328)
2. App shell markup: `.rail` (multi-server) → `.chans` (primary/rooms/DMs) → `.main` containing `.chatview` + five `.page` mounts (lines 332–392)
3. `.scrim` modal mount (line 394)
4. `<script>`: data (`CREWS`, `USERS`, `PLATES`, `LISTINGS`, `AUCTIONS`, `RUNS`, `RIG`, `INV`, `PRIMARY`/`ROOMS`/`DMS`, `E` embed factory, `MSGS`, `COMMANDS`), helpers, nav, view switch, chat, pages, modal shell + `MODALS`, rig/inventory bodies, `openByKind`, composer menus/panels, command dispatch, `send`, event delegation, boot (lines 396–1436)

The social file is a **superset** of the chat file: it reuses the same shell, tokens, message/embed/modal patterns and adds the social/page/feed/rig layers.

---

## 2. Design tokens

All tokens are CSS custom properties on `:root` plus a small set of recurring
literal values. Both files share the same palette; social adds `--gold`.

| Token | Value | Used by | Notes |
|---|---|---|---|
| `--bg-0` | `#141518` | server rail, settings nav | darkest layer |
| `--bg-1` | `#1b1d22` | channel list, modal body | layer 1 |
| `--bg-2` | `#232529` | chat surface, body bg, set cards | layer 2 / base canvas |
| `--bg-3` | `#2b2e34` | hover, embeds, cards, chips | layer 3 |
| `--bg-4` | `#34373e` | inputs, composer, embed accent bg | layer 4 (highest) |
| `--txt` | `#e3e5e8` | primary text | |
| `--txt-2` | `#9a9da3` | secondary text | |
| `--txt-3` | `#6c6f76` | tertiary / muted (hash, labels) | |
| `--accent` | `#6573e8` | active states, primary buttons, send | indigo brand accent |
| `--accent-2` | `#4853b8` | primary button hover | |
| `--ok` | `#3aa55d` | success embeds, presence-online, up | green |
| `--warn` | `#d8b13c` | warning embeds, idle presence | amber |
| `--danger` | `#d84040` | danger buttons/embeds, dnd, down | red |
| `--gold` | `#d8a83c` | donor mark, patron plate ring | **social only** |
| `--r` | `8px` | declared radius token | declared but most radii are literal (see notes) |
| font-family | `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif` | `body` | system sans; **no web font** |
| mono font | `ui-monospace, Menlo, monospace` | `.cmd b`, `.stockrow .tk`, `.slot` | social only |
| base font-size | `14px` | `body` | |
| line-height | `1.45` | `body` (1.2 on `.me__name`) | |
| font-size scale | `9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 24px` | various | 11px = uppercase labels; 22px = convstart h2; 24px = profile avatar initial |
| radius scale | `5px` (rows/btn), `6px` (msg/embed/send), `8px` (cards/sect/`--r`), `10px` (modal/composer), `14px` (rail hover/active), `50%`/`99px` (avatars/chips) | mixed | radii are mostly literal, not `--r` |
| spacing scale | padding `2,4,6,7,8,10,11,12,14,16,18,22,26`; gap `1,2,4,6,7,8,10,12,14,18`; margin `6,8,14,16,18` | all | informal 2px-step scale |
| rail width | `64px` | `.rail` | both files |
| channel sidebar width | `230px` (chat) / `240px` (social) | `.chans` | |
| settings nav width | `200px` | `.set__nav` | |
| avatar size | `38px` (default), `30/32/34px` (inline), `72px` (profile), `22/24px` (mini/member) | `.ava`, `.chan .mini` | |
| modal width | `440px` (chat) / `460px` (social); per-modal overrides `520/560px` | `.modal` | |
| wide modal | `760px`, height `min(560px, 90vh)` | `.modal--wide` | settings two-pane |
| modal max-height | `90vh`, scroll on overflow | `.modal` | |
| embed max-width | `min(100%, 420px)` (chat) / `min(100%, 440px)` (social) | `.embed` | `width:fit-content` |
| button height | `32px` (base), `26px` (`.btn--sm`) | `.btn` | |
| composer parts | plus/send `30/32px`, radius `10px` | `.composer` | |
| player plate | `150 × 46px`, radius `8px` | `.plate` | social only |
| card grid track | `repeat(auto-fill, minmax(210px, 1fr))`, gap `12px` | `.grid` | social only |
| **breakpoint** | `max-width: 720px` | media query | single breakpoint, both files |
| mobile drawer width | `260px` (chat) / `268px` (social) | `.chans` @media | |
| z-index | scrim `50`, mobile drawer `40`, popmenu `30`, ctx menu `20` | layering | social adds 30/20 |
| shadow — modal | `0 12px 40px rgba(0,0,0,.5)` | `.modal` | |
| shadow — popmenu/ctx | `0 8px 30px rgba(0,0,0,.5)` | `.popmenu`, `.ctx` | social only |
| shadow — msg more | `0 2px 8px rgba(0,0,0,.3)` | `.msg__more` | social only |
| shadow — drawer | `4px 0 24px rgba(0,0,0,.4)` | `.chans` @media | |
| overlay opacity | scrim `rgba(0,0,0,.6)`; me-card bg `.2`; msg hover `.12`; border `rgba(0,0,0,.25)`; plate small `.7` | various | |

> Note: `--r:8px` is declared but the code applies radii as literals. A later
> token pass could route radii through `--r` and a `--r-sm`/`--r-lg` pair, but
> that is a refactor, **not** part of any content pass.

---

## 3. Grid and layout system

### Root app layout

`.app { display:flex; height:100% }` — a single horizontal flexbox. `html,body`
are `height:100%; overflow:hidden`. All scroll is delegated to the feed / pages /
modal bodies, never the page.

### Columns (desktop)

- **Rail** — `width:64px; flex:none`, vertical flex column, `overflow-y:auto` (social).
- **Channel sidebar** — `width:230/240px; flex:none`, vertical flex column. Header (fixed) → list (`flex:1; overflow-y:auto`) → pinned user menu (`flex:none`).
- **Main column** — `.chat`/`.main` `flex:1; min-width:0`, vertical flex. Header (fixed) → body. In chat the body is the feed; in social the body is either `.chatview` or one of five `.page` mounts (toggled by `display`).

### Feed / composer

- `.feed { flex:1; min-height:0; overflow-y:auto }` — owns vertical scroll; `min-height:0` lets it shrink inside the flex column. Auto-scrolled to bottom after every render (`feed.scrollTop = feed.scrollHeight`).
- Composer is a **sibling** of the feed (`flex:none`), never inside the scroll area. Typing indicator sits directly above it. In social the composer is wrapped in `.compwrap` (relative) so the `.popmenu` can float above it.

### Pages / feed (social)

- `.page { flex:1; min-height:0; overflow-y:auto; padding:22px 26px; display:none }`; `.page.is-vis { display:block }`. Exactly one of `chatview` / `page-*` is visible at a time (`show(view)`).
- Card collections use `.grid` (CSS grid, `auto-fill minmax(210px,1fr)`). Lists (`.stockrow`, `.contact`, `.invrow`, `.slotrow`, `.memrow`) are simple fl/flex rows.

### Modal placement

- `.scrim { position:fixed; inset:0; display:none; align-items:center; justify-content:center; padding:20px; z-index:50 }`; `.scrim.is-vis { display:flex }`. The modal is centered; `.scrim` is the click-out target.
- `.modal` is a single card (`width:440/460px`, `max-height:90vh`, internal scroll). `.modal--wide` is a 760px two-pane row (settings).

### Mobile (`max-width:720px`)

- `.rail { display:none }`.
- `.chans` becomes a fixed left drawer: `position:fixed; inset:0 auto 0 0; transform:translateX(-100%)`; `.chans.is-open { transform:none }`. Slide transition `.2s`.
- `.chead .burger { display:block }` (hamburger toggles `.is-open`).
- `.modal--wide { flex-direction:column; height:90vh }` and `.set__nav { width:100%; flex-direction:row; flex-wrap:wrap }` (settings two-pane stacks).

### ASCII diagrams

Desktop chat shell (`pure-chat`):

```
┌──────┬──────────────┬────────────────────────────┐
│ rail │ channels     │ chat                        │
│ 64px │ 230px        │ flex:1, min-width:0         │
│      │ ┌──────────┐ │ ┌────────────────────────┐  │
│ [U]  │ │ head     │ │ │ chead (# name · topic) │  │
│  ─   │ ├──────────┤ │ ├────────────────────────┤  │
│ [+]  │ │ list     │ │ │ feed (flex:1, scroll)  │  │
│      │ │ flex:1   │ │ │                        │  │
│      │ ├──────────┤ │ ├────────────────────────┤  │
│      │ │ me menu  │ │ │ typing                 │  │
│      │ └──────────┘ │ │ composer (flex:none)   │  │
└──────┴──────────────┴────────────────────────────┘
```

Desktop social shell (`social`):

```
┌──────┬──────────────┬────────────────────────────┐
│ rail │ chans        │ main (flex:1)               │
│ 64px │ 240px        │  chead                      │
│ home │ PRIMARY      │  ┌───────────────────────┐  │
│ NS   │ ROOMS        │  │ chatview  OR  page-*  │  │
│ JN   │ DMs          │  │ (display-toggled)     │  │
│ DZ   │ ─────────    │  │ feed/pages scroll     │  │
│ [+]  │ me menu      │  │ composer (chat only)  │  │
│ ⌕    │              │  └───────────────────────┘  │
└──────┴──────────────┴────────────────────────────┘
   page mounts: home · contacts · requests · blackmarket · runs
```

Mobile chat/social shell (`max-width:720px`):

```
┌────────────────────────────┐     drawer (off-canvas, slides in):
│ ☰  chead (# name · topic)  │     ┌──────────────┐
├────────────────────────────┤     │ chans 260/268│
│ feed / page (scroll)       │     │ list + me    │  translateX(-100%)
├────────────────────────────┤     └──────────────┘  → .is-open = 0
│ typing + composer          │     rail: display:none
└────────────────────────────┘
```

Settings modal (wide, desktop → mobile):

```
desktop .modal--wide 760px            mobile (<=720px)
┌───────────┬──────────────┐          ┌──────────────────┐
│ set__nav  │ set__content │          │ set__nav (row)   │
│ 200px     │ flex:1       │   →      ├──────────────────┤
│ grouped   │ cards        │          │ set__content     │
└───────────┴──────────────┘          └──────────────────┘
```

---

## 4. Component inventory

Template per component: **classes · purpose · structure · key CSS · states/variants · JS hooks · safe extension · do-not-change.**

### Shared chat components (present in both files)

**AppShell** — `.app` · root flex row holding rail/sidebar/main · `display:flex; height:100%` · no states · JS: none (static) · Extend: nothing inside; mount new boards as siblings only if a future design pass calls for it · Do-not-change: the three-column flex contract and `overflow:hidden` on `html,body`.

**ServerRail** — `.rail` (+ `.rail__sep`) · vertical server/community strip · `width:64px; flex:none; column; gap:10px; padding:12px 0` (social adds `overflow-y:auto`) · JS: social only (`data-rail`, `data-crew-open`) · Extend: add guild buttons via markup/data · Do-not-change: 64px width, separator pattern.

**ServerRailButton** — `.rail__srv`, `.rail__srv.is-on` · circular server icon → squircle on hover/active · `44×44; border-radius:50%→14px; transition .15s`; active = `--accent` bg · States: `.is-on` · JS (social): `data-rail="home"`, `data-crew-open="<id>"` open crew modal · Extend: guild emblems/initials, tooltip `title` · Do-not-change: size, hover-radius motion, active token.

**RailSeparator** — `.rail__sep` · 28px top-border divider between home and servers · no JS · cosmetic.

**ChannelSidebar** — `.chans` (+ `.chans__head`) · left nav column; header shows server/community name · `width:230/240px; flex:none; column`; header `font-weight:700; 15px; bottom border` · JS: becomes drawer at breakpoint (`#chans.is-open`) · Extend: `.chans__head` = guild/relay name · Do-not-change: width, column structure, drawer behavior.

**ChannelList** — `.chans__list` · scrollable middle region of the sidebar · `flex:1; overflow-y:auto; column; gap:1px; padding:10px 8px` · populated by `renderChans`/`renderNav` · Extend: render arrays · Do-not-change: it owns sidebar scroll.

**ChannelGroupLabel** — `.chans__label` · uppercase section header ("Channels"/"Primary"/"Rooms"/"Direct messages") · `11px; 600; uppercase; --txt-3` · Extend: group names · cosmetic.

**ChannelRow** — `.chan` (+ `.chan .hash`, `.chan .nm`, `.chan .dot`; states `.is-on`, `.has-unread`) · a channel/room/DM row · `flex; gap; padding:6px 8px; radius:5px`; active = `--bg-3`+`--txt`; unread = bold + visible `.dot` (`--accent`) · States: `.is-on`, `.has-unread` · JS: `data-chan` (chat) / `data-room` (social) → open room · Extend: labels, unread flags, icons (`.chan .ico` social) · Do-not-change: active/unread visual grammar, dot pattern.

**ChannelMini (DM presence)** *(social)* — `.chan .mini`, `.chan .mini .st` (+ `.idle`, `.dnd`) · DM rows show a 24px avatar with a corner presence dot · presence colors map to `--ok/--warn/--danger` · Extend: courier avatars + presence · Do-not-change: presence-dot grammar.

**PinnedUserMenu** — `.me` (+ `.me__txt`, `.me__name`, `.me__status`, `.me__gear`) · current-user card pinned to sidebar bottom · `flex:none; gap:8px; padding:8px 10px; bg rgba(0,0,0,.2)` · JS: `data-profile="ned"`/`data-myprofile` open profile; `data-modal="settings"` gear · Extend: courier name/status/handle, gear target · Do-not-change: pinned-bottom placement, gear affordance.

**UserAvatar** — `.ava` · circular initial avatar · `38×38; radius:50%; centered; color:#fff`; bg set inline per user · sizes via inline style · JS: clickable (`data-profile`) · Extend: initial/color/(later) image source · Do-not-change: circle, initial fallback.

**ChatColumn** — `.chat` (chat) / `.main` + `.chatview` (social) · main vertical column / chat wrapper · `flex:1; min-width:0; column` · Do-not-change: flex/min-width:0 (prevents overflow).

**ChatHeader** — `.chead` (+ `.burger`, `.hash`, `.nm`, `.topic`) · top bar: hash + channel name + topic; burger on mobile · `flex:none; padding:11px 16px; bottom border` · JS: `#burger` toggles drawer · Extend: name/topic; (social) HUD chips could mount here later · Do-not-change: header height rhythm, burger slot.

**ConversationStart** — `.convstart` (+ `h2`, `p`) · "This is the start of #x" block at top of feed · `padding; bottom border`; `h2` 22px · cosmetic, generated in `renderFeed` · Extend: copy only.

**Feed** — `.feed` · scrolling message list · `flex:1; min-height:0; overflow-y:auto; padding:14px 16px 4px; column` · JS: auto-scroll bottom each render · Do-not-change: it owns scroll; composer must stay a sibling.

**Message** — `.msg` (+ `.ava-slot`, `.msg__col`, `.msg__head`, `.msg__who`, `.msg__time`, `.msg__body`) · full message row with avatar + author + time + body · `flex; gap:12px; padding:2px 6px; margin-top:14px`; hover bg · JS: `data-profile` on author; (social) `.msg__more`/`data-ctx` context trigger · Extend: author/time/body/embed · Do-not-change: avatar-rail + column layout, tail grouping rule.

**GroupedMessage** — `.msg.is-grp` · continuation of same author (no avatar/header) · `margin-top:0`; empty `.ava-slot` keeps alignment · Logic: grouped when previous entry is same `who` and not a system message · Do-not-change: grouping predicate.

**SystemMessage** — `.sysmsg` (+ `.ico`) · centered/muted notice line ("Welcome to #x", "You joined…") · `flex; gap:10px; --txt-2; 13px`; breaks message groups · Extend: notice copy (parcel-ready, customs notices) · Do-not-change: that system rows break grouping.

**DateDivider** — `.divider` *(defined in chat file only; not used in social)* · horizontal rule with centered label · `flex; ::before/::after borders` · Extend: date/label text · Note: social relies on `.sysmsg` instead; if dividers are needed in social, port this class rather than inventing one.

**Embed** — `.embed` (+ `--ok`, `--warn`, `--danger`; `.embed__kicker/__title/__desc/__fields/__field/__acts`) · left-accent "packet" card inside a message body · `width:fit-content; max-width:min(100%,420/440px); left-border 4px; radius:6px; padding:12px 14px` (social adds `cursor:pointer`) · States/variants: status accent via `--ok/--warn/--danger` · JS: chat uses per-button `data-embed-act`; **social makes the whole embed clickable** via `data-open-kind`/`data-open-ref` (`renderEmbed`) · Extend: this is **the** game-packet surface (see §10) — kicker/title/desc/fields/acts + new `kind`s · Do-not-change: the left-accent card shape, status-variant tokens, fit-content sizing.

**EmbedStatusVariants** — `.embed--ok` / `.embed--warn` / `.embed--danger` · recolor the 4px left border only · semantic: ok=success/invite, warn=alert/risk, danger=hostile · Do-not-change: meaning of each accent.

**EmbedField** — `.embed__fields` / `.embed__field` (`b` label + `span` value) · inline key/value row inside an embed · `flex; gap:18px; wrap` · Extend: field pairs.

**EmbedActions** — `.embed__acts` · button row inside an embed · `flex; gap:8px` · first button is `.btn--primary` · Extend: action labels (Buy/Join/Bid/Open/View…).

**Button** — `.btn` (+ `.btn--primary`, `.btn--danger`, `.btn--ghost`, social `.btn--sm`) · the only button primitive · `height:32px; padding:0 14px; radius:5px; bg --bg-4` · Variants: primary (`--accent`), danger (`--danger`), ghost (transparent), sm (26px) · Do-not-change: the variant set and heights — everything reuses them.

**TypingIndicator** — `.typing` (+ `.is-vis`) · "X is typing…" line above composer · `height:20px; padding:0 22px; 12px; visibility hidden` toggled `.is-vis` · JS: shown/hidden by `send()` canned-reply timers · Extend: NPC/courier names · Do-not-change: reserved height (prevents layout shift).

**Composer** — `.composer` (+ `.plus`, `input`, `.send`; social `.compwrap`, `.cico`) · message input row · `flex; gap:8px; bg --bg-4; radius:10px; padding:6px 8px 6px 12px` · JS: Enter / `#send` → `send()`; social adds slash menu + icon panels · Extend: placeholder text · Do-not-change: lead-slot / flex-input / trailing-send shape; composer stays outside feed scroll.

**ComposerPlusButton** — `.composer .plus` · round 30px lead action · social: `#plus` opens the Quick Create panel · Extend: action set.

**ComposerInput** — `.composer input` · flex text input · `flex:1; min-width:0; transparent` · JS: Enter to send; social `input` event drives slash menu · Extend: placeholder.

**ComposerSendButton** — `.composer .send` · 32px trailing send (`--accent`) · JS: `#send` → `send()`.

**Scrim** — `.scrim` (+ `.is-vis`) · full-screen modal backdrop + mount + click-out · `fixed inset:0; rgba(0,0,0,.6); center; z-index:50` · JS: `openModal`/`closeModal` toggle `.is-vis`; click on `#scrim` closes · Do-not-change: single global modal mount.

**Modal** — `.modal` (+ `.modal--wide`) · modal card shell · `bg --bg-1; radius:10px; width:440/460px; max-height:90vh; scroll`; wide = 760px two-pane row · Do-not-change: one-modal-at-a-time controller, shell dimensions.

**ProfileModal** — `.pf__*` group (`__banner/__ava/__body/__name/__handle/__status/__chips/__sect/__row/__acts`, `.st-dot`, `.chip`) · user profile card · banner(120deg gradient)+overlapping avatar → identity → status → chips → sections → actions · States: `.st-dot.idle/.dnd` presence · JS: action buttons (`data-room`, `data-open-kind`, `data-crew`) · Extend: identity/standing/listings/activity copy + action set · Do-not-change: section composition order (banner→identity→status→badges→fields→actions).

**SettingsModal** — `.set__*` (`__nav/__item(/--danger)/__content/__card/__close`) · two-pane settings (`.modal--wide`) · left grouped nav + right content cards · JS: `data-set-page` switches page; `data-close`/`.set__close` closes · Extend: section names + card copy · Do-not-change: two-pane pattern, mobile stack.

**DetailModal** — `.dm__*` (`__body/__kicker/__title/__acts`; social adds `__img`) · generic single-purpose detail/confirm modal · kicker → title → body card(s) → right-aligned actions · JS (chat): `openModal('detail',…)`; (social) many specialized renderers reuse these classes · Extend: kicker/title/body/action copy per kind · Do-not-change: that one shell renders many detail types.

**ResponsiveChannelDrawer** — `.chans` under `@media (max-width:720px)` + `.chhead .burger` · off-canvas sidebar · `fixed; translateX(-100%)`; `.is-open`=visible; `.2s` transition; drawer shadow · JS: `#burger` toggles `.is-open`; opening a room/nav removes it · Do-not-change: this is the entire mobile nav model.

### Social-specific components (from `userland-stoat-social.html`)

**MultiServerRail** — `.rail` with multiple `.rail__srv[data-crew-open]` + `data-rail="home"` + create/discover icons · Extend: guild list · Do-not-change: home/servers/create/discover ordering.

**PrimaryNav / Rooms / DMs** — `.chan[data-nav]` (with `.ico`), `.chan[data-room]`, DM `.chan .mini` · three labeled groups in the sidebar driven by `PRIMARY`/`ROOMS`/`DMS` · JS: `data-nav` switches page, `data-room` opens chat · Extend: nav/room/DM arrays.

**CrewTag** — `.crewtag` · small uppercase guild/crew tag chip; hover → accent · `data-crew` opens crew modal · Extend: guild tags.

**DonorMark** — `.donor` · gold supporter glyph (✦) · cosmetic-only marker (`--gold`).

**PageView** — `.page` (+ `.is-vis`, `h1`, `.sub`, `h3`) · full-screen content view (Home/Contacts/Requests/Market/Contracts) · `flex:1; overflow-y:auto; padding:22px 26px`; toggled by `show()` · Extend: page bodies via `PAGES` · Do-not-change: display-toggle view model.

**Filters** — `.filters`, `.fchip` (+ `.is-on`), `.fsort` · pill filter row + sort select · `.fchip.is-on` = `--accent` · JS (inventory): `data-invfilter` re-renders; market filters are visual-only · Extend: filter labels.

**CardGrid + Card** — `.grid`, `.card` (+ `__img/__name/__meta/__price`), `.rarity` · responsive card collection (listings, jump-back-in) · `grid auto-fill minmax(210px,1fr)`; card hover → `--bg-4` · JS: `data-open-kind`/`data-room` on card · Extend: card content + `.rarity` label · Do-not-change: grid track, card shape.

**RunCard** — `.runcard` (+ `__banner`, `__body`) · banner-topped contract/run card · gradient banner + body meta · JS: `data-open-kind="run"` opens contract modal · Extend: contract data.

**ContactRow** — `.contact` (+ `.nm`, `.meta`, `.acts`) · person row (contacts/requests/members) · `flex; gap:10px; padding:10px` · JS: `data-profile`, `data-room`, action buttons · Extend: courier rows.

**StockRow (auction row)** — `.stockrow` (+ `.tk`, `.co`), `.up`/`.down` · monospace ticker row used by the auctions section · `flex; gap:14px`; up/down color tokens · JS: `data-open-kind="auction"` · Extend: auction lots · **Do-not-change: the class name `stockrow` is retained as a structural class** even though the visible content is now Auctions.

**PlayerPlate** — `.plate` (+ `--default/level/achv/crew/event/patron/founder`, `.is-cur`), `.platewrap`, `.plate small` · cosmetic profile-plate swatches · `150×46; radius:8`; patron has gold inset ring; `.is-cur` = accent outline · Extend: plate copy/labels (cosmetic only) · Do-not-change: cosmetic-only semantics, variant set.

**ComposerPopMenu / SlashMenu** — `.compwrap`, `.popmenu` (+ `.is-vis`, `.popmenu__h`), `.cmd` (+ `.is-sel`, `b`, `.args`, `.desc`) · floating menu above composer for slash commands and Quick-Create/panels · `absolute; bottom:calc(100% + 8px); z-index:30; shadow` · JS: `renderCmdMenu`, `openPanel`, `data-cmd`, `data-pact` · Extend: `COMMANDS` + `PANELS` entries · Do-not-change: float anchor, menu mechanics.

**ComposerIconPanels** — `.composer .cico`, `.gifbtn`, `.emogrid`, `.emo` · gift/media/emote/apps icon buttons + emote grid · JS: `data-panel` opens the matching `PANELS[name]()` · Extend: panel rows / emotes.

**ProfileTabs** — `.tabs`, `.tab` (+ `.is-on`) · tab strip inside `myprofile` modal (Profile/Rig/Inventory/Listings/Badges/Settings) · JS: `data-mytab` re-opens modal on that tab · Extend: tab bodies.

**RigSlots** — `.slotrow` (+ `.slot`, `.part`, `.empty`) · rig module slot rows (CORE/LENS/PORT/BUS/SEAL/SKIN) · monospace slot code + part + actions · JS: `data-open-kind="item"`, `data-modal="inventory"` · Extend: slot/part data (`RIG`).

**StatGrid** — `.statgrid`, `.stat` (`b` value + `span` label) · rig summary stat tiles · `flex; min-width:84px; centered` · Extend: stat set.

**InventoryRows** — `.invrow` (+ `.nm`, `.note`, `.acts`) · inventory item rows with inspect/equip/sell/trade · JS: `data-open-kind` item/listing/trade, `data-invfilter` · Extend: `INV` data.

**MessageContextMenu** — `.msg__more` (hover trigger), `.ctx` (+ `button`, `button.danger`) · per-message ⋯ menu (View Profile/Message/Trade/Red Stamp/…) · `absolute; z-index:20; shadow`; toggled on click, single instance · JS: `data-ctx` builds the menu; entries carry `data-profile`/`data-room`/`data-open-kind` · Extend: menu actions · Do-not-change: single-instance toggle behavior.

**ListingSeller** — `.seller` · clickable seller row inside the listing modal · `data-profile` opens profile · Extend: seller data.

**FormField** — `.field` (+ `label`, `input/select/textarea`) · form rows in create-guild / gift / redeem modals · focus border = `--accent` · Extend: field labels/placeholders.

**TradeColumns** — `.tradecols` (+ `h4`) · two-column "you give / they give" trade layout · Extend: trade contents.

**MemberRow** — `.memrow` (+ `.role`) · roster rows in crew modal · JS: `data-profile` · Extend: roster data.

**DetailImage** — `.dm__img` · placeholder media block in detail/listing/item modals · cosmetic.

---

## 5. Interaction inventory

Both files use **one delegated `document` click handler** plus `keydown` and
composer listeners. No per-element listeners; everything routes through
`data-*` attributes and ids.

### `pure-chat.html`

| Trigger | Selector | Handler | Result | Dependencies |
|---|---|---|---|---|
| Switch channel | `[data-chan]` | click delegate | set `state.chan`, clear unread, `renderChans`+`renderFeed` | `CHANNELS`, `MSGS` |
| Toggle mobile drawer | `#burger` | click delegate | toggle `.chans.is-open` | media query |
| Open profile | `[data-profile]` | `openModal('profile')` | profile modal | `USERS` |
| Open settings | `[data-modal="settings"]` | `openModal('settings')` | settings modal | `MODALS.settings` |
| Switch settings page | `[data-set-page]` | `openModal('settings',{page})` | re-render settings | — |
| Embed action | `[data-embed-act]` | `openModal('detail',…)` | detail modal (kind derived: buy→listing, join→contract) | embed `data-*` |
| Close modal | `[data-close]`, `#scrim` | `closeModal()` | hide scrim | — |
| Send | `#send`, Enter in input | `send()` | push message; canned reply in dm/global with typing timers | `MSGS`, `.typing` |
| Escape | `keydown` | `closeModal()` | close modal | — |

### `social.html` (delegated click handler, in precedence order)

| Trigger | Selector | Handler | Result | Dependencies |
|---|---|---|---|---|
| Message ⋯ menu | `[data-ctx]` | inline | build/toggle single `.ctx` menu | — |
| Settings page | `[data-set-page]` | `openModal('settings',{page})` | switch settings pane | — |
| Close (+ maybe open room) | `[data-close]` (+ nested `[data-room]`) | `closeModal()`; then `openRoom` | close modal, optionally jump to DM | — |
| My-profile tab | `[data-mytab]` | `openModal('myprofile',{tab})` | switch profile tab | `RIG`, `INV` |
| Inventory filter | `[data-invfilter]` | re-open inventory/myprofile with filter | filter inventory | `INV` |
| Share rig | `[data-sharerig]` | `closeModal()`+`insertPacket(E.rigcard())` | insert rig packet into feed | `E.rigcard` |
| My profile | `[data-myprofile]` | `openModal('myprofile')` | open own profile | `USERS.ned` |
| Crew tag / rail server | `[data-crew]`, `[data-crew-open]` | `openModal('crew',{id})` | crew modal | `CREWS` |
| Open room (room wins over profile when nested) | `[data-room]` | `openRoom(id)` | switch to chat room | `ROOMS`/`MSGS` |
| Open profile | `[data-profile]` | `openModal('profile',{id})` | profile modal | `USERS` |
| Open modal by name | `[data-modal]` | `openModal(name)` | any modal | `MODALS` |
| Open by kind (cards/embeds) | `[data-open-kind]` (+ `-ref`) | `openByKind(kind,ref)` | maps kind→modal | `openByKind` map |
| Click-out | `#scrim` | `closeModal()` | close | — |
| Primary nav | `[data-nav]` | `show(view)` (patron→modal) | switch page | `PRIMARY`, `PAGES` |
| Home (rail) | `[data-rail]` | `show('home')` | home page | — |
| Mobile drawer | `#burger` | toggle `.chans.is-open` | drawer | media query |
| Quick Create | `#plus` | `openPanel('quick')` | composer panel | `PANELS` |
| Composer panel | `[data-panel]` | `openPanel(name)` | gift/media/emote/apps panel | `PANELS` |
| Run slash command | `[data-cmd]` | `runCommand(cmd)` | open the command's modal/view | `COMMANDS` |
| Quick-create action | `[data-pact]` | `doPact(a)` | open modal / insert packet / switch view | `doPact` map |
| Insert emote | `[data-emo]` | append to input | type emote | — |
| Send | `#send`, Enter | `send()` (slash-aware) | message or command | `MSGS` |
| Hide menus on outside click | not in `#popmenu`/`.composer` | `hideMenu()` | close menu | — |
| Escape | `keydown` | `hideMenu()`+`closeModal()` | close menu+modal | — |
| Slash typing | `input` event | `renderCmdMenu` / `hideMenu` | live command menu | `COMMANDS` |

Core JS functions (social): `renderNav`, `show`, `openRoom`, `renderFeed`,
`renderEmbed`, `PAGES.*`, `cardListing`, `openModal`/`closeModal`, `MODALS.*`,
`rigBody`/`invBody`, `openByKind`, `renderCmdMenu`/`openPanel`/`doPact`,
`runCommand`, `insertPacket`, `send`. Boot: `renderNav(); renderFeed();`.

---

## 6. Content slots and metadata fields

### Chat content model (both files)

- Server/community name (`.chans__head`)
- Channel group label, channel name, channel topic, unread flag (`CHANNELS`/`ROOMS`)
- User: display name, handle, status/presence, avatar initial + color (+ future image), level, title (`USERS`)
- Message: author ref, timestamp, body, grouped-continuation flag, system-message text
- Divider date/label (chat `.divider`; social uses system rows)
- Embed: `kind`, `ref`, kicker, title, description, fields[ ], actions[ ], status variant (`cls`)
- Profile modal: name, handle, level, title, presence, badges/chips, standing rows (reputation, guild, SEN balance), public listings, recent activity, action buttons
- Settings: grouped sections + per-card label/value
- Generic detail modal: kind label, title, body, actions

### Social feed/social model (additional)

- Crew/guild: tag, name, color, banner, members, rep, worth, public contracts, listings, roster (`CREWS`)
- Player plate (cosmetic): variant + current flag (`PLATES`)
- Listing: id, name, rarity, seller, price, escrow, type (item/player), sale history (`LISTINGS`)
- Auction lot: ticker, label, top bid, change, up/down, lots, watched, event, bid trend (`AUCTIONS`)
- Contract/run: id, title, route/node, risk, reward, customs heat, requirements, participants, convoy status, state (available/crew/active/claim), banner (`RUNS`)
- Rig: name, owner, stats[ ], slots[6] (`RIG`); Inventory items: name, type, rarity, note (`INV`)
- Activity rows (profile "recent activity")
- Preview cards (Home "jump back in")
- Tabs/filters/actions (myprofile tabs, market/inventory filters, contact actions)
- Notification/social counters: unread dot on channel rows (no numeric counters in this build)
- Slash commands (`COMMANDS`), composer panels (`PANELS`)

---

## 7. State and variant inventory

| Class | Applies to | Meaning | Visual / behavioral result |
|---|---|---|---|
| `.is-on` | `.rail__srv`, `.chan`, `.set__item`, `.fchip`, `.tab`, `.cmd` (`.is-sel`) | active/selected | accent bg or underline; squircle for rail |
| `.has-unread` | `.chan` | unread channel | bold text + visible `.dot` |
| `.is-grp` | `.msg` | grouped continuation | no avatar/header; `margin-top:0` |
| `.is-vis` | `.scrim`, `.typing`, `.popmenu` | shown | `display:flex/block` or `visibility:visible` |
| `.is-open` | `.chans` (mobile) | drawer open | `transform:none` (slid in) |
| `.is-cur` | `.plate` | current equipped plate | accent outline |
| `.modal--wide` | `.modal` | two-pane modal | 760px row → stacks on mobile |
| `.btn--primary/--danger/--ghost/--sm` | `.btn` | button intent/size | accent / red / transparent / 26px |
| `.embed--ok/--warn/--danger` | `.embed` | status accent | left-border color |
| `.st-dot.idle/.dnd`, `.mini .st.idle/.dnd` | presence | idle/dnd | warn/danger dot |
| `.up` / `.down` | `.stockrow` value | positive/negative | green/red |
| `.set__item--danger` | settings nav | destructive (log out) | red text |
| `.ctx button.danger` | context menu | destructive (Red Stamp) | red text |
| `.plate--<variant>` | `.plate` | cosmetic plate style | gradient/ring per variant |

---

## 8. CSS architecture map

Both stylesheets follow the same top-to-bottom organization (social = chat + extra layers).

| Order | Section | chat lines | social lines |
|---|---|---|---|
| 1 | Header comment + intent | 8–14 | 8–13 |
| 2 | `:root` tokens | 15–30 | 14–20 |
| 3 | Global reset + `body` + `button` | 31–35 | 21–26 |
| 4 | App shell `.app` | 38 | 26 |
| 5 | Server rail | 40–48 | 28–36 |
| 6 | Channel list / sidebar (+ social `.chan .mini`/`.ico`) | 50–64 | 38–58 |
| 7 | User menu `.me` | 66–73 | 60–65 |
| 8 | Main column + chat header | 75–84 | 67–76 |
| 9 | Chat view + feed + messages + avatar (+ social `.crewtag`/`.donor`) | 86–113 | 78–101 |
| 10 | Embeds + status variants | 115–126 | 103–114 |
| 11 | Buttons (+ social `.btn--sm`) | 129–136 | 117–125 |
| 12 | Typing + composer (+ social `.compwrap`/`.popmenu`/`.cmd`) | 138–151 | 127–151 |
| 13 | **(social) Pages / filters / grid / card / runcard / contact / stockrow** | — | 153–191 |
| 14 | Modal layer (`.scrim`/`.modal`/`--wide`) | 153–159 | 193–199 |
| 15 | Profile modal `.pf__*` (+ social `.plate*`) | 161–180 | 201–234 |
| 16 | Settings modal `.set__*` | 182–199 | 236–252 |
| 17 | Detail modal `.dm__*` (+ social `.seller`/`.field`/`.tradecols`/`.memrow`) | 201–205 | 254–274 |
| 18 | **(social) pass-3: composer icons, tabs, rig, inventory, msg context** | — | 276–317 |
| 19 | Responsive `@media (max-width:720px)` | 207–216 | 319–327 |

Conventions: BEM-ish (`block__element`, `block--modifier`); tokens for color
only (sizes/radii are literal); single breakpoint; no preprocessor, no external
CSS, no web fonts.

---

## 9. Data / component extraction recommendation

**Content is already separated from rendering inside each file's `<script>`.**
The chat file holds `USERS`/`CHANNELS`/`MSGS`; the social file holds
`CREWS`/`USERS`/`PLATES`/`LISTINGS`/`AUCTIONS`/`RUNS`/`RIG`/`INV`/`PRIMARY`/`ROOMS`/`DMS`/`E`/`MSGS`/`COMMANDS`.
Render functions consume these arrays/objects; very little content is hardcoded
in markup (the static shell, a few Home preview cards, and modal scaffolding).

Because the data structures already exist, the realistic follow-up is **not**
"extract inline content" but "**lift the shared data + render layer into a
common module**" so both files (and a future LiveView port) draw from one source:

- Shared schema: `CHANNELS`/`ROOMS`, `USERS`, `MESSAGES`, `EMBEDS` (the `E` factory), `POSTS`/`LISTINGS`/`AUCTIONS`/`RUNS`, `PROFILE`, `SETTINGS_SECTIONS`, `CREWS`, `RIG`/`INV`.
- The `E` embed factory and `MODALS`/`openByKind` map are the natural seam between data and UI.

Do **not** perform this extraction now — it is a separate, explicitly-scoped task
(see §11). This pass only documents that the seam exists.

---

## 10. Safe Userland extension points

Where Userland content/features plug in **without touching the Stoat system**:

- **Channel/room data** — `CHANNELS` (chat) / `ROOMS` + `PRIMARY` + `DMS` (social): names, topics, unread flags. (Keep internal ids; relabel display only.)
- **Message data** — `MSGS` arrays per room: courier chat, system notices.
- **Embed variants** — the `E` factory + `renderEmbed` + `openByKind` map: add/extend `kind`s for
  - marketplace/auction embeds (`E.listing`, `E.auction`)
  - card-pull embeds (`E.listing` of a foil card / a dedicated card kind)
  - manifest-risk / customs embeds (`embed--warn`/`--danger`, e.g. `E.redstamp`)
  - contract-result embeds (`E.run` of a completed contract)
  - parcel-ready notices (system messages)
  - guild-recruitment posts (`E.crewinv`)
  - convoy posts (contract/run embeds)
  - album/completion posts (card-pull + activity rows)
- **Profile modal copy/data** — `USERS` fields + `MODALS.profile`/`myprofile`: identity, standing, listings, activity, action labels.
- **Social feed post copy/data** — `MSGS`, `LISTINGS`, `AUCTIONS`, `RUNS`, `CREWS`, `PAGES.*`.
- **Settings copy** — `MODALS.settings` section/card text.
- **Cosmetic plates / patron** — `PLATES`, `MODALS.patron` (cosmetic-only, no power).

What must **not** be touched until a dedicated design pass:

- Shell layout (rail/sidebar/main flex contract, `overflow:hidden`)
- Responsive drawer logic (`@media 720px`, `.chans.is-open`, burger)
- Base component **class names** (incl. retained `.stockrow`/`.runcard`/`.crewtag`)
- Modal foundation (`.scrim`/`.modal`/`--wide`, one-at-a-time controller)
- Feed/composer mechanics (feed owns scroll; composer is a sibling; typing reserved height)
- Base spacing, widths, breakpoint
- Base color/radius/font tokens
- Social feed/page structure (`.page` display-toggle model, `.grid`/card shapes)

---

## 11. Recommended next tasks (in order)

1. **Content-only Userland pass** — per `docs/tasks/stoat-content-pass.md`: swap written/sample content to Courier Guild canon, no structure/CSS/behavior changes. *(Already completed for both experiment files in the prior pass; re-run this checklist for any new surfaces.)*
2. **Component/data extraction pass** — lift the shared data (`USERS`/`MESSAGES`/`EMBEDS`/`POSTS`/`PROFILE`/`SETTINGS_SECTIONS`/…) and the `E`/`MODALS` seam into a single reusable module powering both files and a future LiveView port. Pure refactor; no visual change.
3. **Visual skin / customization pass** — only after components and content are stable: introduce Userland tokens/skin (color, radius, type, motion) on top of the documented system, one component group at a time.

---

## Appendix — quick reference

- Breakpoint: `720px` · Rail: `64px` · Sidebar: `230/240px` · Settings nav: `200px`
- Modal: `440/460px` (wide `760px`, `min(560px,90vh)`) · Embed: `min(100%,420/440px)`
- Avatars: `38px` (chat), `72px` (profile) · Buttons: `32px` / `26px` (sm)
- z-index: scrim `50` · drawer `40` · popmenu `30` · ctx `20`
- One delegated click handler per file; all routing via `data-*` + ids; single global modal.
