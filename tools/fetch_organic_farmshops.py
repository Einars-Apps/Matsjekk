#!/usr/bin/env python3
"""Build a dataset of organic farm shops from Økoguiden.

Rules:
- Include only farmshop-like entries (category/name/url indicates farm outlet)
- Keep only organic actors (all Økoguiden entries are organic-focused, but we
  still prefer explicit organic certs when available)
- Output schema matches the existing shop pages
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / "docs" / "data" / "organic_farmshops.json"
EXAMPLE_FILE = ROOT / "docs" / "data" / "organic_farmshops.example.json"

BASE_URL = "https://okologisknorge.no"
LOCATIONS_URL = f"{BASE_URL}/Umbraco/Api/EcoGuideApi/Locations/8074"
ENTRY_URL = f"{BASE_URL}/Umbraco/Api/EcoGuideApi/GetEntry/{{entry_id}}"

FARMSHOP_NAME_PATTERN = re.compile(
    r"(gårdsbutikk|gardsbutikk|gårdsutsalg|gaardsutsalg|gardsutsalg)",
    re.IGNORECASE,
)
GENERIC_CHAIN_PATTERN = re.compile(
    r"^(rema\s*1000|coop\b|kiwi\b|meny\b|joker\b|spar\b)",
    re.IGNORECASE,
)


def _to_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _normalize_text(value: str | None) -> str:
    return (value or "").strip()


def _normalize_municipality(value: str | None) -> str | None:
    text = _normalize_text(value)
    if not text:
        return None
    text = re.sub(r"\s+kommune$", "", text, flags=re.IGNORECASE)
    return text.title()


def _normalize_region(value: str | None) -> str | None:
    text = _normalize_text(value)
    if not text:
        return None
    return text.title()


def _build_address(address: dict) -> str | None:
    if not isinstance(address, dict):
        return None
    parts = [
        _normalize_text(address.get("streetName")),
        _normalize_text(address.get("postalCode")),
        _normalize_text(address.get("city")),
    ]
    merged = ", ".join([part for part in parts if part])
    return merged or None


def _extract_cert_names(certs):
    out = []
    if not isinstance(certs, list):
        return out
    for cert in certs:
        if isinstance(cert, dict):
            name = _normalize_text(cert.get("name") or cert.get("title"))
            if name:
                out.append(name)
        else:
            name = _normalize_text(str(cert))
            if name:
                out.append(name)
    return out


def _is_farmshop_entry(entry: dict) -> bool:
    categories = entry.get("categories") if isinstance(entry.get("categories"), list) else []
    category_set = {str(cat).strip().lower() for cat in categories if str(cat).strip()}
    if "gårdsbutikk" in category_set:
        return True

    name = _normalize_text(entry.get("name"))
    url = _normalize_text(entry.get("url"))
    intro = _normalize_text(entry.get("intro"))
    probe = " ".join([name, url, intro])
    if FARMSHOP_NAME_PATTERN.search(probe):
        return True
    return False


def _is_generic_chain(name: str) -> bool:
    return bool(GENERIC_CHAIN_PATTERN.search(name))


def fetch_json(url: str):
    response = requests.get(url, timeout=60)
    response.raise_for_status()
    return response.json()


def to_item(entry: dict):
    if not isinstance(entry, dict):
        return None

    name = _normalize_text(entry.get("name"))
    if not name or _is_generic_chain(name):
        return None

    lat = _to_float(entry.get("lat"))
    lon = _to_float(entry.get("lng"))
    if lat is None or lon is None:
        return None

    address = entry.get("address") if isinstance(entry.get("address"), dict) else {}
    municipality = _normalize_municipality(address.get("municipality"))
    region = _normalize_region(address.get("county"))
    categories = [str(cat).strip() for cat in (entry.get("categories") or []) if str(cat).strip()]
    cert_names = _extract_cert_names(entry.get("certs"))

    url_path = _normalize_text(entry.get("url"))
    website = f"{BASE_URL}{url_path}" if url_path.startswith("/") else (url_path or None)

    entry_id = _normalize_text(entry.get("id"))
    if not entry_id:
        return None

    products = categories[:]
    if cert_names:
        products.extend([f"Sertifisering: {cert}" for cert in cert_names])

    return {
        "id": f"organic_okoguide_{entry_id}",
        "name": name,
        "country": "Norway",
        "region": region,
        "municipality": municipality,
        "products": products,
        "website": website,
        "lat": lat,
        "lon": lon,
        "address": _build_address(address),
        "category": "Økologisk gårdsbutikk",
        "source": website or f"{BASE_URL}/oekoguiden/",
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


def main():
    locations = fetch_json(LOCATIONS_URL)
    if not isinstance(locations, list):
        raise RuntimeError("Unexpected locations payload")

    items = []
    for location in locations:
        entry_id = _normalize_text((location or {}).get("id"))
        if not entry_id:
            continue
        try:
            entry = fetch_json(ENTRY_URL.format(entry_id=entry_id))
        except Exception as error:  # noqa: BLE001
            print(f"Skipping entry {entry_id}: {error}")
            continue

        if not _is_farmshop_entry(entry):
            continue

        item = to_item(entry)
        if item:
            items.append(item)

    items = dedupe(items)
    items.sort(key=lambda row: (row.get("name") or "").lower())

    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding="utf-8")

    preview = items[: min(120, len(items))]
    EXAMPLE_FILE.write_text(json.dumps(preview, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Wrote {len(items)} organic farmshops to {OUT_FILE}")


if __name__ == "__main__":
    main()
