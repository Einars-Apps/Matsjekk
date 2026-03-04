#!/usr/bin/env python3
"""Build a shared locality cache for farmshops lookups.

Input:
  docs/data/farmshops.json
Output:
  docs/data/farmshops_area_cache.json
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
IN_FILE = ROOT / "docs" / "data" / "farmshops.json"
OUT_FILE = ROOT / "docs" / "data" / "farmshops_area_cache.json"

MAX_ITEMS_PER_KEY = 120
MAX_KEYS = 1200

COUNTRY_CODE_BY_NAME = {
    "norway": "NO",
    "sweden": "SE",
    "denmark": "DK",
    "finland": "FI",
    "germany": "DE",
    "netherlands": "NL",
    "belgium": "BE",
    "france": "FR",
    "italy": "IT",
    "portugal": "PT",
    "spain": "ES",
    "united kingdom": "GB",
    "ireland": "IE",
    "austria": "AT",
    "switzerland": "CH",
    "liechtenstein": "LI",
    "luxembourg": "LU",
}


def locality_token(value: Any) -> str:
    return (
        str(value or "")
        .strip()
        .lower()
        .replace("ø", "o")
        .replace("æ", "ae")
        .replace("å", "a")
    )


def country_code_for_shop(shop: dict[str, Any]) -> str:
    explicit = str(shop.get("countryCode") or "").strip().upper()
    if explicit:
        return explicit
    country_name = locality_token(shop.get("country"))
    return COUNTRY_CODE_BY_NAME.get(country_name, "ANY")


def cache_key(country_code: str, region: str, municipality: str, query: str) -> str:
    cc = (country_code or "ANY").upper()
    return "|".join(
        [
            cc,
            locality_token(region) or "-",
            locality_token(municipality) or "-",
            locality_token(query) or "-",
        ]
    )


def normalized_shop(shop: dict[str, Any], country_code: str) -> dict[str, Any] | None:
    name = str(shop.get("name") or "").strip()
    if not name:
        return None

    lat = shop.get("lat")
    lon = shop.get("lon")
    try:
        lat_value = float(lat)
        lon_value = float(lon)
    except (TypeError, ValueError):
        return None

    return {
        "name": name,
        "countryCode": country_code,
        "country": str(shop.get("country") or "").strip(),
        "region": str(shop.get("region") or "").strip(),
        "municipality": str(shop.get("municipality") or "").strip(),
        "address": str(shop.get("address") or "").strip(),
        "products": shop.get("products") if isinstance(shop.get("products"), list) else [],
        "website": str(shop.get("website") or "").strip(),
        "lat": lat_value,
        "lon": lon_value,
        "category": str(shop.get("category") or "Gårdsutsalg").strip(),
        "phone": str(shop.get("phone") or "").strip(),
        "openingHours": str(shop.get("openingHours") or "").strip(),
        "mapsUrl": str(shop.get("mapsUrl") or "").strip(),
    }


def main() -> None:
    if not IN_FILE.exists():
        raise FileNotFoundError(f"Missing input file: {IN_FILE}")

    with IN_FILE.open("r", encoding="utf-8") as file:
        source = json.load(file)

    if not isinstance(source, list):
        raise ValueError("Expected docs/data/farmshops.json to be a JSON array")

    buckets: dict[str, list[dict[str, Any]]] = {}

    for shop in source:
        if not isinstance(shop, dict):
            continue
        country_code = country_code_for_shop(shop)
        normalized = normalized_shop(shop, country_code)
        if not normalized:
            continue

        region = normalized.get("region", "")
        municipality = normalized.get("municipality", "")

        keys = {
            cache_key(country_code, region, municipality, ""),
            cache_key(country_code, "", municipality, ""),
            cache_key(country_code, region, "", ""),
            cache_key(country_code, "", "", municipality),
            cache_key(country_code, region, municipality, municipality),
        }

        for key in keys:
            buckets.setdefault(key, []).append(normalized)

    out_rows = []
    for key, items in buckets.items():
        seen = set()
        unique = []
        for item in items:
            signature = (
                locality_token(item.get("name")),
                item.get("lat"),
                item.get("lon"),
            )
            if signature in seen:
                continue
            seen.add(signature)
            unique.append(item)

        if not unique:
            continue

        out_rows.append(
            {
                "key": key,
                "updatedAt": None,
                "shops": unique[:MAX_ITEMS_PER_KEY],
            }
        )

    out_rows.sort(key=lambda row: (-len(row.get("shops", [])), row.get("key", "")))
    out_rows = out_rows[:MAX_KEYS]

    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with OUT_FILE.open("w", encoding="utf-8") as file:
        json.dump(out_rows, file, ensure_ascii=False, indent=2)

    print(f"Wrote {len(out_rows)} cached locality buckets to {OUT_FILE}")


if __name__ == "__main__":
    main()
