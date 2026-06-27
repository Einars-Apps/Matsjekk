#!/usr/bin/env python3
"""Audit ARB localisation files: report missing/extra keys vs the English template."""
from __future__ import annotations

import glob
import json
import os
import sys

L10N_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "lib", "l10n")
TEMPLATE = "app_en.arb"


def real_keys(d: dict) -> set[str]:
    return {k for k in d if not k.startswith("@")}


def main() -> int:
    files = sorted(glob.glob(os.path.join(L10N_DIR, "app_*.arb")))
    data = {os.path.basename(f): json.load(open(f, encoding="utf-8-sig")) for f in files}
    if TEMPLATE not in data:
        print(f"ERROR: template {TEMPLATE} not found", file=sys.stderr)
        return 1
    tmpl = real_keys(data[TEMPLATE])
    print(f"Template ({TEMPLATE}) keys: {len(tmpl)}\n")
    for name, d in data.items():
        keys = real_keys(d)
        missing = sorted(tmpl - keys)
        extra = sorted(keys - tmpl)
        flag = "OK" if not missing and not extra else "NEEDS WORK"
        print(f"[{flag}] {name}: total={len(keys)} missing={len(missing)} extra={len(extra)}")
        if missing:
            print("   missing: " + ", ".join(missing[:40]) + (" ..." if len(missing) > 40 else ""))
        if extra:
            print("   extra:   " + ", ".join(extra[:40]) + (" ..." if len(extra) > 40 else ""))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
