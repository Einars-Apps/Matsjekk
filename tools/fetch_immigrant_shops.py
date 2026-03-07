#!/usr/bin/env python3
"""Build a baseline dataset of immigrant shops in Norway.

Sources:
- OpenStreetMap Overpass (name + shop tag filtering)
- Deterministic seed file for verified chain locations
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / "docs" / "data" / "immigrant_shops.json"
EXAMPLE_FILE = ROOT / "docs" / "data" / "immigrant_shops.example.json"
AREA_CACHE_FILE = ROOT / "docs" / "data" / "immigrant_shops_area_cache.json"
BY_COUNTRY_DIR = ROOT / "docs" / "data" / "immigrant_shops_by_country"
CHAIN_SEED_FILE = ROOT / "docs" / "data" / "immigrant_chain_seeds.json"

OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://lz4.overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]

BASE_KEYWORDS = [
    "halal",
    "bazaar",
    "bazar",
    "asia",
    "asian",
    "oriental",
    "international",
    "internasjonal",
    "import",
    "world food",
    "africa",
    "afro",
    "turkish",
    "pakistan",
    "arab",
    "middle east",
    "polski",
    "polish",
    "balkan",
    "thai",
]

CHAIN_KEYWORDS = ["fudi", "sultan", "global food", "alanya"]


def _keyword_regex():
    parts = BASE_KEYWORDS + CHAIN_KEYWORDS
    return "|".join(parts)


QUERY = f"""
[out:json][timeout:120];
area["ISO3166-1"="NO"][admin_level=2]->.searchArea;
(
    node["shop"~"supermarket|convenience|greengrocer"]["name"~"({_keyword_regex()})",i](area.searchArea);
    way["shop"~"supermarket|convenience|greengrocer"]["name"~"({_keyword_regex()})",i](area.searchArea);
    relation["shop"~"supermarket|convenience|greengrocer"]["name"~"({_keyword_regex()})",i](area.searchArea);
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


def _slugify_name(value):
    slug = re.sub(r"[^a-z0-9]+", "_", (value or "").lower())
    return slug.strip("_")


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
                "id": f"immigrant_manual_{_slugify_name(name)}",
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


def add_manual_oslo_items(items):
    manual = [
        ("Gronlands Torg Frukt & Gront", 59.9126200, 10.7591270, "https://www.openstreetmap.org/node/1749088463"),
        ("Marmaris Dagligvare", 59.9291030, 10.7673080, "https://www.openstreetmap.org/node/2361432405"),
        ("Chili dagligvarer", 59.9283532, 10.7608199, "https://www.openstreetmap.org/node/2364176930"),
        ("Easy Lavpris Gronland", 59.9123400, 10.7639250, "https://www.openstreetmap.org/node/2622716030"),
        ("Papaya Frukt & Gront AS", 59.9551852, 10.7852672, "https://www.openstreetmap.org/node/2740178582"),
        ("All In One", 59.9132334, 10.7653029, "https://www.openstreetmap.org/node/3650497113"),
        ("Istanbul", 59.8476584, 10.8041906, "https://www.openstreetmap.org/node/3666621787"),
        ("Vart Marked", 59.9624890, 10.9225210, "https://www.openstreetmap.org/node/3682978409"),
        ("A Food Market", 59.9164774, 10.7540620, "https://www.openstreetmap.org/node/4343892492"),
        ("Nye pakstar", 59.9143280, 10.7633310, "https://www.openstreetmap.org/node/4589703068"),
        ("Elma", 59.9193471, 10.7624064, "https://www.openstreetmap.org/node/5091617746"),
        ("Jood dagligvare", 59.9378481, 10.7317499, "https://www.openstreetmap.org/node/5099558121"),
        ("Tayyib Halal Mat", 59.9132123, 10.7604273, "https://www.openstreetmap.org/node/5592979339"),
        ("Pasha Frukt og Gront", 59.9638171, 10.8924640, "https://www.openstreetmap.org/node/6699369415"),
    ]

    for name, lat, lon, source_url in manual:
        items.append(
            {
                "id": f"immigrant_manual_{_slugify_name(name)}",
                "name": name,
                "country": "Norway",
                "region": "Oslo",
                "municipality": "Oslo",
                "products": ["International food", "Imported goods"],
                "website": None,
                "lat": lat,
                "lon": lon,
                "address": None,
                "category": "Innvandrerbutikk",
                "source": source_url,
            }
        )


def add_manual_city_items(items):
    # Deterministic city seed for Voss where OSM keyword matching can be sparse.
    manual = [
        ("Tan Thaimat", 60.6287852, 6.4349575, "Voss", "Vestland", "https://www.openstreetmap.org/node/6606855415"),
    ]

    for name, lat, lon, municipality, region, source_url in manual:
        items.append(
            {
                "id": f"immigrant_manual_{_slugify_name(name)}",
                "name": name,
                "country": "Norway",
                "region": region,
                "municipality": municipality,
                "products": ["International food", "Imported goods"],
                "website": None,
                "lat": lat,
                "lon": lon,
                "address": None,
                "category": "Innvandrerbutikk",
                "source": source_url,
            }
        )


def add_verified_chain_seeds(items):
    if not CHAIN_SEED_FILE.exists():
        return

    payload = json.loads(CHAIN_SEED_FILE.read_text(encoding="utf-8"))
    stores = payload.get("stores", []) if isinstance(payload, dict) else []
    if not isinstance(stores, list):
        return

    for store in stores:
        if not isinstance(store, dict):
            continue

        lat = _to_float(store.get("lat"))
        lon = _to_float(store.get("lon"))
        name = (store.get("name") or "").strip()
        source = (store.get("source") or "").strip()
        if not name or lat is None or lon is None or not source:
            continue

        identifier = (store.get("id") or "").strip()
        if not identifier:
            slug = name.lower().replace(" ", "_")
            identifier = f"immigrant_seed_{slug}_{str(lat).replace('.', '_')}_{str(lon).replace('.', '_')}"

        items.append(
            {
                "id": identifier,
                "name": name,
                "country": store.get("country") or "Norway",
                "region": store.get("region"),
                "municipality": store.get("municipality"),
                "products": store.get("products") or ["International food", "Imported goods"],
                "website": _normalize_website(store.get("website")),
                "lat": lat,
                "lon": lon,
                "address": store.get("address"),
                "category": store.get("category") or "Innvandrerbutikk",
                "source": source,
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
    oslo_coordinate_markers = [
        (59.9516541, 10.8754212),  # Asia Town
        (59.9125093, 10.7644966),  # Batat import
        (59.9613444, 10.8819687),  # Bazaar
        (59.9609384, 10.9263121),  # Scanasia
        (59.9141379, 10.7515608),  # Scanasia Asian Supermarket
        (59.9379660, 10.7642296),  # Sultan
    ]

    city_bboxes = [
        {
            "municipality": "Bergen",
            "region": "Vestland",
            "south": 60.30,
            "west": 5.20,
            "north": 60.45,
            "east": 5.45,
        },
        {
            "municipality": "Trondheim",
            "region": "Trondelag",
            "south": 63.36,
            "west": 10.30,
            "north": 63.49,
            "east": 10.55,
        },
        {
            "municipality": "Voss",
            "region": "Vestland",
            "south": 60.58,
            "west": 6.35,
            "north": 60.70,
            "east": 6.60,
        },
        {
            "municipality": "Stavanger",
            "region": "Rogaland",
            "south": 58.90,
            "west": 5.62,
            "north": 59.00,
            "east": 5.82,
        },
        {
            "municipality": "Kristiansand",
            "region": "Agder",
            "south": 58.11,
            "west": 7.90,
            "north": 58.21,
            "east": 8.10,
        },
        {
            "municipality": "Tromso",
            "region": "Troms",
            "south": 69.58,
            "west": 18.84,
            "north": 69.70,
            "east": 19.10,
        },
    ]

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

        if name in {"sultan marked", "sultan marked strommen"} and lat is not None and lon is not None:
            if abs(lat - 59.949266) < 0.01 and abs(lon - 11.009671) < 0.01:
                item["municipality"] = "Lillestrom"
                item["region"] = "Akershus"
                if not item.get("website"):
                    item["website"] = "https://www.facebook.com/sultanmarked/"

        if name == "alanya import" and lat is not None and lon is not None:
            if abs(lat - 69.6468623) < 0.01 and abs(lon - 18.9530489) < 0.01:
                item["municipality"] = "Tromso"
                item["region"] = "Troms"
                if not item.get("website"):
                    item["website"] = "https://www.facebook.com/alanyaimport/"

        if lat is not None and lon is not None:
            for marker_lat, marker_lon in oslo_coordinate_markers:
                if abs(lat - marker_lat) < 0.01 and abs(lon - marker_lon) < 0.01:
                    item["municipality"] = "Oslo"
                    item["region"] = "Oslo"
                    break

            for bbox in city_bboxes:
                if (
                    bbox["south"] <= lat <= bbox["north"]
                    and bbox["west"] <= lon <= bbox["east"]
                ):
                    if not item.get("municipality"):
                        item["municipality"] = bbox["municipality"]
                    if not item.get("region"):
                        item["region"] = bbox["region"]
                    break

        if (item.get("municipality") or "").strip().lower() == "oslo" and not item.get("region"):
            item["region"] = "Oslo"
        if (item.get("municipality") or "").strip().lower() == "bergen" and not item.get("region"):
            item["region"] = "Vestland"
        if (item.get("municipality") or "").strip().lower() == "trondheim" and not item.get("region"):
            item["region"] = "Trondelag"
        if (item.get("municipality") or "").strip().lower() == "voss" and not item.get("region"):
            item["region"] = "Vestland"
        if (item.get("municipality") or "").strip().lower() == "stavanger" and not item.get("region"):
            item["region"] = "Rogaland"
        if (item.get("municipality") or "").strip().lower() == "kristiansand" and not item.get("region"):
            item["region"] = "Agder"
        if (item.get("municipality") or "").strip().lower() == "tromso" and not item.get("region"):
            item["region"] = "Troms"

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
    add_manual_oslo_items(items)
    add_manual_city_items(items)
    add_verified_chain_seeds(items)
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
