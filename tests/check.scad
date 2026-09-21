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
// M4 x 12 button head on the 1.5 mm steel web: shank x -1.5..10.5, washer
// 6.5..7.3, nut 7.3..10.5. 'ins' sweeps washer and nut in from the bay, which is
// the only way they can get there. Checked at both ends of travel, all 4 holes.
module xcyl(d,x0,x1,fn=40){ translate([x0,0,0]) rotate([0,90,0]) cylinder(d=d,h=x1-x0,$fn=fn); }
module m4hw(ins){
  xcyl(4,-brk_t,-brk_t+12);
  if (ins) { hull(){ xcyl(9,skin_t,skin_t+0.8); xcyl(9,wall_o+2,wall_o+2.8); }
             hull(){ xcyl(8.08,skin_t+0.8,skin_t+4,6); xcyl(8.08,wall_o+2,wall_o+5.2,6); } }
  else { xcyl(9,skin_t,skin_t+0.8); xcyl(8.08,skin_t+0.8,skin_t+4,6); }
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
// the brick bay's inner mounting tab must reach the floor (it once floated 4 mm above it)
module innerTabRoot(){ translate([seam_l-wall_i, tray_d, floor_t+1]) cube([wall_i, 4, 8-(floor_t+1)]); }
if (test=="bb_tab_rooted_L")  intersection(){ bbL(); innerTabRoot(); }
