# Decision log

How the design got to where it is. Most entries follow the same shape: what was
decided, why, and what was rejected. Dates are when the decision was made.

v2 predates the power-brick requirement; v3 incorporates it. Mistakes made along
the way are noted where they happened and collected under Corrections at the end.

---

## Timeline

| Date | Event |
|---|---|
| 2026-09-19 | Brief: 1U shelf, two micro PCs, front keystone for video. v1 drafted internally and rejected; v2 delivered. |
| 2026-09-19 | Mixed Lenovo + Dell confirmed. Survey of public designs. |
| 2026-09-20 | Structural analysis, print orientation, steel ears, front serviceability. Power bricks raised as a hard requirement. Front-rail-only mounting set as a constraint. MS-01 modularity raised. |
| 2026-09-20 | Steel bracket drawing received; v3 designed, verified and shared. |
| 2026-09-20 | Second prior-art pass; the closest public design examined in detail. |
| 2026-09-21 | Repo created. Verification found four defects in v3's front lip; fixed in v3.1 and a test suite added. |
| 2026-09-21 | First git commit, at v3.1. Everything up to here was iterated in Claude Cowork sessions; from this point the work continues in Claude Code, with history in git. |

---

## Geometry and fit

### D1 — Split the 19" shelf into printable parts
A 482.6 mm panel doesn't fit any consumer bed. Two trays joined at a centre keystone
module. v1 put an 8 mm screw boss across the seam, pushing each tray to 219 mm —
too close to a 220 mm bed — and was rejected before delivery. v2 moved to a top flange
screwed into the inner walls (215 mm trays). v3 is 201 mm (203 in v3.1), because the steel ears
(D8) remove the printed ear entirely.

### D2 — PC faces flush in full-width openings
Each bay's front opening is the full bay width, so power buttons, front USB and jacks
are all reachable. **Correction:** v2's notes claimed the case front butted against
the panel. It doesn't — an interference test showed the pull-out corridor is clear,
so v2 had no front stop at all. That turned out to make front loading (D11) almost free.

### D3 — Mixed machines share one envelope
Bays are sized for the larger of the two in every axis (182 × 183 × 36). Only the
rear stop varies by model (a 34.5 mm Lenovo variant exists). Do **not** re-render a
tray with a different `dev_h` or `dev_d`: `dev_h` sets the inner wall height the
keystone flange and tie plate sit on, and `dev_d` moves the tie-plate screws. `dev_w`
per tray is safe, at the cost of a 2 mm asymmetry in the front frame.

### D4 — Keystones are video only; stacked vertically
Two jacks, one per machine, for DP/HDMI couplers. Networking stays at the rear.
In v3 the jacks are rotated 90° and stacked: the thicker outer walls (D9) cost 12 mm
of width that had to come from the centre column, and side-by-side jacks would have
left 2.6 mm edges. Stacked needs ~29 mm; the column is 40 in v3 and 36 in v3.1 (D19).

---

## Structure

### D5 — PETG / ASA, not PLA
The concern is creep in a warm rack over months, not strength (see D6).

### D6 — The cantilever is not the problem; the ear screws are
Front-rail-only mounting with the bricks at the far end looked like the worst case,
so it was calculated rather than guessed. Per tray: PC 1.30 kg at 97 mm, brick
0.55 kg at 285 mm, structure 0.50 kg at 150 mm.

| Quantity | Result |
|---|---|
| Root bending stress | 0.73 MPa (≈3.6% of PETG layer-bond strength) |
| Tip deflection, short term | 0.18 mm |
| Tip deflection, creep-adjusted (E = 900 MPa) | 0.40 mm |
| Load per top rack screw, 1U ear | 111 N (11 kg) |
| Same, with a 2U-tall ear | 39 N |

The tray is a 39 mm-deep U-channel; depth beats length. **Correction:** an earlier
note had overstated the cantilever risk. The real concentration is the rack screw
pulling through a 5 mm strip of plastic beside a 7.2 mm slot, in the layer-weak
direction.

### D7 — Print orientation: floor-down, not face-down
Several public designs print face-down so the ear's bending stress runs along the
extrusions instead of across layer bonds (critical section ≈95 mm² of pure layer
adhesion when printed floor-down). That's correct for printed ears — but with steel
ears (D8) the printed part has no such critical section, and face-down would mean a
206 mm-tall print standing on a mostly-open front frame. So: floor-down, which is the
easier print.

### D8 — Steel rack ears
Penn-Elcom R1206/1U or equivalent: 1.5 mm steel, 43.8 × 20 mm leg, 139.4 mm web.
From the drawing: four Ø4.8 holes, columns 110 mm apart, rows 23.8 mm apart, lower
row 9.4 mm above the bottom edge (9.4 + 23.8 + 10.6 = 43.8, which is how the reading
was confirmed). Removes plastic from the load path and resolves D7.

### D9 — Continuous nut channels, not holes or inserts
The drawing doesn't give the bend-to-first-hole distance, so fixed holes risked
missing. Heat-set inserts can't be slotted, and there's no room inside the bay for
loose nuts. Each outer wall instead carries two M4 nut channels running front to back.
Consequences: outer wall 11 mm; M4 × 8 **button head** (a longer bolt bottoms out,
a socket head fouls the rail); body 442 mm, leaving 2.5 mm per side in a 450 mm
opening. Verified: an M4 hex nut seats in the channel and the bolt clears.

### D10 — Centre tie at front and rear
Keystone module (front) and tie plate (rear) both bolt across the two inner walls.
Field evidence later confirmed this matters: users of the closest public design found
it needs support in the centre once racked (see prior-art.md).

---

## Serviceability and retention

### D11 — Front loading
In a tightly packed rack, pulling the whole shelf to service one machine is not
acceptable. Since the corridor was already clear (D2), v3 only needed a front stop.

### D12 — Front lip instead of clips
Per-bay clips were planned, but there's no structural material inside the full-width
opening to anchor them. The lip spans the opening and screws into the two wall strips
either side, covering the bottom 5 mm of each case front (bezel on both models).
Two screws, lip off, machine slides out. Redesigned in v3.1 after defects were found (D19).

### D13 — Rear stop is set once
Slotted for ±7 mm (172–186 mm device depth), with a 45° self-supporting hook over the
case's rear top edge to stop lift. It's positioned at build time, not a service item.

---

## Power bricks

### D14 — Bricks on the same shelf, behind the PCs
Not a separate U: the point of the design is density, and a U spent on power bricks
is a U lost. The shelf mounts on the front rails only (requirement 8), so it grows
rearward in a bolt-on bay rather than reaching for rear rails. D6 showed the extra
moment is harmless. On a 4-post rack, rear support is an available fallback, but
nothing in the design needs it.

### D15 — Bricks crosswise
Designed to the Lenovo brick (112 × 51 × 35 mm plus ~70 mm of plug and boot) and the
Dell 90 W (130 × 70 × 28). A 130 W Dell adapter exists but isn't needed. Laid crosswise
with mains ends outboard, the pair uses ~372 mm of the width and a 90 mm-deep bay;
lengthwise would have needed ~190 mm of depth. Overall depth ~316 mm. The Lenovo's
35 mm thickness leaves 6.5 mm of headroom in the U, so straps pass under and around,
never over. DC leads run forward through the 36 mm centre gap between the two bays.

### D16 — Thermal risk, accepted and partly de-risked
Both machines exhaust rearward toward the bricks. Mitigations: ~29 mm plenum, vented
floor, open rear, and bays that unbolt so the bricks can move to their own U without
touching anything else. Later evidence: the closest public design puts two PCs and
both bricks in 1U with the bricks directly behind, printed in PLA+, and months of
use by several builders produced no heat or warping complaints. Still worth watching.

Design assumptions: machines that run mostly idle rather than at sustained full
load, in a rack with its own forced ventilation and an interior at or below about
40 °C (100 °F). Under those assumptions, going to 2U for thermal reasons was rejected
as a waste of rack space, and the shelf has no fan of its own. If your rack is
hotter, unventilated, or the machines run flat out, revisit this: the open rear
leaves room to add a fan, and the brick bays unbolt.

---

## Scope and ecosystem

### D17 — 1U micro shelf now; 2U MS-01 shelf later, sharing parts
The MS-01 is 196 × 189 × 48 mm with a 180 W adapter. At 48 mm it cannot fit in 1U,
so it gets a 2U shelf that reuses the ears, keystone module, brick bays and rear
stops. Only the tray changes.

### D18 — Build our own rather than remix the closest public design
Nothing public met all the requirements (see prior-art.md). The closest is
Turaj Pilehvar's Dell Micro 1U mount. Remixing was rejected because: it is STL-only
and the author has confirmed no CAD exists; another user tried importing the STLs
into Fusion 360 for a remix and gave up to redraw from scratch; and changing the bay
for a Lenovo plus adding keystones would alter exactly the geometry that had been
field-tested. What transferred instead was information (D10, D16).

### D20 — Licence: CC BY-NC-SA 4.0 (2026-09-21)
The goal: anyone can print, use and remix the design, with attribution, but not
commercially. CC BY-NC-SA 4.0 does that, and ShareAlike keeps remixes under the same
terms. One licence covers the whole repo, scripts included — Creative Commons advises
against CC licences for software, but the scripts here are small helpers tied to the
design, and splitting licences wasn't worth the complexity. CC BY-NC (no ShareAlike)
was the alternative considered. The `CC-BY-4.0` note in the v3 source header was
added during drafting without anyone deciding it, and is replaced.

---

## Corrections

### D19 — v3.1: front lip defects, found in verification (2026-09-21)
Found while setting up this repo, not by printing. Chasing zero-area triangles in
the exported front lip led to four real defects in v3 as shipped:

1. **The right-hand lip didn't line up.** The lip's holes weren't symmetric, but the
   same part was placed on both trays without mirroring. On the right tray the holes
   missed the pilots by 2.5 mm. The v3 checks only ever tested the left side.
2. **The inner hole broke out of the lip's end** — its centre sat 1 mm from the edge.
3. **The countersunk head was wider than the lip:** a 6.6 mm head on a 5 mm strip,
   leaving 0.8 mm of plastic around the hole.
4. **The outer pilot ran ~1 mm into the lower nut channel.** Two voids touching,
   which no solid-against-solid test can see.

Fixes:
- Symmetric lip with 11 mm end tabs sitting over the two wall strips (never over a
  PC face), M3 pan heads instead of countersunk. One part fits either tray.
- Outer pilot shortened to stop 1 mm short of the nut channel.
- Inner walls widened 6 → 8 mm, taken from the keystone column (40 → 36; the stacked
  jacks need ~29). Overall width unchanged at 442 mm. Every screw into the inner
  walls — keystone flange, tie plate, lip, brick bay — now gets 4 mm of edge
  distance instead of 3, and no countersink breaks out of a flange edge.
- Countersink cones everywhere now stop at the clearance diameter rather than a
  zero-width point.

The checks that would have caught all four are now in `tests/run.sh`: every part
pair on both sides, rods down each lip hole *as placed*, void-against-void tests,
and nut and bolt fit. The alignment tests were confirmed to fail both on the
shipped v3 and on a deliberately broken lip.

**The v3 files shared before this repo existed have these defects. Use this repo.**
