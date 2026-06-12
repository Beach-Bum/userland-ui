# Stoat Web Client — Structure Map for Userland

Source: `stoatchat/for-web` (audited at /tmp/stoat-for-web, package `packages/client`).
SolidJS + solid-router + panda/styled-system. Used as **app-structure reference only** —
no Stoat branding, assets, protocol, or code is copied. Target: Phoenix/LiveView.

## 1. App shell
- **Path**: `src/Interface.tsx` (`Interface`, `Layout`, `Content`)
- Column: `Titlebar` → `Layout` (row: `Sidebar` + `Content{children}`) → `NotificationsWorker`.
  Auth gate redirects to /login; disconnected state recolors the shell.
- **Copy structurally**: one shell component that owns chrome (HUD, nav, notification worker)
  and slots the active screen as children. LiveView: `AppShell` layout component wrapping
  the stream; connection state on the shell, not per-screen.
- **Ignore**: desktop Titlebar, sidebar-on-left desktop split, MD3 color tokens.

## 2. Route structure
- **Path**: `src/index.tsx` lines 158–186; helpers in `components/routing/index.tsx`.
- `/` → Interface shell, nested: `/friends`, `/server/:server/*` → `/channel/:channel/*` →
  `ChannelPage`, fallback `HomePage`. Channel id in URL = which stream you look at.
- **Copy structurally**: ONE stream screen parameterized by filter:
  `/os/stream` (+ `?board=now|map|runs|soul|market|net` or live patch). Boards are params
  over the same LiveView, not separate live routes.
- **Ignore**: servers/invites/bots/discover/settings routes.

## 3. Channel screen
- **Path**: `src/interface/channels/ChannelPage.tsx` → `text/TextChannel.tsx`
- Column: `ChannelHeader` → `Messages` (flex-1, owns scroll) → `NewMessages` bar →
  `MessageComposition`. Optional `MemberSidebar` to the side.
- **Copy structurally**: exact vertical order for Userland screen:
  TopHUD → FeedFilterTabs → PinnedAction → ChatFeed → Composer. Feed owns scroll;
  composer is a sibling, never inside the scroll.
- **Ignore**: member sidebar, search sidebar, voice call card, age gate.

## 4. Message list rendering
- **Path**: `components/app/interface/channels/text/Messages.tsx` (`Messages`, 1043 ln)
- One memo turns the raw message array into render entries: messages + date dividers +
  unread divider + blocked-count dividers; object cache keyed `id:tail` prevents re-render.
- **Copy structurally**: single STREAM array → derived visible list (filter + grouping +
  dividers) computed in one place, not in templates. LiveView: assign `:entries` derived
  from packets; `phx-update="stream"` later.
- **Ignore**: virtualization details, blocked-message collapsing, fetch paging.

## 5. Composer / input
- **Paths**: `src/interface/channels/text/Composition.tsx` (wiring),
  `components/ui/components/features/messaging/composition/MessageBox.tsx` (component)
- Row: `actionsStart` slot → flex editor (`content`, `onSendMessage`, `onTyping`,
  `onEditLastMessage`) → `actionsEnd` slot. `FileCarousel` + `MessageReplyPreview` +
  `TypingIndicator` mount ABOVE the box.
- **Copy structurally**: ActionComposer = lead slot / flex input / trailing send; the
  typing-indicator line lives directly above the composer. Event: `message:send`.
- **Ignore**: file uploads, emoji picker, prosemirror editor.

## 6. Message grouping
- **Path**: `Messages.tsx` lines 725–790 ("Determine which messages have a tail")
- `tail=true` (header+avatar dropped on NEXT message) unless: author changed, gap ≥ 420 s,
  masquerade changed, either is a system message, message has replies, or unread divider
  intervenes. Date change inserts a divider. `Message.tsx`/`Container.tsx` render
  tail variant with no avatar/header, tighter padding.
- **Copy structurally**: MessageGroup = consecutive same-sender bubbles inside the window
  drop avatar+header; system packets always break groups; date/system dividers as syslines.
- **Ignore**: masquerade, replies machinery.

## 7. Embeds / card-like message components
- **Paths**: `components/ui/components/features/messaging/elements/` —
  `Embed.tsx` (type switch), `TextEmbed.tsx` (card), `Attachment.tsx`, `Invite.tsx`,
  `SystemMessage.tsx`, `MessageReply.tsx`
- `TextEmbed` Base: `width:fit-content; maxWidth:min(100%,420px); borderInlineStart:
  solid accent; padding gap-md; radius md` → icon row → title → description → media.
  `Embed` is a `<Switch>` over embed types. `Invite.tsx` = an ACTIONABLE embed with a
  join button inside the feed — exactly a game packet.
- **Copy structurally**: GamePacketEmbed = left-accent card, type-switched renderer
  (`SystemPacket|RunPacket|ItemPacket|MarketPacket|CrewPacket|LorePacket|WarningPacket|
  ResultPacket`), actions inline like Invite's join. PacketActions inside the embed.
- **Ignore**: website/video/GIF embeds, proxied media.

## 8. Modals / sheets / dialogs
- **Path**: `components/modal/index.tsx` (`ModalController`), `components/modal/modals/*`
- Global controller: `openModal({type, ...props})`, stack of `ActiveModal{id,show,props}`,
  `RenderModal` switches on type. Each modal is one small single-purpose file.
- **Copy structurally**: one DetailSheet controller (`openSheet(type, props)`) with
  single-purpose sheet renderers: ItemSheet, RunSheet, MarketSheet, LoreSheet, ProfileSheet.
  LiveView: one `live_component` + `:sheet` assign. Never nested.
- **Ignore**: the 50+ admin modals, MFA flows, modal stacking (we allow exactly one).

## 9. Notification / unread state
- **Paths**: `components/ui/components/design/Unreads.tsx`,
  `components/ui/components/features/messaging/bars/` (`NewMessages.tsx`,
  `JumpToBottom.tsx`), `components/client/NotificationsWorker.tsx`
- Unread = tiny corner dot/counter on the NAV row graphic only; `NewMessages` is a thin
  jump bar above the feed; worker lives on the shell.
- **Copy structurally**: BoardGlyph on filter tabs only (· ∴ ✦ ⌁ ▴ ■), never restyling
  the feed; clearing on tab focus. Optional later: thin "new packets ↓" jump bar.
- **Ignore**: push notifications, sounds, per-channel notification settings.

## 10. Presence / member / friend surfaces
- **Paths**: `src/interface/channels/text/MemberSidebar.tsx` (online filter, `UserStatus`
  dot, "N members online"), `src/interface/Friends.tsx`, `modals/UserProfile.tsx`
- Presence = status dot + grouping by online; profile opens as modal from any avatar.
- **Copy structurally**: NET filter is the social surface; tapping a name/avatar opens
  ProfileSheet (later). Presence dot on avatars only.
- **Ignore**: friends list screens, mutuals, roles, member management.

## Userland translation table

| Stoat | Userland (prototype → LiveView) |
|---|---|
| `Interface` shell | AppShell (`live.html.heex` + shell component) |
| route `/channel/:id` | one stream LV, `board` param = filter |
| `ChannelHeader` | TopHUD (SEN/HEAT/RIG/AURA + identity) |
| `Sidebar` server/channel list | FeedFilterTabs (NOW MAP RUNS SOUL MARKET NET) |
| `Messages` + tail memo | ChatFeed + MessageGroup derivation |
| `Message`/`Container` | MessageBubble (tail variant = grouped) |
| `Embed`/`TextEmbed`/`Invite` | GamePacketEmbed + PacketActions (collapsed→peek→sheet→resolved) |
| `MessageBox` slots | Composer (lead / input / send) |
| `ModalController` | DetailSheet controller (one sheet, single purpose) |
| `Unreads` corner dot | BoardGlyph on tabs |
| `TypingIndicator` | "… is typing" line above composer (NPC replies) |
| `MemberSidebar` presence | ProfileSheet later; presence dots only |
