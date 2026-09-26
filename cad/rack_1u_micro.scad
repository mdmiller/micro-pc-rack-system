// =====================================================================
//  MODULAR 19" MICRO-PC RACK SYSTEM  —  v3
//  1U shelf: two 1-litre micro PCs, front-loading, stacked keystone bay,
//  power bricks in each tray's rear section.  Mounts on steel rack ears
//  (Penn-Elcom R1206/1U or equivalent) — no printed ear.
//
//  x = 0 at the left rail face, y = 0 at the rack face, z = 0 at the
//  bottom of the U.  Units: millimetres.
//
//  © 2026 Matt Miller and contributors.  Licence: CC BY-NC-SA 4.0
//  SPDX-License-Identifier: CC-BY-NC-SA-4.0
// =====================================================================

/* [Part to render] */
part = "tray_left"; // [tray_left,tray_right,keystone,front_lip,rear_stop,tie_plate,cable_floor,assembly]
show_devices = true;

/* [Rack + steel bracket] */
rack_u      = 1;
u_h         = 44.45;
panel_gap   = 0.8;
panel_t     = 6;
brk_h       = 43.8;    // bracket leg height
brk_row_z   = 9.4;     // lowest hole, up from bracket bottom edge
brk_row_dz  = 23.8;    // vertical spacing of the two hole rows
brk_col_dy  = 110;     // depth spacing of the two hole columns
brk_len     = 139.4;   // bracket web length
brk_t       = 1.5;     // bracket steel thickness
rack_open   = 450.85;  // measured clear width between the front rails (#5)
rack_margin = 2.0;     // minimum clearance per side, across the ear-bolt heads (D28)

/* [Device] */
dev_w = 182;
dev_d = 183;
dev_h = 36;
fit   = 1;
dev_depths = [178, 183]; // machines the rear stop must reach: Dell 7060 Micro, Lenovo Tiny (D32)

/* [Structure] */
wall_o   = 11;    // outer wall — carries the M4 ear-bolt pockets
wall_i   = 8;     // inner wall — carries the keystone, tie-plate and lip screws
key_w    = 33;    // narrowest the braced, rotated jacks allow (D28)
floor_t  = 3;
tray_d   = 206;
pad_t    = 3;
flange_t = 3;
flange_l = 30;

/* [M4 ear bolts] */
nut_s    = 7.0;   // M4 square nut (DIN 557) across flats; the pocket is sized to it
nut_m    = 3.2;   // nut thickness
nut_clr  = 0.4;   // pocket clearance over nut_s; the diagonal (9.9) can't turn in it
skin_t   = 7.3;   // solid outer skin the bolt passes through
bolt_slot = 4.5;  // M4 clearance slot height
ear_c0   = 22;    // first bracket hole column at mid-travel, from the rack face
ear_travel = 16;  // fore-aft adjustment of the shelf against the bracket

/* [Keystone] */
ks_w  = 19.3;     // aperture, rotated 90 deg (stacked pair)
ks_h  = 14.8;
ks_gap = 4;
ks_wall = 2.8;
ks_clr = 0.5;     // side clearance of the keystone panel in the gap between trays
ks_chamfer = 0.5; // 45-deg chamfer on the face-down edges: eats elephant's foot (D30)
ks_relief_d = 1.0;  // relief in the flange underside over the upper rear video plug,
ks_relief_w = 9;    // so a slim (16 mm) HDMI head clears it — D26

/* [Braces] — D27 */
ks_brace   = 12;   // keystone panel-to-flange braces, leg length
ks_brace_w = 3.7;  // each sits in the strip outside the jacks, clear of latch travel

/* [Floor vents] */
vent_chamfer = 1.5; // 45-deg top-edge chamfer so rubber feet ride out of the vents (D32)

/* [Rear stop] */
stop_h = 8;       // top of the stop face above the tray floor; the stop touches
                  // only this band of the rear face, so any port layout clears it

/* [Cable floor] */
cf_y0   = 50;     // starts behind the lower rear video plug's head (slim HDMI, D26)
cf_ext  = 16;     // overhang past the tray rear, into the gap between brick bays
cf_t    = 3;
ledge_w = 8;      // ledge on each inner wall that carries the cable floor (2.65 mm
                  // of plastic either side of its M3 pilot, D30)
ledge_h = 4;      // also the zip-tie clearance under the floor

/* [Brick bay] — the rear section of each tray (D34) */
bb_front = 12;    // open plenum slot at the front of the bay
bb_depth = 82;
bb_rear  = 16;    // rear rib: deep so it resists twist, which is what stiffens the tray
lead_y   = [4, 39]; // window in the inner wall for the video leads, from the bay front
lead_h   = 20;
cord_x   = [15, 45]; // mains-cord hole through the rear rib
cord_h   = 20;
bb_clear = 25;    // bay depth kept clear behind the machines' rear plugs; the
                  // bricks' front edges sit here, located by the strap row

/* [Bricks] — calipered 2026-09-25 (D33); L x W x T, laid crosswise so W runs
   front to back and T stands up */
bricks   = [[107, 46, 29],   // Lenovo 65 W slim
            [128, 66, 23]];  // Dell 90 W
strap_w  = 16;               // velcro strap width; the slots and grooves fit it
strap_y  = 48;               // one slot row, centred on the narrower brick
strap_x  = [30, 70, 110, 150]; // two loops per brick, (30,70) and (110,150)
strap_loop = 40;             // slot pitch of a loop; the groove runs between them
vent_rows = [[15, 22], [59, 32]]; // bay-y start and height of each vent row:
                                  // ahead of and behind the strap row

/* [Hardware] */
d_pilot = 2.7;
d_free  = 3.4;
d_csk   = 6.6;

/* [Hidden] */
csk_h = (d_csk - d_free)/2;   // 90-degree countersink, truncated at the clearance hole
$fn = 40;
eps = 0.01;

// ---------------------- derived ----------------------
panel_h = rack_u*u_h - panel_gap;
bay_w   = dev_w + 2*fit;
body_w  = 2*bay_w + 2*wall_o + 2*wall_i + key_w;
seam_l  = wall_o + bay_w + wall_i;
seam_r  = body_w - seam_l;
bay_x0  = wall_o;
bay_cx  = bay_x0 + bay_w/2;
wall_ho = 42;                       // outer wall height
wall_hi = floor_t + dev_h;          // inner wall height = device top
open_z0 = floor_t;
open_z1 = floor_t + dev_h + 1.0;
brk_z   = [for (r=[0,1]) (u_h-brk_h)/2 + brk_row_z + r*brk_row_dz];
scr_y   = [panel_t+10, panel_t+24];
tie_y   = [tray_d-22, tray_d-8];
ret_y   = tray_d-10;                 // stop reaches 175.5-186.5 mm deep machines (D32)
ret_w   = 64;
pad_y0  = tray_d-14;
lip_h     = 5;                          // bar height across the opening
lip_t     = 6;                          // 6 deep: stiff to handle; M3 x 12 screws (D32)
lip_tab_h = 11;                         // taller tabs over the two wall strips
lip_tab_w = 8;
lip_scr_x = [wall_o/2, seam_l-wall_i/2];// tray x of the two lip screws
lip_edge  = wall_i/2;                   // hole centre to lip end, both ends
lip_x0    = lip_scr_x[0] - lip_edge;
lip_len   = seam_l - lip_x0;            // symmetric: same part fits either tray
lip_scr_z = floor_t + lip_tab_h/2;
bb_d    = bb_front + bb_depth + bb_rear;
tie_yr  = [bb_d-22, bb_d-8];             // rear tie plate, in bay coordinates
cf_w    = key_w - 0.6;
cf_len  = tray_d + cf_ext - cf_y0;
cf_scr_y = [58, 112, 170];          // clear of the keystone flange and tie plate

module rr(w,h,r=2) { offset(r=r) square([w-2*r,h-2*r],center=true); }
module yprism(x,z,len) { translate([x,-eps,z]) rotate([-90,0,0]) linear_extrude(len) children(); }

// =====================================================================
//  TRAY
// =====================================================================
// One pocket per bracket hole, open to the bay: a square nut slides in from
// inside before the PC does, the bolt comes in from outside through the slot.
// The pocket is nut-height, so the nut's 9.9 mm diagonal can't turn in it; it
// only slides fore-aft with the travel. Every roof is a short bridge. (D29)
ear_y_min = ear_c0 - ear_travel/2 - (nut_s+nut_clr)/2;   // front edge of the front pockets
module ear_pockets() {
  for (z = brk_z, c = [0,1]) {
    y0 = ear_c0 + c*brk_col_dy - ear_travel/2;
    translate([-1, y0-bolt_slot/2, z-bolt_slot/2])
      cube([skin_t+1+eps, ear_travel+bolt_slot, bolt_slot]);            // bolt slot
    translate([skin_t, y0-(nut_s+nut_clr)/2, z-(nut_s+nut_clr)/2])
      cube([wall_o-skin_t+1, ear_travel+nut_s+nut_clr, nut_s+nut_clr]); // square nut
  }
}

// Vent cell (i,j) in 2D; grow > 0 enlarges it (the top-edge chamfer, and the tests).
vent_n = [3, 4];
module vent_cell(i, j, grow=0) {
  rib=10;
  x0=bay_x0+14; x1=bay_x0+bay_w-14;
  y0=panel_t+18; y1=panel_t+dev_d-18;
  cw=((x1-x0)-(vent_n[0]-1)*rib)/vent_n[0];  ch=((y1-y0)-(vent_n[1]-1)*rib)/vent_n[1];
  translate([x0+i*(cw+rib)+cw/2, y0+j*(ch+rib)+ch/2]) rr(cw+2*grow, ch+2*grow, 3+grow);
}
module floor_vents() {
  for (i=[0:vent_n[0]-1], j=[0:vent_n[1]-1]) {
    translate([0,0,-eps]) linear_extrude(floor_t+2*eps) vent_cell(i,j);
    hull() {                                    // chamfer, per cell: a machine's feet
      translate([0,0,floor_t-vent_chamfer]) linear_extrude(eps) vent_cell(i,j);  // ride
      translate([0,0,floor_t]) linear_extrude(eps) vent_cell(i,j,vent_chamfer);  // out
    }
  }
}

module inner_wall_vents() {
  for (i=[0:2])
    translate([seam_l-wall_i/2, panel_t+55+i*42+15, wall_hi/2-1])
      rotate([0,90,0]) linear_extrude(wall_i+14, center=true) rr(22,30,4);
}

module tray_left() { tray_front(); translate([0, tray_d, 0]) brick_bay(); }  // one part (D34)

module tray_front() {
  difference() {
    union() {
      cube([seam_l, panel_t, panel_h]);                                  // panel
      translate([0, panel_t, 0]) cube([seam_l, tray_d-panel_t, floor_t]);// floor
      translate([0, panel_t, 0]) cube([wall_o, tray_d-panel_t, wall_ho]);// outer wall
      translate([seam_l-wall_i, panel_t, 0])
        cube([wall_i, tray_d-panel_t, wall_hi]);                         // inner wall
      translate([bay_cx-ret_w/2, pad_y0, floor_t])
        cube([ret_w, tray_d-pad_y0, pad_t]);                             // rear-stop pad
      translate([seam_l, cf_y0, 0]) cube([ledge_w, tray_d-cf_y0, ledge_h]);// cable-floor ledge
    }
    yprism(bay_x0+bay_w/2, (open_z0+open_z1)/2, panel_t+2*eps)
      rr(bay_w, open_z1-open_z0, 2);                                     // PC face opening
    ear_pockets();
    for (x=lip_scr_x)                                                    // front lip pilots
      translate([x, -eps, lip_scr_z]) rotate([-90,0,0])                  // outer stops short
        cylinder(d=d_pilot, h=(x < wall_o) ? ear_y_min-1 : 9);           // of the ear pocket
    for (y=scr_y)                                                        // keystone flange
      translate([seam_l-wall_i/2, y, wall_hi-16]) cylinder(d=d_pilot, h=17);
    for (y=tie_y)                                                        // tie plate
      translate([seam_l-wall_i/2, y, wall_hi-16]) cylinder(d=d_pilot, h=17);
    for (dx=[-20,20])                                                    // rear stop
      translate([bay_cx+dx, ret_y, 0.6]) cylinder(d=d_pilot, h=floor_t+pad_t);  // M3 x 8 tip clears
    for (y=cf_scr_y)                                                     // cable floor
      translate([seam_l+ledge_w/2, y, 0.4]) cylinder(d=d_pilot, h=ledge_h);
    floor_vents();
    inner_wall_vents();
  }
}

module tray_right() { translate([body_w,0,0]) mirror([1,0,0]) tray_left(); }

// =====================================================================
//  KEYSTONE MODULE  (two apertures stacked, rotated 90 deg)
// =====================================================================
ks_z = [panel_h/2 - (ks_h+ks_gap)/2, panel_h/2 + (ks_h+ks_gap)/2];

// The panel prints face-down; a 45-degree chamfer round its front perimeter
// removes the first-layer flare that would eat the 0.5 mm side clearance.
module ks_face_chamfer() {
  x0 = seam_l+ks_clr;  w = key_w-2*ks_clr;  c = ks_chamfer;
  difference() {
    translate([x0-1, -1, -1]) cube([w+2, 1+c, panel_h+2]);
    hull() { translate([x0+c, 0, c]) cube([w-2*c, eps, panel_h-2*c]);
             translate([x0, c-eps, 0]) cube([w, eps, panel_h]); }
  }
}
module keystone() {
  difference() {
    union() {
      translate([seam_l+ks_clr, 0, 0]) cube([key_w-2*ks_clr, panel_t, panel_h]);
      translate([seam_l-wall_i, panel_t, wall_hi])
        cube([key_w+2*wall_i, flange_l, flange_t]);
      for (x0=[seam_l+ks_clr, seam_r-ks_clr-ks_brace_w])             // braces: the panel
        translate([x0,0,0]) rotate([90,0,90]) linear_extrude(ks_brace_w) // hangs from this joint
          polygon([[panel_t,wall_hi],[panel_t,wall_hi-ks_brace],[panel_t+ks_brace,wall_hi]]);
    }
    translate([body_w/2-ks_relief_w/2, ks_wall+panel_t, wall_hi-eps])    // plug relief, clear of
      cube([ks_relief_w, flange_l-ks_wall+eps, ks_relief_d+eps]);      // the panel joint at y=6
    ks_face_chamfer();
    for (z = ks_z) {
      yprism(body_w/2, z, panel_t+2*eps) square([ks_w, ks_h], center=true);
      hull() {                                                        // aperture front chamfer
        translate([body_w/2, -eps, z]) rotate([-90,0,0]) linear_extrude(eps) square([ks_w+2*ks_chamfer, ks_h+2*ks_chamfer], center=true);
        translate([body_w/2, ks_chamfer, z]) rotate([-90,0,0]) linear_extrude(eps) square([ks_w, ks_h], center=true);
      }
      translate([body_w/2, ks_wall, z]) rotate([-90,0,0])
        linear_extrude(panel_t) square([ks_w+2, ks_h+2], center=true);
    }
    for (x=[seam_l-wall_i/2, seam_r+wall_i/2], y=scr_y) {
      translate([x,y,wall_hi-eps]) cylinder(d=d_free, h=flange_t+2*eps);
      translate([x,y,wall_hi+flange_t-csk_h]) cylinder(d1=d_free,d2=d_csk,h=csk_h+eps);
    }
  }
}

// =====================================================================
//  FRONT LIP  (removable forward stop, sits on the panel face)
// =====================================================================
module front_lip() {
  difference() {
    union() {
      cube([lip_len, lip_t, lip_h]);
      cube([lip_tab_w, lip_t, lip_tab_h]);
      translate([lip_len-lip_tab_w, 0, 0]) cube([lip_tab_w, lip_t, lip_tab_h]);
    }
    for (x=[lip_edge, lip_len-lip_edge])                 // M3 pan head, no countersink
      translate([x, -eps, lip_tab_h/2]) rotate([-90,0,0]) cylinder(d=d_free, h=lip_t+2*eps);
  }
}

// =====================================================================
//  REAR STOP
// =====================================================================
module stop_profile() {             // a low curb: catches only the bottom edge
  polygon([[0,0],[26,0],[26,pad_t],[5,pad_t],[5,stop_h-pad_t],[0,stop_h-pad_t]]);
}
module rear_stop() {
  difference() {
    rotate([0,0,90]) rotate([90,0,0]) linear_extrude(ret_w) stop_profile();
    for (dx=[-20,20])
      translate([ret_w/2+dx,15,-1]) hull() for(s=[-1,1])
        translate([0,s*5.5,0]) cylinder(d=d_free,h=pad_t+2);
  }
}

// =====================================================================
//  TIE PLATE
// =====================================================================
module tie_plate() {
  difference() {
    cube([key_w+2*wall_i, 30, flange_t]);
    for (x=[wall_i/2, key_w+1.5*wall_i], y=[8,22]) {
      translate([x,y,-eps]) cylinder(d=d_free,h=flange_t+2*eps);
      translate([x,y,flange_t-csk_h]) cylinder(d1=d_free,d2=d_csk,h=csk_h+eps);
    }
  }
}

// =====================================================================
//  CABLE FLOOR  (spans the centre channel on the two ledges; video leads
//  run forward on it to the keystones, zip ties pass underneath)
// =====================================================================
module cable_floor() {
  difference() {
    cube([cf_w, cf_len, cf_t]);
    for (x=[ledge_w/2-0.3, cf_w-ledge_w/2+0.3], y=cf_scr_y)
      translate([x, y-cf_y0, -eps]) cylinder(d=d_free, h=cf_t+2*eps);
    for (y=[20:30:cf_len-10], dx=[-6,6])                     // zip-tie slot pairs
      translate([cf_w/2+dx, y, -eps]) linear_extrude(cf_t+2*eps) square([2.2,5],center=true);
  }
}

// =====================================================================
//  BRICK BAY  (rear section of each tray, printed with it; D34). The outer
//  wall, the inner wall and a deep rear rib make it a stiff frame that
//  holds up the inner wall's rear end, so the tray can't sag at the seam.
// =====================================================================
module brick_bay() {
  difference() {
    union() {
      cube([seam_l, bb_d, floor_t+1]);                              // floor
      cube([wall_o, bb_d, wall_ho]);                                // outer wall
      translate([seam_l-wall_i, 0, 0]) cube([wall_i, bb_d, wall_hi]); // inner wall
      translate([0, bb_d-bb_rear, 0]) cube([seam_l, bb_rear, wall_hi]); // rear rib
    }
    translate([wall_o+8, 2, -eps]) cube([seam_l-wall_o-30, bb_front-4, floor_t+2]); // plenum slot
    for (x=strap_x)                                          // velcro strap slots, one
      translate([x, strap_y, -eps]) linear_extrude(floor_t+2) rr(5,strap_w,2); // row (D33)
    for (x0=[strap_x[0], strap_x[2]])                        // strap recessed under the
      translate([x0, strap_y-strap_w/2, -eps]) cube([strap_loop, strap_w, 2+eps]); // floor
    for (i=[0:2], r=vent_rows)                               // vent grid: a row each side
      translate([wall_o+26+i*52, r[0]+r[1]/2, -eps])         // of the strap row
        linear_extrude(floor_t+2) rr(40,r[1],4);
    translate([seam_l-wall_i-1, lead_y[0], floor_t+1])       // video-lead window
      cube([wall_i+2, lead_y[1]-lead_y[0], lead_h]);
    translate([cord_x[0], bb_d-bb_rear-1, floor_t+1])        // mains-cord hole
      cube([cord_x[1]-cord_x[0], bb_rear+2, cord_h]);
    for (y=tie_yr)                                           // rear tie plate
      translate([seam_l-wall_i/2, y, wall_hi-16]) cylinder(d=d_pilot, h=17);
    for (y=[30,60,90]) {                                     // zip-tie anchors: slot
      for (x=[170,186])                                      // pairs, strap recessed
        translate([x, y, -eps]) linear_extrude(floor_t+2) square([2.2,5],center=true);
      translate([170, y-2.5, -eps]) cube([16, 5, 1.6]);      // in an underside groove
    }
  }
}

// =====================================================================
//  ASSEMBLY
// =====================================================================
module ghost(x0) { %translate([x0+fit, 0, floor_t]) cube([dev_w,dev_d,dev_h]); }  // against the lip
module steel_ear(x, mir) {
  translate([x,0,(u_h-brk_h)/2]) mirror([mir,0,0]) %union() {
    cube([brk_t, brk_len, brk_h]);
    translate([-20,0,0]) cube([20, brk_t, brk_h]);
  }
}
module assembly() {
  tray_left(); tray_right(); keystone();
  translate([lip_x0, -lip_t, floor_t]) front_lip();
  translate([body_w-lip_x0-lip_len, -lip_t, floor_t]) front_lip();
  for (cx=[bay_cx, body_w-bay_cx])
    translate([cx-ret_w/2, dev_d, floor_t+pad_t]) rear_stop();
  for (y=[tray_d-30, tray_d+bb_d-30]) translate([seam_l-wall_i, y, wall_hi]) tie_plate();
  translate([seam_l+0.3, cf_y0, ledge_h]) cable_floor();
  steel_ear(-brk_t,0); steel_ear(body_w+brk_t,1);
  if (show_devices) { ghost(bay_x0); ghost(body_w-bay_x0-bay_w); }
}

// ---------------------- render ----------------------
// Each part in its print orientation. build.sh exports these; tests/run.sh
// checks them for unsupported overhangs (D31).
module printed(p) {
  if      (p=="tray_left")   tray_left();
  else if (p=="tray_right")  tray_right();
  else if (p=="keystone")    translate([-seam_l+wall_i, panel_h, 0]) rotate([90,0,0]) keystone();
  else if (p=="front_lip")   translate([0, lip_tab_h, 0]) rotate([90,0,0]) front_lip();  // face down
  else if (p=="rear_stop")   rear_stop();
  else if (p=="tie_plate")   tie_plate();
  else if (p=="cable_floor") cable_floor();
}
if      (part=="none")     { }                 // used by tests/run.sh
else if (part=="assembly") assembly();
else                       printed(part);
