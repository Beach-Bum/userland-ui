# experiments/

One-off design experiments. **Not canon** — nothing here is part of the
approved deck design system (`deck.css` / `DESIGN-ASCII.md` rails) unless it
is promoted out of this folder by Bob.

| File | What it is |
| --- | --- |
| `gear-holo-3d.html` | 3D test of the gear-library items: each item's ASCII art is voxelized (frame + solid blocks get depth) and rotated as glyphs inside the standard 8×14 terminal cell grid — no canvas, no WebGL, no images. Front-on it reproduces the art character-for-character; at angles it decodes into block shading. Drag to rotate, AUTO to spin, PREV/NEXT/CAT to browse all 96 items. Respects `prefers-reduced-motion` (static 3/4 view, drag still works). |
| `gear-holo-3d-textured.html` | Textured WebGL companion to the above (Three.js from CDN — needs internet). Same 96 items as extruded holo-slabs: item art baked into an emissive phosphor canvas texture with scanlines, dark-metal chassis sides, raised relief blocks where the art has `█`/`▓` masses, additive glow halo. Same controls. **Deliberately violates the no-canvas/ASCII-native rails** — it exists to compare directions, not to ship. |

Open files directly in a browser — standalone, no toolchain. The glyph version
needs no network; the textured version loads Three.js from a CDN.
