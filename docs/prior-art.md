# Prior art

Public designs surveyed on 2026-09-19 and 2026-09-20, and what was taken from each.
None met all the requirements in the README.

## Closest overall — Turaj Pilehvar, "Dell Micro PC 1U Rack Mount"
https://www.printables.com/model/775243-dell-micro-pc-1u-rack-mount

Two Dell Micros and both power supplies in 1U, with cable management. The only free
design found that handles bricks at full two-machine density.

- **Layout:** PCs flat at the front with faces in the panel, power supplies directly
  behind them, printed cross-bars strapping both rows down, cable exit at the rear
  centre. Essentially the same architecture as ours, arrived at independently.
- **Material:** shown in PLA+.
- **Construction:** printed pins, then glued or friction-welded — the author and at
  least one builder found welding necessary for rigidity. Permanent; not serviceable.
- **Gaps for us:** Dell only, no keystone, printed ears, STL only (no CAD exists).
- **From the comments:** one user wanted a Lenovo Tiny remix; another tried to remix
  via Fusion 360, couldn't work with the STLs, and redrew from scratch; one asked for
  a front RJ45; one advised making sure the shelf is supported in the centre. No
  reports of heat, warping or sag across the whole thread.

## Others

| Design | What it does well | Why not for us |
|---|---|---|
| [PNW_PRNTR, Lenovo dual 1U](https://makerworld.com/en/models/923893-lenovo-thinkcentre-dual-1u-19-inch-rackmount) | Two Tinys, front keystone, slide in/out from the front with a rear stop | No brick handling, printed ears |
| [noamf, Dell Micro 1U](https://www.printables.com/model/644173-dell-micro-1u-rack-mount) | Well reviewed; M4 through-bolts; clear material advice | No keystone, no bricks |
| [simbaja, Lenovo Tiny 1U](https://www.thingiverse.com/thing:4769452) | Variant that bolts to steel Penn-Elcom ears | Single machine |
| [harebonse, Lenovo Tiny](https://makerworld.com/en/models/619346-lenovo-tiny-thinkcentre-19-rack-mount) | Accommodates the 135 W PSU; STEP file | Single machine |
| [Modular 19" system](https://www.printables.com/model/179524-modular-19-inch-rack-mounting-system) | Modular, pinned, bricks beside the PCs, Fusion source | Bricks beside halves the density; no keystone |
| [Mauker, modular blanks](https://makerworld.com/en/models/770165) | A genuine half-width module ecosystem with STEP files | No micro-PC module, no bricks |

## Lessons adopted

- **Face-down printing** is the community standard for printed ears. Adopted as
  reasoning, then made moot by steel ears (DECISIONS.md D7).
- **Metal in the joints:** through-bolts and nuts beat plastic threads (D9).
- **Steel ears** exist as an established option (D8).
- **Centre support** matters once racked (D10).
- **Retention:** a recurring complaint about tray designs was nothing holding the
  machine in; ours has a rear stop and front lip (D12, D13).
