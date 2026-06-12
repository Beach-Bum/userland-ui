# 07 — Event Feedback and Inventory Flow

## Principle

After every player action, the UI must show: what happened, whether it worked, and what to do next. No silent state changes. No mystery items. No ambiguous results.

## Flow Definitions

### 1. PREP a Signal Relay

| Step | Detail |
|------|--------|
| **Initial state** | Card: `available`. Glyph: `▾`. Chip: none. |
| **User action** | Tap `[PREP]` in expanded card or action bar. |
| **Server event** | `signal_relay:prep {relay_id, rig_snapshot}` |
| **Pending state** | Card: `prepping`. Dot: lime pulse. Chip: "PREPPING". Button: disabled + pulse border. Indeterminate progress bar. |
| **Success state** | Card: `ready_to_claim`. Dot: green blink. Chip: "READY" blink. Shimmer border. Button changes to `[CLAIM]`. |
| **Failure state** | Card: `failed` (3s) → `available`. Chip: "FAILED". Expanded shows reason + fix button. Button shake. |
| **Card shows** | Collapsed: dot + chip. Peek: progress + status text. Expanded: requirements pass/fail list. |
| **Board glyph** | RUNS tab dot blinks while prepping. |
| **Notification** | None (user initiated, visible on screen). |
| **Inspector opens** | No. |
| **Result stored** | Relay state updated server-side. |
| **Next action** | `[CLAIM]` (primary), `[DETAILS]` (secondary). |

### 2. START a Run

| Step | Detail |
|------|--------|
| **Initial state** | Run card: `available`. Requirements visible in expanded view. |
| **User action** | Tap `[START]` → if requirements met, run begins. If risk (heat ≥30%), confirmation sheet opens first. |
| **Server event** | `run:start {run_id, rig_id}` |
| **Pending state** | Card: `running`. Dot: lime solid. Chip: "RUNNING". Timer counts up. Progress bar fills. |
| **Success state** | Card: `ready_to_claim`. Chip: "COMPLETE". Result modal opens automatically with rewards. |
| **Failure state** | Card: `failed`. Chip: "FAILED". Reason: "Heat spike", "Connection lost", "ICE blocked". Expanded shows what happened + `[RETRY]` if applicable. |
| **Card shows** | Collapsed: timer + dot. Peek: %, ETA, abort button. Expanded: stats, reward preview. |
| **Board glyph** | RUNS tab dot solid lime while running. NOW tab dot blinks if reward ready. |
| **Notification** | Push notification when complete (if app backgrounded). |
| **Inspector opens** | No (result modal opens instead). |
| **Result stored** | Run result + items stored server-side. Items added to inventory. |
| **Next action** | `[CLAIM ALL]` in result modal. |

### 3. CLAIM a Run Reward

| Step | Detail |
|------|--------|
| **Initial state** | Run card: `ready_to_claim`. Shimmer border. `[CLAIM]` button visible. |
| **User action** | Tap `[CLAIM]` or `[CLAIM ALL]` in result modal. |
| **Server event** | `run:claim_reward {run_id}` |
| **Pending state** | Button: pending (pulse). Brief — usually <500ms. |
| **Success state** | Result modal: SUCCESS banner. Items listed with rarity + "Added to Inventory". SEN/heat summary. Card: `claimed` with ✓. |
| **Failure state** | Rare — server error. Button shake + "Try again" text. Card stays `ready_to_claim`. |
| **Card shows** | Claimed state: ✓ chip, dim. No more actions. |
| **Board glyph** | RUNS tab dot → idle. SOUL tab may blink if achievement progress. |
| **Notification** | None (user initiated). |
| **Inspector opens** | `[INSPECT]` button available per item in result modal. |
| **Result stored** | Items → inventory. SEN → wallet. Heat → heat meter. Achievement progress updated. |
| **Next action** | Per item: `[INSPECT]`, `[INSTALL]`, `[SELL]`. Global: `[DONE]`. |

### 4. OPEN a Cache

| Step | Detail |
|------|--------|
| **Initial state** | Cache item in inventory. Card: `available`. Chip shows rarity of cache. |
| **User action** | Tap `[OPEN]` in expanded cache card or item inspector. |
| **Server event** | `cache:open {cache_id}` |
| **Pending state** | Button: pending. Brief. |
| **Success state** | Cache reveal modal (dark sheet). 3D stage: cache model → glow → item reveal animation. Contents listed: items + rarity + stats. "Added to Inventory" per item. |
| **Failure state** | Very rare — server error only. |
| **Card shows** | Cache card removed from inventory (destroyed). New item cards appear in inventory list. |
| **Board glyph** | SOUL tab may blink (new inventory). |
| **Notification** | None. |
| **Inspector opens** | `[INSPECT]` per revealed item in result modal. |
| **Result stored** | Cache → destroyed. Contents → inventory. |
| **Next action** | Per item: `[INSPECT]`, `[INSTALL]`, `[SELL]`. |

### 5. INSTALL a Rig Part

| Step | Detail |
|------|--------|
| **Initial state** | Item in inventory. Target slot visible in SOUL rig view. |
| **User action** | Tap `[INSTALL]` in item inspector or expanded card. If slot occupied → compare modal opens. If slot empty → confirmation with stat preview. |
| **Server event** | `rig:install {item_id, slot}` or `rig:swap {item_id, slot}` |
| **Pending state** | Button: pending. Brief. |
| **Success state** | Compare modal (if swap): shows old → new. Confirmation: "Installed to {SLOT}". Card updates to show equipped state. Old item (if swap) → "Moved to Inventory". |
| **Failure state** | "Wrong slot", "Item locked", "Slot damaged". Shown in modal. |
| **Card shows** | Item card in rig: location → "Installed in {SLOT}". Category color accent on rig slot. |
| **Board glyph** | SOUL rig slot updates. NOW rig summary updates if visible. |
| **Notification** | None. |
| **Inspector opens** | Can re-inspect from rig slot view. |
| **Result stored** | Item location → rig. Old item location → inventory (if swap). Rig stats recalculated server-side. |
| **Next action** | `[INSPECT]` (rig slot), `[SWAP]` (replace), `[UNINSTALL]`. |

### 6. SELL an Item

| Step | Detail |
|------|--------|
| **Initial state** | Item in inventory. |
| **User action** | Tap `[SELL]` in item inspector → price input or auto-price sheet. |
| **Server event** | `market:sell {item_id, price}` |
| **Pending state** | Button: pending. Brief. |
| **Success state** | "Listed on Market for {price} SEN". Item location → market. Card appears in MARKET > My Listings. |
| **Failure state** | "Market full", "Item locked". Shown inline. |
| **Card shows** | Item card in inventory: removed. Item card in MARKET: listed with price. |
| **Board glyph** | MARKET tab may show activity dot. |
| **Notification** | Push when item sells (someone buys). |
| **Inspector opens** | Can inspect from MARKET listing. |
| **Result stored** | Item location → market. Listing created server-side. |
| **Next action** | `[DELIST]`, `[CHANGE PRICE]` from MARKET listing. |

### 7. ACCEPT a Market Offer

| Step | Detail |
|------|--------|
| **Initial state** | Market listing with incoming bid/offer. Notification badge on MARKET tab. |
| **User action** | Tap listing → expand → see offer → `[ACCEPT]`. |
| **Server event** | `market:accept {listing_id, offer_id}` |
| **Pending state** | Button: pending. |
| **Success state** | "Sold for {price} SEN". SEN added to wallet. Item removed from My Listings. Buyer gets item. |
| **Failure state** | "Offer expired", "Buyer insufficient funds". |
| **Card shows** | Listing: removed. Wallet: updated SEN. |
| **Board glyph** | MARKET tab dot clears. |
| **Notification** | "Item sold!" confirmation. |
| **Inspector opens** | No (item no longer owned). |
| **Result stored** | Item → buyer inventory. SEN → seller wallet. |
| **Next action** | None (transaction complete). |

### 8. RECEIVE a Social/Trade Response

| Step | Detail |
|------|--------|
| **Initial state** | Outgoing trade offer in NET chat. Card: `syncing`. |
| **User action** | None — server push event. |
| **Server event** | `trade:response {trade_id, accepted|declined|countered}` |
| **Pending state** | N/A (incoming). |
| **Success state** | If accepted: "Trade complete" banner in chat. Items swapped. Result: "{item} received → Inventory". |
| **Failure state** | If declined: "Trade declined by {player}". Items returned. If countered: counter-offer card in chat. |
| **Card shows** | Chat: trade result card inline. |
| **Board glyph** | NET tab dot blinks. |
| **Notification** | Push: "Trade accepted/declined by {player}". |
| **Inspector opens** | `[INSPECT]` on received item if accepted. |
| **Result stored** | Items swapped server-side. Chat log updated. |
| **Next action** | `[INSPECT]` received item, or `[COUNTER]` if counter-offer. |

### 9. FAIL a Run

| Step | Detail |
|------|--------|
| **Initial state** | Run card: `running`. Timer active. Progress bar filling. |
| **User action** | None — server push (or player `[ABORT]`). |
| **Server event** | `run:failed {run_id, reason}` or `run:abort {run_id}` |
| **Pending state** | N/A. |
| **Success state** | N/A (this IS the failure). |
| **Failure state** | Card: `failed`. Chip: "FAILED". Dot: red. Glyph: `✕`. Progress bar: red fill at failure point. Expanded: reason text + consequence. |
| **Card shows** | Collapsed: "FAILED" chip + red dot. Expanded: "ICE BLOCKED — your CORE couldn't bypass the GIL firewall. Heat +12. No reward." |
| **Board glyph** | RUNS tab dot red briefly (3s) → idle. |
| **Notification** | Push if app backgrounded: "Run failed: {reason}". |
| **Inspector opens** | No. |
| **Result stored** | Run result → failed. Heat added. No items. Achievement "attempts" counter incremented. |
| **Next action** | `[RETRY]` (if requirements still met), `[UPGRADE RIG]` (link to rig), `[COOL DOWN]` (if heat caused it). |

### 10. UNLOCK a Lore Entry

| Step | Detail |
|------|--------|
| **Initial state** | Lore is hidden — locked icon on MAP node or SOUL archive. |
| **User action** | Triggered by: discovering a MAP node, completing a run, achieving a milestone. Not a direct button tap. |
| **Server event** | `lore:unlock {lore_id}` (side effect of another action). |
| **Pending state** | N/A (side effect). |
| **Success state** | Inline notification: "Lore unlocked: {title}". SOUL tab blinks. SOUL > Archive shows new entry with "NEW" badge. |
| **Failure state** | N/A (lore unlock doesn't fail). |
| **Card shows** | In result modal of triggering action: "Lore unlocked" row. In SOUL archive: new card with "NEW" badge, tappable to read. |
| **Board glyph** | SOUL tab dot blinks. |
| **Notification** | Subtle inline toast: "📖 Lore: {title}". Not a modal. |
| **Inspector opens** | No (lore is text, not an item). Tap opens lore card expanded. |
| **Result stored** | Lore entry unlocked in player profile. |
| **Next action** | `[READ]` in SOUL archive. |

## Notification Priority

| Priority | Type | Visual | Duration |
|----------|------|--------|----------|
| 1 (highest) | MIL threat / heat critical | Red banner top of screen | Until dismissed |
| 2 | Reward ready to claim | Green shimmer on card + tab dot | Until claimed |
| 3 | Run complete | Tab dot blink + result modal | Until claimed |
| 4 | Trade response | Tab dot blink + chat card | Until read |
| 5 | Lore unlock | Inline toast | 5s auto-dismiss |
| 6 (lowest) | Market activity | Tab dot | Until viewed |

## Inventory Flow Summary

```
CLAIM/OPEN/BUY/TRADE → Item appears in Inventory
                        ↓
                  [INSPECT] → Item Inspector (3D + details)
                        ↓
              [INSTALL] → Compare modal → Rig slot
              [SELL]    → Price sheet → Market listing
              [TRADE]   → Chat offer → NET
              [DISCARD] → Confirm modal → Destroyed
```

Every transition is server-authoritative. The client shows optimistic UI but must confirm with server push.
