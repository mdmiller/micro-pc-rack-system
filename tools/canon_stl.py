#!/usr/bin/env python3
"""Rewrite binary STLs in a canonical form so identical geometry gives identical bytes.

OpenSCAD's triangle order varies between environments, which makes every rebuild
look like a change in git. Here each triangle's vertices are rotated so the
smallest comes first (winding, and therefore the normal, is preserved) and the
triangles are then sorted. The geometry is untouched.
Usage: python3 tools/canon_stl.py file.stl [file.stl ...]
"""
import struct, sys

def canonicalise(path):
    data = open(path, 'rb').read()
    n = struct.unpack('<I', data[80:84])[0]
    if len(data) != 84 + 50 * n:
        sys.exit(f"{path}: not a binary STL")
    tris = []
    for i in range(n):
        rec = data[84 + i*50 : 84 + i*50 + 50]
        normal = rec[0:12]
        v = [rec[12:24], rec[24:36], rec[36:48]]
        k = min(range(3), key=lambda j: struct.unpack('<3f', v[j]))
        v = v[k:] + v[:k]                       # rotate, keeping the winding
        tris.append(b''.join(v) + normal)
    tris.sort()
    out = [data[:80], struct.pack('<I', n)]
    for t in tris:
        out.append(t[36:48] + t[0:36] + b'\0\0')
    open(path, 'wb').write(b''.join(out))

for p in sys.argv[1:]:
    canonicalise(p)
