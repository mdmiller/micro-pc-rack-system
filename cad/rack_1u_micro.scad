// =====================================================================
//  MODULAR 19" MICRO-PC RACK SYSTEM  —  v3
//  1U shelf: two 1-litre micro PCs, front-loading, stacked keystone bay,
//  bolt-on rear power-brick bay.  Mounts on steel rack ears
//  (Penn-Elcom R1206/1U or equivalent) — no printed ear.
//
//  x = 0 at the left rail face, y = 0 at the rack face, z = 0 at the
//  bottom of the U.  Units: millimetres.
//
//  © 2026 Matt Miller and contributors.  Licence: CC BY-NC-SA 4.0
//  SPDX-License-Identifier: CC-BY-NC-SA-4.0
// =====================================================================

/* [Part to render] */
part = "tray_left"; // [tray_left,tray_right,keystone,front_lip,rear_stop,tie_plate,cable_floor,brick_bay,assembly]
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
ks_clr = 0.3;     // side clearance of the keystone panel in the gap between trays
ks_relief_d = 1.0;  // relief in the flange underside over the upper rear video plug,
ks_relief_w = 9;    // so a slim (16 mm) HDMI head clears it — D26

/* [Braces] — D27 */
ks_brace   = 12;   // keystone panel-to-flange braces, leg length
ks_brace_w = 3.7;  // each sits in the strip outside the jacks, clear of latch travel
bb_brace   = 11;   // brick bay inner tab brace; tops out below the M3 head at z 20
bb_brace_o = 4.5;  // brick bay outer tab brace, above the outer lip

/* [Rear stop] */
stop_h = 8;       // top of the stop face above the tray floor; the stop touches
                  // only this band of the rear face, so any port layout clears it

/* [Cable floor] */
cf_y0   = 50;     // starts behind the lower rear video plug's head (slim HDMI, D26)
cf_ext  = 16;     // overhang past the tray rear, into the gap between brick bays
cf_t    = 3;
ledge_w = 6;      // ledge on each inner wall that carries the cable floor
ledge_h = 4;      // also the zip-tie clearance under the floor

/* [Brick bay] */
bb_front = 12;    // open plenum slot at the front of the module
bb_depth = 90;
bb_rear  = 8;
bb_lip   = 12;

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
ret_y   = tray_d-6;
ret_w   = 64;
pad_y0  = tray_d-14;
lip_h     = 5;                          // bar height across the opening
lip_t     = 3;
lip_tab_h = 11;                         // taller tabs over the two wall strips
lip_tab_w = 8;
lip_scr_x = [wall_o/2, seam_l-wall_i/2];// tray x of the two lip screws
lip_edge  = wall_i/2;                   // hole centre to lip end, both ends
lip_x0    = lip_scr_x[0] - lip_edge;
lip_len   = seam_l - lip_x0;            // symmetric: same part fits either tray
lip_scr_z = floor_t + lip_tab_h/2;
bb_d    = bb_front + bb_depth + bb_rear;
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

module floor_vents() {
  nx=3; ny=4; rib=10;
  x0=bay_x0+14; x1=bay_x0+bay_w-14;
  y0=panel_t+18; y1=panel_t+dev_d-18;
  cw=((x1-x0)-(nx-1)*rib)/nx;  ch=((y1-y0)-(ny-1)*rib)/ny;
  for (i=[0:nx-1], j=[0:ny-1])
    translate([x0+i*(cw+rib)+cw/2, y0+j*(ch+rib)+ch/2, -eps])
      linear_extrude(floor_t+2*eps) rr(cw,ch,3);
}

module inner_wall_vents() {
  for (i=[0:2])
    translate([seam_l-wall_i/2, panel_t+55+i*42+15, wall_hi/2-1])
      rotate([0,90,0]) linear_extrude(wall_i+14, center=true) rr(22,30,4);
}

module tray_left() {
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
    for (x=[wall_o/2, seam_l-wall_i/2])                                  // brick-bay pilots
      translate([x, tray_d-14, 20]) rotate([-90,0,0]) cylinder(d=d_pilot, h=15);
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
    for (z = ks_z) {
      yprism(body_w/2, z, panel_t+2*eps) square([ks_w, ks_h], center=true);
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
    for (y=[20:30:cf_len-10], dx=[-8,8])                     // zip-tie slot pairs
      translate([cf_w/2+dx, y, -eps]) linear_extrude(cf_t+2*eps) square([2.2,5],center=true);
  }
}

// =====================================================================
//  BRICK BAY MODULE  (one per side; the centre gap is the cable run)
// =====================================================================
module brick_bay() {
  difference() {
    union() {
      cube([seam_l, bb_d, floor_t+1]);                       // floor
      cube([wall_o, bb_d, bb_lip]);                          // outer lip
      translate([0, bb_d-bb_rear, 0]) cube([seam_l, bb_rear, bb_lip]);  // rear lip
      for (x=[0, seam_l-wall_i])                             // front mounting tabs
        translate([x, 0, 0]) cube([x==0?wall_o:wall_i, 4, 32]); // from the floor: the
                                                               // inner edge has no lip
      translate([seam_l-wall_i,0,0]) rotate([90,0,90]) linear_extrude(wall_i)   // tab braces
        polygon([[4,floor_t+1],[4,floor_t+1+bb_brace],[4+bb_brace,floor_t+1]]);
      rotate([90,0,90]) linear_extrude(wall_o)
        polygon([[4,bb_lip],[4,bb_lip+bb_brace_o],[4+bb_brace_o,bb_lip]]);
    }
    translate([wall_o+8, 2, -eps]) cube([seam_l-wall_o-30, bb_front-4, floor_t+2]); // plenum slot
    for (x=[30,70,110,150], y=[18, 93])                      // velcro strap slots
      translate([x, y, -eps]) linear_extrude(floor_t+2) rr(5,16,2);
    for (i=[0:2], j=[0:1])                                   // vent grid
      translate([wall_o+26+i*52, 42+j*30, -eps])
        linear_extrude(floor_t+2) rr(40,22,4);
    for (x=[wall_o/2, seam_l-wall_i/2])                      // tray bolt holes
      translate([x,-eps,20]) rotate([-90,0,0]) cylinder(d=d_free,h=6);
    translate([15, bb_d-bb_rear-eps, 3]) cube([30, bb_rear+2, bb_lip]); // cord notch
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
module ghost(x0) { %translate([x0+fit, panel_t, floor_t]) cube([dev_w,dev_d,dev_h]); }
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
    translate([cx-ret_w/2, panel_t+dev_d, floor_t+pad_t]) rear_stop();
  translate([seam_l-wall_i, tray_d-30, wall_hi]) tie_plate();
  translate([seam_l+0.3, cf_y0, ledge_h]) cable_floor();
  translate([0,tray_d,0]) brick_bay();
  translate([body_w,tray_d,0]) mirror([1,0,0]) brick_bay();
  steel_ear(-brk_t,0); steel_ear(body_w+brk_t,1);
  if (show_devices) { ghost(bay_x0); ghost(body_w-bay_x0-bay_w); }
}

// ---------------------- render ----------------------
if      (part=="none")       { }                 // used by tests/run.sh
else if (part=="tray_left")  tray_left();
else if (part=="tray_right") tray_right();
else if (part=="keystone")   translate([-seam_l+wall_i, panel_h, 0]) rotate([90,0,0]) keystone();
else if (part=="front_lip")  translate([0, lip_tab_h, 0]) rotate([90,0,0]) front_lip();  // flat, show face down
else if (part=="rear_stop")  rear_stop();
else if (part=="tie_plate")  tie_plate();
else if (part=="cable_floor") cable_floor();
else if (part=="brick_bay")  brick_bay();
else                         assembly();
