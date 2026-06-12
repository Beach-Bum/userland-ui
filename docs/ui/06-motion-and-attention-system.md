# 06 — Motion and Attention System

## Principle

Animation is a state signal, not decoration. Every motion communicates exactly one thing. The total motion budget per screen is strictly limited to prevent visual noise.

## Motion Budget

The budget ensures consistency without being overly restrictive. The key rule: animations must communicate state, and their visual grammar (timing, easing, stroke weight) must be uniform.

| Rule | Limit | Rationale |
|------|-------|-----------|
| Max strong shimmer (ready) per screen | 2 | Ready items can compete for attention |
| Max rarity shimmer (MYTH) per screen | 1 | MYTH is singular — only one shimmers, others show static gradient |
| Max rarity pulse (MIL) per screen | 2 | MIL threat must always be visible |
| Max quiet active glyphs per screen | 5 | Running/prepping/cooling items show dots |
| Max progress bars animating | 3 | Active processes |
| Idle cards animate | Never | No motion = nothing happening |
| Blocked cards shimmer | Never | Blocked means stopped |
| Background decoration motion | Never | No ambient particles, waves, pulses |

**Consistency rule**: All animations share the same visual grammar — 1.5px stroke weight on borders/outlines, consistent easing curves, matching pulse frequencies for same-priority signals. The system stays coherent because every animation looks like it belongs to the same family, not because animations are rare.

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

### 9. MIL Threat Pulse (full card)

**Purpose**: Signal that an item is dangerous. MIL items carry real risk (heat, corp attention). The entire card must communicate this.
**Allowed on**: The entire card border + rarity badge. MIL gets its own unique animation, distinct from ready shimmer.
**Visual**: Card border: 1.5px red, pulses opacity AND a red box-shadow glow (0 → 6px → 0). Rarity badge text pulses in sync. The glow is red, not violet.
**Duration**: 3s cycle.
**Easing**: `ease-in-out`.
**Loop**: Yes, while MIL item is visible.
**Intensity**: Medium — full card border, unmistakable. Feels like a warning light, not decoration.
**Reduced-motion**: Static red border, no pulse, no glow.

```css
@keyframes mil-threat {
  0%, 100% { box-shadow: 0 0 0 rgba(242,71,46,0); border-color: rgba(242,71,46,.5); }
  50% { box-shadow: 0 0 6px rgba(242,71,46,.35); border-color: rgba(242,71,46,1); }
}
.k-card.rar-mil {
  border: 1.5px solid var(--clr-rar-mil);
  animation: mil-threat 3s ease-in-out infinite;
}
```

### 10. MYTH Shimmer (full card)

**Purpose**: Signal maximum rarity. MYTH is the rarest tier — the entire card surface shimmers with a multi-gradient sweep. This is the most visually premium moment in the UI.
**Allowed on**: The entire card background. MYTH is the only rarity that takes over the full card surface.
**Visual**: Card background is the MYTH gradient (lime → yellow → sky → violet → pink → lime). The gradient `background-position` shifts continuously, creating a slow color sweep across the surface. Card text uses ink color for contrast.
**Duration**: 6s cycle.
**Easing**: `linear`.
**Loop**: Yes.
**Intensity**: High — full-card shimmer, unmistakable. Max 1 MYTH shimmer on screen.
**Reduced-motion**: Static gradient snapshot (no animation), "MYTH" label visible.

```css
@keyframes myth-shimmer {
  0% { background-position: 0% 50%; }
  100% { background-position: 200% 50%; }
}
.k-card.rar-myth {
  background: linear-gradient(
    135deg,
    #CDF263 0%, #F2DF4E 16%, #79A8E6 33%,
    #B5A8F2 50%, #F2CCE3 66%, #CDF263 83%, #F2DF4E 100%
  );
  background-size: 300% 100%;
  animation: myth-shimmer 6s linear infinite;
  color: var(--ink);
}
```

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

1. **MYTH shimmer** (highest visual): full-card gradient shimmer (max 1)
2. **MIL threat** (highest priority): full-card red border pulse (max 2)
3. **Ready to claim**: green border shimmer (max 2)
3. **Running**: lime dot + progress bar
4. **Prepping**: lime pulse dot
5. **Idle**: no motion (lowest)

If a MIL item is present and a ready item exists, both animate. This is the one exception to the "max 1 shimmer" rule — MIL threat pulse is a safety signal.
