#!/usr/bin/env bash
# Regenerate every printable part from the OpenSCAD source.
# Usage: bash build.sh        (needs openscad and python3 on PATH)
set -euo pipefail
cd "$(dirname "$0")"
SRC=cad/rack_1u_micro.scad
# Everyone builds with the same OpenSCAD, so an STL diff means a shape change and not
# a different tessellation (D25). Bump this and rebuild every STL in the same commit.
OPENSCAD_VERSION=2026.09.18
have=$(openscad --version 2>&1 | awk '{print $3}')
if [ "$have" != "$OPENSCAD_VERSION" ]; then
  echo "warning: OpenSCAD $have, but this repo is pinned to $OPENSCAD_VERSION." >&2
  echo "         STLs may change in their triangles without any change in shape." >&2
fi
mkdir -p stl
for p in tray_left tray_right keystone front_lip rear_stop tie_plate cable_floor; do
  echo "rendering $p"
  openscad --export-format binstl -o "stl/$p.stl" -D "part=\"$p\"" "$SRC"
done
echo "canonicalising"
python3 tools/canon_stl.py stl/*.stl
echo "done"
