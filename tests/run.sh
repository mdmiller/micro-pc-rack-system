#!/usr/bin/env bash
# Interference, clearance and alignment checks for the whole assembly.
# Usage: bash tests/run.sh      (needs openscad and python3)
# "zero" tests must come back at (near) zero volume; "block" tests must not.
set -uo pipefail
cd "$(dirname "$0")"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
TESTS="tray_keystone_L:zero tray_keystone_R:zero tray_lip_L:zero tray_lip_R:zero
tray_stop_L:zero tray_stop_R:zero trays_tie:zero tray_bricks_L:zero tray_bricks_R:zero
tray_device_L:zero tray_device_R:zero tray_tray:zero keystone_tie:zero
pullout_L:zero pullout_R:zero lip_blocks_L:block lip_blocks_R:block
lip_holes_L:zero lip_holes_R:zero pilot_vs_pocket:zero lip_clear_of_face:zero
m4_hw_seated:zero m4_hw_insertable:zero m4_past_travel:block
bb_tab_rooted_L:block
tray_cf:zero keystone_cf:zero tie_cf:zero bricks_cf:zero cf_holes:zero ziptie_void:zero
rear_face_open_L:zero stop_meets_face_L:block
stop_screws_L:zero stop_screws_R:zero keystone_side_clear:zero"
fail=0
for t in $TESTS; do
  name=${t%%:*}; kind=${t##*:}
  openscad --export-format asciistl -o "$TMP/$name.stl" \
    -D 'part="none"' -D "test=\"$name\"" check.scad >/dev/null 2>&1
  v=$(python3 - "$TMP/$name.stl" <<'PY'
import sys, os
f=sys.argv[1]; V=0.0; vs=[]
if os.path.exists(f):
    for l in open(f, errors='ignore'):
        s=l.split()
        if s and s[0]=='vertex':
            vs.append([float(x) for x in s[1:4]])
            if len(vs)==3:
                a,b,c=vs
                V+=(a[0]*(b[1]*c[2]-b[2]*c[1])-a[1]*(b[0]*c[2]-b[2]*c[0])+a[2]*(b[0]*c[1]-b[1]*c[0]))/6
                vs=[]
print(f"{abs(V):.2f}")
PY
)
  # pull-out corridors graze the opening's 2 mm corner radii (~1.1 mm^3); allow 2
  if [ "$kind" = zero ]; then ok=$(python3 -c "print(float('$v')<2)"); else ok=$(python3 -c "print(float('$v')>100)"); fi
  if [ "$ok" = True ]; then printf "PASS  %-20s %10s mm3\n" "$name" "$v"
  else printf "FAIL  %-20s %10s mm3  (want %s)\n" "$name" "$v" "$kind"; fail=1; fi
done
[ $fail = 0 ] && echo "all checks passed" || { echo "SOME CHECKS FAILED"; exit 1; }
