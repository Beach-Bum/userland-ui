# 06 — Motion and Attention System

## Principle

Animation is a state signal, not decoration. Every motion communicates exactly one thing. The total motion budget per screen is strictly limited to prevent visual noise.

## Motion Budget

| Rule | Limit | Rationale |
|------|-------|-----------|
| Max strong shimmer per screen | 1 | Only the highest-priority ready item |
| Max quiet active glyphs per screen | 3 | Running/prepping items show dots |
| Max progress bars animating | 2 | Active processes only |
| Idle cards animate | Never | No motion = nothing happening |
| Blocked cards shimmer | Never | Blocked means stopped |
| Background decoration motion | Never | No ambient particles, waves, pulses |

If more than 1 item is `ready_to_claim`, only the most recent one shimmers. Others show a static green dot.

## Motion Types

### 1. Board Activity Glyph Blink

**Purpose**: Show that a board has active content requiring attention.
**Allowed on**: Tab bar board icons, desktop nav pills.
**Visual**: State dot blinks (opacity 1 → 0.3 → 1) next to board name.
**Duration**: 2s cycle.
**Easing**: `ease-in-out`.
**Loop**: Yes, while board has active/ready items.
**Intensity**: Subtle — 6px dot, no glow.
**Reduced-motion**: Static dot, no blink.

```css
@keyframes glyph-blink {
  0%, 100% { opacity: 1 }
  50% { opacity: 0.3 }
}
.board-dot.has-activity { animation: glyph-blink 2s ease-in-out infinite; }
```

### 2. Ready Shimmer

**Purpose**: Signal that an object is ready to claim/act on.
**Allowed on**: Card border (the `ready_to_claim` card).
**Visual**: 1.5px green border pulses glow (0 → 8px box-shadow → 0).
**Duration**: 2.5s cycle.
**Easing**: `ease-in-out`.
**Loop**: Yes, while state is `ready_to_claim`.
**Intensity**: Medium — visible but not aggressive.
**Reduced-motion**: Static green border, no pulse.

```css
@keyframes ready-shimmer {
  0%, 100% { box-shadow: 0 0 0 rgba(79,214,69,0); }
  50% { box-shadow: 0 0 8px rgba(79,214,69,.35); }
}
.is-ready {
  border: 1.5px solid var(--clr-state-ready);
  animation: ready-shimmer 2.5s ease-in-out infinite;
}
```

### 3. Progress Fill

**Purpose**: Show a process advancing toward completion.
**Allowed on**: Progress bar inside peek/expanded/modal.
**Visual**: Bar width animates from 0% to target %.
**Duration**: Matches real server-reported progress. Initial fill: 0.6s ease-out.
**Easing**: `ease-out` for initial, `linear` for real-time updates.
**Loop**: No — one-shot per update.
**Intensity**: Low — 4px bar, no glow.
**Reduced-motion**: Instant width set, no animation.

```css
.k-progress i {
  transition: width 0.6s ease-out;
}
@media (prefers-reduced-motion: reduce) {
  .k-progress i { transition: none; }
}
```

### 4. Item Reveal Drop

**Purpose**: Announce a new item received from claim/cache/reward.
**Allowed on**: 3D stage in result modal only.
**Visual**: Stage bg dark → violet glow border (0.5s) → object scale 90%→100% + opacity 0→1 (0.4s).
**Duration**: 0.9s total.
**Easing**: `cubic-bezier(.4,0,.15,1)`.
**Loop**: No — one-shot.
**Intensity**: High — this is the premium moment.
**Reduced-motion**: Instant appear with static glow border.

```css
@keyframes item-reveal {
  0% { opacity: 0; transform: scale(.9); }
  100% { opacity: 1; transform: scale(1); }
}
@keyframes glow-in {
  0% { box-shadow: none; border-color: transparent; }
  100% { box-shadow: 0 0 20px rgba(181,168,242,.3); border-color: var(--clr-reveal); }
}
```

### 5. 3D Object Rotate

**Purpose**: Show the item has depth/is interactive.
**Allowed on**: 3D stage in item inspector and result modal.
**Visual**: Slow Y-axis rotation, 360° per 20s.
**Duration**: 20s.
**Easing**: `linear`.
**Loop**: Yes, while inspector is open.
**Intensity**: Very low — ambient, not attention-seeking.
**Reduced-motion**: Static, no rotation.

### 6. Failed Shake

**Purpose**: Communicate that an action was rejected.
**Allowed on**: The CTA button that was pressed.
**Visual**: Horizontal shake (±4px, 3 cycles).
**Duration**: 0.4s.
**Easing**: `ease-in-out` per cycle.
**Loop**: No — one-shot.
**Intensity**: Medium — noticeable but brief.
**Reduced-motion**: Button turns red border briefly (0.3s), no movement.

```css
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-4px); }
  75% { transform: translateX(4px); }
}
.act-failed { animation: shake 0.4s ease-in-out; }
```

### 7. Success Settle

**Purpose**: Confirm an action succeeded.
**Allowed on**: The CTA button or result banner.
**Visual**: Button bg → green, label → "✓", hold 1.5s, then revert or close.
**Duration**: 1.5s hold.
**Easing**: Instant color change, `ease-out` revert.
**Loop**: No.
**Intensity**: Low — calm confirmation.
**Reduced-motion**: Same (color change is not motion).

### 8. Sync Scan

**Purpose**: Show the client is waiting for server response.
**Allowed on**: Progress bar, state dot.
**Visual**: Indeterminate bar — a short highlight slides left-to-right across the bar.
**Duration**: 1.5s per pass.
**Easing**: `ease-in-out`.
**Loop**: Yes, while syncing.
**Intensity**: Low.
**Reduced-motion**: Static bar at 50% opacity with "SYNCING" label.

```css
@keyframes scan {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(200%); }
}
.progress-scan i::after {
  animation: scan 1.5s ease-in-out infinite;
}
```

### 9. Rarity Pulse (MIL only)

**Purpose**: Signal that an item is dangerous (MIL rarity).
**Allowed on**: Rarity badge border on MIL items.
**Visual**: Red border pulses (opacity 0.5 → 1 → 0.5).
**Duration**: 3s.
**Easing**: `ease-in-out`.
**Loop**: Yes, while MIL item is visible.
**Intensity**: Subtle — badge only, not entire card.
**Reduced-motion**: Static red border, no pulse.

### 10. MYTH Shimmer (MYTH rarity)

**Purpose**: Signal maximum rarity.
**Allowed on**: Rarity badge on MYTH items.
**Visual**: Multi-color gradient shifts across the badge text.
**Duration**: 4s.
**Easing**: `linear`.
**Loop**: Yes.
**Intensity**: Medium — the only multi-color element in the system.
**Reduced-motion**: Static violet text with "MYTH" label.

## Category → Motion Mapping (Detail/Decode Views)

When items are revealed or inspected in the 3D stage, their category determines the entry animation:

| Category | Motion name | Visual | Duration |
|----------|-------------|--------|----------|
| CORE | bloom | Scale 0→1 from center | 0.5s |
| LENS | sweep | Horizontal wipe reveal | 0.6s |
| PORT | handshake | Two halves slide together | 0.5s |
| BUS | route | Trace path from left to right | 0.7s |
| ICE | blade | Sharp diagonal reveal | 0.4s |
| SKIN | shimmer | Surface color wash | 0.8s |
| CACHE | seal-crack | Split down center, open | 0.6s |
| DATA | glitch | Pixel scatter → assemble | 0.5s |

These are **only used in detail/decode views** (item inspector, reward reveal). List views use the standard item-reveal-drop.

## Attention Priority

When multiple items compete for attention on one screen:

1. **MIL threat** (highest): red pulse on rarity badge
2. **Ready to claim**: green border shimmer
3. **Running**: lime dot + progress bar
4. **Prepping**: lime pulse dot
5. **Idle**: no motion (lowest)

If a MIL item is present and a ready item exists, both animate. This is the one exception to the "max 1 shimmer" rule — MIL threat pulse is a safety signal.
