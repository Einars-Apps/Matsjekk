#!/usr/bin/env python3
"""Build immigrant shop country slices for selected European countries.

This script writes `docs/data/immigrant_shops_by_country/<cc>.json` files for
countries configured in `TARGET_COUNTRIES` (excluding NO by default to preserve
curated Norwegian data).
"""

from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parents[1]
BY_COUNTRY_DIR = ROOT / "docs" / "data" / "immigrant_shops_by_country"
INDEX_FILE = BY_COUNTRY_DIR / "index.json"

OVERPASS_ENDPOINTS = [
    "https://overpass-api.de/api/interpreter",
    "https://lz4.overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
]

# Keep this aligned with docs/js/innvandrerbutikker.js country selector.
TARGET_COUNTRIES = [
    ("SE", "Sverige"),
    ("DK", "Danmark"),
    ("FI", "Finland"),
    ("DE", "Tyskland"),
    ("NL", "Nederland"),
    ("BE", "Belgia"),
    ("FR", "Frankrike"),
    ("IT", "Italia"),
    ("PT", "Portugal"),
    ("ES", "Spania"),
    ("GB", "Storbritannia"),
    ("IE", "Irland"),
    ("AT", "Osterrike"),
    ("CH", "Sveits"),
    ("LI", "Liechtenstein"),
    ("LU", "Luxembourg"),
    ("PL", "Polen"),
    ("CZ", "Tsjekkia"),
    ("SK", "Slovakia"),
    ("HU", "Ungarn"),
    ("RO", "Romania"),
    ("BG", "Bulgaria"),
    ("GR", "Hellas"),
    ("HR", "Kroatia"),
    ("SI", "Slovenia"),
    ("EE", "Estland"),
    ("LV", "Latvia"),
    ("LT", "Litauen"),
    ("IS", "Island"),
    ("MT", "Malta"),
    ("CY", "Kypros"),
    ("AL", "Albania"),
    ("BA", "Bosnia-Hercegovina"),
    ("ME", "Montenegro"),
    ("MK", "Nord-Makedonia"),
    ("RS", "Serbia"),
    ("MD", "Moldova"),
    ("UA", "Ukraina"),
]

KEYWORDS = [
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
    "fudi",
    "sultan",
    "global food",
    "alanya",
]

NOMINATIM_QUERIES = [
    "halal market",
    "asian market",
    "international food",
    "import store",
    "bazaar",
    "world food",
    "middle east market",
    "african food store",
    "turkish market",
]

LOCAL_NOMINATIM_QUERIES_BY_COUNTRY = {
    "FR": ["epicerie du monde", "epicerie orientale", "epicerie asiatique", "marche halal"],
    "ES": ["tienda halal", "supermercado arabe", "alimentacion internacional", "bazar asiatico"],
    "IT": ["alimentari etnici", "negozio halal", "supermercato etnico", "market asiatico"],
    "DE": ["orientalischer laden", "asiatischer supermarkt", "halal markt", "internationaler supermarkt"],
    "AT": ["orientalischer laden", "halal markt", "asiatischer supermarkt"],
    "CH": ["orientalischer laden", "halal markt", "asiatischer supermarkt", "epicerie orientale"],
    "PL": ["sklep orientalny", "sklep halal", "market azjatycki", "sklep miedzynarodowy"],
    "CZ": ["halal obchod", "asijska prodejna", "mezinarodni potraviny"],
    "SK": ["halal obchod", "azijska predajna", "medzinarodne potraviny"],
    "HU": ["halal bolt", "azsiai bolt", "nemzetkozi elelmiszer"],
    "RO": ["magazin halal", "magazin asiatic", "alimentara internationala"],
    "BG": ["halal market", "asian food store", "international food store"],
    "GR": ["halal market", "asian market", "international food"],
    "HR": ["halal trgovina", "azijska trgovina", "medunarodna hrana"],
    "SI": ["halal trgovina", "azijska trgovina", "mednarodna hrana"],
    "EE": ["halal pood", "aasia pood", "rahvusvaheline toidupood"],
    "LV": ["halal veikals", "azijas veikals", "starptautisks partikas veikals"],
    "LT": ["halal parduotuve", "azijos parduotuve", "tarptautine maisto parduotuve"],
    "IS": ["halal market", "asian market", "international food"],
    "MT": ["halal shop", "asian shop", "international food"],
    "CY": ["halal market", "asian market", "international food"],
    "AL": ["halal market", "asian market", "international food"],
    "BA": ["halal market", "asian market", "international food"],
    "ME": ["halal market", "asian market", "international food"],
    "MK": ["halal market", "asian market", "international food"],
    "RS": ["halal market", "asian market", "international food"],
    "MD": ["magazin halal", "magazin asiatic", "alimentara internationala"],
    "UA": ["halal market", "asian market", "international food"],
    "BE": ["epicerie orientale", "halal market", "aziatische supermarkt"],
    "NL": ["halal supermarkt", "aziatische supermarkt", "internationale supermarkt"],
    "PT": ["mercearia internacional", "mercado halal", "supermercado asiatico"],
    "GB": ["ethnic supermarket", "halal grocery", "asian supermarket"],
    "IE": ["ethnic supermarket", "halal grocery", "asian supermarket"],
    "LU": ["epicerie orientale", "halal market", "asiatischer supermarkt"],
    "SE": ["halal butik", "asiatisk butik", "internationell livsmedel"],
    "DK": ["halal butik", "asiatisk butik", "international mad butik"],
    "FI": ["halal kauppa", "aasialainen kauppa", "kansainvalinen ruokakauppa"],
}

FALLBACK_THRESHOLD = 25


def _keyword_regex() -> str:
    return "|".join(KEYWORDS)


def _query_for_country(country_code: str) -> str:
    cc = (country_code or "").strip().upper()
    return f"""
[out:json][timeout:120];
area["ISO3166-1"="{cc}"][admin_level=2]->.searchArea;
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


def _address_from_tags(tags):
    street = (tags.get("addr:street") or "").strip()
    number = (tags.get("addr:housenumber") or "").strip()
    postcode = (tags.get("addr:postcode") or "").strip()
    city = (tags.get("addr:city") or tags.get("addr:municipality") or "").strip()
    parts = [" ".join([street, number]).strip(), postcode, city]
    merged = ", ".join([p for p in parts if p])
    return merged or None


def fetch_overpass_candidates(country_code: str):
    query = _query_for_country(country_code)
    last_error = None
    for endpoint in OVERPASS_ENDPOINTS:
        try:
            response = requests.post(endpoint, data={"data": query}, timeout=180)
            response.raise_for_status()
            payload = response.json()
            rows = payload.get("elements", []) if isinstance(payload, dict) else []
            if not isinstance(rows, list):
                rows = []
            print(f"[{country_code}] fetched {len(rows)} OSM candidates via {endpoint}")
            return rows
        except Exception as error:  # noqa: BLE001
            last_error = error
            print(f"[{country_code}] overpass failed via {endpoint}: {error}")
    print(f"[{country_code}] overpass failed on all endpoints: {last_error}")
    return None


def to_item(element, country_code: str, country_label: str):
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
        "country": country_label,
        "countryCode": country_code,
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


def dedupe_nominatim(rows):
    seen = set()
    out = []
    for row in rows:
        osm_type = (row.get("osm_type") or "").strip().lower()
        osm_id = str(row.get("osm_id") or "").strip()
        if not osm_type or not osm_id:
            continue
        key = f"{osm_type}:{osm_id}"
        if key in seen:
            continue
        seen.add(key)
        out.append(row)
    return out


def build_nominatim_queries(country_code: str, country_label: str):
    queries = list(NOMINATIM_QUERIES)
    queries.extend(LOCAL_NOMINATIM_QUERIES_BY_COUNTRY.get(country_code, []))
    if country_label:
        queries.extend([
            f"halal market {country_label}",
            f"asian market {country_label}",
            f"international food {country_label}",
        ])

    # Deduplicate while preserving order.
    seen = set()
    out = []
    for query in queries:
        key = query.strip().lower()
        if not key or key in seen:
            continue
        seen.add(key)
        out.append(query)
    return out


def fetch_nominatim_candidates(country_code: str, country_label: str):
    all_rows = []
    for query in build_nominatim_queries(country_code, country_label):
        try:
            response = requests.get(
                "https://nominatim.openstreetmap.org/search",
                params={
                    "format": "jsonv2",
                    "countrycodes": country_code.lower(),
                    "addressdetails": 1,
                    "limit": 80,
                    "dedupe": 1,
                    "q": query,
                },
                headers={"User-Agent": "matsjekk-bot/1.0"},
                timeout=40,
            )
            response.raise_for_status()
            payload = response.json()
            rows = payload if isinstance(payload, list) else []
            all_rows.extend(rows)
        except Exception as error:  # noqa: BLE001
            print(f"[{country_code}] nominatim failed for query '{query}': {error}")

    deduped = dedupe_nominatim(all_rows)
    print(f"[{country_code}] nominatim fallback candidates: {len(deduped)}")
    return deduped


def to_item_from_nominatim(row, country_code: str, country_label: str):
    lat = _to_float(row.get("lat"))
    lon = _to_float(row.get("lon"))
    if lat is None or lon is None:
        return None

    display_name = (row.get("display_name") or "").strip()
    name = (row.get("name") or "").strip() or (display_name.split(",")[0].strip() if display_name else "")
    if not name:
        return None

    # Keep only likely shop-like POIs from nominatim fallback.
    cls = (row.get("class") or "").strip().lower()
    typ = (row.get("type") or "").strip().lower()
    if cls not in {"shop", "amenity"} and typ not in {"supermarket", "convenience", "greengrocer"}:
        text = f"{name} {display_name}".lower()
        if not any(keyword in text for keyword in ["market", "bazaar", "halal", "asia", "import", "food"]):
            return None

    osm_type = (row.get("osm_type") or "").strip().lower()
    osm_id = row.get("osm_id")
    if osm_type not in {"node", "way", "relation"} or not osm_id:
        return None

    address = row.get("address") if isinstance(row.get("address"), dict) else {}
    municipality = (
        address.get("city")
        or address.get("town")
        or address.get("village")
        or address.get("municipality")
        or None
    )
    region = address.get("county") or address.get("state") or None

    return {
        "id": f"immigrant_osm_{osm_type}_{osm_id}",
        "name": name,
        "country": country_label,
        "countryCode": country_code,
        "region": region,
        "municipality": municipality,
        "products": ["International food", "Imported goods"],
        "website": None,
        "lat": lat,
        "lon": lon,
        "address": display_name or None,
        "category": "Innvandrerbutikk",
        "source": f"https://www.openstreetmap.org/{osm_type}/{osm_id}",
    }


def write_country_file(country_code: str, items):
    BY_COUNTRY_DIR.mkdir(parents=True, exist_ok=True)
    out_file = BY_COUNTRY_DIR / f"{country_code.lower()}.json"
    out_file.write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding="utf-8")
    return out_file


def maybe_preserve_existing(country_code: str, candidate_items):
    existing_path = BY_COUNTRY_DIR / f"{country_code.lower()}.json"
    if not existing_path.exists():
        return candidate_items, "ok"

    try:
        existing = json.loads(existing_path.read_text(encoding="utf-8"))
        existing_items = existing if isinstance(existing, list) else []
    except Exception:  # noqa: BLE001
        return candidate_items, "ok"

    new_count = len(candidate_items)
    existing_count = len(existing_items)
    if existing_count >= 20 and new_count < int(existing_count * 0.75):
        print(
            f"[{country_code}] preserving existing dataset ({existing_count}) over lower regenerated count ({new_count})"
        )
        return existing_items, "kept_existing_higher_count"

    return candidate_items, "ok"


def main():
    summary = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "countries": {},
    }

    for country_code, country_label in TARGET_COUNTRIES:
        rows = fetch_overpass_candidates(country_code)
        if rows is None:
            rows = []

        items = []
        for element in rows:
            item = to_item(element, country_code, country_label)
            if item:
                items.append(item)

        if len(items) < FALLBACK_THRESHOLD:
            fallback_rows = fetch_nominatim_candidates(country_code, country_label)
            for row in fallback_rows:
                item = to_item_from_nominatim(row, country_code, country_label)
                if item:
                    items.append(item)

        items = dedupe(items)
        items = sorted(items, key=lambda row: (row.get("name") or "").lower())
        items, status = maybe_preserve_existing(country_code, items)
        out_file = write_country_file(country_code, items)
        print(f"[{country_code}] wrote {len(items)} shops -> {out_file}")
        summary["countries"][country_code] = {"count": len(items), "status": status}

    INDEX_FILE.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote index -> {INDEX_FILE}")


if __name__ == "__main__":
    main()
