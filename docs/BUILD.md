# Modular 19" Micro-PC Rack System — v3

A 1U shelf for two 1-litre micro PCs, front-loading, with a stacked keystone bay for
video pass-through and a bolt-on rear bay for the power bricks. Mounts on **steel rack
ears** — there is no printed ear, so no plastic in the critical load path.

Bays accept up to **182 × 183 × 36 mm**: Lenovo ThinkCentre/ThinkStation Tiny, Dell
OptiPlex Micro, HP EliteDesk Mini. Overall depth ~316 mm.

Source: `cad/rack_1u_micro.scad`. Pre-exported binary meshes in `stl/`; regenerate with `bash build.sh`.

---

## Parts

| Part | Qty | Footprint |
|---|---|---|
| `tray_left` / `tray_right` | 1 each | 209 × 206 × 44 mm |
| `brick_bay` | 2 | 203 × 110 × 32 mm |
| `keystone` | 1 | 52 × 44 × 36 mm |
| `rear_stop` | 2 | 64 × 26 × 5 mm |
| `front_lip` | 2 | 202 × 11 × 3 mm — symmetric, same part both sides |
| `tie_plate` | 1 | 52 × 30 × 3 mm |
| `cable_floor` | 1 | 35 × 178 × 3 mm |

One rear stop fits every machine. It's a low curb that touches only the bottom 8 mm of
the rear face, so it doesn't care about case height or where the ports are.

Largest part is 209 × 206 mm, so a 220 mm bed works with margin. Everything prints in
the orientation it's exported in, no supports. Roughly 590 cm³ / 450 g of filament.

**PETG, ASA or PC-blend — not PLA.** Root bending stress is only 0.73 MPa, so this is
about creep in a warm rack over months, not about strength.

## Bill of materials

**Rack mounting**
- 2 × steel 1U rack ear brackets (Penn-Elcom R1206/1U or equivalent, ~$5.50 each)
- 8 × M4 × 12 button head — anything taller than a button head fouls the rail
- 8 × M4 hex nuts (7.0 mm across flats, 3.2 thick — standard DIN 934)
- 8 × M4 washers (9 mm OD, 0.8 thick — standard DIN 125)
- 4 × rack screws + cage nuts for the brackets themselves

**Assembly**
- 4 × M3 × 16 countersunk — keystone module
- 4 × M3 × 16 countersunk — tie plate
- 4 × M3 × 10 pan — rear stops
- 4 × M3 × 16 pan — brick bays to trays
- 6 × M3 × 6 pan — cable floor to ledges
- 4 × M3 × 8 pan head — front lips
- All M3 threads directly into 2.7 mm printed pilots. No inserts anywhere.

**Other**
- 2 × keystone couplers, HDMI or DP female-female (mix freely, the apertures are identical)
- 2 × short video cables, PC rear port to the back of the jack
- 4 × velcro straps for the power bricks
- Small zip ties (up to 4 mm wide) for the DC and video leads

## The ear bolts

Each outer wall has four pockets, one per bracket hole, at z = 9.7 and 33.5 mm to match
the bracket's two hole rows (9.4 mm up from the bracket's bottom edge, 23.8 mm apart) and
110 mm apart front to back. Each pocket opens into the bay: drop a washer and nut in from
inside, then bolt through the bracket's Ø4.8 hole from outside. An M4 × 12 lands flush
with the nut face and stops 0.5 mm short of the bay.

The bolt passes through a slot rather than a hole, giving ±8 mm of fore-aft travel. The
bracket's hole column position doesn't need to be exact, and you can slide the shelf to
set how far it sits proud of the rack face. The pocket is sized for the washer, so the
nut can turn: hold it with a finger or a 7 mm spanner while you tighten.

## Assembly

1. Drop a washer then a nut into each of the four pockets in each tray's outer wall, from
   inside the bay, and bolt the steel ears on loosely.
2. Drop the keystone module between the two tray fronts; screw its top flange into both
   inner walls. Fit the tie plate at the rear the same way.
3. Slide the cable floor in from the rear onto the two ledges between the trays and screw
   it down (6 screws, all reachable from above).
4. Bolt a brick bay to the rear of each tray (2 screws each, from inside the bay).
5. Push the keystone couplers in from the front until they click.
6. Rack it, then tighten the M4s once the depth looks right.
7. Slide each PC in from the front. Slide its rear stop forward until it touches the
   bottom of the rear face, tighten, then fit the front lip.
8. Bricks go in crosswise with their mains-cord ends facing outboard, DC ends toward the
   centre. Strap them down. DC leads run forward to each machine's power jack; coil the
   slack in the free two-thirds of the bay.
9. Video leads go inboard behind the tray, into the centre gap, then forward along the
   cable floor to the back of the keystones. Zip-tie them to the slot pairs in the cable
   floor and the anchors along the inboard edge of each brick bay.

## Servicing

Undo two screws, lift the front lip off, and the machine slides straight out the front.
The rear stop stays put — it's a set-once adjustment, not a service item.

## Customising

```
openscad -o tray_left.stl -D 'part="tray_left"' cad/rack_1u_micro.scad
```

| Parameter | Default | Effect |
|---|---|---|
| `dev_w`, `dev_d`, `dev_h` | 182, 183, 36 | device envelope |
| `stop_h` | 8 | how far up the rear face the rear stop reaches |
| `cf_y0` | 44 | where the cable floor starts; the lower video plug has to clear it |
| `brk_row_z`, `brk_row_dz` | 9.4, 23.8 | bracket hole rows — change these if your brackets measure differently |
| `wall_o` | 11 | outer wall; must stay thick enough to hold the ear-bolt pockets |
| `ear_c0`, `ear_travel` | 22, 16 | first bracket hole column at mid-travel, and the fore-aft travel of the slots |
| `bb_depth` | 90 | brick bay depth |
| `ks_gap` | 4 | vertical gap between the stacked keystone apertures |

## Known limitations

- **Thermal:** both machines exhaust rearward toward the brick bay. There's a ~29 mm
  plenum, an open vent grid under the bricks and an open rear, but two adapters sitting in
  a 1U exhaust stream is not a configuration I can promise runs cool. If it does run hot,
  the brick bays unbolt and move to their own U without touching anything else.
- The Lenovo brick's 35 mm thickness leaves 6.5 mm of headroom in the U, so nothing can
  sit on top of it. Straps pass under and around, not over.
- Verified against the bracket drawing, not against a bracket in hand. Check the 23.8 mm
  row spacing with calipers before printing both trays; it's a one-parameter fix.
- Front-rail mounting only. The numbers say that's fine — 0.4 mm of creep deflection over
  a warm year — but an asymmetrically loaded shelf will still twist slightly, which is
  what the tie plate is there to resist.
