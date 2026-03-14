#!/usr/bin/env python3
"""
Import farm shops, agritourism, wineries, organic shops etc. from OpenStreetMap
for any supported country (or all countries at once).

Usage:
    python import_osm_farmshops.py           # all countries
    python import_osm_farmshops.py DE        # Germany only
    python import_osm_farmshops.py DE FR AT  # Multiple countries
    python import_osm_farmshops.py --dry-run # Show counts without saving
"""

import json, requests, time, sys, re, argparse
from pathlib import Path

FARMSHOPS_PATH = Path(__file__).parent.parent / "docs" / "data" / "farmshops.json"
COUNTRY_SLICE_DIR = Path(__file__).parent.parent / "docs" / "data" / "farmshops_by_country"
OVERPASS_URL = "https://overpass-api.de/api/interpreter"

# ──────────────────────────────────────────────────────────────────────────────
# Country registry
# ──────────────────────────────────────────────────────────────────────────────

COUNTRIES = {
    "NO": {"name": "Norway",         "osm_name": "Norge",          "country_label": "Norway"},
    "DE": {"name": "Germany",        "osm_name": "Deutschland",    "country_label": "Germany"},
    "FR": {"name": "France",         "osm_name": "France",         "country_label": "France"},
    "CH": {"name": "Switzerland",    "osm_name": "Schweiz",        "country_label": "Switzerland"},
    "AT": {"name": "Austria",        "osm_name": "Österreich",     "country_label": "Austria"},
    "NL": {"name": "Netherlands",    "osm_name": "Nederland",      "country_label": "Netherlands"},
    "BE": {"name": "Belgium",        "osm_name": "Belgique",       "country_label": "Belgium"},
    "DK": {"name": "Denmark",        "osm_name": "Danmark",        "country_label": "Denmark"},
    "SE": {"name": "Sweden",         "osm_name": "Sverige",        "country_label": "Sweden"},
    "FI": {"name": "Finland",        "osm_name": "Suomi",          "country_label": "Finland"},
    "GB": {"name": "United Kingdom", "osm_name": "United Kingdom", "country_label": "United Kingdom"},
    "IE": {"name": "Ireland",        "osm_name": "Ireland",        "country_label": "Ireland"},
    "ES": {"name": "Spain",          "osm_name": "España",         "country_label": "Spain"},
    "PT": {"name": "Portugal",       "osm_name": "Portugal",       "country_label": "Portugal"},
    "IT": {"name": "Italy",          "osm_name": "Italia",         "country_label": "Italy"},
    "LU": {"name": "Luxembourg",     "osm_name": "Lëtzebuerg",     "country_label": "Luxembourg"},
    "LI": {"name": "Liechtenstein",  "osm_name": "Liechtenstein",  "country_label": "Liechtenstein"},
    # Central / Eastern Europe
    "PL": {"name": "Poland",                  "osm_name": "Polska",              "country_label": "Poland"},
    "CZ": {"name": "Czechia",                 "osm_name": "Cesko",               "country_label": "Czechia"},
    "SK": {"name": "Slovakia",                "osm_name": "Slovensko",           "country_label": "Slovakia"},
    "HU": {"name": "Hungary",                 "osm_name": "Magyarorszag",        "country_label": "Hungary"},
    "RO": {"name": "Romania",                 "osm_name": "Romania",             "country_label": "Romania"},
    "BG": {"name": "Bulgaria",                "osm_name": "Bulgaria",            "country_label": "Bulgaria"},
    # Baltic states
    "EE": {"name": "Estonia",                 "osm_name": "Eesti",               "country_label": "Estonia"},
    "LV": {"name": "Latvia",                  "osm_name": "Latvija",             "country_label": "Latvia"},
    "LT": {"name": "Lithuania",               "osm_name": "Lietuva",             "country_label": "Lithuania"},
    # Western Balkans
    "HR": {"name": "Croatia",                 "osm_name": "Hrvatska",            "country_label": "Croatia"},
    "SI": {"name": "Slovenia",                "osm_name": "Slovenija",           "country_label": "Slovenia"},
    "RS": {"name": "Serbia",                  "osm_name": "Srbija",              "country_label": "Serbia"},
    "BA": {"name": "Bosnia and Herzegovina",  "osm_name": "Bosna i Hercegovina", "country_label": "Bosnia and Herzegovina"},
    "ME": {"name": "Montenegro",              "osm_name": "Crna Gora",           "country_label": "Montenegro"},
    "MK": {"name": "North Macedonia",         "osm_name": "Makedonija",          "country_label": "North Macedonia"},
    "AL": {"name": "Albania",                 "osm_name": "Shqiperia",           "country_label": "Albania"},
    "GR": {"name": "Greece",                  "osm_name": "Ellada",              "country_label": "Greece"},
    # Other
    "CY": {"name": "Cyprus",                  "osm_name": "Kypros",              "country_label": "Cyprus"},
    # Non-European
    "US": {"name": "United States",           "osm_name": "United States",       "country_label": "United States"},
    "CA": {"name": "Canada",                  "osm_name": "Canada",              "country_label": "Canada"},
    "AU": {"name": "Australia",               "osm_name": "Australia",           "country_label": "Australia"},
    "NZ": {"name": "New Zealand",             "osm_name": "New Zealand",         "country_label": "New Zealand"},
}

# Tags considered inherently curated — name + coordinates is sufficient
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
    ("shop", "deli"),
    ("shop", "butcher"),          # farmstead butcher/spekematprodusent
    ("craft", "distillery"),
    ("craft", "brewery"),
    ("shop", "alcohol"),          # rural wine/spirits shops
    ("tourism", "farm"),
    ("landuse", "farmyard"),      # only when has shop/tourism sub-tag
}

SUPPRESS_PATTERNS = re.compile(
    r"^(farm\s*shop|hofladen|fermette|ferme|vente directe|negozio agricolo|"
    r"spaccio aziendale|vendita diretta|gårdsbutikk|gårdsutsalg|bondegård)$",
    re.IGNORECASE,
)


def build_overpass_query(iso_code: str, timeout: int = 180) -> str:
    """Build an Overpass query for the given ISO 3166-1 country code."""
    return f"""
[out:json][timeout:{timeout}];
area["ISO3166-1"="{iso_code}"][boundary=administrative]->.country;
(
  node["tourism"="agritourism"](area.country);
  way["tourism"="agritourism"](area.country);
  relation["tourism"="agritourism"](area.country);
  node["tourism"="farm"](area.country);
  way["tourism"="farm"](area.country);
  node["shop"="farm"](area.country);
  way["shop"="farm"](area.country);
  node["shop"="farmshop"](area.country);
  way["shop"="farmshop"](area.country);
  node["shop"="wine"](area.country);
  way["shop"="wine"](area.country);
  node["amenity"="winery"](area.country);
  way["amenity"="winery"](area.country);
  node["craft"="winery"](area.country);
  way["craft"="winery"](area.country);
  node["craft"="distillery"](area.country);
  way["craft"="distillery"](area.country);
  node["craft"="brewery"]["taproom"="yes"](area.country);
  node["shop"="organic"](area.country);
  way["shop"="organic"](area.country);
  node["shop"="cheese"](area.country);
  way["shop"="cheese"](area.country);
  node["shop"="olive_oil"](area.country);
  node["shop"="deli"]["local_food"](area.country);
  node["amenity"="marketplace"]["organic"="yes"](area.country);
  node["amenity"="marketplace"]["local_food"](area.country);
  node["amenity"="marketplace"]["shop"="farm"](area.country);
);
out center tags;
"""


def query_overpass(iso_code: str, retries: int = 3) -> list:
    query = build_overpass_query(iso_code)
    for attempt in range(1, retries + 1):
        try:
            resp = requests.post(OVERPASS_URL, data={"data": query}, timeout=180)
            resp.raise_for_status()
            return resp.json().get("elements", [])
        except requests.exceptions.Timeout:
            if attempt < retries:
                print(f"  Timeout (attempt {attempt}), retrying in 20s...")
                time.sleep(20)
            else:
                print(f"  ERROR: Overpass timed out after {retries} attempts")
                return []
        except requests.exceptions.HTTPError as e:
            if e.response is not None and e.response.status_code == 429:
                wait = 60 * attempt
                print(f"  Rate limited (attempt {attempt}), waiting {wait}s...")
                time.sleep(wait)
                if attempt == retries:
                    print(f"  ERROR: Still rate limited after {retries} attempts")
                    return []
            else:
                print(f"  ERROR querying Overpass: {e}")
                return []
        except Exception as e:
            print(f"  ERROR querying Overpass: {e}")
            return []


# ──────────────────────────────────────────────────────────────────────────────
# Tag helpers
# ──────────────────────────────────────────────────────────────────────────────

def is_curated(tags: dict) -> bool:
    for key, value in CURATED_TAGS:
        if tags.get(key) == value:
            return True
    # Farmyard with any shop or direct-sale indicator
    if tags.get("landuse") == "farmyard" and (
        tags.get("shop") or tags.get("direct_sales") == "yes" or tags.get("tourism")
    ):
        return True
    return False


def get_lat_lon(el: dict):
    if el["type"] == "node":
        return el.get("lat"), el.get("lon")
    if el["type"] in ("way", "relation") and "center" in el:
        return el["center"].get("lat"), el["center"].get("lon")
    return None, None


def get_name(tags: dict, prefer_lang: str = None) -> str | None:
    name = None
    if prefer_lang:
        name = tags.get(f"name:{prefer_lang}")
    if not name:
        name = tags.get("name")
    if not name:
        return None
    # Bilingual name: pick the longer part (usually the local one)
    if " - " in name:
        name = max(name.split(" - "), key=len).strip()
    return name.strip() or None


def get_website(tags: dict) -> str | None:
    for k in ("website", "contact:website", "url"):
        v = tags.get(k)
        if v and v.startswith("http"):
            return v
    return None


def build_address(tags: dict) -> str | None:
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


def get_municipality(tags: dict) -> str | None:
    for k in ("addr:city", "contact:city", "addr:hamlet", "addr:suburb", "addr:town", "addr:village"):
        v = tags.get(k)
        if v:
            if " - " in v:
                return v.split(" - ")[-1].strip()
            return v
    return None


def get_region(tags: dict, country_code: str) -> str | None:
    """Try to extract region from addr:state / addr:province tags."""
    state = tags.get("addr:state") or tags.get("is_in:state")
    if state:
        return state.strip()
    return None


def get_products(tags: dict) -> list:
    produce = tags.get("produce") or tags.get("product")
    if produce:
        return [p.strip() for p in re.split(r"[;,/]", produce) if p.strip()]
    return []


def element_to_entry(el: dict, country_label: str, country_code: str) -> dict | None:
    tags = el.get("tags", {})
    name = get_name(tags)
    lat, lon = get_lat_lon(el)

    if not lat or not lon or not name:
        return None

    website = get_website(tags)
    address = build_address(tags)
    phone = (tags.get("phone") or tags.get("contact:phone") or
             tags.get("mobile") or tags.get("contact:mobile"))
    municipality = get_municipality(tags)

    # For non-curated tags require at least one contact/location field
    if not is_curated(tags):
        if not (website or address or phone or municipality):
            return None

    # Skip overly generic names with no extra info
    if SUPPRESS_PATTERNS.match(name) and not website and not address:
        return None

    region = get_region(tags, country_code)
    products = get_products(tags)

    entry = {
        "id": el["id"],
        "name": name,
        "country": country_label,
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


# ──────────────────────────────────────────────────────────────────────────────
# Region assignment via bounding boxes
# ──────────────────────────────────────────────────────────────────────────────

# Rough bounding boxes [south, north, west, east] per country-code → region
# These cover the main NUTS-1/NUTS-2 or equivalent administrative regions.
# Enough for coarse assignment; Nominatim or a dedicated script can refine later.

REGION_BBOXES: dict[str, list[tuple]] = {
    "DE": [
        ("Baden-Württemberg",  47.5, 49.8,  7.5, 10.5),
        ("Bayern",             47.2, 50.6,  9.9, 13.9),
        ("Berlin",             52.3, 52.7, 13.0, 13.8),
        ("Brandenburg",        51.4, 53.6, 11.3, 14.8),
        ("Bremen",             53.0, 53.6,  8.5,  9.0),
        ("Hamburg",            53.4, 53.7,  9.7, 10.3),
        ("Hessen",             49.4, 51.7,  7.8, 10.2),
        ("Mecklenburg-Vorpommern", 53.1, 54.7, 10.6, 14.5),
        ("Niedersachsen",      51.3, 53.9,  6.6, 11.6),
        ("Nordrhein-Westfalen",50.3, 52.5,  5.9,  9.5),
        ("Rheinland-Pfalz",    49.1, 51.0,  6.1,  8.5),
        ("Saarland",           49.1, 49.7,  6.4,  7.4),
        ("Sachsen",            50.2, 51.7, 11.9, 15.1),
        ("Sachsen-Anhalt",     51.0, 53.1, 10.6, 13.2),
        ("Schleswig-Holstein", 53.4, 55.1,  8.0, 11.3),
        ("Thüringen",          50.2, 51.7,  9.9, 12.7),
    ],
    "FR": [
        ("Auvergne-Rhône-Alpes",    44.1, 46.8,  2.1,  7.7),
        ("Bourgogne-Franche-Comté", 46.2, 48.5,  3.2,  7.1),
        ("Bretagne",                47.3, 48.9, -5.2, -1.1),
        ("Centre-Val de Loire",     46.4, 48.8,  0.0,  3.2),
        ("Corse",                   41.3, 43.1,  8.5,  9.6),
        ("Grand Est",               47.4, 50.0,  3.4,  8.3),
        ("Hauts-de-France",         49.3, 51.1,  1.4,  4.3),
        ("Île-de-France",           48.1, 49.2,  1.4,  3.6),
        ("Normandie",               48.1, 50.0, -2.1,  1.8),
        ("Nouvelle-Aquitaine",      43.0, 47.6, -1.9,  3.3),
        ("Occitanie",               42.3, 45.1, -0.2,  4.9),
        ("Pays de la Loire",        46.3, 48.4, -2.6,  1.6),
        ("Provence-Alpes-Côte d'Azur", 43.1, 45.1,  3.9,  7.7),
    ],
    "CH": [
        ("Zürich",         47.2, 47.7,  8.4,  8.9),
        ("Bern",           46.3, 47.5,  6.9,  8.5),
        ("Luzern",         46.8, 47.3,  7.8,  8.6),
        ("Uri",            46.5, 47.0,  8.4,  8.9),
        ("Schwyz",         46.9, 47.3,  8.5,  9.1),
        ("Obwalden",       46.7, 47.0,  8.0,  8.5),
        ("Nidwalden",      46.8, 47.1,  8.2,  8.6),
        ("Glarus",         46.8, 47.2,  8.9,  9.2),
        ("Zug",            47.1, 47.3,  8.4,  8.7),
        ("Fribourg",       46.5, 47.1,  6.8,  7.4),
        ("Solothurn",      47.1, 47.6,  7.3,  8.1),
        ("Basel-Stadt",    47.5, 47.6,  7.5,  7.7),
        ("Basel-Landschaft", 47.3, 47.6, 7.5, 8.1),
        ("Schaffhausen",   47.6, 47.9,  8.3,  8.8),
        ("Appenzell Ausserrhoden", 47.3, 47.5, 9.2, 9.5),
        ("Appenzell Innerrhoden",  47.3, 47.5, 9.2, 9.5),
        ("St. Gallen",     46.9, 47.6,  8.9,  9.8),
        ("Graubünden",     46.1, 47.1,  8.7, 10.5),
        ("Aargau",         47.3, 47.7,  7.7,  8.4),
        ("Thurgau",        47.5, 47.7,  8.7,  9.5),
        ("Ticino",         45.8, 46.7,  8.4,  9.1),
        ("Vaud",           46.2, 47.0,  6.1,  7.3),
        ("Valais",         45.9, 46.8,  6.8,  8.4),
        ("Neuchâtel",      46.9, 47.2,  6.5,  7.1),
        ("Genève",         46.1, 46.4,  5.9,  6.3),
        ("Jura",           47.1, 47.5,  6.8,  7.6),
    ],
    "AT": [
        ("Burgenland",     47.4, 48.0, 16.0, 17.2),
        ("Kärnten",        46.4, 47.2, 12.6, 15.1),
        ("Niederösterreich", 47.4, 49.0, 14.5, 17.2),
        ("Oberösterreich", 47.5, 48.8, 12.8, 15.1),
        ("Salzburg",       47.0, 48.1, 12.2, 14.0),
        ("Steiermark",     46.6, 48.0, 13.6, 16.2),
        ("Tirol",          46.7, 47.8, 10.1, 12.9),
        ("Vorarlberg",     47.0, 47.6,  9.5, 10.3),
        ("Wien",           48.1, 48.3, 16.2, 16.6),
    ],
    "NL": [
        ("Groningen",     52.9, 53.5,  6.5,  7.2),
        ("Friesland",     52.8, 53.5,  4.7,  6.4),
        ("Drenthe",       52.5, 53.1,  6.1,  7.1),
        ("Overijssel",    52.2, 52.9,  6.1,  7.2),
        ("Flevoland",     52.3, 52.8,  5.3,  6.1),
        ("Gelderland",    51.7, 52.5,  5.2,  7.0),
        ("Utrecht",       51.9, 52.3,  4.8,  5.6),
        ("Noord-Holland", 52.2, 53.2,  4.5,  5.2),
        ("Zuid-Holland",  51.7, 52.2,  4.0,  5.1),
        ("Zeeland",       51.2, 51.8,  3.4,  4.3),
        ("Noord-Brabant", 51.3, 51.9,  3.8,  6.2),
        ("Limburg",       50.8, 51.9,  5.6,  6.2),
    ],
    "BE": [
        ("Antwerpen",            51.1, 51.6, 3.9, 5.3),
        ("Oost-Vlaanderen",      50.7, 51.3, 3.2, 4.2),
        ("West-Vlaanderen",      50.7, 51.4, 2.5, 3.6),
        ("Vlaams-Brabant",       50.6, 51.1, 4.3, 5.1),
        ("Limburg",              50.7, 51.3, 5.1, 5.9),
        ("Hainaut",              49.9, 50.8, 3.3, 4.6),
        ("Namur",                49.8, 50.6, 4.5, 5.7),
        ("Liège",                50.2, 50.9, 5.5, 6.4),
        ("Luxembourg",           49.4, 50.3, 5.1, 6.0),
        ("Brabant Wallon",       50.5, 50.8, 4.3, 5.0),
        ("Bruxelles",            50.8, 50.9, 4.3, 4.5),
    ],
    "DK": [
        ("Nordjylland",         56.8, 57.8,  8.1, 11.0),
        ("Midtjylland",         55.7, 57.2,  8.0, 11.0),
        ("Syddanmark",          54.9, 56.3,  8.1, 12.4),
        ("Sjælland",            54.5, 56.1,  9.7, 12.6),
        ("Hovedstaden",         55.4, 56.2, 11.5, 12.7),
    ],
    "SE": [
        ("Norrbotten",    64.0, 69.1, 16.0, 24.2),
        ("Västernorrland",62.0, 64.2, 14.9, 19.1),
        ("Jämtland",      61.9, 65.0, 11.8, 17.8),
        ("Västerbotten",  63.1, 66.3, 15.5, 21.6),
        ("Gävleborg",     60.5, 62.5, 14.8, 18.2),
        ("Dalarna",       59.6, 62.1, 12.2, 16.5),
        ("Värmland",      59.2, 61.0, 11.7, 14.4),
        ("Uppsala",       59.5, 61.0, 16.7, 18.6),
        ("Örebro",        58.6, 59.9, 13.9, 16.0),
        ("Västmanland",   59.3, 60.0, 15.6, 16.8),
        ("Stockholm",     58.8, 59.9, 17.2, 19.0),
        ("Södermanland",  58.5, 59.6, 15.9, 17.7),
        ("Östergötland",  57.7, 59.0, 14.3, 16.9),
        ("Västra Götaland",57.0, 59.3, 10.8, 13.8),
        ("Jönköping",     57.1, 58.5, 13.0, 15.4),
        ("Kronoberg",     56.4, 57.7, 13.0, 15.5),
        ("Kalmar",        55.8, 57.8, 14.6, 17.4),
        ("Blekinge",      55.8, 56.4, 14.2, 16.0),
        ("Halland",       56.3, 57.6, 11.6, 13.7),
        ("Skåne",         55.2, 56.5, 12.4, 14.6),
        ("Gotland",       56.9, 58.0, 18.0, 19.4),
    ],
    "FI": [
        ("Lappi",              66.0, 70.1, 23.5, 29.4),
        ("Pohjois-Pohjanmaa",  63.5, 66.2, 23.0, 30.0),
        ("Kainuu",             63.1, 65.1, 27.3, 30.5),
        ("Pohjois-Savo",       62.1, 64.0, 25.8, 29.5),
        ("Pohjois-Karjala",    61.8, 63.8, 28.5, 31.6),
        ("Etelä-Savo",         60.8, 62.9, 26.0, 30.2),
        ("Keski-Suomi",        61.5, 63.1, 23.5, 26.0),
        ("Pirkanmaa",          61.0, 62.5, 22.5, 24.8),
        ("Satakunta",          61.0, 62.2, 21.1, 23.4),
        ("Pohjanmaa",          62.4, 63.9, 20.4, 23.2),
        ("Etelä-Pohjanmaa",    62.0, 63.5, 21.6, 23.8),
        ("Keski-Pohjanmaa",    63.3, 64.4, 23.0, 25.0),
        ("Päijät-Häme",        60.6, 61.5, 25.5, 26.5),
        ("Kanta-Häme",         60.4, 61.4, 23.5, 26.0),
        ("Kymenlaakso",        60.2, 61.2, 26.6, 28.0),
        ("Etelä-Karjala",      60.5, 61.8, 27.8, 30.2),
        ("Varsinais-Suomi",    59.8, 61.6, 20.5, 23.6),
        ("Uusimaa",            59.9, 61.0, 23.5, 26.9),
    ],
    "GB": [
        ("England",         50.0, 55.8,  -5.8,  2.2),
        ("Scotland",        54.5, 60.9,  -7.5,  1.8),
        ("Wales",           51.3, 53.5,  -5.4, -2.7),
        ("Northern Ireland",54.0, 55.4,  -8.2, -5.4),
    ],
    "IE": [
        ("Connacht",  52.6, 54.4, -10.7, -7.4),
        ("Leinster",  52.2, 54.2,  -8.3, -5.9),
        ("Munster",   51.4, 53.2,  -10.7, -7.2),
        ("Ulster",    54.0, 55.4,   -8.3, -5.9),
    ],
    "ES": [
        ("Galicia",                    42.0, 44.0, -9.3, -6.7),
        ("Asturias",                   42.9, 43.7, -7.2, -4.5),
        ("Cantabria",                  42.8, 43.5, -4.9, -3.3),
        ("País Vasco",                 42.5, 43.5, -3.4, -1.7),
        ("Navarra",                    41.9, 43.5, -2.5,  2.0),
        ("La Rioja",                   41.9, 42.7, -3.2, -2.0),
        ("Aragón",                     39.9, 43.0, -1.9,  1.1),
        ("Cataluña",                   40.5, 42.9,  0.0,  3.3),
        ("Islas Baleares",             38.6, 40.1,  1.3,  4.4),
        ("Castilla y León",            40.0, 43.2, -7.1,  3.0),
        ("Madrid",                     39.9, 41.3, -4.6, -3.0),
        ("Castilla-La Mancha",         37.9, 41.5, -5.6, -0.9),
        ("Extremadura",                37.9, 40.5, -7.6, -4.9),
        ("Andalucía",                  36.0, 38.8, -7.5, -1.6),
        ("Valencia",                   37.8, 40.8, -1.5,  0.5),
        ("Murcia",                     37.4, 38.7, -2.4,  0.1),
        ("Canarias",                   27.6, 29.5, -18.2, -13.4),
    ],
    "PT": [
        ("Norte",          40.8, 42.2, -8.2, -6.2),
        ("Centro",         39.0, 41.4, -9.0, -6.7),
        ("Lisboa",         38.5, 39.3, -9.5, -8.8),
        ("Alentejo",       37.1, 39.6, -8.9, -6.6),
        ("Algarve",        36.9, 37.8, -8.7, -7.4),
        ("Açores",         36.9, 40.3, -31.3, -24.8),
        ("Madeira",        32.4, 33.2, -17.3, -16.3),
    ],
    "PL": [
        ("Dolnoslaskie",          50.0, 51.9, 14.5, 17.9),
        ("Kujawsko-Pomorskie",    52.5, 53.8, 17.5, 19.7),
        ("Lubelskie",             50.2, 52.5, 21.5, 24.2),
        ("Lubuskie",              51.2, 52.9, 14.0, 16.2),
        ("Lodzkie",               51.0, 52.5, 18.0, 20.7),
        ("Malopolskie",           49.2, 50.8, 19.0, 21.6),
        ("Mazowieckie",           51.0, 53.5, 19.3, 22.9),
        ("Opolskie",              50.0, 51.2, 17.0, 18.5),
        ("Podkarpackie",          49.0, 50.9, 21.5, 23.1),
        ("Podlaskie",             52.0, 54.5, 22.0, 24.0),
        ("Pomorskie",             53.5, 54.9, 16.5, 19.5),
        ("Slaskie",               49.5, 51.2, 17.8, 19.8),
        ("Swietokrzyskie",        50.2, 51.3, 19.7, 21.5),
        ("Warminsko-Mazurskie",   53.0, 54.5, 19.0, 23.0),
        ("Wielkopolskie",         51.3, 53.5, 15.5, 19.0),
        ("Zachodniopomorskie",    52.9, 54.5, 14.0, 17.2),
    ],
    "CZ": [
        ("Praha",               49.9, 50.2, 14.2, 14.7),
        ("Stredocesky",         49.5, 50.8, 13.5, 15.8),
        ("Jihocesky",           48.5, 49.9, 13.2, 15.5),
        ("Plzensky",            49.0, 50.1, 12.2, 13.8),
        ("Karlovarsky",         49.7, 50.5, 12.0, 13.1),
        ("Ustecky",             50.2, 51.0, 12.8, 14.8),
        ("Liberecky",           50.5, 51.1, 14.7, 15.8),
        ("Kralovehradecky",     50.0, 50.8, 15.4, 16.7),
        ("Pardubicky",          49.7, 50.5, 15.5, 17.0),
        ("Vysocina",            49.2, 50.0, 15.3, 16.8),
        ("Jihomoravsky",        48.6, 49.6, 15.8, 18.5),
        ("Olomoucky",           49.3, 50.3, 16.5, 17.8),
        ("Zlinsky",             48.9, 49.8, 17.3, 18.5),
        ("Moravskoslezsky",     49.4, 50.5, 17.5, 18.9),
    ],
    "SK": [
        ("Bratislavsky",        47.7, 48.5, 16.8, 18.0),
        ("Trnavsky",            47.7, 48.7, 17.2, 18.8),
        ("Trenciansky",         48.5, 49.5, 17.5, 18.9),
        ("Nitriansky",          47.6, 48.7, 17.6, 19.2),
        ("Zilinsky",            49.0, 49.8, 18.5, 20.0),
        ("Banskobystricky",     48.1, 49.5, 18.5, 20.8),
        ("Presovsky",           48.5, 49.6, 20.0, 22.5),
        ("Kosicky",             48.2, 49.3, 20.3, 22.0),
    ],
    "HU": [
        ("Budapest",            47.35, 47.65, 18.9, 19.3),
        ("Pest",                47.0,  48.3,  18.7, 20.2),
        ("Kozep-Dunantul",      46.7,  48.1,  17.3, 19.2),
        ("Nyugat-Dunantul",     46.7,  47.6,  15.8, 17.7),
        ("Del-Dunantul",        45.6,  47.0,  16.5, 19.5),
        ("Eszak-Magyarorszag",  47.5,  48.9,  19.0, 22.2),
        ("Del-Alfold",          45.6,  47.2,  18.8, 21.8),
        ("Eszak-Alfold",        47.0,  48.5,  21.0, 23.0),
    ],
    "RO": [
        ("Nord-Vest",           46.7, 48.3, 22.0, 27.0),
        ("Centru",              45.0, 47.5, 23.5, 27.5),
        ("Nord-Est",            45.0, 48.3, 26.0, 30.0),
        ("Sud-Est",             43.6, 46.0, 26.0, 30.5),
        ("Sud-Muntenia",        43.5, 45.5, 24.0, 28.5),
        ("Bucuresti-Ilfov",     44.0, 44.7, 25.7, 26.5),
        ("Sud-Vest Oltenia",    43.5, 45.5, 22.0, 25.5),
        ("Vest",                44.5, 46.5, 21.0, 23.5),
    ],
    "BG": [
        ("Northwest",           43.0, 44.6, 22.0, 24.8),
        ("North Central",       43.0, 44.0, 24.5, 27.0),
        ("Northeast",           43.0, 44.0, 26.5, 28.6),
        ("Southwest",           41.0, 43.0, 22.0, 24.5),
        ("South Central",       41.0, 43.0, 23.0, 26.5),
        ("Southeast",           41.6, 43.0, 25.5, 28.6),
    ],
    "EE": [
        ("Northern Estonia",    59.0, 59.9, 23.3, 27.8),
        ("Eastern Estonia",     57.7, 59.5, 26.5, 28.2),
        ("Southern Estonia",    57.5, 58.5, 24.5, 27.2),
        ("Western Estonia",     57.5, 59.7, 21.8, 25.3),
    ],
    "LV": [
        ("Riga",     56.7, 57.1, 23.7, 24.5),
        ("Vidzeme",  56.5, 58.0, 24.5, 27.1),
        ("Zemgale",  56.0, 57.2, 22.7, 25.6),
        ("Kurzeme",  55.7, 57.8, 20.9, 23.5),
        ("Latgale",  55.5, 57.5, 26.5, 28.7),
    ],
    "LT": [
        ("Vilnius",      54.0, 55.5, 24.5, 26.5),
        ("Kaunas",       54.0, 55.5, 23.0, 25.0),
        ("Klaipeda",     55.2, 56.6, 21.0, 23.1),
        ("Siauliai",     55.5, 56.9, 22.5, 24.5),
        ("Panevezys",    55.5, 57.0, 23.5, 26.0),
        ("Alytus",       53.5, 54.5, 23.5, 25.5),
        ("Marijampole",  54.0, 55.0, 22.5, 24.0),
        ("Taurage",      55.0, 56.2, 21.8, 23.0),
        ("Telsiai",      55.5, 56.8, 21.5, 23.0),
        ("Utena",        54.8, 56.2, 24.5, 26.7),
    ],
    "HR": [
        ("Northwest Croatia",   45.5, 46.7, 15.0, 17.5),
        ("Slavonia",            44.5, 46.0, 17.0, 19.5),
        ("Kvarner",             44.5, 46.5, 14.0, 15.5),
        ("Dalmatia",            42.3, 45.0, 13.3, 17.5),
    ],
    "SI": [
        ("Western Slovenia",    45.4, 46.9, 13.4, 15.1),
        ("Eastern Slovenia",    45.4, 47.0, 14.8, 16.6),
    ],
    "RS": [
        ("Vojvodina",           44.5, 46.2, 18.8, 23.0),
        ("Belgrade",            44.6, 45.0, 20.0, 20.8),
        ("Central Serbia",      42.2, 44.8, 19.0, 23.0),
        ("Southern Serbia",     41.8, 43.5, 20.0, 22.8),
    ],
    "BA": [
        ("Federation BiH",      42.4, 45.3, 15.7, 18.5),
        ("Republika Srpska",    44.0, 45.3, 17.2, 19.7),
    ],
    "ME": [
        ("Coastal Montenegro",  41.8, 42.7, 18.3, 19.2),
        ("Central Montenegro",  42.0, 43.0, 19.0, 20.5),
        ("Northern Montenegro", 42.5, 43.5, 18.5, 20.5),
    ],
    "MK": [
        ("Skopje",      41.7, 42.3, 20.9, 22.0),
        ("Western",     40.8, 42.3, 20.2, 21.0),
        ("Central",     41.5, 42.5, 21.0, 22.5),
        ("Eastern",     41.1, 42.0, 22.0, 23.2),
    ],
    "AL": [
        ("Northern Albania",    41.5, 42.7, 19.0, 21.0),
        ("Central Albania",     40.5, 41.6, 19.5, 20.5),
        ("Coastal Albania",     39.5, 42.0, 18.9, 20.0),
        ("Southeastern Albania",40.0, 41.5, 20.0, 21.5),
    ],
    "GR": [
        ("Attica",                              37.6, 38.3, 23.0, 24.2),
        ("Central Greece",                      38.0, 39.5, 21.2, 24.5),
        ("Central Macedonia",                   40.0, 41.4, 21.5, 24.5),
        ("Crete",                               34.8, 35.8, 24.0, 26.5),
        ("Eastern Macedonia and Thrace",        40.5, 42.0, 24.5, 26.7),
        ("Epirus",                              38.8, 40.8, 20.4, 21.5),
        ("Ionian Islands",                      37.3, 40.0, 19.5, 21.5),
        ("North Aegean",                        37.5, 40.0, 25.3, 27.2),
        ("Peloponnese",                         36.4, 38.3, 21.0, 23.5),
        ("South Aegean",                        35.0, 38.5, 24.5, 28.3),
        ("Thessaly",                            39.0, 40.5, 21.5, 23.6),
        ("Western Greece",                      37.8, 39.8, 20.5, 22.5),
        ("Western Macedonia",                   40.0, 41.5, 20.8, 22.5),
    ],
    "CY": [
        ("Nicosia",   34.9, 35.4, 32.8, 33.6),
        ("Limassol",  34.5, 35.2, 32.4, 33.5),
        ("Larnaca",   34.7, 35.2, 33.3, 34.2),
        ("Paphos",    34.6, 35.2, 32.2, 32.9),
        ("Famagusta", 34.9, 35.7, 33.5, 34.6),
        ("Kyrenia",   35.2, 35.7, 32.8, 34.0),
    ],
    "US": [
        ("New England",        41.0, 47.5, -73.5, -66.9),
        ("Middle Atlantic",    39.5, 45.0, -80.5, -71.9),
        ("East North Central", 36.5, 48.5, -90.5, -80.5),
        ("West North Central", 36.0, 49.4,-104.1, -89.9),
        ("South Atlantic",     24.4, 39.6, -84.9, -75.4),
        ("East South Central", 30.0, 37.0, -91.7, -82.0),
        ("West South Central", 25.5, 37.3,-106.7, -88.7),
        ("Mountain",           31.3, 49.0,-116.1,-102.0),
        ("Pacific",            32.5, 49.0,-124.8,-114.1),
        ("Alaska",             54.5, 71.5,-168.0,-130.0),
        ("Hawaii",             18.9, 22.3,-160.2,-154.8),
    ],
    "CA": [
        ("British Columbia",           48.3, 60.0, -139.1, -113.9),
        ("Alberta",                    49.0, 60.0, -120.0, -110.0),
        ("Saskatchewan",               49.0, 60.0, -110.0, -102.0),
        ("Manitoba",                   49.0, 60.0, -102.1,  -88.9),
        ("Ontario",                    41.6, 57.0,  -95.2,  -74.3),
        ("Quebec",                     44.9, 62.6,  -79.8,  -57.1),
        ("New Brunswick",              44.5, 48.1,  -69.1,  -63.8),
        ("Nova Scotia",                43.4, 47.1,  -66.4,  -59.7),
        ("Prince Edward Island",       45.9, 47.1,  -64.5,  -62.0),
        ("Newfoundland and Labrador",  46.6, 60.4,  -67.8,  -52.6),
        ("Yukon",                      60.0, 70.0, -141.0, -124.0),
        ("Northwest Territories",      60.0, 78.8, -136.5, -101.4),
        ("Nunavut",                    61.5, 83.1, -120.0,  -61.8),
    ],
    "AU": [
        ("New South Wales",           -37.6, -28.2, 140.9, 153.7),
        ("Victoria",                  -39.2, -34.0, 140.9, 150.0),
        ("Queensland",                -29.2, -10.7, 138.0, 153.6),
        ("South Australia",           -38.1, -26.0, 129.0, 141.0),
        ("Western Australia",         -35.2, -14.0, 112.9, 129.0),
        ("Tasmania",                  -43.7, -39.6, 143.8, 148.5),
        ("Northern Territory",        -26.1, -10.9, 129.0, 138.1),
        ("Australian Capital Territory", -35.9, -35.1, 148.8, 149.4),
    ],
    "NZ": [
        ("Northland",      -36.4, -34.4, 173.0, 174.6),
        ("Auckland",       -37.5, -36.4, 174.1, 176.0),
        ("Waikato",        -39.2, -36.9, 174.5, 178.5),
        ("Bay of Plenty",  -38.5, -37.0, 175.5, 178.5),
        ("Hawke's Bay",    -40.3, -38.5, 175.5, 178.5),
        ("Taranaki",       -39.8, -38.7, 173.8, 175.0),
        ("Wellington",     -41.8, -40.6, 174.5, 176.5),
        ("Canterbury",     -44.6, -42.0, 169.0, 173.5),
        ("Otago",          -46.5, -43.3, 168.0, 171.5),
        ("Southland",      -46.7, -44.9, 166.4, 169.5),
        ("West Coast",     -44.4, -41.5, 167.8, 172.5),
        ("Nelson-Marlborough", -42.5, -41.2, 172.0, 174.5),
    ],
}


def assign_region(lat: float, lon: float, country_code: str) -> str | None:
    """Assign a region using rough bounding boxes."""
    bboxes = REGION_BBOXES.get(country_code.upper(), [])
    for region_name, south, north, west, east in bboxes:
        if south <= lat <= north and west <= lon <= east:
            return region_name
    return None


# ──────────────────────────────────────────────────────────────────────────────
# Main import logic
# ──────────────────────────────────────────────────────────────────────────────

def import_country(code: str, all_data: list, dry_run: bool = False) -> list:
    """Import or refresh entries for one country. Returns updated all_data list."""
    info = COUNTRIES[code.upper()]
    country_label = info["country_label"]
    osm_name = info["osm_name"]

    print(f"\n{'='*60}")
    print(f"  {country_label} ({code.upper()})")
    print(f"{'='*60}")

    existing_non_country = [e for e in all_data if e.get("country") != country_label]
    existing_country = [e for e in all_data if e.get("country") == country_label]
    print(f"  Existing entries for {country_label}: {len(existing_country)}")

    print(f"  Querying Overpass API ({code.upper()} via ISO3166)...")
    elements = query_overpass(code.upper())
    print(f"  Got {len(elements)} Overpass elements")

    new_entries = []
    skipped = 0
    for el in elements:
        entry = element_to_entry(el, country_label, code.upper())
        if entry is None:
            skipped += 1
            continue
        # Assign region from bounding box if not already set
        if not entry.get("region") and entry.get("lat") and entry.get("lon"):
            entry["region"] = assign_region(float(entry["lat"]), float(entry["lon"]), code.upper())
        new_entries.append(entry)

    # Deduplicate by id
    seen = set()
    deduped = []
    for e in new_entries:
        if e["id"] not in seen:
            seen.add(e["id"])
            deduped.append(e)
    new_entries = deduped

    print(f"  Skipped: {skipped} | New entries: {len(new_entries)}")

    # Region summary
    from collections import Counter
    region_counts = Counter(e.get("region") or "unassigned" for e in new_entries)
    for region, cnt in sorted(region_counts.items(), key=lambda x: -x[1])[:10]:
        print(f"    {cnt:4d}  {region}")
    if len(region_counts) > 10:
        print(f"    ... and {len(region_counts)-10} more regions")

    if dry_run:
        print("  [dry-run] Not saving.")
        return all_data

    return existing_non_country + new_entries


def rebuild_country_slice(country_label: str, all_data: list):
    """Write the country slice JSON file."""
    cc = next((k for k, v in COUNTRIES.items() if v["country_label"] == country_label), None)
    if not cc:
        return
    entries = [e for e in all_data if e.get("country") == country_label]
    out_path = COUNTRY_SLICE_DIR / f"{cc.lower()}.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(entries, f, ensure_ascii=False, indent=2)
    print(f"  Saved {len(entries)} entries → {out_path.name}")


# ──────────────────────────────────────────────────────────────────────────────
# Entry point
# ──────────────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Import OSM farmshops for one or more countries.")
    parser.add_argument("countries", nargs="*", help="Country codes e.g. DE FR AT (default: all)")
    parser.add_argument("--dry-run", action="store_true", help="Query and count without saving")
    args = parser.parse_args()

    target_codes = [c.upper() for c in args.countries] if args.countries else list(COUNTRIES.keys())
    # Skip Norway — it has its own dedicated import pipeline
    target_codes = [c for c in target_codes if c != "NO"]

    invalid = [c for c in target_codes if c not in COUNTRIES]
    if invalid:
        print(f"Unknown country codes: {invalid}")
        print(f"Valid codes: {', '.join(COUNTRIES.keys())}")
        sys.exit(1)

    print(f"Loading {FARMSHOPS_PATH}...")
    with open(FARMSHOPS_PATH, encoding="utf-8") as f:
        all_data = json.load(f)
    print(f"  Total entries: {len(all_data)}")

    updated_countries = []

    for code in target_codes:
        all_data = import_country(code, all_data, dry_run=args.dry_run)
        updated_countries.append(COUNTRIES[code]["country_label"])
        if not args.dry_run:
            # Save after each country so we don't lose progress on failure
            with open(FARMSHOPS_PATH, "w", encoding="utf-8") as f:
                json.dump(all_data, f, ensure_ascii=False, indent=2)
            rebuild_country_slice(COUNTRIES[code]["country_label"], all_data)
        # Brief pause between countries to be polite to Overpass
        if len(target_codes) > 1:
            print("  Waiting 5s before next country...")
            time.sleep(5)

    if not args.dry_run:
        # Final save (already saved incrementally, but ensures last country is written)
        with open(FARMSHOPS_PATH, "w", encoding="utf-8") as f:
            json.dump(all_data, f, ensure_ascii=False, indent=2)

        print(f"\n{'='*60}")
        print(f"  DONE")
        print(f"  Total entries: {len(all_data)}")
        from collections import Counter
        c = Counter(e.get("country", "?") for e in all_data)
        for country, count in sorted(c.items(), key=lambda x: -x[1]):
            if country in updated_countries or True:
                print(f"    {count:6d}  {country}")
        print(f"{'='*60}")


if __name__ == "__main__":
    main()
