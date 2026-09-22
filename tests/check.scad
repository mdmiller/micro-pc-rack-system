// Geometry checks. Run via tests/run.sh, not directly.
// Each test renders an intersection; the runner measures its volume.
include <../cad/rack_1u_micro.scad>
test = "";

module dev(x0){ translate([x0+fit,panel_t,floor_t]) cube([dev_w,dev_d,dev_h]); }
module devL(){ dev(bay_x0); }
module devR(){ dev(body_w-bay_x0-bay_w); }
module corrL(){ hull(){ devL(); translate([0,-260,0]) devL(); } }   // pull-out path
module corrR(){ hull(){ devR(); translate([0,-260,0]) devR(); } }
lipLx = lip_x0;  lipRx = body_w - lip_x0 - lip_len;
module lipL(){ translate([lipLx,-lip_t,floor_t]) front_lip(); }
module lipR(){ translate([lipRx,-lip_t,floor_t]) front_lip(); }
module stopL(){ translate([bay_cx-ret_w/2,panel_t+dev_d,floor_t+pad_t]) rear_stop(); }
module stopR(){ translate([body_w-bay_cx-ret_w/2,panel_t+dev_d,floor_t+pad_t]) rear_stop(); }
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
module rearFaceAbove(){ translate([bay_x0+fit,panel_t+dev_d,floor_t+stop_h]) cube([dev_w,1,dev_h-stop_h]); }
module rearFaceBand(){  translate([bay_x0+fit,panel_t+dev_d,floor_t]) cube([dev_w,1,stop_h]); }
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

