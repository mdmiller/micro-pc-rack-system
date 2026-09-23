// Geometry checks. Run via tests/run.sh, not directly.
// Each test renders an intersection; the runner measures its volume.
include <../cad/rack_1u_micro.scad>
test = "";

// Machines sit where the front lip holds them: front face at y = 0 (D32).
module dev(x0){ translate([x0+fit,0,floor_t]) cube([dev_w,dev_d,dev_h]); }
module devL(){ dev(bay_x0); }
module devR(){ dev(body_w-bay_x0-bay_w); }
module corrL(){ hull(){ devL(); translate([0,-260,0]) devL(); } }   // pull-out path
module corrR(){ hull(){ devR(); translate([0,-260,0]) devR(); } }
lipLx = lip_x0;  lipRx = body_w - lip_x0 - lip_len;
module lipL(){ translate([lipLx,-lip_t,floor_t]) front_lip(); }
module lipR(){ translate([lipRx,-lip_t,floor_t]) front_lip(); }
module stopL(d=dev_d){ translate([bay_cx-ret_w/2,d,floor_t+pad_t]) rear_stop(); }
module stopR(d=dev_d){ translate([body_w-bay_cx-ret_w/2,d,floor_t+pad_t]) rear_stop(); }
module tieP(){ translate([seam_l-wall_i,tray_d-30,wall_hi]) tie_plate(); }
module bbL(){ translate([0,tray_d,0]) brick_bay(); }
module bbR(){ translate([body_w,tray_d,0]) mirror([1,0,0]) brick_bay(); }
// thin rods down each lip hole *as placed*: they must pass cleanly into the pilots
module lipRods(x0){ for(h=[lip_edge, lip_len-lip_edge])
  translate([x0+h,0.5,lip_scr_z]) rotate([-90,0,0]) cylinder(d=2.0,h=5); }
// voids modelled as solids, so void-vs-void contact can be measured
module outerPilot(){ translate([lip_scr_x[0],-eps,lip_scr_z]) rotate([-90,0,0]) cylinder(d=d_pilot,h=ear_y_min-1); }
module openingAboveLip(){ translate([bay_x0,-10,floor_t+lip_h]) cube([bay_w,10,dev_h]); }
// M4 x 12 button head on the 1.5 mm steel web: shank x -1.5..10.5, square nut
// (DIN 557) skin_t..skin_t+nut_m. 'ins' sweeps the nut in from the bay, which is
// the only way it can get there. Checked at both ends of travel, all 4 holes.
module xcyl(d,x0,x1,fn=40){ translate([x0,0,0]) rotate([0,90,0]) cylinder(d=d,h=x1-x0,$fn=fn); }
module sqnut(x0) translate([x0, -nut_s/2, -nut_s/2]) cube([nut_m, nut_s, nut_s]);
module m4hw(ins){
  xcyl(4,-brk_t,-brk_t+12);
  if (ins) hull(){ sqnut(skin_t); sqnut(wall_o+2); } else sqnut(skin_t);
}
module m4all(ins,past=0){ for(z=brk_z, c=[0,1], e=[-1,1])
  translate([0, ear_c0+c*brk_col_dy+e*(ear_travel/2+past), z]) m4hw(ins); }

if (test=="tray_keystone_L")  intersection(){ tray_left();  keystone(); }
if (test=="tray_keystone_R")  intersection(){ tray_right(); keystone(); }
if (test=="tray_lip_L")       intersection(){ tray_left();  lipL(); }
if (test=="tray_lip_R")       intersection(){ tray_right(); lipR(); }
if (test=="tray_stop_L")      intersection(){ tray_left();  stopL(); }
if (test=="tray_stop_R")      intersection(){ tray_right(); stopR(); }
if (test=="trays_tie")        intersection(){ union(){ tray_left(); tray_right(); } tieP(); }
if (test=="tray_bricks_L")    intersection(){ tray_left();  bbL(); }
if (test=="tray_bricks_R")    intersection(){ tray_right(); bbR(); }
if (test=="tray_device_L")    intersection(){ tray_left();  devL(); }
if (test=="tray_device_R")    intersection(){ tray_right(); devR(); }
if (test=="tray_tray")        intersection(){ tray_left();  tray_right(); }
if (test=="keystone_tie")     intersection(){ keystone();   tieP(); }
if (test=="pullout_L")        intersection(){ tray_left();  corrL(); }
if (test=="pullout_R")        intersection(){ tray_right(); corrR(); }
if (test=="lip_blocks_L")     intersection(){ lipL(); corrL(); }
if (test=="lip_blocks_R")     intersection(){ lipR(); corrR(); }
if (test=="lip_holes_L")      intersection(){ tray_left();  lipRods(lipLx); }
if (test=="lip_holes_R")      intersection(){ tray_right(); lipRods(lipRx); }
if (test=="pilot_vs_pocket")  intersection(){ outerPilot(); ear_pockets(); }
if (test=="lip_clear_of_face")intersection(){ lipL(); openingAboveLip(); }
if (test=="m4_hw_seated")     intersection(){ tray_left(); m4all(false); }
if (test=="m4_hw_insertable") intersection(){ tray_left(); m4all(true); }
if (test=="m4_past_travel")   intersection(){ tray_left(); m4all(false, 4); } // must hit
// the nut can't spin: its full turning circle (the 9.9 mm diagonal) must hit wall
module nutSpin() for(z=brk_z, c=[0,1], e=[-1,1])
  translate([skin_t, ear_c0+c*brk_col_dy+e*ear_travel/2, z]) rotate([0,90,0]) cylinder(d=nut_s*sqrt(2), h=nut_m);
if (test=="m4_nut_cannot_spin") intersection(){ tray_left(); nutSpin(); }
// the brick bay's inner mounting tab must reach the floor (it once floated 4 mm above it)
module innerTabRoot(){ translate([seam_l-wall_i, tray_d, floor_t+1]) cube([wall_i, 4, 8-(floor_t+1)]); }
if (test=="bb_tab_rooted_L")  intersection(){ bbL(); innerTabRoot(); }
// cable floor, rear stop band, zip-tie clearance
module cfP(){ translate([seam_l+0.3,cf_y0,ledge_h]) cable_floor(); }
module cfRods(){ for(x=[seam_l+ledge_w/2, seam_r-ledge_w/2], y=cf_scr_y)      // M3 x 6 cores
  translate([x,y,ledge_h+cf_t-6]) cylinder(d=2.6,h=6); }
module zipVoid(){ translate([seam_l+ledge_w+0.5,cf_y0,0]) cube([key_w-2*ledge_w-1,tray_d-cf_y0,ledge_h]); }
module rearFaceAbove(){ translate([bay_x0+fit,dev_d,floor_t+stop_h]) cube([dev_w,1,dev_h-stop_h]); }
module rearFaceBand(){  translate([bay_x0+fit,dev_d,floor_t]) cube([dev_w,1,stop_h]); }
if (test=="tray_cf")          intersection(){ union(){ tray_left(); tray_right(); } cfP(); }
if (test=="keystone_cf")      intersection(){ keystone(); cfP(); }
if (test=="tie_cf")           intersection(){ tieP(); cfP(); }
if (test=="bricks_cf")        intersection(){ union(){ bbL(); bbR(); } cfP(); }
if (test=="cf_holes")         intersection(){ union(){ tray_left(); tray_right(); cfP(); } cfRods(); }
if (test=="ziptie_void")      intersection(){ union(){ tray_left(); tray_right(); keystone(); cfP(); } zipVoid(); }
if (test=="rear_face_open_L") intersection(){ stopL(); rearFaceAbove(); }
if (test=="stop_meets_face_L")intersection(){ stopL(); rearFaceBand(); }

// Screw cores are 2.6 mm: inside a 2.7 pilot they measure zero, but a tip that runs
// past the pilot bottom into the skin below shows up above the 2 mm3 threshold.
// M3 x 8 (the BOM screw) plus 0.5 mm, so the tip still clears if the 3 mm foot prints thin
module stopRods(cx){ for(dx=[-20,20]) translate([cx+dx,ret_y,floor_t+2*pad_t-8.5]) cylinder(d=2.6,h=8.5); }
if (test=="stop_screws_L")    intersection(){ tray_left();  stopRods(bay_cx); }
if (test=="stop_screws_R")    intersection(){ tray_right(); stopRods(body_w-bay_cx); }
// the keystone panel must keep >= 0.25 mm each side between the tray panels
if (test=="keystone_side_clear") intersection(){ keystone();
  union(){ translate([0.25,0,0]) tray_left(); translate([-0.25,0,0]) tray_right(); } }
// Rear video plugs (D26). The jacks are rotated, so each plug stands on its long edge.
// Slim HDMI head 16 x 6.6 x 14 mm; coupler rear face 24 or 32 mm behind the panel
// front (couplers vary), so both depths are checked.
module plug(zc,yf) translate([body_w/2-3.3, yf, zc-8]) cube([6.6, 14, 16]);
module plugs(yf) { plug(ks_z[0],yf); plug(ks_z[1],yf); }
if (test=="plug_vs_keystone") intersection(){ keystone(); union(){ plugs(24); plugs(32); } }
if (test=="plug_vs_cf")       intersection(){ cfP(); union(){ plugs(24); plugs(32); } }
if (test=="plug_vs_plug")     union(){ intersection(){ plug(ks_z[0],24); plug(ks_z[1],24); }
                                       intersection(){ plug(ks_z[0],32); plug(ks_z[1],32); } }
// the relief must not break through: 2 mm of flange stays over it
if (test=="flange_over_relief") intersection(){ keystone();
  translate([body_w/2-ks_relief_w/2, ks_wall+panel_t, wall_hi+ks_relief_d]) cube([ks_relief_w, flange_l-ks_wall, flange_t-ks_relief_d]); }
// Braces (D27): present, and clear of latch travel and the bay screwdrivers
if (test=="ks_braces_present")  intersection(){ keystone(); for (x0=[seam_l+ks_clr, seam_r-ks_clr-ks_brace_w])
  translate([x0, panel_t, wall_hi-8]) cube([ks_brace_w, 3, 8]); }
if (test=="bb_braces_present_L") intersection(){ bbL(); union(){
  translate([seam_l-wall_i, tray_d+4, floor_t+2]) cube([wall_i, 4, 5]);
  translate([0, tray_d+4, bb_lip]) cube([wall_o, 2, 2]); } }
module latchZone() for (zc=ks_z) translate([body_w/2-ks_w/2-2.5, panel_t, zc-ks_h/2]) cube([ks_w+5, 30, ks_h]);
if (test=="ks_latch_room")      intersection(){ keystone(); latchZone(); }
module bayDrivers() for (x=[wall_o/2, seam_l-wall_i/2])   // M3 pan head + screwdriver along y
  translate([x, tray_d+4, 20]) rotate([-90,0,0]) cylinder(d=6, h=bb_d);
if (test=="bb_driver_clear_L")  intersection(){ bbL(); bayDrivers(); }
// Rack width (D28): with the steel webs and M4 button heads (ISO 7380: 7.6 mm x 2.2 mm)
// fitted, the shelf must clear the measured rail opening by rack_margin each side.
module earHeads(){ for (s=[0,1], z=brk_z, c=[0,1])
  translate([s==0 ? -brk_t : body_w+brk_t, ear_c0+c*brk_col_dy, z]) rotate([0,s==0?-90:90,0]) cylinder(d=7.6, h=2.2); }
module outsideEnvelope(){ half=rack_open/2-rack_margin;
  translate([body_w/2-half-50,-10,-10]) cube([50,260,70]); translate([body_w/2+half,-10,-10]) cube([50,260,70]); }
if (test=="rack_width_margin") intersection(){ union(){ tray_left(); tray_right(); earHeads(); } outsideEnvelope(); }
// #15 fixes (D30)
// plastic between the plenum slot and the front velcro slots must be solid
if (test=="bb_plenum_velcro_rib") intersection(){ bbL(); for (x=[30,70,110,150])
  translate([x-2.5, tray_d+10, 0]) cube([5, 2.5, floor_t+1]); }
// the velcro strap path under the floor is recessed (clear up to z 1.8)
if (test=="velcro_groove_clear") intersection(){ bbL(); for (x0=[30,110], y=[20.5,93])
  translate([x0+3, tray_d+y-7.5, 0]) cube([34, 15, 1.8]); }
// the keystone's face-down perimeter is chamfered: nothing within 0.25 mm of the edge at y < 0.2
if (test=="ks_face_chamfered") intersection(){ keystone(); difference(){
  translate([seam_l+ks_clr, 0, 0]) cube([key_w-2*ks_clr, 0.2, panel_h]);
  translate([seam_l+ks_clr+0.25, -1, 0.25]) cube([key_w-2*ks_clr-0.5, 2, panel_h-0.5]); } }

// ---------------------------------------------------------------------------
// Unsupported overhangs in print orientation (D31). Each part is sliced every
// ov_dz; material not within 45 deg of the slice below is unsupported. An
// opening of ov_open removes slivers narrower than 2*ov_open (the caps of small
// horizontal holes, which bridge trivially). Each slice is extruded ov_h tall so
// the runner's volume threshold sees small areas. Everything left must sit in
// that part's allow-list: bridges that print as bridges, and the features that
// need support in this orientation. A new overhang anywhere else fails.
ov_dz = 0.4; ov_open = 1.3; ov_h = 5;
module ovSlice(z) projection(cut=true) translate([0,0,-z]) children();
module unsupported(H) for (i=[1:ceil(H/ov_dz)]) {
  z = (i+0.5)*ov_dz;
  translate([0,0,i*ov_dz]) linear_extrude(ov_h)
    offset(r=ov_open) offset(delta=-ov_open)
      difference(){ ovSlice(z) children(); offset(r=ov_dz+0.05) ovSlice(z-ov_dz) children(); }
}
ovH = [["tray_left",panel_h],["tray_right",panel_h],["keystone",key_w+2*wall_i],["brick_bay",32],
       ["front_lip",lip_t],["rear_stop",stop_h],["tie_plate",flange_t],["cable_floor",cf_t]];
function ovHeight(p) = ovH[search([p],ovH)[0]][1];
// Allow-lists, in each part's print coordinates. Every box reaches ov_h + 1 above
// its band so it covers the measuring extrusion.
module ovTrayAllow() {                                   // left tray; mirrored for right
  translate([bay_x0-1, -1, open_z1-1]) cube([bay_w+2, panel_t+2, panel_h-open_z1+ov_h+3]); // strip over the opening: NEEDS SUPPORT
  for (z=brk_z, c=[0,1]) { y0 = ear_c0+c*brk_col_dy-ear_travel/2;                        // ear-bolt pocket + slot roofs: bridges
    translate([-1, y0-(nut_s+nut_clr)/2-1, z]) cube([wall_o+2, ear_travel+nut_s+nut_clr+2, (nut_s+nut_clr)/2+ov_h+2]); }
  for (i=[0:2]) translate([seam_l-wall_i-1, panel_t+55+i*42+15-16, wall_hi/2-1+11-5])     // inner-wall vent roofs: bridges
    cube([wall_i+2, 32, 5+ov_h+2]);
}
module ovAllow(p) {
  if (p=="tray_left")  ovTrayAllow();
  if (p=="tray_right") translate([body_w,0,0]) mirror([1,0,0]) ovTrayAllow();
  if (p=="keystone") for (x0=[-1, key_w+wall_i-ks_clr])                                   // flange wings: NEEDS SUPPORT
    translate([x0, 0, panel_t-1]) cube([wall_i+ks_clr+1, panel_h, ov_h+3]);
  if (p=="brick_bay") {
    for (x0=[30,110], y=[20.5,93]) translate([x0-1, y-9, 1]) cube([42, 18, 1+ov_h+2]);    // velcro groove roofs: bridges
    for (y=[30,60,90]) translate([169, y-3.5, 0.6]) cube([18, 7, 1+ov_h+2]);              // zip-tie groove roofs: bridges
  }
}
module ovCheck(p) difference(){ unsupported(ovHeight(p)+1) printed(p); ovAllow(p); }
for (p=["tray_left","tray_right","keystone","brick_bay","front_lip","rear_stop","tie_plate","cable_floor"])
  if (test==str("ov_",p)) ovCheck(p);
// control: with no allow-list the keystone's flange wings must be caught
if (test=="ov_control_wings") unsupported(ovHeight("keystone")+1) printed("keystone");
// debugging: -D 'test="ov_raw"' -D 'ov_part="brick_bay"' exports everything flagged
ov_part = "tray_left";
if (test=="ov_raw") unsupported(ovHeight(ov_part)+1) printed(ov_part);

// ---------------------------------------------------------------------------
// D32
// The rear stop must set snug against every machine in dev_depths: with the stop's
// face at that depth, an M3 through each pad pilot must pass cleanly through its slot.
module stopPilotRods() for (dx=[-20,20]) translate([bay_cx+dx, ret_y, 0]) cylinder(d=3.0, h=20);
for (k=[0:len(dev_depths)-1])
  if (test==str("stop_reaches_", k)) intersection(){ stopL(dev_depths[k]); stopPilotRods(); }
// Front lip screws: M3 x 12 pan heads on the lip face, 2.6 mm cores (+0.5 margin) must
// sit inside the tray pilots without reaching their bottoms.
module lipScrews(x0) for(h=[lip_edge, lip_len-lip_edge])
  translate([x0+h,-lip_t,lip_scr_z]) rotate([-90,0,0]) cylinder(d=2.6,h=12.5);
if (test=="lip_screws_L") intersection(){ tray_left();  lipScrews(lipLx); }
if (test=="lip_screws_R") intersection(){ tray_right(); lipScrews(lipRx); }
// Floor vents: the top edge of every cell is chamfered (a 1 mm ring just below the
// top face, outside each cell, must be clear).
module ventRing() for (i=[0:vent_n[0]-1], j=[0:vent_n[1]-1])
  translate([0,0,floor_t-0.3]) linear_extrude(0.3) difference(){ vent_cell(i,j,1.0); vent_cell(i,j); }
if (test=="vents_chamfered") intersection(){ tray_left(); ventRing(); }

