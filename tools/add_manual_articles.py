#!/usr/bin/env python3
"""Add manually curated articles back to news JSON files with manuallyAdded flag."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

FILES = [
    ROOT / "docs" / "data" / "news.latest.json",
    ROOT / "docs" / "data" / "news.region.cluster_scandinavia.json",
]

MANUAL_ARTICLES = [
    {
        "title": "Stortingets nei til et krav n\u00e5 er kun et tidsbegrenset pusterom for norske b\u00f8nder",
        "url": "https://steigan.no/2026/02/stortingets-nei-til-et-krav-na-er-kun-et-tidsbegrenset-pusterom-for-norske-bonder/",
        "source": "Steigan.no",
        "pubDate": "2026-02-15T12:00:00Z",
        "language": "nb",
        "country": "NO",
        "summary": "Stortingets avvisning av metanhemmer-kravet (Bovaer) er bare midlertidig \u2013 EU fortsetter presset.",
        "englishSummary": "Norwegian parliament rejection of Bovaer methane inhibitor mandate is only a temporary reprieve.",
        "manuallyAdded": True,
    },
    {
        "title": "Tine raser p\u00e5 omd\u00f8mmem\u00e5ling etter metanhemmer-striden \u2013 ubehagelig overraskelse",
        "url": "https://www.document.no/2026/03/12/tine-raser-pa-omdommemaling-etter-metanhemmer-striden-ubehagelig-overraskelse/",
        "source": "Document.no",
        "pubDate": "2026-03-12T10:00:00Z",
        "language": "nb",
        "country": "NO",
        "summary": "Tine opplever kraftig fall i omd\u00f8mmem\u00e5ling etter den p\u00e5g\u00e5ende metanhemmer-striden (Bovaer).",
        "englishSummary": "Tine dairy experiences significant reputation decline following the ongoing Bovaer methane inhibitor controversy.",
        "manuallyAdded": True,
    },
    {
        "title": "B\u00f8nder raser mot Bondelaget: Melkeprodusentenes verste fiende",
        "url": "https://www.document.no/2026/02/24/bonder-raser-mot-bondelaget-melkeprodusentenes-verste-fiende/",
        "source": "Document.no",
        "pubDate": "2026-02-24T10:00:00Z",
        "language": "nb",
        "country": "NO",
        "summary": "Melkeb\u00f8nder reagerer sterkt mot Bondelaget i oppgj\u00f8ret rundt metanhemmere og melkeproduksjonsvilk\u00e5r.",
        "englishSummary": "Dairy farmers rage against the Norwegian Farmers Union over methane inhibitors and milk production conditions.",
        "manuallyAdded": True,
    },
    {
        "title": "N\u00e6ringskomiteen vil kutte metanhemmer-krav for melkeb\u00f8nder",
        "url": "https://www.document.no/2026/02/13/naeringskomiteen-vil-kutte-metanhemmer-krav-for-melkebonder/",
        "source": "Document.no",
        "pubDate": "2026-02-13T10:00:00Z",
        "language": "nb",
        "country": "NO",
        "summary": "N\u00e6ringskomiteen i Stortinget \u00f8nsker \u00e5 fjerne kravet til bruk av metanhemmere (Bovaer) for norske melkeb\u00f8nder.",
        "englishSummary": "Norwegian parliamentary committee wants to remove Bovaer methane inhibitor requirement for dairy farmers.",
        "manuallyAdded": True,
    },
]


def main():
    for fpath in FILES:
        with open(fpath, "r", encoding="utf-8") as f:
            data = json.load(f)

        existing_urls = {item.get("url", "").strip().lower() for item in data["items"]}
        added = 0
        for art in MANUAL_ARTICLES:
            if art["url"].strip().lower() not in existing_urls:
                data["items"].append(art)
                added += 1

        data["items"].sort(
            key=lambda x: x.get("pubDate", x.get("date", "1970")), reverse=True
        )
        data["total"] = len(data["items"])

        with open(fpath, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f"{fpath.name}: added {added}, total {data['total']}")


if __name__ == "__main__":
    main()
