#!/usr/bin/env python3
"""Report ARB values that are still identical to the English template (untranslated)."""
from __future__ import annotations

import glob
import json
import os

L10N_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "lib", "l10n")
TEMPLATE = "app_en.arb"
# Keys whose value is intentionally the same across languages (brand/proper nouns)
ALLOW_SAME = {"appName", "norwegian", "english"}


def real_items(d: dict) -> dict:
    return {k: v for k, v in d.items() if not k.startswith("@") and isinstance(v, str)}


def main() -> int:
    files = sorted(glob.glob(os.path.join(L10N_DIR, "app_*.arb")))
    data = {os.path.basename(f): json.load(open(f, encoding="utf-8-sig")) for f in files}
    en = real_items(data[TEMPLATE])
    for name, d in data.items():
        if name in (TEMPLATE, "app_nb.arb"):
            continue
        items = real_items(d)
        same = [k for k, v in items.items() if k in en and v == en[k] and k not in ALLOW_SAME]
        print(f"{name}: untranslated={len(same)}")
        if same:
            print("   " + ", ".join(sorted(same)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
