# experiments/

One-off design experiments. **Not canon** — nothing here is part of the
approved deck design system (`deck.css` / `DESIGN-ASCII.md` rails) unless it
is promoted out of this folder by Bob.

| File | What it is |
| --- | --- |
| `gear-holo-3d.html` | 3D test of the gear-library items: each item's ASCII art is voxelized (frame + solid blocks get depth) and rotated as glyphs inside the standard 8×14 terminal cell grid — no canvas, no WebGL, no images. Front-on it reproduces the art character-for-character; at angles it decodes into block shading. Drag to rotate, AUTO to spin, PREV/NEXT/CAT to browse all 96 items. Respects `prefers-reduced-motion` (static 3/4 view, drag still works). |

Open files directly in a browser — standalone, no toolchain, no network.
