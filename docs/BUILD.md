# Modular 19" Micro-PC Rack System — build guide

A 1U shelf for two 1-litre micro PCs, front-loading, with a stacked keystone bay for
video pass-through and a rear bay for the power bricks, printed as part of each tray. Mounts on **steel rack
ears** — there is no printed ear, so no plastic in the critical load path.

Bays accept up to **182 × 183 × 36 mm**: Lenovo ThinkCentre/ThinkStation Tiny, Dell
OptiPlex Micro, HP EliteDesk Mini. Overall depth ~316 mm. Overall width 439 mm, or
446.4 mm across the ear-bolt heads with the steel ears fitted: allow at least 450.4 mm
clear between the front rails (2 mm per side; D28).

Source: `cad/rack_1u_micro.scad`. Pre-exported binary meshes in `stl/`; regenerate with `bash build.sh`.

---

## Parts

| Part | Qty | Footprint |
|---|---|---|
| `tray_left` / `tray_right` | 1 each | 211 × 316 × 44 mm, brick bay included (D34) |
| `keystone` | 1 | 49 × 44 × 36 mm |
| `rear_stop` | 2 | 64 × 26 × 5 mm |
| `front_lip` | 2 | 202 × 11 × 6 mm — symmetric, same part both sides |
| `tie_plate` | 2 | 49 × 30 × 3 mm — one at the back of the PC bays, one at the back of the brick bays |
| `cable_floor` | 1 | 32 × 172 × 3 mm |

One rear stop fits every machine. It's a low curb that touches only the bottom 8 mm of
the rear face, so it doesn't care about case height or where the ports are.

Each tray is 211 × 316 mm, so it needs a bed at least 320 mm on one axis (a 350 × 320 bed
has 4 mm to spare). The STLs are exported
in print orientation. In that orientation two features need support: the strip above
each tray's PC opening, and the keystone flange's two wings. Everything else prints
without (`tests/run.sh` checks this; D31). Roughly 925 cm³ / 700 g of filament.

**PETG, ASA or PC-blend — not PLA.** Root bending stress is only 0.73 MPa, so this is
about creep in a warm rack over months, not about strength.

## Bill of materials

**Rack mounting**
- 2 × steel 1U rack ear brackets (Penn-Elcom R1206/1U or equivalent, ~$5.50 each)
- 8 × M4 × 12 button head — anything taller than a button head fouls the rail
- 8 × M4 **square** nuts (7.0 mm across flats, 3.2 thick — standard DIN 557). No washers.
- 4 × rack screws + cage nuts for the brackets themselves

**Assembly**
- 4 × M3 × 16 countersunk — keystone module
- 8 × M3 × 16 countersunk — tie plates
- 4 × M3 × 8 pan — rear stops
- 6 × M3 × 6 pan — cable floor to ledges
- 4 × M3 × 12 pan head — front lips
- All M3 threads directly into 2.7 mm printed pilots. No inserts anywhere.

**Other**
- 2 × keystone couplers, female-female: HDMI or mini-DisplayPort, one per machine
- 2 × video cables, PC rear port to the back of the jack. **The plug heads must be
  small.** The jacks are rotated, so each rear plug stands on its long edge, and the two
  sit on 18.8 mm centres. Use one of:
  - slim-head HDMI, passive, head ≤ 16 mm wide (e.g. Monoprice Ultra Slim, Cable Matters
    Ultra Thin);
  - mini-DP couplers with DP ↔ mini-DP cables (the machines keep their full-size DP ports).

  Standard-head HDMI or DP plugs (~21 mm) collide with each other and with the keystone
  flange. A standard HDMI plug fits only in the **lower** jack, with a mini-DP above it,
  and then the cable floor has to start at ~85–90 mm (`cf_y0`). See D26.
- 4 × velcro straps, 16 mm wide and at least 250 mm long, for the power bricks (two
  loops per brick)
- Small zip ties (up to 4 mm wide) for the DC and video leads

## The ear bolts

Each outer wall has four pockets, one per bracket hole, at z = 9.7 and 33.5 mm to match
the bracket's two hole rows (9.4 mm up from the bracket's bottom edge, 23.8 mm apart) and
110 mm apart front to back. Each pocket opens into the bay: slide a square nut in from
inside, then bolt through the bracket's Ø4.8 hole from outside. An M4 × 12 lands flush
with the nut face and stops 0.5 mm short of the bay.

The bolt passes through a slot rather than a hole, giving ±8 mm of fore-aft travel. The
bracket's hole column position doesn't need to be exact, and you can slide the shelf to
set how far it sits proud of the rack face. The pocket is only 0.4 mm taller than the
nut, so the nut slides along the slot but can't turn: no tool needed on the inside.

Tighten **snug, not hard.** The nut bears on the strips of plastic either side of the
slot, and those crush long before an M4 is at full torque. The joint doesn't need clamp
force: the shelf's weight is carried by the bolt shanks bearing on the slot edges.

## Assembly

Everything up to racking happens on the bench. Once the shelf is racked, the ear bolts,
the nuts, the rear-stop screws and the backs of the keystones can't be reached, because
the U above blocks access from the top.

1. Fit the keystone couplers first. Lay the keystone module face-down on a flat surface
   and press the couplers in until they click. Once installed, the panel hangs from its
   top edge only, so don't push couplers into it afterwards.
2. Slide a square nut into each of the four pockets in each tray's outer wall, from
   inside the bay, and bolt the steel ears on loosely.
3. Drop the keystone module between the two tray fronts; screw its top flange into both
   inner walls. Fit the two tie plates the same way, at the back of the PC bays and at
   the back of the brick bays.
4. Slide the cable floor in from the rear onto the two ledges between the trays and screw
   it down (6 screws, all reachable from above).
5. Set the depth: slide the shelf along the bracket slots until its front sits where you
   want it relative to the ear legs, then tighten all eight M4s snug.
6. Set the rear stops: slide each machine in from the front, push its rear stop forward
   against the bottom of the rear face, tighten, then slide the machine back out.
7. Thread the four velcro straps first: each goes down through one slot of a pair, along
   the groove under the floor, and up through the other, so two loops wait in each bay.
   Bricks go in crosswise on top of them, mains-cord ends outboard, DC ends toward the
   centre. The strap row sets each brick's front edge ~25 mm back from the bay front,
   which keeps that space clear for the machines' rear plugs. Cinch the straps. Mains
   cords leave through the hole in the rear rib.
8. Plug the video leads into the backs of the couplers (reachable only from above), run
   them back along the cable floor and through the window in each tray's inner wall behind
   the machine, and zip-tie them to the slot pairs in the cable floor and the anchors along
   the inboard edge of each brick bay.
9. Rack the shelf empty.
10. Slide each machine in from the front, connect its rear cables, and fit the front lip.

## Servicing

To remove a machine:

1. From behind the rack, unplug its rear cables (power, video, network). The ports are
   about 130 mm into the shelf, past the brick, so it's a tight reach, but a rare one.
2. Undo the two front-lip screws, lift the lip off, and slide the machine out the front.

To refit, do the reverse: slide the machine in until it meets the rear stop, refit the
lip, and reconnect its cables from behind.

The shelf doesn't store service loops. These machines have no hot-swappable parts, so
there's no reason to pull one while it's running, and pulling a machine out with its
cables attached would need ~200 mm of slack per cable that the bay has no room for.

The rear stop stays put. It's a set-once adjustment, not a service item.

## Customising

```
openscad -o tray_left.stl -D 'part="tray_left"' cad/rack_1u_micro.scad
```

| Parameter | Default | Effect |
|---|---|---|
| `dev_w`, `dev_d`, `dev_h` | 182, 183, 36 | device envelope |
| `stop_h` | 8 | how far up the rear face the rear stop reaches |
| `dev_depths` | 178, 183 | machine depths the rear stop must reach (Dell 7060 Micro, Lenovo Tiny); the stop adjusts over 175.5–186.5 mm and `tests/run.sh` checks each |
| `vent_chamfer` | 1.5 | 45° chamfer on the floor vents' top edges so rubber feet ride out instead of catching |
| `cf_y0` | 50 | where the cable floor starts; the lower rear video plug's head has to clear it |
| `ks_relief_d`, `ks_relief_w` | 1.0, 9 | relief in the keystone flange underside over the upper rear plug |
| `ks_brace`, `ks_brace_w` | 12, 3.7 | keystone panel-to-flange braces; wider than 3.7 intrudes on latch travel |
| `bricks` | 107 × 46 × 29, 128 × 66 × 23 | the power bricks, L × W × T (Lenovo 65 W slim, Dell 90 W); `tests/run.sh` checks each fits the bay and sits under the strap band |
| `strap_y`, `bb_clear` | 48, 25 | the velcro slot row, and where it puts the bricks' front edges; move both for a much deeper brick |
| `brk_row_z`, `brk_row_dz` | 9.4, 23.8 | bracket hole rows — change these if your brackets measure differently |
| `wall_o` | 11 | outer wall; must stay thick enough to hold the ear-bolt pockets |
| `nut_s`, `nut_clr`, `skin_t` | 7.0, 0.4, 7.3 | square nut size, its pocket clearance (the nut's 9.9 mm diagonal must not fit), and the solid skin the bolt passes through |
| `ear_c0`, `ear_travel` | 22, 16 | first bracket hole column at mid-travel, and the fore-aft travel of the slots |
| `bb_depth`, `bb_rear` | 82, 16 | brick bay depth, and the rear rib behind it; the rib's depth is most of the tray's stiffness (D34) |
| `ks_gap` | 4 | vertical gap between the stacked keystone apertures |
| `key_w` | 33 | keystone column width; 33 is the narrowest the braced jacks allow (D28) |
| `ks_clr`, `ks_chamfer` | 0.5, 0.5 | keystone panel side clearance, and the chamfer on its face-down edges and apertures |
| `ledge_w` | 8 | cable-floor ledges; below ~8 the M3 pilot's inboard wall gets thin enough to split |
| `rack_open`, `rack_margin` | 450.85, 2.0 | measured rail opening and the clearance `tests/run.sh` enforces across the ear-bolt heads |

## Known limitations

- **Thermal:** both machines exhaust rearward toward the brick bay. There's a ~40 mm gap
  behind each machine (17 mm to the tray's rear edge plus the 25 mm kept clear at the
  front of the bay), an open vent grid under the bricks and an open rear, but two adapters sitting in
  a 1U exhaust stream is not a configuration I can promise runs cool. The bays are part of
  the trays (D34), so moving the bricks to their own U means a different shelf.
- The bays are laid out for the two calipered bricks (Lenovo 65 W slim 107 × 46 × 29 mm,
  Dell 90 W 128 × 66 × 23; ~11 mm of headroom over the taller one). A different adapter
  needs to be 31–77 mm front to back to sit under the strap band and inside the bay, and
  under ~37 mm tall with a strap over it. Add it to `bricks` and `tests/run.sh` checks both.
- Verified against the bracket drawing, not against a bracket in hand. Check the 23.8 mm
  row spacing (`brk_row_dz`) and the bend-to-first-hole distance (`ear_c0`) with calipers
  before printing both trays; each is a one-parameter fix.
- Front-rail mounting only. The numbers say that's fine — 0.4 mm of creep deflection over
  a warm year — but an asymmetrically loaded shelf will still twist slightly, which is
  what the tie plates are there to resist.
