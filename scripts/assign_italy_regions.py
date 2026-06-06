#!/usr/bin/env python3
"""
Assign Italian regions to farmshops entries with country=Italy using Nominatim
reverse geocoding. Respects 1 req/sec rate limit. Caches results.
Only processes entries that currently have region=null.
"""

import json, time, sys, re
from pathlib import Path

try:
    import requests
except ImportError:
    sys.exit("pip install requests")

FARMSHOPS_PATH = Path(__file__).parent.parent / "docs" / "data" / "farmshops.json"
CACHE_PATH = Path(__file__).parent / "italy_region_cache.json"
NOMINATIM_URL = "https://nominatim.openstreetmap.org/reverse"

# Italian province code → region (same table as in import script)
PROVINCE_TO_REGION = {
    "AQ": "Abruzzo", "CH": "Abruzzo", "PE": "Abruzzo", "TE": "Abruzzo",
    "MT": "Basilicata", "PZ": "Basilicata",
    "CS": "Calabria", "CZ": "Calabria", "KR": "Calabria", "RC": "Calabria", "VV": "Calabria",
    "AV": "Campania", "BN": "Campania", "CE": "Campania", "NA": "Campania", "SA": "Campania",
    "BO": "Emilia-Romagna", "FE": "Emilia-Romagna", "FC": "Emilia-Romagna",
    "MO": "Emilia-Romagna", "PR": "Emilia-Romagna", "PC": "Emilia-Romagna",
    "RA": "Emilia-Romagna", "RE": "Emilia-Romagna", "RN": "Emilia-Romagna",
    "GO": "Friuli-Venezia Giulia", "PN": "Friuli-Venezia Giulia",
    "TS": "Friuli-Venezia Giulia", "UD": "Friuli-Venezia Giulia",
    "FR": "Lazio", "LT": "Lazio", "RI": "Lazio", "RM": "Lazio", "VT": "Lazio",
    "GE": "Liguria", "IM": "Liguria", "SP": "Liguria", "SV": "Liguria",
    "BG": "Lombardia", "BS": "Lombardia", "CO": "Lombardia", "CR": "Lombardia",
    "LC": "Lombardia", "LO": "Lombardia", "MB": "Lombardia", "MI": "Lombardia",
    "MN": "Lombardia", "PV": "Lombardia", "SO": "Lombardia", "VA": "Lombardia",
    "AN": "Marche", "AP": "Marche", "FM": "Marche", "MC": "Marche", "PU": "Marche",
    "CB": "Molise", "IS": "Molise",
    "AL": "Piemonte", "AT": "Piemonte", "BI": "Piemonte", "CN": "Piemonte",
    "NO": "Piemonte", "TO": "Piemonte", "VB": "Piemonte", "VC": "Piemonte",
    "BA": "Puglia", "BT": "Puglia", "BR": "Puglia", "FG": "Puglia",
    "LE": "Puglia", "TA": "Puglia",
    "CA": "Sardegna", "CI": "Sardegna", "MD": "Sardegna",
    "NU": "Sardegna", "OG": "Sardegna", "OR": "Sardegna",
    "OT": "Sardegna", "SS": "Sardegna", "VS": "Sardegna",
    "AG": "Sicilia", "CL": "Sicilia", "CT": "Sicilia", "EN": "Sicilia",
    "ME": "Sicilia", "PA": "Sicilia", "RG": "Sicilia", "SR": "Sicilia", "TP": "Sicilia",
    "AR": "Toscana", "FI": "Toscana", "GR": "Toscana", "LI": "Toscana",
    "LU": "Toscana", "MS": "Toscana", "PI": "Toscana", "PT": "Toscana",
    "PO": "Toscana", "SI": "Toscana",
    "BZ": "Trentino-Alto Adige", "TN": "Trentino-Alto Adige",
    "PG": "Umbria", "TR": "Umbria",
    "AO": "Valle d'Aosta",
    "BL": "Veneto", "PD": "Veneto", "RO": "Veneto",
    "TV": "Veneto", "VE": "Veneto", "VI": "Veneto", "VR": "Veneto",
}

# Known Italian region name variants in Nominatim responses
REGION_NORMALIZE = {
    "Trentino-South Tyrol": "Trentino-Alto Adige",
    "Trentino-Alto Adige/Südtirol": "Trentino-Alto Adige",
    "Friuli Venezia Giulia": "Friuli-Venezia Giulia",
    "Emilia Romagna": "Emilia-Romagna",
    "Valle d'Aosta / Vallée d'Aoste": "Valle d'Aosta",
    "Apulia": "Puglia",
    "Tuscany": "Toscana",
    "Sardinia": "Sardegna",
    "Sicily": "Sicilia",
    "Campagna": "Campania",
}


def load_cache():
    if CACHE_PATH.exists():
        with open(CACHE_PATH, encoding="utf-8") as f:
            return json.load(f)
    return {}


def save_cache(cache):
    with open(CACHE_PATH, "w", encoding="utf-8") as f:
        json.dump(cache, f, ensure_ascii=False, indent=2)


def cache_key(lat, lon):
    # Round to 2 decimal places to merge nearby points
    return f"{round(lat, 2)},{round(lon, 2)}"


def reverse_geocode(lat, lon, cache):
    key = cache_key(lat, lon)
    if key in cache:
        return cache[key]

    try:
        resp = requests.get(
            NOMINATIM_URL,
            params={"lat": lat, "lon": lon, "format": "json", "zoom": 5},
            headers={"User-Agent": "mat_sjekk/1.0 (local dev)"},
            timeout=10,
        )
        resp.raise_for_status()
        data = resp.json()
        address = data.get("address", {})
        region = (
            address.get("state")
            or address.get("region")
            or address.get("county")
        )
        if region:
            region = REGION_NORMALIZE.get(region, region)
        result = region
    except Exception as e:
        print(f"  Warning: geocode failed for {lat},{lon}: {e}")
        result = None

    cache[key] = result
    return result


def main():
    print(f"Loading {FARMSHOPS_PATH}...")
    with open(FARMSHOPS_PATH, encoding="utf-8") as f:
        data = json.load(f)

    cache = load_cache()
    print(f"  Cache has {len(cache)} entries")

    italy = [e for e in data if e.get("country") == "Italy" and not e.get("region")]
    print(f"  Italian entries without region: {len(italy)}")

    if not italy:
        print("All Italian entries already have regions. Nothing to do.")
        return

    updated = 0
    for i, entry in enumerate(italy):
        lat, lon = entry.get("lat"), entry.get("lon")
        if not lat or not lon:
            continue

        region = reverse_geocode(lat, lon, cache)
        if region:
            # Find the entry in data and update it
            for d in data:
                if d["id"] == entry["id"]:
                    d["region"] = region
                    updated += 1
                    break

        # Rate limit: 1 req/sec
        key = cache_key(lat, lon)
        if key not in cache or cache[key] is None:
            time.sleep(1.1)

        if (i + 1) % 50 == 0:
            print(f"  Processed {i+1}/{len(italy)}, updated {updated} regions so far...")
            save_cache(cache)

    save_cache(cache)

    # Save updated farmshops
    with open(FARMSHOPS_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    # Report
    italy_all = [e for e in data if e.get("country") == "Italy"]
    with_region = [e for e in italy_all if e.get("region")]
    print(f"\nDone. Updated {updated} entries.")
    print(f"Italy: {len(with_region)}/{len(italy_all)} now have region data.")

    from collections import Counter
    region_counts = Counter(e["region"] for e in with_region)
    for region, count in sorted(region_counts.items(), key=lambda x: -x[1]):
        print(f"  {region}: {count}")


if __name__ == "__main__":
    main()
