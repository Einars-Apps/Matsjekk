#!/usr/bin/env python3
"""
Assign Italian regions to farmshops entries using geographic bounding boxes.
Instant, no API calls needed. Updates docs/data/farmshops.json in place.
"""

import json
from pathlib import Path

FARMSHOPS_PATH = Path(__file__).parent.parent / "docs" / "data" / "farmshops.json"


# Ordered list of (region, lat_min, lat_max, lon_min, lon_max) bounding boxes.
# Islands first (unambiguous), then mainland from most specific to least.
# Each entry can have an optional "exclude" list of (lat_min,lat_max,lon_min,lon_max)
# sub-boxes to exclude from the match.
REGIONS = [
    # Islands
    ("Sardegna",           38.86, 41.32,  8.08,  9.84),
    ("Sicilia",            36.60, 38.35, 11.85, 15.70),
    # Extreme corners (unambiguous)
    ("Valle d'Aosta",      45.46, 45.99,  6.80,  7.95),
    ("Friuli-Venezia Giulia", 45.58, 46.66, 12.30, 13.92),
    # High-latitude NE: Trentino before Veneto/Lombardia
    ("Trentino-Alto Adige", 45.67, 47.10, 10.37, 12.48),
    # Narrow coastal NW strip (Liguria)
    ("Liguria",            43.76, 44.68,  7.49, 10.08),
    # Southern regions (least overlap risk)
    ("Calabria",           37.92, 39.98, 15.62, 16.66),
    ("Molise",             41.35, 42.08, 13.97, 15.18),
    ("Basilicata",         39.89, 41.16, 15.32, 16.96),
    ("Puglia",             39.79, 41.93, 14.93, 18.53),
    # Central-south
    ("Campania",           39.99, 41.51, 13.88, 15.82),
    ("Abruzzo",            41.70, 42.91, 13.17, 14.81),
    # Central
    ("Umbria",             42.37, 43.52, 11.88, 12.97),
    ("Marche",             42.68, 43.97, 12.17, 13.93),
    ("Lazio",              41.25, 42.85, 11.43, 13.98),
    ("Toscana",            42.37, 44.49,  9.67, 12.37),
    # Po Valley / North
    ("Emilia-Romagna",     43.72, 45.15,  9.17, 12.81),
    ("Veneto",             44.79, 46.69, 10.96, 13.11),
    ("Lombardia",          44.68, 46.66,  8.49, 11.37),
    ("Piemonte",           44.06, 46.48,  6.62, 9.22),
]


def assign_region(lat, lon):
    """Return the Italian region for a given coordinate, or None."""
    for region, lat_min, lat_max, lon_min, lon_max in REGIONS:
        if lat_min <= lat <= lat_max and lon_min <= lon <= lon_max:
            return region
    return None


def main():
    print(f"Loading {FARMSHOPS_PATH}...")
    with open(FARMSHOPS_PATH, encoding="utf-8") as f:
        data = json.load(f)

    italy = [e for e in data if e.get("country") == "Italy"]
    print(f"Total Italian entries: {len(italy)}")
    print(f"Without region: {sum(1 for e in italy if not e.get('region'))}")

    updated = 0
    unchanged = 0
    unmatched = 0

    for entry in data:
        if entry.get("country") != "Italy":
            continue
        lat, lon = entry.get("lat"), entry.get("lon")
        if not lat or not lon:
            continue
        if entry.get("region"):  # already has region
            unchanged += 1
            continue

        region = assign_region(lat, lon)
        if region:
            entry["region"] = region
            updated += 1
        else:
            unmatched += 1

    print(f"\nRegion assignment results:")
    print(f"  Assigned:   {updated}")
    print(f"  Unmatched:  {unmatched}")
    print(f"  Pre-filled: {unchanged}")

    # Save
    with open(FARMSHOPS_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"\nSaved {len(data)} entries to {FARMSHOPS_PATH}")

    # Region breakdown
    from collections import Counter
    region_counts = Counter(
        e["region"] for e in data
        if e.get("country") == "Italy" and e.get("region")
    )
    print("\nItaly entries by region:")
    for region, count in sorted(region_counts.items(), key=lambda x: -x[1]):
        print(f"  {region}: {count}")


if __name__ == "__main__":
    main()
