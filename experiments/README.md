# experiments/

One-off design experiments. **Not canon** — nothing here is part of the
approved deck design system (`deck.css` / `DESIGN-ASCII.md` rails) unless it
is promoted out of this folder by Bob.

| File | What it is |
| --- | --- |
| `gear-holo-3d.html` | 3D test of the gear-library items: each item's ASCII art is voxelized (frame + solid blocks get depth) and rotated as glyphs inside the standard 8×14 terminal cell grid — no canvas, no WebGL, no images. Front-on it reproduces the art character-for-character; at angles it decodes into block shading. Drag to rotate, AUTO to spin, PREV/NEXT/CAT to browse all 96 items. Respects `prefers-reduced-motion` (static 3/4 view, drag still works). |
| `gear-holo-3d-textured.html` | Textured WebGL companion to the above (Three.js from CDN — needs internet). Same 96 items as extruded holo-slabs: item art baked into an emissive phosphor canvas texture with scanlines, dark-metal chassis sides, raised relief blocks where the art has `█`/`▓` masses, additive glow halo. Same controls. **Deliberately violates the no-canvas/ASCII-native rails** — it exists to compare directions, not to ship. |
| `gear-bench-3d.html` | Realistic-hardware variant (Three.js from CDN — needs internet). Every category is procedurally modeled as physical hacker gear: CORE = CPU + heatsink + VRM caps, LENS = optic barrel with emissive iris, PORT = shielded jack cage with EMI fingers, BUS = backplane slots + ribbon cable, ICE = honed blade probe, SKIN = overlapping cloak plates, CACHE = stacked memory dies on posts, DEF = polished mirror shield, AUTO = relay tower, MARKET = angled ticker display, SOUL = bond-wired die under a glass dome, MILDEV = armored case with antennas. PCB textures (traces/vias/silkscreen/gold edge fingers) are generated per item and seeded by item id; rarity drives accent color, component count, and glow; BROKEN items get scorch marks, cracked boards, bent/missing parts. Same controls, plus a WIRE toggle: hidden-line wireframe mode — meshes go matte black and their edge structure renders as phosphor lines (accent parts keep their color, gold goes amber). **Also outside the ASCII rails — comparison experiment only.** |
| `gear-wire-glow.html` | Neon blueprint wireframe variant (Three.js r147 + UnrealBloom from CDN — needs internet). Same 96 hardware models rendered in the "nanosphere matrix" reference language: ink-navy ground, bloomed edge lines in a fixed palette (mint structure, magenta hot/emissive parts, cyan board + glass, yellow gold), faint double-stroke echo for the screenprint feel, dashed magenta plate border, cyan ground grid. Auto-spin nods to show top and underside. Falls back to flat (no-bloom) wireframe if the post-processing addons fail to load. **Outside the ASCII rails — comparison experiment only.** |

Open files directly in a browser — standalone, no toolchain. The glyph version
needs no network; the textured version loads Three.js from a CDN.
