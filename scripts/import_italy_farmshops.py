#!/usr/bin/env python3
"""
Import Italian agritourism, farm shops, and local markets from OpenStreetMap Overpass API.
Deduplicates against existing entries in docs/data/farmshops.json by OSM id.
"""

import json, requests, time, sys, re
from pathlib import Path

FARMSHOPS_PATH = Path(__file__).parent.parent / "docs" / "data" / "farmshops.json"
OVERPASS_URL = "https://overpass-api.de/api/interpreter"

# Italian province code → region name
PROVINCE_TO_REGION = {
    # Abruzzo
    "AQ": "Abruzzo", "CH": "Abruzzo", "PE": "Abruzzo", "TE": "Abruzzo",
    # Basilicata
    "MT": "Basilicata", "PZ": "Basilicata",
    # Calabria
    "CS": "Calabria", "CZ": "Calabria", "KR": "Calabria", "RC": "Calabria", "VV": "Calabria",
    # Campania
    "AV": "Campania", "BN": "Campania", "CE": "Campania", "NA": "Campania", "SA": "Campania",
    # Emilia-Romagna
    "BO": "Emilia-Romagna", "FE": "Emilia-Romagna", "FC": "Emilia-Romagna",
    "MO": "Emilia-Romagna", "PR": "Emilia-Romagna", "PC": "Emilia-Romagna",
    "RA": "Emilia-Romagna", "RE": "Emilia-Romagna", "RN": "Emilia-Romagna",
    # Friuli-Venezia Giulia
    "GO": "Friuli-Venezia Giulia", "PN": "Friuli-Venezia Giulia",
    "TS": "Friuli-Venezia Giulia", "UD": "Friuli-Venezia Giulia",
    # Lazio
    "FR": "Lazio", "LT": "Lazio", "RI": "Lazio", "RM": "Lazio", "VT": "Lazio",
    # Liguria
    "GE": "Liguria", "IM": "Liguria", "SP": "Liguria", "SV": "Liguria",
    # Lombardia
    "BG": "Lombardia", "BS": "Lombardia", "CO": "Lombardia", "CR": "Lombardia",
    "LC": "Lombardia", "LO": "Lombardia", "MB": "Lombardia", "MI": "Lombardia",
    "MN": "Lombardia", "PV": "Lombardia", "SO": "Lombardia", "VA": "Lombardia",
    # Marche
    "AN": "Marche", "AP": "Marche", "FM": "Marche", "MC": "Marche", "PU": "Marche",
    # Molise
    "CB": "Molise", "IS": "Molise",
    # Piemonte
    "AL": "Piemonte", "AT": "Piemonte", "BI": "Piemonte", "CN": "Piemonte",
    "NO": "Piemonte", "TO": "Piemonte", "VB": "Piemonte", "VC": "Piemonte",
    # Puglia
    "BA": "Puglia", "BT": "Puglia", "BR": "Puglia", "FG": "Puglia",
    "LE": "Puglia", "TA": "Puglia",
    # Sardegna
    "CA": "Sardegna", "CI": "Sardegna", "MD": "Sardegna",
    "NU": "Sardegna", "OG": "Sardegna", "OR": "Sardegna",
    "OT": "Sardegna", "SS": "Sardegna", "VS": "Sardegna",
    # Sicilia
    "AG": "Sicilia", "CL": "Sicilia", "CT": "Sicilia", "EN": "Sicilia",
    "ME": "Sicilia", "PA": "Sicilia", "RG": "Sicilia", "SR": "Sicilia", "TP": "Sicilia",
    # Toscana
    "AR": "Toscana", "FI": "Toscana", "GR": "Toscana", "LI": "Toscana",
    "LU": "Toscana", "MS": "Toscana", "PI": "Toscana", "PT": "Toscana",
    "PO": "Toscana", "SI": "Toscana",
    # Trentino-Alto Adige
    "BZ": "Trentino-Alto Adige", "TN": "Trentino-Alto Adige",
    # Umbria
    "PG": "Umbria", "TR": "Umbria",
    # Valle d'Aosta
    "AO": "Valle d'Aosta",
    # Veneto
    "BL": "Veneto", "PD": "Veneto", "RO": "Veneto",
    "TV": "Veneto", "VE": "Veneto", "VI": "Veneto", "VR": "Veneto",
}

QUERY = """
[out:json][timeout:180];
area["name"="Italia"][boundary=administrative][admin_level=2]->.it;
(
  node["tourism"="agritourism"](area.it);
  way["tourism"="agritourism"](area.it);
  relation["tourism"="agritourism"](area.it);
  node["shop"="farm"](area.it);
  way["shop"="farm"](area.it);
  node["shop"="farmshop"](area.it);
  way["shop"="farmshop"](area.it);
  node["shop"="wine"](area.it);
  way["shop"="wine"](area.it);
  node["amenity"="winery"](area.it);
  way["amenity"="winery"](area.it);
  node["craft"="winery"](area.it);
  way["craft"="winery"](area.it);
  node["shop"="organic"](area.it);
  way["shop"="organic"](area.it);
  node["shop"="cheese"](area.it);
  node["shop"="olive_oil"](area.it);
  node["amenity"="marketplace"]["organic"="yes"](area.it);
  node["amenity"="marketplace"]["shop"="farm"](area.it);
  node["amenity"="marketplace"]["local_food"](area.it);
);
out center tags;
"""


def query_overpass():
    print("Querying Overpass API for Italy farm/agritourism data...")
    resp = requests.post(OVERPASS_URL, data={"data": QUERY}, timeout=150)
    resp.raise_for_status()
    data = resp.json()
    elements = data.get("elements", [])
    print(f"  Got {len(elements)} elements from Overpass")
    return elements


def get_lat_lon(el):
    if el["type"] == "node":
        return el.get("lat"), el.get("lon")
    elif el["type"] == "way" and "center" in el:
        return el["center"].get("lat"), el["center"].get("lon")
    return None, None


def build_address(tags):
    """Construct a street-level address from OSM addr: tags."""
    parts = []
    street = tags.get("addr:street") or tags.get("contact:street")
    housenumber = tags.get("addr:housenumber") or tags.get("contact:housenumber")
    if street:
        parts.append(f"{street} {housenumber}".strip() if housenumber else street)
    elif housenumber:
        parts.append(housenumber)
    postcode = tags.get("addr:postcode") or tags.get("contact:postcode")
    if postcode:
        parts.append(postcode)
    return ", ".join(parts) if parts else None


def get_municipality(tags):
    for k in ("addr:city", "contact:city", "addr:hamlet", "addr:suburb"):
        v = tags.get(k)
        if v:
            # Take the Italian part if bilingual (e.g. "Klausen - Chiusa")
            if " - " in v:
                return v.split(" - ")[-1].strip()
            return v
    return None


def get_region(tags):
    prov = tags.get("addr:province") or tags.get("province")
    if prov:
        # Could be full name or code
        upper = prov.upper().strip()
        if upper in PROVINCE_TO_REGION:
            return PROVINCE_TO_REGION[upper]
        # Try to match partial name
        for code, region in PROVINCE_TO_REGION.items():
            if prov.lower() in region.lower():
                return region
    state = tags.get("addr:state")
    if state:
        return state
    return None


def get_website(tags):
    for k in ("website", "contact:website", "url"):
        v = tags.get(k)
        if v and v.startswith("http"):
            return v
    return None


def get_products(tags):
    produce = tags.get("produce") or tags.get("product")
    if produce:
        return [p.strip() for p in re.split(r"[;,/]", produce) if p.strip()]
    return []


def get_name(tags):
    # Prefer Italian name; fall back to any name
    name = tags.get("name:it") or tags.get("name")
    if not name:
        return None
    # Take Italian part of bilingual name
    if " - " in name:
        parts = name.split(" - ")
        # Heuristic: pick the longer part (usually the Italian one)
        name = max(parts, key=len).strip()
    return name


SUPPRESS_PATTERNS = re.compile(
    r"^(farm\s*shop|hofladen|negozio agricolo|spaccio aziendale|vendita diretta)$",
    re.IGNORECASE,
)


# Tags that are inherently curated / relevant even without contact details
CURATED_TAGS = {
    ("tourism", "agritourism"),
    ("shop", "farm"),
    ("shop", "farmshop"),
    ("shop", "wine"),
    ("amenity", "winery"),
    ("craft", "winery"),
    ("shop", "organic"),
    ("shop", "cheese"),
    ("shop", "olive_oil"),
}


def is_curated(tags):
    """Return True if the element has a tag that qualifies it as a curated farm/local-food entry."""
    for key, value in CURATED_TAGS:
        if tags.get(key) == value:
            return True
    return False


def element_to_entry(el):
    tags = el.get("tags", {})
    name = get_name(tags)
    lat, lon = get_lat_lon(el)

    if not lat or not lon:
        return None

    website = get_website(tags)
    address = build_address(tags)
    phone = tags.get("phone") or tags.get("contact:phone") or tags.get("mobile") or tags.get("contact:mobile")
    municipality = get_municipality(tags)

    if not name:
        return None

    # For curated OSM tags (agritourism, farm, winery…) name + coordinates is enough.
    # For marketplaces / less specific tags, require at least one contact field.
    if not is_curated(tags):
        if not (website or address or phone or municipality):
            return None

    # Skip generic suppressed names that carry no extra information
    if SUPPRESS_PATTERNS.match(name.strip()) and not website and not address:
        return None

    region = get_region(tags)
    products = get_products(tags)

    entry = {
        "id": el["id"],
        "name": name,
        "country": "Italy",
        "region": region,
        "municipality": municipality,
        "products": products,
        "website": website,
        "lat": lat,
        "lon": lon,
        "address": address,
        "source": "osm",
    }
    if phone:
        entry["phone"] = phone
    return entry


def main():
    # Load existing farmshops
    print(f"Loading {FARMSHOPS_PATH}...")
    with open(FARMSHOPS_PATH, encoding="utf-8") as f:
        existing = json.load(f)
    print(f"  Existing entries: {len(existing)}")

    # Keep all non-Italian entries; re-import all Italian entries from scratch
    non_italy = [e for e in existing if e.get("country") != "Italy"]
    italy_existing = [e for e in existing if e.get("country") == "Italy"]
    print(f"  Existing Italian entries (will be replaced): {len(italy_existing)}")
    print(f"  Non-Italian entries (kept): {len(non_italy)}")

    # Query Overpass
    elements = query_overpass()

    # Convert
    new_entries = []
    skipped_no_name = 0
    skipped_filtered = 0

    for el in elements:
        entry = element_to_entry(el)
        if entry is None:
            skipped_filtered += 1
            continue
        new_entries.append(entry)

    # Deduplicate new entries by id (Overpass may return duplicates across types)
    seen_ids = set()
    deduped = []
    for e in new_entries:
        if e["id"] not in seen_ids:
            seen_ids.add(e["id"])
            deduped.append(e)
    new_entries = deduped

    print(f"\nResults:")
    print(f"  Total Overpass elements: {len(elements)}")
    print(f"  Skipped (filtered out): {skipped_filtered}")
    print(f"  New Italian entries: {len(new_entries)}")

    if not new_entries:
        print("Nothing to add.")
        return

    # Show sample
    print("\nSample new entries:")
    for e in new_entries[:8]:
        print(f"  [{e['id']}] {e['name']} | {e.get('municipality')} | {e.get('region')} | {e.get('website', 'no website')}")

    # Combine non-Italy + all new Italian entries and save
    combined = non_italy + new_entries
    with open(FARMSHOPS_PATH, "w", encoding="utf-8") as f:
        json.dump(combined, f, ensure_ascii=False, indent=2)

    print(f"\nSaved {len(combined)} total entries to {FARMSHOPS_PATH}")
    print(f"Italy total now: {len(new_entries)}")


if __name__ == "__main__":
    main()
