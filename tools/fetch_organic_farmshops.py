#!/usr/bin/env python3
"""Build organic farmshop dataset from Debio Finn Oko.

Source:
- https://finnoko.debio.no/ (companies + filter metadata)
- https://portal.debio.no/ACM/api/certsearch/getcertificates

Selection (matching current checked filters from Finn Oko screenshot context):
- Organic certification: result sid 509 (Ø-merket / Økologisk)
- Sales channels: 6821 (Gårdsutsalg), 6820 (Salg på markeder), 6825 (Matvarehandel)

This currently yields 59 entries in this project context.
"""

from __future__ import annotations

import json
import time
from pathlib import Path

import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / "docs" / "data" / "organic_farmshops.json"
EXAMPLE_FILE = ROOT / "docs" / "data" / "organic_farmshops.example.json"
GEOCODE_CACHE_FILE = ROOT / "docs" / "data" / "organic_farmshops_geocode_cache.json"

FINNOKO_BASE = "https://finnoko.debio.no"
PORTAL_BASE = "https://portal.debio.no/ACM/api"

COMPANIES_URL = f"{FINNOKO_BASE}/api/acm/companies"
SALES_CHANNELS_URL = f"{FINNOKO_BASE}/api/acm/sales-channels"
RESULTS_URL = f"{FINNOKO_BASE}/api/acm/results"
CERTS_URL = f"{PORTAL_BASE}/certsearch/getcertificates"

ORGANIC_RESULT_SID = 509
ALLOWED_SALES_CHANNEL_IDS = {6821, 6820, 6825}
NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
GEOCODE_USER_AGENT = "mat-sjekk-organic/1.0"


def _normalize_text(value):
    if value is None:
        return ""
    text = str(value).strip()
    # Debio payload occasionally arrives with mojibake (e.g. "GÃ¥rd").
    if any(marker in text for marker in ("Ã", "Â", "â")):
        try:
            repaired = text.encode("latin-1").decode("utf-8")
            if repaired:
                text = repaired
        except Exception:  # noqa: BLE001
            pass
    return text


def _to_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _title_case(value):
    text = _normalize_text(value)
    return text.title() if text else None


def _safe_get_json(url, method="GET", body=None):
    if method == "POST":
        response = requests.post(url, json=body or {}, timeout=180, verify=False)
    else:
        response = requests.get(url, timeout=120, verify=False)
    response.raise_for_status()
    return response.json()


def _load_geocode_cache():
    if not GEOCODE_CACHE_FILE.exists():
        return {}
    try:
        payload = json.loads(GEOCODE_CACHE_FILE.read_text(encoding="utf-8"))
    except Exception:  # noqa: BLE001
        return {}
    return payload if isinstance(payload, dict) else {}


def _save_geocode_cache(cache):
    GEOCODE_CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
    GEOCODE_CACHE_FILE.write_text(
        json.dumps(cache, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def _geocode_key(street, number, zip_code, city):
    return "|".join([
        _normalize_text(street).lower(),
        _normalize_text(number).lower(),
        _normalize_text(zip_code).lower(),
        _normalize_text(city).lower(),
    ])


def _geocode_address(street, number, zip_code, city, cache, place_name=""):
    key = _geocode_key(street, number, zip_code, city)
    if key in cache:
        value = cache[key]
        if isinstance(value, list) and len(value) == 2:
            return (_to_float(value[0]), _to_float(value[1]))
        return (None, None)

    line = " ".join([_normalize_text(street), _normalize_text(number)]).strip()
    zip_part = _normalize_text(zip_code)
    city_part = _normalize_text(city)
    candidates = []
    full = ", ".join([part for part in [line, zip_part, city_part, "Norway"] if part])
    if full:
        candidates.append(full)
    zip_city = " ".join([part for part in [zip_part, city_part] if part]).strip()
    if zip_city:
        candidates.append(f"{zip_city}, Norway")
    if zip_part:
        candidates.append(f"{zip_part}, Norway")
    if city_part:
        candidates.append(f"{city_part}, Norway")
    if _normalize_text(place_name) and city_part:
        candidates.append(f"{_normalize_text(place_name)}, {city_part}, Norway")
    if _normalize_text(place_name):
        candidates.append(f"{_normalize_text(place_name)}, Norway")

    for query in candidates:
        try:
            response = requests.get(
                NOMINATIM_URL,
                params={
                    "format": "jsonv2",
                    "limit": 1,
                    "countrycodes": "no",
                    "q": query,
                },
                headers={"User-Agent": GEOCODE_USER_AGENT},
                timeout=30,
            )
            response.raise_for_status()
            payload = response.json()
            if isinstance(payload, list) and payload:
                first = payload[0]
                lat = _to_float(first.get("lat"))
                lon = _to_float(first.get("lon"))
                if lat is not None and lon is not None:
                    cache[key] = [lat, lon]
                    time.sleep(1.0)
                    return (lat, lon)
        except Exception:  # noqa: BLE001
            pass

    cache[key] = None
    time.sleep(1.0)
    return (None, None)


def _sales_channel_map(rows):
    mapping = {}
    for row in rows:
        if not isinstance(row, dict):
            continue
        sid = row.get("id")
        if sid is None:
            continue
        mapping[int(sid)] = _normalize_text(row.get("content"))
    return mapping


def _result_name_map(result_rows):
    mapping = {}
    for group in result_rows:
        if not isinstance(group, dict):
            continue
        for sub in group.get("subresult") or []:
            if not isinstance(sub, dict):
                continue
            sid = sub.get("sid")
            if sid is None:
                continue
            mapping[int(sid)] = _normalize_text(sub.get("name"))
    return mapping


def _normalize_website(raw):
    value = _normalize_text(raw)
    if not value:
        return None
    if value.startswith("http://") or value.startswith("https://"):
        return value
    return f"https://{value}"


def _build_address(company):
    street = _normalize_text(company.get("street") or "")
    number = _normalize_text(company.get("houseNr") or "")
    zip_code = _normalize_text(company.get("zipCode") or "")
    city = _normalize_text(company.get("city") or "")

    line1 = " ".join([part for part in [street, number] if part]).strip()
    line2 = " ".join([part for part in [zip_code, city] if part]).strip()
    merged = ", ".join([part for part in [line1, line2] if part])
    return merged or None


def _sales_ids(company):
    ids = set()
    for row in company.get("sales_channels") or []:
        if not isinstance(row, dict):
            continue
        sid = row.get("id")
        if sid is None:
            continue
        ids.add(int(sid))
    return ids


def _result_ids(cert):
    ids = set()
    for sid in cert.get("resultSids") or []:
        if sid is None:
            continue
        ids.add(int(sid))
    return ids


def _to_item(cert, company, sales_name_by_id, result_name_by_id):
    cert_id = cert.get("sid")
    if cert_id is None:
        return None

    lat = _to_float(cert.get("lat"))
    lon = _to_float(cert.get("lng"))

    name = _normalize_text(company.get("name") or company.get("display_name") or cert.get("name"))
    if not name:
        return None

    sales_ids = sorted(_sales_ids(company))
    result_ids = sorted(_result_ids(cert))

    products = []
    for sid in sales_ids:
        label = sales_name_by_id.get(int(sid))
        if label:
            products.append(f"Salgskanal: {label}")
    for sid in result_ids:
        label = result_name_by_id.get(int(sid))
        if label:
            products.append(f"Sertifisering: {label}")

    website = _normalize_website(cert.get("dispCertificate"))
    if not website:
        website = f"{FINNOKO_BASE}/?id={int(cert_id)}"

    return {
        "id": f"organic_debio_{int(cert_id)}",
        "name": name,
        "country": "Norway",
        "region": _title_case(company.get("region_name")),
        "municipality": _title_case(company.get("city") or cert.get("city")),
        "products": products,
        "website": website,
        "lat": lat,
        "lon": lon,
        "address": _build_address(company),
        "category": "Økologisk gårdsbutikk",
        "source": f"{FINNOKO_BASE}/?id={int(cert_id)}",
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
    companies = _safe_get_json(COMPANIES_URL)
    sales_channels = _safe_get_json(SALES_CHANNELS_URL)
    results = _safe_get_json(RESULTS_URL)
    certificates = _safe_get_json(CERTS_URL, method="POST", body={"searchText": ""})

    if not isinstance(companies, list):
        raise RuntimeError("Unexpected companies payload")
    if not isinstance(certificates, list):
        raise RuntimeError("Unexpected certificates payload")

    company_by_partner = {}
    for company in companies:
        if not isinstance(company, dict):
            continue
        partner_sid = company.get("partner_sid")
        if partner_sid is None:
            continue
        company_by_partner[int(partner_sid)] = company

    sales_name_by_id = _sales_channel_map(sales_channels if isinstance(sales_channels, list) else [])
    result_name_by_id = _result_name_map(results if isinstance(results, list) else [])
    geocode_cache = _load_geocode_cache()

    items = []
    for cert in certificates:
        if not isinstance(cert, dict):
            continue

        cert_sid = cert.get("sid")
        if cert_sid is None:
            continue

        company = company_by_partner.get(int(cert_sid))
        if not company:
            continue

        if ORGANIC_RESULT_SID not in _result_ids(cert):
            continue

        if not (_sales_ids(company) & ALLOWED_SALES_CHANNEL_IDS):
            continue

        item = _to_item(cert, company, sales_name_by_id, result_name_by_id)
        if item:
            if item.get("lat") is None or item.get("lon") is None:
                street = _normalize_text(cert.get("street") or company.get("street"))
                number = _normalize_text(cert.get("houseNr") or company.get("houseNr"))
                zip_code = _normalize_text(cert.get("zipCode") or company.get("zipCode"))
                city = _normalize_text(cert.get("city") or company.get("city"))
                lat, lon = _geocode_address(
                    street,
                    number,
                    zip_code,
                    city,
                    geocode_cache,
                    place_name=item.get("name") or "",
                )
                item["lat"] = lat
                item["lon"] = lon

            if item.get("lat") is None or item.get("lon") is None:
                continue
            items.append(item)

    items = dedupe(items)
    items.sort(key=lambda row: (row.get("name") or "").lower())
    _save_geocode_cache(geocode_cache)

    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(json.dumps(items, ensure_ascii=False, indent=2), encoding="utf-8")

    preview = items[: min(120, len(items))]
    EXAMPLE_FILE.write_text(json.dumps(preview, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"Wrote {len(items)} organic farmshops to {OUT_FILE}")


if __name__ == "__main__":
    main()
