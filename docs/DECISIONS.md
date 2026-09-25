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
| 2026-09-21 | Independent review of v3.1 (Temple Keller). Brick bay inner tab found floating (D21); ear nut channels found impossible to load (D22); rear stop redesigned and a cable floor added (D23); fastener lengths, keystone clearance and assembly order corrected (D24). |
| 2026-09-21 | OpenSCAD pinned to 2026.09.18 (D25). |
| 2026-09-21 | Rear video plug clearance: slim HDMI or mini-DP, flange relief, cable floor moved back (D26). |
| 2026-09-21 | Keystone panel and brick bay tabs braced (D27). |
| 2026-09-21 | Rack opening measured at 450.85 mm; keystone column narrowed to 33 mm (D28). |
| 2026-09-22 | Ear bolts: square nut, no washer (D29). |
| 2026-09-22 | Printability fixes from the H2D review (D30). |
| 2026-09-22 | Tests check each part for unsupported overhangs in print orientation (D31). |
| 2026-09-22 | Docs cleanup: stale statements corrected, preview re-rendered. |
| 2026-09-25 | Both bricks calipered, smaller than D15 assumed in every axis; strap row moved so it holds them (D33). |
| 2026-09-23 | Rear stop reaches the Dell, stiffer front lip, chamfered floor vents (D32). |

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
rear stop varies by model (a 34.5 mm Lenovo variant existed until D23 made one stop fit all). Do **not** re-render a
tray with a different `dev_h` or `dev_d`: `dev_h` sets the inner wall height the
keystone flange and tie plate sit on, and `dev_d` moves the tie-plate screws. `dev_w`
per tray is safe, at the cost of a 2 mm asymmetry in the front frame.

### D4 — Keystones are video only; stacked vertically
Two jacks, one per machine, for DP/HDMI couplers. Networking stays at the rear.
In v3 the jacks are rotated 90° and stacked: the thicker outer walls (D9) cost 12 mm
of width that had to come from the centre column, and side-by-side jacks would have
left 2.6 mm edges. Stacked needs ~29 mm; the column is 40 in v3, 36 in v3.1 (D19) and 33 after D28. Rear-plug clearance for this layout: D26.

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
opening. **Correction (D28):** that counted the steel but not the bolt heads. Verified: an M4 hex nut seats in the channel and the bolt clears.
**Superseded by D22:** the nuts could never be loaded into the channels.


### D10 — Centre tie at front and rear
Keystone module (front) and tie plate (rear) both bolt across the two inner walls.
Field evidence later confirmed this matters: users of the closest public design found
it needs support in the centre once racked (see prior-art.md).

---

## Serviceability and retention

### D11 — Front loading
In a tightly packed rack, pulling the whole shelf to service one machine is not
acceptable. Since the corridor was already clear (D2), v3 only needed a front stop.

**Servicing procedure (2026-09-21, issue #7):** a machine's rear cables are unplugged
from behind the rack before it slides out the front. Pulling it out with cables still
attached would need ~200 mm of free slack on each rear cable. Behind each machine, the
bay has only ~8–27 mm of free depth left after the rear plugs and the brick, and
building in room for service loops would lengthen the shelf. The machines have no
hot-swappable parts, so a rare, tight reach from behind was judged the simpler
trade-off.

### D12 — Front lip instead of clips
Per-bay clips were planned, but there's no structural material inside the full-width
opening to anchor them. The lip spans the opening and screws into the two wall strips
either side, covering the bottom 5 mm of each case front (bezel on both models).
Two screws, lip off, machine slides out. Redesigned in v3.1 after defects were found (D19).

### D13 — Rear stop is set once
Slotted for ±7 mm (172–186 mm device depth), with a 45° self-supporting hook over the
case's rear top edge to stop lift. It's positioned at build time, not a service item.
**Hook replaced by a low curb in D23.**
*The ±7 mm / 172–186 mm figures were stale; the stop reached 179.5–190.5 mm, which missed
the 178 mm Dell. Moved in D32 to 175.5–186.5 mm.*

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
*Corrected since: the bay floor is 4 mm, so headroom is ~5.5 mm, and a strap does pass
over the brick (D24). DC leads only run forward to each machine's own jack; the centre
gap carries the video leads (D23). Both bricks were calipered on 2026-09-25 and are
smaller in every axis: Lenovo 65 W slim 107 × 46 × 29, Dell 90 W 128 × 66 × 23. Headroom
over the Lenovo is ~11 mm, not ~5.5, and the pair uses ~365 mm of width (D33).*

### D16 — Thermal risk, accepted and partly de-risked
Both machines exhaust rearward toward the bricks. Mitigations: ~29 mm plenum, vented
floor, open rear, and bays that unbolt so the bricks can move to their own U without
touching anything else. Later evidence: the closest public design puts two PCs and
both bricks in 1U with the bricks directly behind, printed in PLA+, and months of
use by several builders produced no heat or warping complaints. Still worth watching.
*The plenum is now ~40 mm: the bricks sit behind the 25 mm kept clear for the machines'
rear plugs.*

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

### D21 — Brick bay inner mounting tab floated above the floor (2026-09-21)
Found by counting connected solids in the exported mesh: `brick_bay` was two
separate bodies. Both front mounting tabs started at z = 8. The outer one overlaps
the outer lip beneath it (12 mm tall), so it was fused. The inner edge is the open
cable-run side and has no lip, so the inner tab hung 4 mm above the 4 mm floor with
nothing joining them. It sliced as an unsupported island, and it carries one of the
two bolts that hold each bay to its tray.

Fix: both tabs now run from the floor (z 0–32). The outer tab is unchanged in the
union, because it already sat inside the lip.

Why the checks missed it: every existing test is an intersection between two parts,
and a part that falls apart into two bodies doesn't collide with anything. New test
`bb_tab_rooted_L` requires the space under the inner tab to be solid; it fails on
v3.1 and passes now.

### D22 — Ear nut channels couldn't be loaded; replaced with per-bolt pockets (2026-09-21)
*Washer and hex nut replaced by a square nut in D29.*
D9's channels were sealed at both ends. They run y 8–165 inside a wall that runs
6–206, so the "slide the nuts in from the rear" step had 41 mm of solid wall in the way.
The only opening was the 4.8 mm bolt slot on the outside face. A 7 mm nut passes that
only lying flat, and the 4 mm-deep pocket has no room to stand it up. Sweeping the
`m4_nut_fits` nut out of its seat towards the bay, the outside, the rear and the front
hits wall every time. Each channel roof was also a 157 mm unsupported bridge when
printed floor-down.

Fix: four pockets per tray, one per bracket hole, each open to the bay. A washer and
nut go in from inside before the machine does; the bolt comes in from outside through
a slot that keeps ±8 mm of fore-aft travel (`ear_c0`, `ear_travel`), so the
bracket's column position still needn't be exact. The longest roof is now a 25.6 mm
bridge supported at both ends.

- **Washer:** it spreads the clamp load off the strips of skin beside the slot. The
  old nut bore on two 1.1 mm strips.
- **No anti-rotation:** a stepped pocket that would stop the nut spinning was tried and
  dropped. A 9 mm washer can't pass a 7.3 mm nut opening or be turned upright inside
  one, so the pocket is washer-sized and the nut is held while tightening.
- **Bolts:** now M4 × 12. Through 1.5 mm steel, 6.5 mm skin and a 0.8 mm washer, the
  tip lands flush with the nut face, 0.5 mm short of the bay.
- **Lip pilot:** the outer lip pilot keeps D19's rule and stops 1 mm short of the new
  front pockets.

Why the checks missed it: `m4_nut_fits` placed a nut in its final position and
confirmed it fit. It never asked how the nut got there. Replaced by:
- `m4_hw_seated`: bolt, washer and nut at both ends of travel in all four holes.
- `m4_hw_insertable`: washer and nut swept in from the bay.
- `m4_past_travel`: the same hardware 4 mm past the end of travel must hit wall, which
  proves the other two can fail.

### D23 — Open rear, cable floor, zip-tie anchors (2026-09-21)
**Rear stop.** The hook's web was a solid plate 64 mm wide and 33 mm tall, flush
against the middle third of each machine's rear face (about 32% of it), where the
ports and exhaust are. That conflicts with requirement 3's rear video cables and with
D16's airflow, and it depended on `dev_h`, hence the Lenovo variant. The stop is now
a curb that touches only the bottom `stop_h` (8 mm) of the rear face. One part fits
every machine, the rear stays open for any port layout, and the Lenovo variant is
gone. It gives up the hook's lift restraint; the U above and the front lip bound that.

**Cable floor.** Requirement 6 calls cord management imperative, but the video leads
had no supported route to the keystones:
- the inner wall behind each machine is solid;
- the tie plate leaves ~2.5 mm over the top of the wall;
- the centre channel between the trays had nothing under it.

A new `cable_floor` part spans the channel on a 6 × 4 mm ledge added to each inner
wall and screws down from above. Zip ties pass through slot pairs into the 4 mm gap
beneath, so nothing hangs below the shelf. It also ties the bottoms of the two trays
together; that stiffening hasn't been quantified. The route for each video lead is:
machine's rear → brick bay → centre gap → cable floor → keystone. D15's "DC leads run
forward through the centre gap" was a slip: DC leads only go forward to each
machine's own jack.

**Brick bay.** Zip-tie anchors along the inboard edge: slot pairs joined by an
underside groove, so the strap sits flush with the bottom face.

New tests:
- `tray_cf`, `keystone_cf`, `tie_cf`, `bricks_cf`: no collisions.
- `cf_holes`: screw cores pass the floor into the ledge pilots without bottoming out.
- `ziptie_void`: the gap under the floor is clear.
- `rear_face_open_L`: nothing touches the rear face above the curb.
- `stop_meets_face_L`: the curb does meet the face.

### D24 — Fastener lengths, keystone clearance, assembly order, supports (2026-09-21)
Found by working through every screw (reach, length, engagement), every assembly step
(possible in this order, in a rack?) and every part (printable as exported?):

- **Rear-stop screws broke through.** The BOM's M3 × 10, through the 3 mm foot into
  6 mm of pad and floor, stuck 1 mm out of the underside into the U below. Now M3 × 8,
  and the pilot starts at z = 0.6 so the flat tip clears the pilot bottom instead of
  meeting it. The test models the screw 0.5 mm long to keep that margin, which catches
  both the old pilot and the old screw.
- **The keystone panel had zero clearance:** 36.0 mm in a 36.0 mm gap between the tray
  panels. Now 35.4 mm (`ks_clr` = 0.3 per side, the same as the cable floor).
- **Assembly order.** Tightening the ear bolts and setting the rear stops after racking
  isn't possible with the U above populated: the nuts and stop screws are reached from
  above, and the bolt heads sit between the bracket and the rail. All of that, plus
  fitting the couplers and plugging in the video leads, now happens on the bench. The
  couplers go in first, with the panel backed up, because the installed panel hangs
  from a 36 × 3 mm joint loaded across the print layers. The shelf is racked empty and
  the machines slide in from the front.
- **Supports.** The strip above each PC opening is a 184 mm unsupported span when
  printed floor-down, so the trays need supports there. "No supports" was wrong.
  *Since then (D31, 2026-09-22): slicer settings, including how to support, are left to
  the 3MF built from this geometry. BUILD.md only says which features need support, and
  `tests/run.sh` checks that list. "Supports from the build plate are enough" was wrong:
  the support stands on the panel's own lower strip.*
- **Headroom.** The bay floor is 4 mm, not 3, so the Lenovo brick gets about 5.5 mm of
  headroom, not 6.5. A velcro strap does pass over the brick: it has to, to hold it.
  That corrects D15.
  *Since measured (D33): the Lenovo brick is 29 mm thick, so headroom is ~11 mm.*

New tests:
- `stop_screws_L` / `_R`: fail on v3.1, pass now.
- `keystone_side_clear`: fails on v3.1 with 131 mm³ of overlap, passes now.
- `cf_holes`: now uses 2.6 mm cores, so a tip that runs through a pilot's skin shows up
  above the 2 mm³ threshold.

### D25 — Pin the OpenSCAD version (2026-09-21)
Different OpenSCAD versions tessellate curves differently. `canon_stl.py` only makes
identical *triangles* byte-identical, so two contributors on different versions each
rewrite every curved STL on every build. The review PRs (D21–D24) were built on
2026.06.12, and three STLs then changed when rebuilt on 2026.09.18, with no change in
shape. Pinned to 2026.09.18, the version the owner already had and the current
Homebrew `openscad@snapshot`. `build.sh` warns on a mismatch rather than failing,
because a mismatched build is still geometrically correct, just noisy in git. The
2021.01 stable release was never in use here.

### D26 — Rear video plug clearance (2026-09-21, issue #6)
The rotated, stacked jacks (D4) put each rear plug on its long edge, 18.8 mm apart,
between the keystone flange above (underside at z = 39, back to y = 36) and the
cable floor below. Plugs were modelled as blocks at two coupler depths (rear face 24
and 32 mm behind the panel front):

- **Standard HDMI or DP heads (~21 × 11 × 40 mm)** collide with each other, the
  flange and the cable floor under every small change considered. The two plugs alone
  overlap by ~1000 mm³.
- **Slim HDMI heads (16 × 6.6 × 14 mm)** missed by ~0.2 mm per side at the flange and
  hit the cable floor at the deeper coupler depth.
- **Mini-DP** is smaller still.

Three ways to make 2 × slim HDMI fit were compared:

| Option | Upper plug to flange | Plug to plug | Cost |
|---|---|---|---|
| `ks_gap` 4 → 3 | 0.3 mm | 1.8 mm | halves the full-thickness plastic between the jacks (2 → 1 mm) |
| **1 mm relief in the flange underside** | 0.8 mm | 2.8 mm | flange 2 mm thick instead of 3 over a 9 mm-wide strip |
| Move the flange back | — | — | restructures the keystone module for no extra gain |

Chosen: the relief (`ks_relief_d` = 1.0, `ks_relief_w` = 9). It starts behind the
panel at y = 8.8, so the panel-to-flange joint is untouched. `cf_y0` goes from 44 to 50
so the lower plug's head clears the floor. The first cable-floor screw pair moves
54 → 58 to keep its edge distance.

**Supported cables:**
- 2 × slim HDMI (passive; active RedMere cables may not like a passive coupler);
- 2 × mini-DP;
- one of each;
- mini-DP upper with standard HDMI lower, provided `cf_y0` goes to ~85–90.

Standard-head cables in both jacks would need the jacks turned upright and the flange
cut away over them. That's a different layout, not taken.

Tests: `plug_vs_keystone`, `plug_vs_cf` and `plug_vs_plug` check both jacks at both
coupler depths. The first two failed before this change. `flange_over_relief` checks
that 2 mm of flange remains.

### D27 — Brace the keystone panel and the brick bay tabs (2026-09-21, issue #11)
Two parts behave like vertical posts loaded across their print layers. The numbers
are hand calculations with rounded loads; the ratios are what matter.

**Keystone panel.** It hangs from a 35.4 × 3 mm joint with the flange. The module
prints panel-down, so that joint is a layer boundary. A 30 N push on the lower jack,
from plugging a monitor into the front, gives ~16 MPa there, repeated at every plug-in.
Two 12 mm braces between the panel back and the flange underside fix it. They sit in
the 3.7 mm strips at the panel edges, clear of the jacks' latch travel. The composite
section takes the same push to ~2.2 MPa, about 7× less, and the braces print as 45°
fins.

**Brick bay tabs.** The bay hangs from two bolts at z = 20.
- **Inner tab (8 × 4 mm).** At rest it sees ~6.5 MPa at its root; a 50 N handling load
  gives ~38 MPa. An 11 mm brace behind it, topping out below the bolt head, moves the
  weakest section up to the brace top, where the same load gives ~12 MPa.
- **Outer tab (above the 12 mm lip).** A 50 N load gives ~14 MPa; a 4.5 mm brace takes
  it to ~6 MPa.

The bay braces sit in the front ~25 mm that is already kept clear for the machines'
rear plugs.

**Not braced:**
- the tray wall-to-floor corners inside the bays (~1 mm PC clearance, no room);
- the tray's front posts (backed by the full-length walls).

Tests: `ks_braces_present` and `bb_braces_present_L` fail before this change and pass
now. `ks_latch_room` keeps the jacks plus 2.5 mm of latch travel clear; widening the
braces to 6 mm makes it fail. `bb_driver_clear_L` keeps the M3 heads and the screwdriver
path along y clear.

### D28 — Clearance in the rack opening (2026-09-21, issue #5)
With the steel ears fitted, the shelf is widest across the M4 button heads: body
+ 2 × 1.5 mm web + 2 × 2.2 mm head. At 442 mm that was 449.4 mm. The rack's clear width
between the front rails was measured at 450.85 mm (17¾", two tapes), leaving 0.7 mm
per side. That's about a tape measure's own accuracy, before print tolerance or web
flatness. Standard rack equipment leaves about 3 mm per side.

Four ways to take 3 mm out were run against the full test suite:

| Change | Result |
|---|---|
| **Keystone column 36 → 33** | all checks pass |
| Column 34, bay fit 1 → 0.75 | machines graze the openings sliding out (`pullout`) |
| Inner walls 8 → 7, bay fit 0.75 | `pullout` and `lip_clear_of_face` fail |
| Column 34, inner walls 7.5 | `lip_clear_of_face` fails |

Chosen: `key_w` = 33, giving a 439 mm body, 446.4 mm across the bolt heads and
**2.2 mm per side**. The keystone panel, tie plate and cable floor are all derived from
`key_w` and follow. The cost is latch access: the gap between each keystone brace (D27)
and the jack body shrinks from ~4.3 to ~2.85 mm. That still covers the 2.5 mm of latch
travel `ks_latch_room` reserves, and couplers are fitted once on the bench. 33 is the
floor: at 32 the braces cut into the latch clearance.

`rack_open` and `rack_margin` now live in the source. The new test
`rack_width_margin` models the heads at every bolt and fails if they come within
2 mm of the rails; it fails at 36 (461 mm³ outside the margin) and passes at 33.

### D29 — Ear bolts: square nut, no washer (2026-09-22, issue #15)
D22's pocket was sized for a 9 mm washer, which made it taller than the hex nut's
8.1 mm corners. That caused two problems:
- The nut spun freely. The only way to hold it was a fingertip; a spanner can't get
  around a nut inside a 9.3 mm pocket.
- The pocket had 0.3 mm of clearance over the washer. Layer quantisation and roof sag
  (#15) could close that up, so the washer might not go in at all.

A square nut in the same washer pocket doesn't fully fix it. Its 9.9 mm diagonal lets
it turn 23–37° before jamming corner-first into printed plastic, depending on the
printed pocket height. And the window between "washer won't fit" and "nut spins
freely" is only ~0.7 mm.

Chosen: **square M4 nut (DIN 557), no washer, pocket sized to the nut** (7.4 mm tall,
`nut_clr` 0.4). In that pocket the nut can turn about 2.5° before it locks, and it
still slides fore-aft with the ±8 mm travel.

**What dropping the washer costs.** Once the 4.5 mm slot band is taken out, the nut's
face bears on less plastic:

| Nut bearing on plastic | Area | Stress at ~0.5 N·m |
|---|---|---|
| washer (D22) | ~25 mm² | — |
| **square nut** | **~17.5 mm²** | ~36 MPa |
| hex nut | ~11.9 mm² | ~52 MPa |

Among the no-washer options the square nut is clearly better: the hex nut is already
around PETG's crush strength at snug. Dropping the washer also frees 0.8 mm, so the
solid skin goes from 6.5 to 7.3 mm, which helps pull-through and the slot edges' bearing
against the bolt. M4 × 12 still lands flush with the nut face, 0.5 mm short of the bay.

**Assembly note.** BUILD.md now says "snug, not hard". The joint's load is the bolt
shanks bearing on the slot edges, not clamp force.

Test: `m4_nut_cannot_spin` requires the nut's full turning circle to hit wall at every
seat. It gets 427 mm³ here. With the washer-height pocket it's 50 mm³, so that pocket
would let the nut turn. The seated, insertable and past-travel checks now use the
square nut. D22 marked partly superseded.

### D30 — Printability fixes from the H2D review (2026-09-22, issue #15)
Model changes from #15 that don't depend on a test print:

- **Cable-floor ledges 6 → 8 mm.** The M3 pilot, centred in a 6 mm ledge, left
  1.65 mm of plastic on the inboard side, likely to split as the screw self-taps. Now
  2.65 mm each side. The void between the ledges drops to 17 mm, so the zip-tie slot
  pairs move from ±8 to ±6 mm about the centre; `ziptie_void` still passes.
- **Plenum and velcro slots no longer touch.** The plenum slot (y 2–10) and the front
  velcro slots (then y 10–26) met at y = 10, the same "two voids touching" defect as
  D19. That left the bay's front edge as two thin ribs, and it's the edge that bears
  on the tray. The front velcro row moves to y = 20.5, leaving 2.5 mm of rib to the
  plenum and 2.5 mm to the vent grid. *Since replaced by a single row at y = 48 (D33).*
- **Velcro strap path recessed.** The zip-tie anchors got underside grooves in D23;
  the velcro slots didn't, so a strap under the floor stood ~1.5–2 mm below the shelf
  into the inter-U gap. Each slot pair is now joined by a 16 × 2 mm underside groove.
  Printed floor-down, that's a 16 mm bridge.
- **Keystone panel chamfer and clearance.** The panel prints face-down, and first-layer
  flare (0.1–0.25 mm per side) ate most of the 0.3 mm side clearance and narrowed the
  aperture fronts where the couplers enter. A 0.5 mm 45° chamfer round the face-down
  perimeter and both apertures (`ks_chamfer`) removes the flare, and `ks_clr` goes
  0.3 → 0.5. The braces (D27) move in with the panel edge and still clear the latch
  zone.

**Waiting on data:**
- **Horizontal pilot size (2.7 → 2.9 or teardrop):** waits for a test print.
- **Solid runners in the floor vents under the machines' feet:** waits for the actual
  foot positions.

New tests: `bb_plenum_velcro_rib`, `velcro_groove_clear` and `ks_face_chamfered` all
fail on the previous geometry and pass now.

### D31 — Test for unsupported overhangs in print orientation (2026-09-22, issue #15)
#15's point 8: every check in `tests/run.sh` was solid-against-solid in the
assembly, so nothing could see how a part prints. That's how the keystone flange
wings, which start 6 mm above the bed with nothing under them, reached `main`. It's
also how v3's floating brick-bay tab (D21) got through until someone counted shells.

**The check.** Each part is taken in its exported orientation. A new `printed(p)`
module holds the export transforms, shared by `build.sh` and the tests; the refactor
leaves every STL byte-identical. The part is sliced every 0.4 mm, and material not
within 45° of the slice below counts as unsupported. An opening of 1.3 mm removes
slivers narrower than 2.6 mm: these are the caps of M3/M4 horizontal holes and
countersinks, which bridge trivially. What remains must fall inside that part's
**allow-list**:

| Part | Allowed | Why |
|---|---|---|
| trays | strip above each PC opening | **needs support** |
| trays | ear-bolt pocket and slot roofs, inner-wall vent roofs | bridges ≤ 30 mm |
| keystone | the two flange wings | **needs support** |
| brick bay | velcro and zip-tie groove roofs under the floor | bridges ≤ 16 mm |
| all others | nothing | |

So a new overhang fails unless someone decides it's a bridge or that it needs support,
and adds it to the list. The allow-list boxes are derived from the same parameters as the features,
so they move with the geometry.

**Controls.**
- `ov_control_wings` runs the keystone with no allow-list and must catch the wings
  (227 mm³).
- Restoring v3.1's floating tab in a scratch copy makes `ov_brick_bay` fail at exactly
  the tab (x 195–203, z 8).

**Scope.** This is a geometry check: which features bridge and which need support.
How to support them is a slicer decision and lives in the 3MF, not the repo.

**Limits.** It judges geometry, not a slicer. The 45° rule and the 2.6 mm sliver
filter are approximations; bridge quality, sag and first-layer flare aren't modelled.
Adds ~2 s to the suite.

### D32 — Rear stop reach, stiffer front lip, chamfered floor vents (2026-09-23)
**Rear stop reach.** With the front lip fitted, a machine sits with its front face flush
with the panel front (y = 0), so the stop's face has to reach the machine's depth. Its
slots only covered 179.5–190.5 mm. The Lenovo (183) was fine, but the Dell 7060 Micro
(178) could never be set snug and kept ~1.5 mm of rattle. The tests missed it because
they modelled the machine 6 mm back, at the panel's rear face. Moving the stop's
pilots and pad 4 mm forward (`ret_y` = `tray_d` − 10) gives 175.5–186.5 mm, which
covers both with ≥ 2 mm margin.

The test machine envelope and the assembly now put the machine against the lip. New
parameter `dev_depths` lists the machines, and `stop_reaches_*` checks that an M3
through each pad pilot passes the stop's slot at every listed depth. At the old
position the Dell check fails (22 mm³).

**Stiffer front lip.** The lip was a 5 mm-tall, 3 mm-deep bar spanning ~194 mm between
its screws, and it felt flimsy in the hand on a test print. As a retainer it was
already adequate: a flat machine face bears near the lip's ends, where it's stiff,
about 0.1 mm per N. But it bent and twisted easily when handled. It's now 6 mm deep
(`lip_t`), about 8× stiffer in bending and far stiffer in torsion. Its height is
unchanged, so it covers no more of the machine's face. It stands 6 mm proud of the
panel instead of 3, and it still prints face-down.

The lip screws become M3 × 12. New checks `lip_screws_L/R` confirm they seat in the
tray pilots without bottoming out; M3 × 12 would have hit the pilot bottoms with the
old 3 mm lip.

**Chamfered floor vents.** A machine sliding in crosses four rows of vent openings on
its rubber feet. #15 flagged that a foot can drop in and catch on a square edge. Each
cell's top edge now has a 1.5 mm 45° chamfer (`vent_chamfer`), so a foot rides out.
This needs no foot positions. Solid runners under the feet remain an option once
the positions are measured. The 10 mm ribs keep a 7 mm flat top.
`vents_chamfered` checks every cell; with no chamfer it fails.

**Not changed:** the Lenovo's side play (179 mm in a 184 mm bay). Nobody has asked for
it tightened; D3 describes the per-tray `dev_w` route if that changes.

### D33 — Bricks calipered; one strap row, centred on them (2026-09-25)
**Measurements.** Both bricks were calipered. D15's figures were over in every axis:

| Brick | D15 | Calipered |
|---|---|---|
| Lenovo 65 W slim | 112 × 51 × 35 | **107 × 46 × 29** |
| Dell 90 W | 130 × 70 × 28 | **128 × 66 × 23** |

They're now in the source as `bricks`, so the tests can use them. Nothing in the bay
depended on the bricks being larger: `bb_depth` stays at 90 (66 is needed), and D6's
loads assumed heavier bricks than these. Two things do change:

- **Headroom.** 44.45 − 4 (bay floor) − 29 = ~11 mm over the Lenovo, not ~5.5. The
  "room for a strap over the top, nothing more" warning in BUILD.md and D24 goes.
- **The strap rows couldn't hold the Lenovo.** The slot rows at y = 20.5 and 93 (bands
  12.5–28.5 and 85–101) need a brick at least 59 mm deep to sit under both. With the
  brick's front edge 25 mm back, as BUILD.md asks, the front band overlapped the Lenovo
  by 3.5 mm and the rear band not at all; the Dell got 3.5 and 6 mm. A 16 mm strap with
  3.5 mm of brick under it slips off the edge. The measured widths (46, 66) made this
  worse, but the rows were already wrong at 51 and 70.

**Fix.** One slot row at y = 48 (`strap_y`), centred on the Lenovo's 25–71 and inside
the Dell's 25–91 with ≥ 15 mm to spare each side. Each brick gets two loops, through
the (30, 70) and (110, 150) slot pairs, each pair with its underside groove: four
straps, which is what the BOM always said. The row also locates the bricks: a strap
over the brick puts its front edge at `bb_clear` = 25, the plug clearance BUILD.md
used to ask for by hand.

The vent grid moves out of the strap band: a 22 mm row ahead of it (y 15–37) and a
38 mm row behind (59–97), still three cells wide (`vent_rows`). Open area per bay goes
from 5280 to 7200 mm², and no strap crosses a vent. The rib between the plenum slot and
the front vent row is 5 mm; between the plenum and the strap slots, 30.

**Not changed:** the slot pitch. For the Lenovo (x 12–119) the second loop's inner
slot at x = 110 sits 9 mm inside the brick's end, so that strap comes up under the
brick and over its end rather than beside it. It still cinches, and threading the straps
before the bricks go in was already the order in BUILD.md.

**Tests**, one per entry in `bricks`: `brick_in_bay_i` (the brick, front edge at
`bb_clear`, clears the bay's lips and the tray) and `strap_under_brick_i` (the 16 mm
strap band falls wholly inside the brick's footprint). At the old rows the Lenovo check
fails with 2538 mm³ (front row) and 3248 mm³ (rear row: the entire band); at y = 48
it's zero. The D30 velcro checks and the D31 overhang allow-list now read the strap
parameters instead of literals.
