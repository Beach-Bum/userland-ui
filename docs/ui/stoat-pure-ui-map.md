# Stoat Pure UI Map — neutral chat skeleton pass

Goal of this pass: a Stoat/Discord-like chat skeleton with ZERO Userland/Bento identity,
to prove Userland game systems can live inside a normal chat app before any skinning.
Prototype: `experiments/userland-stoat-pure-chat.html`.

## 1. Stoat files inspected (stoatchat/for-web, packages/client)
- `src/Interface.tsx` — app shell: column → row(Sidebar | Content)
- `src/index.tsx` 158–186 — route tree (`/channel/:id`, `/friends`, fallback home)
- `src/interface/Sidebar.tsx`, `src/interface/navigation/servers/ServerList.tsx`,
  `navigation/channels/HomeSidebar.tsx` / `ServerSidebar.tsx`, `servers/UserMenu.tsx`
- `src/interface/channels/ChannelPage.tsx`, `ChannelHeader.tsx`, `text/TextChannel.tsx`
- `components/app/interface/channels/text/Messages.tsx` (tail/grouping algo, dividers),
  `Message.tsx`, `elements/Container.tsx` (row layout, tail variant)
- `elements/TextEmbed.tsx`, `Embed.tsx`, `Invite.tsx` (actionable embed), `SystemMessage.tsx`
- `composition/MessageBox.tsx` (actionsStart / editor / actionsEnd), `TypingIndicator.tsx`
- `components/modal/index.tsx` (ModalController stack), `modals/UserProfile.tsx`,
  `modals/Settings.tsx`, `settings/_layout/Sidebar.tsx`
- `features/profiles/*` — Profile.Banner/Status/Badges/Bio/Joined/Actions/Mutuals
- `components/ui/components/design/Unreads.tsx` (corner dot/counter on nav rows)

## 2. Structure copied conceptually
- Shell: server rail → channel list → chat column (header / feed / typing / composer),
  user/account card pinned at the bottom of the channel list (UserMenu).
- Rooms as a flat channel list with # rows, active = filled row, unread = dot/bold.
- Feed: top-down chronological, conversation-start block, message rows with avatar rail;
  tail grouping = same author + <7 min + no system message between.
- Embeds: fit-content card with left accent border inside the author's text column;
  Invite.tsx pattern = embed with action buttons in the feed.
- Composer: plus slot / flex input / send; typing indicator line above.
- One ModalController: `openModal({type})` → type-switched single-purpose renderers.
- Profile modal composition order: Banner(avatar overlap) → identity → status →
  badges → bio/fields → mutuals → actions row.
- Settings modal: left nav list (grouped sections) + right content pane.
- Mobile: panes collapse — rail+channels slide away, chat is full-width (hamburger).

## 3. Visual identity intentionally ignored
- Stoat MD3 tokens, purple branding, icons, fonts, logos — replaced with neutral
  dark grays + one indigo-ish accent + system sans (-apple-system stack).
- Also banned for this pass (per directive): bone/ink, Gamja Flower, Space Mono as UI
  font, Bento keylines/cards, pill buttons, pixel glyphs, HUD strip, phone shell,
  packet styling, cyber/terminal anything.

## 4. Reusable modal patterns found
- ModalController stack with typed modals: one shell, many small renderers
  (UserProfile, Settings, ChannelInfo, ImageViewer, Invite, confirmations…).
- Two modal shapes cover everything: (a) card modal (profile/detail/confirm),
  (b) full-screen two-pane modal (settings). Confirm dialogs are just small cards.

## 5. Mapping to Userland later
- Rooms global/crew/dm/market/runs/system → later become board filters/streams.
- Embed cards (market listing, run invite, stock alert) → GamePackets after skinning.
- Profile modal placeholders (banner, title, rep, badges, crew, net worth, listings,
  message/trade/hack actions) → SOUL/player plate.
- Settings modal → account/cosmetics/donor surface.
- One modal shell → ItemSheet/RunSheet/MarketSheet/TradeOffer/HackConfirm all reuse it.
- Unread dot on channel rows → BoardGlyph once skinned.
