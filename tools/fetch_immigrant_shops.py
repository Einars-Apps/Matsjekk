#!/usr/bin/env python3
"""Build a baseline dataset of immigrant shops in Norway.

Sources:
- OpenStreetMap Overpass (name + shop tag filtering)
- Nominatim lookups for required manual seeds (Asker Supermarked, Fudi)
"""

from __future__ import annotations

import json
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / "docs" / "data" / "immigrant_shops.json"
EXAMPLE_FILE = ROOT / "docs" / "data" / "immigrant_shops.example.json"
AREA_CACHE_FILE = ROOT / "docs" / "data" / "immigrant_shops_area_cache.json"
BY_COUNTRY_DIR = ROOT / "docs" / "data" / "immigrant_shops_by_country"

OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://lz4.overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]

KEYWORD_RE = (
    "halal|bazaar|bazar|asia|asian|oriental|international|internasjonal|"
    "import|world food|africa|afro|turkish|pakistan|arab|middle east|"
    "polski|polish|balkan|fudi"
)

QUERY = f"""
[out:json][timeout:120];
area["ISO3166-1"="NO"][admin_level=2]->.searchArea;
(
  node["shop"~"supermarket|convenience"]["name"~"({KEYWORD_RE})",i](area.searchArea);
  way["shop"~"supermarket|convenience"]["name"~"({KEYWORD_RE})",i](area.searchArea);
  relation["shop"~"supermarket|convenience"]["name"~"({KEYWORD_RE})",i](area.searchArea);
);
out center tags;
"""


def _to_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _normalize_website(value):
    raw = (value or "").strip()
    if not raw:
        return None
    if raw.startswith("http://") or raw.startswith("https://"):
        return raw
    return f"https://{raw}"


def _address_from_tags(tags):
    street = (tags.get("addr:street") or "").strip()
    number = (tags.get("addr:housenumber") or "").strip()
    postcode = (tags.get("addr:postcode") or "").strip()
    city = (tags.get("addr:city") or tags.get("addr:municipality") or "").strip()
    parts = [" ".join([street, number]).strip(), postcode, city]
    merged = ", ".join([p for p in parts if p])
    return merged or None


def fetch_overpass_candidates():
    last_error = None
    for endpoint in OVERPASS_ENDPOINTS:
        try:
            response = requests.post(endpoint, data={"data": QUERY}, timeout=180)
            response.raise_for_status()
            payload = response.json()
            rows = payload.get("elements", []) if isinstance(payload, dict) else []
            if not isinstance(rows, list):
                rows = []
            print(f"Fetched {len(rows)} raw OSM candidates via {endpoint}")
            return rows
        except Exception as error:  # noqa: BLE001
            last_error = error
            print(f"Overpass failed via {endpoint}: {error}")
    raise RuntimeError(f"Overpass failed on all endpoints: {last_error}")


def to_item(element):
    tags = element.get("tags") or {}
    if not isinstance(tags, dict):
        tags = {}

    lat = _to_float(element.get("lat"))
    lon = _to_float(element.get("lon"))
    center = element.get("center") if isinstance(element.get("center"), dict) else {}
    if lat is None:
        lat = _to_float(center.get("lat"))
    if lon is None:
        lon = _to_float(center.get("lon"))
    if lat is None or lon is None:
        return None

    name = (tags.get("name") or "").strip()
    if not name:
        return None

    municipality = (tags.get("addr:municipality") or tags.get("addr:city") or "").strip() or None
    region = (tags.get("addr:state") or tags.get("addr:county") or "").strip() or None

    return {
        "id": f"immigrant_osm_{element.get('type')}_{element.get('id')}",
        "name": name,
        "country": "Norway",
        "region": region,
        "municipality": municipality,
        "products": ["International food", "Imported goods"],
        "website": _normalize_website(tags.get("website") or tags.get("contact:website")),
        "lat": lat,
        "lon": lon,
        "address": _address_from_tags(tags),
        "category": "Innvandrerbutikk",
        "source": f"https://www.openstreetmap.org/{element.get('type')}/{element.get('id')}",
    }


def add_manual_asker_items(items):
    manual = [
        # User-confirmed Asker stores. Asker Supermarked uses a provisional
        # center-point coordinate in Asker until exact coordinate is verified.
        ("Asker Supermarked", 59.8333, 10.4376, "https://www.google.com/maps/search/?api=1&query=Asker+Supermarked+Asker"),
        ("Fudi", 59.8556786, 10.490474, "https://www.openstreetmap.org/node/5178084238"),
    ]

    for name, lat, lon, source_url in manual:
        items.append(
            {
                "id": f"immigrant_manual_{name.lower().replace(' ', '_')}",
                "name": name,
                "country": "Norway",
                "region": "Akershus",
                "municipality": "Asker",
                "products": ["International food", "Imported goods"],
                "website": None,
                "lat": lat,
                "lon": lon,
                "address": None,
                "category": "Innvandrerbutikk",
                "source": source_url,
            }
        )


def dedupe(items):
    seen = set()
    out = []
    for item in items:
        key = (
            (item.get("name") or "").strip().lower(),
            round(float(item.get("lat") or 0.0), 5),
            round(float(item.get("lon") or 0.0), 5),
        )
        if key in seen:
            continue
        seen.add(key)
        out.append(item)
    return out


def fill_missing_admin_fields(items):
    # Keep generation deterministic and fast; avoid bulk reverse-geocoding rate limits.
    for item in items:
        name = (item.get("name") or "").strip().lower()
        lat = _to_float(item.get("lat"))
        lon = _to_float(item.get("lon"))

        # User-verified: Fudi in Asker.
        if name == "fudi" and lat is not None and lon is not None:
            if abs(lat - 59.8556786) < 0.01 and abs(lon - 10.490474) < 0.01:
                item["municipality"] = "Asker"
                item["region"] = "Akershus"
            elif abs(lat - 59.9462184) < 0.01 and abs(lon - 10.6430174) < 0.01:
                item["municipality"] = "Oslo"
                item["region"] = "Oslo"

        if not item.get("municipality"):
            item["municipality"] = None
        if not item.get("region"):
            item["region"] = None


def main():
    elements = fetch_overpass_candidates()
    items = []
    for element in elements:
        item = to_item(element)
        if item:
            items.append(item)

    add_manual_asker_items(items)
    items = dedupe(items)
    fill_missing_admin_fields(items)
    items = sorted(items, key=lambda row: (row.get("name") or "").lower())

    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding="utf-8")

    preview = items[: min(120, len(items))]
    EXAMPLE_FILE.write_text(json.dumps(preview, ensure_ascii=False, indent=2), encoding="utf-8")
    AREA_CACHE_FILE.write_text("[]\n", encoding="utf-8")

    BY_COUNTRY_DIR.mkdir(parents=True, exist_ok=True)
    (BY_COUNTRY_DIR / "no.json").write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Wrote {len(items)} immigrant shops to {OUT_FILE}")


if __name__ == "__main__":
    main()
