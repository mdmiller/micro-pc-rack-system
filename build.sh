#!/usr/bin/env bash
# Regenerate every printable part from the OpenSCAD source.
# Usage: bash build.sh        (needs openscad and python3 on PATH)
set -euo pipefail
cd "$(dirname "$0")"
SRC=cad/rack_1u_micro.scad
mkdir -p stl
for p in tray_left tray_right keystone front_lip rear_stop tie_plate cable_floor brick_bay; do
  echo "rendering $p"
  openscad --export-format binstl -o "stl/$p.stl" -D "part=\"$p\"" "$SRC"
done
echo "canonicalising"
python3 tools/canon_stl.py stl/*.stl
echo "done"
