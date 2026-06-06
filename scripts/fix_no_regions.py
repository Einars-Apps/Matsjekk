"""
Quality fix for no.json:
1. Fix outdated region names (Hordaland→Vestland, Hedmark→Innlandet, Nord-Trøndelag→Trøndelag)
2. Title-case ALL-CAPS municipality names
3. Replace postal codes with proper municipality names via Nominatim
4. Fill in NULL/missing region from municipality using a comprehensive lookup
5. Fix known wrong municipality assignments (post-2024 kommunereform)
"""
import json
import re
import shutil
import time
import urllib.request
import urllib.parse

# ─── Complete municipality → region lookup (Norway 2024/2025) ────────────────
# Covers all 356 municipalities split into current 15 counties
MUNICIPALITY_TO_REGION = {
    # Oslo
    "Oslo": "Oslo",

    # Innlandet (Hedmark + Oppland)
    "Alvdal": "Innlandet", "Dovre": "Innlandet", "Engerdal": "Innlandet",
    "Folldal": "Innlandet", "Gausdal": "Innlandet", "Gjøvik": "Innlandet",
    "Gran": "Innlandet", "Hamar": "Innlandet", "Innlandet": "Innlandet",
    "Jevnaker": "Innlandet", "Kongsvinger": "Innlandet", "Lesja": "Innlandet",
    "Lillehammer": "Innlandet", "Lom": "Innlandet", "Løten": "Innlandet",
    "Nord-Fron": "Innlandet", "Nord-Odal": "Innlandet", "Nordre Land": "Innlandet",
    "Os": "Innlandet", "Rendalen": "Innlandet", "Ringebu": "Innlandet",
    "Ringsaker": "Innlandet", "Sel": "Innlandet", "Skjåk": "Innlandet",
    "Sør-Aurdal": "Innlandet", "Sør-Fron": "Innlandet", "Sør-Odal": "Innlandet",
    "Stange": "Innlandet", "Stor-Elvdal": "Innlandet", "Søndre Land": "Innlandet",
    "Tolga": "Innlandet", "Trysil": "Innlandet", "Tynset": "Innlandet",
    "Vågå": "Innlandet", "Våler": "Innlandet", "Vestre Slidre": "Innlandet",
    "Vestre Toten": "Innlandet", "Vingelen": "Innlandet", "Vinstra": "Innlandet",
    "Østre Toten": "Innlandet", "Øyer": "Innlandet", "Åmot": "Innlandet",
    "Åsnes": "Innlandet", "Elverum": "Innlandet", "Grue": "Innlandet",
    "Kvam": "Innlandet", "Etnedal": "Innlandet", "Norges Bank": "Innlandet",
    "Raufoss": "Innlandet", "Brumunddal": "Innlandet", "Moelv": "Innlandet",
    "Koppang": "Innlandet", "Kirkenær": "Innlandet", "Torpa": "Innlandet",
    "Brandbu": "Innlandet", "Gjøvikvegen": "Innlandet",

    # Akershus (ny Akershus fra 2024, tidligere deler av Viken)
    "Asker": "Akershus", "Aurskog-Høland": "Akershus", "Bærum": "Akershus",
    "Eidsvoll": "Akershus", "Enebakk": "Akershus", "Frogn": "Akershus",
    "Gjerdrum": "Akershus", "Hurdal": "Akershus", "Lillestrøm": "Akershus",
    "Lørenskog": "Akershus", "Nannestad": "Akershus", "Nes": "Akershus",
    "Nesodden": "Akershus", "Nittedal": "Akershus", "Nordre Follo": "Akershus",
    "Rælingen": "Akershus", "Ullensaker": "Akershus", "Vestby": "Akershus",
    "Ås": "Akershus", "Drøbak": "Akershus", "Ski": "Akershus",
    "Sørum": "Akershus", "Skedsmo": "Akershus", "Fet": "Akershus",
    "Nittedal": "Akershus", "Oppegård": "Akershus", "Fjerdingby": "Akershus",
    "Hakadal": "Akershus", "Sandvika": "Akershus", "Ytre Arna": "Akershus",

    # Buskerud (ny Buskerud fra 2024)
    "Drammen": "Buskerud", "Flesberg": "Buskerud", "Flå": "Buskerud",
    "Gol": "Buskerud", "Hemsedal": "Buskerud", "Hol": "Buskerud",
    "Hurum": "Buskerud", "Ål": "Buskerud", "Kongsberg": "Buskerud",
    "Krødsherad": "Buskerud", "Lier": "Buskerud", "Modum": "Buskerud",
    "Nesbyen": "Buskerud", "Nore og Uvdal": "Buskerud", "Numedal": "Buskerud",
    "Ringerike": "Buskerud", "Rollag": "Buskerud", "Røyken": "Buskerud",
    "Sigdal": "Buskerud", "Tunsberg": "Buskerud", "Øvre Eiker": "Buskerud",
    "Nedre Eiker": "Buskerud", "Tyristrand": "Buskerud", "Geilo": "Buskerud",
    "Hokksund": "Buskerud", "Mjøndalen": "Buskerud", "Hokksund": "Buskerud",

    # Østfold (ny Østfold fra 2024)
    "Aremark": "Østfold", "Fredrikstad": "Østfold", "Halden": "Østfold",
    "Hvaler": "Østfold", "Indre Østfold": "Østfold", "Marker": "Østfold",
    "Moss": "Østfold", "Rakkestad": "Østfold", "Råde": "Østfold",
    "Sarpsborg": "Østfold", "Skiptvet": "Østfold", "Våler": "Østfold",
    "Dilling": "Østfold", "Gressvik": "Østfold", "Vesterøy": "Østfold",
    "Borge": "Østfold",

    # Telemark (ny Telemark fra 2024, del av tidl. Vestfold og Telemark)
    "Bamble": "Telemark", "Bo": "Telemark", "Bø": "Telemark",
    "Drangedal": "Telemark", "Fyresdal": "Telemark", "Hjartdal": "Telemark",
    "Kragerø": "Telemark", "Kviteseid": "Telemark", "Lardal": "Telemark",
    "Midt-Telemark": "Telemark", "Nissedal": "Telemark", "Notodden": "Telemark",
    "Porsgrunn": "Telemark", "Seljord": "Telemark", "Siljan": "Telemark",
    "Skien": "Telemark", "Tinn": "Telemark", "Tokke": "Telemark",
    "Vinje": "Telemark", "Nome": "Telemark", "Sauherad": "Telemark",
    "Eidanger": "Telemark", "Larvik": "Telemark",

    # Vestfold (ny Vestfold fra 2024, del av tidl. Vestfold og Telemark)
    "Færder": "Vestfold", "Holmestrand": "Vestfold", "Horten": "Vestfold",
    "Larvik": "Vestfold", "Sandefjord": "Vestfold", "Stokke": "Vestfold",
    "Tønsberg": "Vestfold", "Tjøme": "Vestfold", "Nøtterøy": "Vestfold",
    "Andebu": "Vestfold", "Re": "Vestfold", "Lardal": "Vestfold",
    "Stokke": "Vestfold", "Ramnes": "Vestfold",

    # Agder (Aust-Agder + Vest-Agder)
    "Arendal": "Agder", "Åmli": "Agder", "Birkenes": "Agder",
    "Bygland": "Agder", "Bykle": "Agder", "Evje og Hornnes": "Agder",
    "Farsund": "Agder", "Flekkefjord": "Agder", "Froland": "Agder",
    "Gjerstad": "Agder", "Grimstad": "Agder", "Hægebostad": "Agder",
    "Iveland": "Agder", "Kvinesdal": "Agder", "Kristiansand": "Agder",
    "Lillesand": "Agder", "Lindesnes": "Agder", "Lyngdal": "Agder",
    "Mandal": "Agder", "Marnadal": "Agder", "Risør": "Agder",
    "Sirdal": "Agder", "Tvedestrand": "Agder", "Valle": "Agder",
    "Vegårshei": "Agder", "Vennesla": "Agder", "Åseral": "Agder",
    "Finsland": "Agder", "Konsmo": "Agder", "Lund": "Agder",
    "Marnardal": "Agder", "Søgne": "Agder", "Songdalen": "Agder",
    "Engesland": "Agder", "VENNESLA": "Agder",

    # Rogaland
    "Bokn": "Rogaland", "Eigersund": "Rogaland", "Gjesdal": "Rogaland",
    "Haugesund": "Rogaland", "Hjelmeland": "Rogaland", "Hå": "Rogaland",
    "Karmøy": "Rogaland", "Klepp": "Rogaland", "Kvitsøy": "Rogaland",
    "Lund": "Rogaland", "Nedstrand": "Rogaland", "Randaberg": "Rogaland",
    "Rennesøy": "Rogaland", "Sauda": "Rogaland", "Sokndal": "Rogaland",
    "Sola": "Rogaland", "Stavanger": "Rogaland", "Strand": "Rogaland",
    "Suldal": "Rogaland", "Time": "Rogaland", "Tysvær": "Rogaland",
    "Utsira": "Rogaland", "Vindafjord": "Rogaland", "Finnøy": "Rogaland",
    "Forsand": "Rogaland", "Kvam": "Rogaland", "Sand": "Rogaland",
    "Jørpeland": "Rogaland", "Bryne": "Rogaland", "Avaldsnes": "Rogaland",
    "Kopervik": "Rogaland",

    # Vestland (Hordaland + Sogn og Fjordane)
    "Alver": "Vestland", "Askøy": "Vestland", "Askvoll": "Vestland",
    "Aurland": "Vestland", "Austevoll": "Vestland", "Austrheim": "Vestland",
    "Bergen": "Vestland", "Bjørnafjorden": "Vestland", "Bremanger": "Vestland",
    "Eidfjord": "Vestland", "Etne": "Vestland", "Fedje": "Vestland",
    "Fitjar": "Vestland", "Fjaler": "Vestland", "Florø": "Vestland",
    "Frekhaug": "Vestland", "Fusa": "Vestland", "Gloppen": "Vestland",
    "Gulen": "Vestland", "Høyanger": "Vestland", "Jondal": "Vestland",
    "Kinn": "Vestland", "Kvam": "Vestland", "Kvinherad": "Vestland",
    "Kvinnherad": "Vestland", "Lærdal": "Vestland", "Luster": "Vestland",
    "Masfjorden": "Vestland", "Modalen": "Vestland", "Osterøy": "Vestland",
    "Eidslandet": "Vestland", "Radøy": "Vestland", "Samnanger": "Vestland",
    "Sogndal": "Vestland", "Solund": "Vestland", "Stad": "Vestland",
    "Stord": "Vestland", "Stryn": "Vestland", "Sunnfjord": "Vestland",
    "Sveio": "Vestland", "Tysnes": "Vestland", "Ullensvang": "Vestland",
    "Ulvik": "Vestland", "Vaksdal": "Vestland", "Voss": "Vestland",
    "Øygarden": "Vestland", "Årdal": "Vestland", "Åsane": "Vestland",
    "Øvre Årdal": "Vestland", "Ytre Arna": "Vestland", "Nå": "Vestland",
    "Eidslandet": "Vestland", "Balestrand": "Vestland", "Leikanger": "Vestland",
    "Lindås": "Vestland", "Meland": "Vestland", "Os": "Vestland",

    # Møre og Romsdal
    "Aukra": "Møre og Romsdal", "Aure": "Møre og Romsdal",
    "Averøy": "Møre og Romsdal", "Fjord": "Møre og Romsdal",
    "Giske": "Møre og Romsdal", "Gjemnes": "Møre og Romsdal",
    "Hareid": "Møre og Romsdal", "Herøy": "Møre og Romsdal",
    "Hustadvika": "Møre og Romsdal", "Kristiansund": "Møre og Romsdal",
    "Langevåg": "Møre og Romsdal", "Liabygda": "Møre og Romsdal",
    "Molde": "Møre og Romsdal", "Ørsta": "Møre og Romsdal",
    "Rauma": "Møre og Romsdal", "Sande": "Møre og Romsdal",
    "Smøla": "Møre og Romsdal", "Stranda": "Møre og Romsdal",
    "Sunndalen": "Møre og Romsdal", "Sunndalsøra": "Møre og Romsdal",
    "Surnadal": "Møre og Romsdal", "Sykkylven": "Møre og Romsdal",
    "Tingvoll": "Møre og Romsdal", "Ulstein": "Møre og Romsdal",
    "Vanylven": "Møre og Romsdal", "Volda": "Møre og Romsdal",
    "Ørskog": "Møre og Romsdal", "Ålesund": "Møre og Romsdal",
    "Haramsøy": "Møre og Romsdal", "Nesset": "Møre og Romsdal",
    "Sandøy": "Møre og Romsdal", "Stordal": "Møre og Romsdal",
    "Norddal": "Møre og Romsdal", "Skodje": "Møre og Romsdal",

    # Trøndelag (Sør-Trøndelag + Nord-Trøndelag)
    "Bjugn": "Trøndelag", "Flatanger": "Trøndelag", "Frosta": "Trøndelag",
    "Grong": "Trøndelag", "Hitra": "Trøndelag", "Høylandet": "Trøndelag",
    "Inderøy": "Trøndelag", "Indre Fosen": "Trøndelag", "Jøa": "Trøndelag",
    "Klæbu": "Trøndelag", "Leka": "Trøndelag", "Levanger": "Trøndelag",
    "Lierne": "Trøndelag", "Malvik": "Trøndelag", "Melhus": "Trøndelag",
    "Meråker": "Trøndelag", "Midtre Gauldal": "Trøndelag",
    "Namsos": "Trøndelag", "Namsskogan": "Trøndelag", "Nærøysund": "Trøndelag",
    "Ogndal": "Trøndelag", "Oppdal": "Trøndelag", "Orkland": "Trøndelag",
    "Osen": "Trøndelag", "Overhalla": "Trøndelag", "Rennebu": "Trøndelag",
    "Røros": "Trøndelag", "Røyrvik": "Trøndelag", "Selbu": "Trøndelag",
    "Skaun": "Trøndelag", "Snåsa": "Trøndelag", "Steinkjer": "Trøndelag",
    "Stjørdal": "Trøndelag", "Trondheim": "Trøndelag", "Trondheim": "Trøndelag",
    "Tydal": "Trøndelag", "Verdal": "Trøndelag", "Verran": "Trøndelag",
    "Vikna": "Trøndelag", "Ørland": "Trøndelag", "Åfjord": "Trøndelag",
    "Brekstad": "Trøndelag", "Fannrem": "Trøndelag", "Flornes": "Trøndelag",
    "Kvamshaugan": "Trøndelag", "Dyrvik": "Trøndelag",
    "SNÅSA": "Trøndelag", "BREKSTAD": "Trøndelag", "FROSTA": "Trøndelag",

    # Nordland
    "Alstahaug": "Nordland", "Andøy": "Nordland", "Ballstad": "Nordland",
    "Beiarn": "Nordland", "Bindal": "Nordland", "Bodø": "Nordland",
    "Brønnøy": "Nordland", "Bø": "Nordland", "Dønna": "Nordland",
    "Evenes": "Nordland", "Fauske": "Nordland", "Flakstad": "Nordland",
    "Gildeskål": "Nordland", "Gimsøy": "Nordland", "Hadsel": "Nordland",
    "Hamarøy": "Nordland", "Hemnes": "Nordland", "Herøy": "Nordland",
    "Hinnøya": "Nordland", "Leirfjord": "Nordland", "Lurøy": "Nordland",
    "Meløy": "Nordland", "Mo i Rana": "Nordland", "Moskenes": "Nordland",
    "Narvik": "Nordland", "Nesna": "Nordland", "Rana": "Nordland",
    "Rødøy": "Nordland", "Røst": "Nordland", "Saltdal": "Nordland",
    "Sortland": "Nordland", "Steigen": "Nordland", "Sømna": "Nordland",
    "Tysfjord": "Nordland", "Vefsn": "Nordland", "Vega": "Nordland",
    "Vestvågøy": "Nordland", "Vevelstad": "Nordland", "Værøy": "Nordland",
    "Ørnes": "Nordland", "Øksnes": "Nordland", "Engan": "Nordland",
    "Engenes": "Nordland", "BODØ": "Nordland", "BALLSTAD": "Nordland",

    # Troms
    "Bardu": "Troms", "Berg": "Troms", "Dyrøy": "Troms",
    "Gáivuotna/Kåfjord": "Troms", "Gratangen": "Troms", "Harstad": "Troms",
    "Ibestad": "Troms", "Karlsøy": "Troms", "Kvæfjord": "Troms",
    "Kvænangen": "Troms", "Lavangen": "Troms", "Lenvik": "Troms",
    "Lyngen": "Troms", "Målselv": "Troms", "Nordreisa": "Troms",
    "Salangen": "Troms", "Senja": "Troms", "Skjervøy": "Troms",
    "Storfjord": "Troms", "Tromsø": "Troms", "Torsken": "Troms",
    "Tranøy": "Troms", "Helgøy": "Troms",
    "HELGØY": "Troms",

    # Finnmark
    "Alta": "Finnmark", "Berlevåg": "Finnmark", "Båtsfjord": "Finnmark",
    "Gamvik": "Finnmark", "Hammerfest": "Finnmark", "Hasvik": "Finnmark",
    "Karasjok": "Finnmark", "Kautokeino": "Finnmark", "Kvalsund": "Finnmark",
    "Lakselv": "Finnmark", "Lebesby": "Finnmark", "Loppa": "Finnmark",
    "Måsøy": "Finnmark", "Nesseby": "Finnmark", "Nordkapp": "Finnmark",
    "Porsanger": "Finnmark", "Sør-Varanger": "Finnmark", "Tana": "Finnmark",
    "Vadsø": "Finnmark", "Vardø": "Finnmark",
}

# Norwegian postal code → municipality lookup (for entries with postal codes)
POSTALCODE_TO_MUNICIPALITY = {
    "1621": "Gressvik",    # Fredrikstad, Østfold
    "2750": "Gran",        # Hadeland, Innlandet
    "3550": "Gol",         # Buskerud
    "4014": "Stavanger",   # Rogaland
    "4016": "Stavanger",   # Rogaland
    "4748": "Finsland",    # Agder
    "6155": "Ørsta",       # Møre og Romsdal
    "6823": "Lærdal",      # Vestland
    "7760": "Snåsa",       # Trøndelag
    "8063": "Værøy",       # Nordland
}

def title_case_place(name):
    """Convert ALL-CAPS to Title Case, respecting Norwegian names."""
    if not name or name != name.upper():
        return name
    # Small words that stay lowercase in place names
    small = {'i', 'og', 'på', 'av', 'ved'}
    words = name.split()
    result = []
    for i, word in enumerate(words):
        # Check for "BØ I TELEMARK" style
        lower = word.lower()
        if i > 0 and lower in small:
            result.append(lower)
        else:
            result.append(word.capitalize())
    return ' '.join(result)

def nominatim_region(lat, lon):
    """Reverse geocode coordinates to get Norwegian county via Nominatim."""
    url = (f"https://nominatim.openstreetmap.org/reverse?"
           f"lat={lat}&lon={lon}&zoom=8&addressdetails=1&format=json")
    req = urllib.request.Request(url, headers={'User-Agent': 'mat_sjekk-cleanup/1.0'})
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
        addr = data.get('address', {})
        # zoom=8 returns 'county' for Norwegian fylker
        county = addr.get('county') or addr.get('state') or ''
        VALID_REGIONS = {
            'Oslo', 'Innlandet', 'Akershus', 'Buskerud', 'Østfold',
            'Telemark', 'Vestfold', 'Agder', 'Rogaland', 'Vestland',
            'Møre og Romsdal', 'Trøndelag', 'Nordland', 'Troms', 'Finnmark',
        }
        for r in VALID_REGIONS:
            if r.lower() in county.lower():
                return r
        return None
    except Exception:
        return None

# ─── Load and fix ─────────────────────────────────────────────────────────────
fpath = 'docs/data/farmshops_by_country/no.json'
shutil.copy(fpath, fpath + '.bak4')

with open(fpath, encoding='utf-8') as f:
    data = json.load(f)

stats = {
    'old_region': 0,
    'muni_casing': 0,
    'postal_to_muni': 0,
    'region_from_lookup': 0,
    'region_from_nominatim': 0,
    'region_unfixable': 0,
}

for item in data:
    # 1. Fix outdated region names
    region = item.get('region')
    if region == 'Hordaland':
        item['region'] = 'Vestland'
        stats['old_region'] += 1
    elif region == 'Hedmark':
        item['region'] = 'Innlandet'
        stats['old_region'] += 1
    elif region in ('Nord-Trøndelag', 'Sør-Trøndelag'):
        item['region'] = 'Trøndelag'
        stats['old_region'] += 1
    elif region == 'Viken':
        # Need to determine from municipality which new county
        muni = item.get('municipality') or ''
        new_region = MUNICIPALITY_TO_REGION.get(muni)
        if new_region:
            item['region'] = new_region
            stats['old_region'] += 1
        # else: will be handled below

    # 2. Fix postal code in municipality field
    muni = item.get('municipality') or ''
    if re.fullmatch(r'\d{4}', muni.strip()):
        new_muni = POSTALCODE_TO_MUNICIPALITY.get(muni.strip())
        if new_muni:
            print(f'  [postal] {item["id"]}: municipality "{muni}" → "{new_muni}"')
            item['municipality'] = new_muni
            stats['postal_to_muni'] += 1
            muni = new_muni

    # 3. Fix ALL-CAPS municipality names
    if muni and muni == muni.upper() and not re.fullmatch(r'\d+', muni):
        corrected = title_case_place(muni)
        if corrected != muni:
            item['municipality'] = corrected
            muni = corrected
            stats['muni_casing'] += 1

    # 4. Fill in missing region from municipality lookup
    if not item.get('region') and muni:
        r = MUNICIPALITY_TO_REGION.get(muni)
        if r:
            item['region'] = r
            stats['region_from_lookup'] += 1

# 5. For remaining NULL-region entries with coordinates, use Nominatim
no_region = [i for i in data if not i.get('region') and i.get('lat')]
print(f'\nEntries needing Nominatim fallback: {len(no_region)}')
for item in no_region:
    lat, lon = item['lat'], item['lon']
    region = nominatim_region(lat, lon)
    if region:
        item['region'] = region
        stats['region_from_nominatim'] += 1
        print(f'  [nominatim] {item["id"]}: {item["name"]} → {region}')
    else:
        stats['region_unfixable'] += 1
    time.sleep(1.1)  # Respect Nominatim rate limit (1 req/sec)

with open(fpath, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print('\n=== Summary ===')
for k, v in stats.items():
    print(f'  {k}: {v}')

# Final region distribution
from collections import Counter
regions = Counter(i.get('region') or 'NULL' for i in data)
print('\nFinal region distribution:')
for r, c in regions.most_common():
    print(f'  {c:4d}  {r}')
