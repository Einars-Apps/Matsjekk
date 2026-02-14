#!/usr/bin/env python3
"""
Fetch country-specific news feeds for Mat Sjekk and publish a unified JSON file
for the website frontend.

Input:
- docs/data/news_feeds.json

Output:
- docs/data/news.latest.json
"""
from __future__ import annotations

import json
import hashlib
from dataclasses import dataclass
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
from pathlib import Path
from typing import Any
import xml.etree.ElementTree as ET
from urllib.parse import quote_plus

import requests

ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "docs" / "data" / "news_feeds.json"
OUT_PATH = ROOT / "docs" / "data" / "news.latest.json"

TOPIC_KEYWORDS = (
    "bovaer",
    "gmo",
    "insect",
    "insekt",
    "insek",
    "sporbar",
    "trace",
    "feed",
    "fôr",
)
PRIMARY_TOPIC = "bovaer"
MAX_ITEMS = 50

EUROPE_COUNTRIES: dict[str, tuple[str, str]] = {
    "AL": ("sq", "Albania"),
    "AD": ("ca", "Andorra"),
    "AM": ("hy", "Armenia"),
    "AT": ("de", "Austria"),
    "AZ": ("az", "Azerbaijan"),
    "BY": ("ru", "Belarus"),
    "BE": ("nl", "Belgium"),
    "BA": ("bs", "Bosnia and Herzegovina"),
    "BG": ("bg", "Bulgaria"),
    "HR": ("hr", "Croatia"),
    "CY": ("el", "Cyprus"),
    "CZ": ("cs", "Czechia"),
    "DK": ("da", "Denmark"),
    "EE": ("et", "Estonia"),
    "FI": ("fi", "Finland"),
    "FR": ("fr", "France"),
    "GE": ("ka", "Georgia"),
    "DE": ("de", "Germany"),
    "GR": ("el", "Greece"),
    "HU": ("hu", "Hungary"),
    "IS": ("is", "Iceland"),
    "IE": ("en", "Ireland"),
    "IT": ("it", "Italy"),
    "XK": ("sq", "Kosovo"),
    "LV": ("lv", "Latvia"),
    "LI": ("de", "Liechtenstein"),
    "LT": ("lt", "Lithuania"),
    "LU": ("fr", "Luxembourg"),
    "MT": ("en", "Malta"),
    "MD": ("ro", "Moldova"),
    "MC": ("fr", "Monaco"),
    "ME": ("sr", "Montenegro"),
    "NL": ("nl", "Netherlands"),
    "MK": ("mk", "North Macedonia"),
    "NO": ("nb", "Norway"),
    "PL": ("pl", "Poland"),
    "PT": ("pt", "Portugal"),
    "RO": ("ro", "Romania"),
    "SM": ("it", "San Marino"),
    "RS": ("sr", "Serbia"),
    "SK": ("sk", "Slovakia"),
    "SI": ("sl", "Slovenia"),
    "ES": ("es", "Spain"),
    "SE": ("sv", "Sweden"),
    "CH": ("de", "Switzerland"),
    "TR": ("tr", "Turkey"),
    "UA": ("uk", "Ukraine"),
    "GB": ("en", "United Kingdom"),
    "VA": ("it", "Vatican City"),
}


def default_feed_url(country_code: str, language: str) -> str:
    query = quote_plus("Bovaer OR GMO OR insect meal OR food traceability")
    hl = f"{language}-{country_code}" if language != "en" else f"en-{country_code}"
    return (
        f"https://news.google.com/rss/search?q={query}"
        f"&hl={hl}&gl={country_code}&ceid={country_code}:{language}"
    )


def expand_to_all_europe(countries: dict[str, Any]) -> dict[str, Any]:
    merged = dict(countries)
    for code, (language, name) in EUROPE_COUNTRIES.items():
        if code not in merged:
            merged[code] = {
                "language": language,
                "name": name,
                "feeds": [default_feed_url(code, language)],
            }
            continue

        payload = merged[code]
        payload.setdefault("language", language)
        payload.setdefault("name", name)
        feeds = payload.get("feeds", [])
        if not feeds:
            payload["feeds"] = [default_feed_url(code, payload["language"])]
        merged[code] = payload
    return merged


@dataclass
class FeedItem:
    title: str
    url: str
    pub_date: str
    source: str
    language: str
    country: str
    source_api: str
    summary: str = ""

    def as_dict(self) -> dict[str, Any]:
        return {
            "title": self.title,
            "url": self.url,
            "pubDate": self.pub_date,
            "source": self.source,
            "language": self.language,
            "country": self.country,
            "sourceApi": self.source_api,
            "summary": self.summary,
            "id": hashlib.sha1(f"{self.url}|{self.title}".encode("utf-8")).hexdigest()[:16],
        }


def _safe_text(node: ET.Element | None, default: str = "") -> str:
    if node is None or node.text is None:
        return default
    return node.text.strip()


def _to_iso8601(raw: str) -> str:
    if not raw:
        return datetime.now(timezone.utc).isoformat()
    try:
        dt = parsedate_to_datetime(raw)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.astimezone(timezone.utc).isoformat()
    except Exception:
        return datetime.now(timezone.utc).isoformat()


def _is_relevant(title: str, summary: str) -> bool:
    text = f"{title} {summary}".lower()
    return any(k in text for k in TOPIC_KEYWORDS)


def _is_primary_topic(title: str, summary: str, url: str) -> bool:
    text = f"{title} {summary} {url}".lower()
    return PRIMARY_TOPIC in text


def fetch_rss(url: str, country: str, language: str) -> list[FeedItem]:
    response = requests.get(url, timeout=25)
    response.raise_for_status()
    root = ET.fromstring(response.content)

    items = []
    for item in root.findall(".//item"):
        title = _safe_text(item.find("title"), "Untitled")
        link = _safe_text(item.find("link"))
        pub_date = _to_iso8601(_safe_text(item.find("pubDate")))
        source = _safe_text(item.find("source"), "unknown")
        summary = _safe_text(item.find("description"))

        if not link:
            continue
        if not _is_relevant(title, summary):
            continue

        items.append(
            FeedItem(
                title=title,
                url=link,
                pub_date=pub_date,
                source=source,
                language=language,
                country=country,
                source_api=url,
                summary=summary,
            )
        )
    return items


def dedupe(items: list[FeedItem]) -> list[FeedItem]:
    seen: set[str] = set()
    out: list[FeedItem] = []
    for item in sorted(items, key=lambda i: i.pub_date, reverse=True):
        key = item.url.strip().lower()
        if key in seen:
            continue
        seen.add(key)
        out.append(item)
    return out


def main() -> int:
    if not CONFIG_PATH.exists():
        raise FileNotFoundError(f"Missing config: {CONFIG_PATH}")

    cfg = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    countries = cfg.get("countries", {})
    if cfg.get("includeAllEurope", True):
        countries = expand_to_all_europe(countries)

    collected: list[FeedItem] = []
    errors: list[dict[str, str]] = []

    for country_code, payload in countries.items():
        language = payload.get("language", "en")
        feeds = payload.get("feeds", [])

        for feed_url in feeds:
            try:
                collected.extend(fetch_rss(feed_url, country_code, language))
            except Exception as ex:
                errors.append(
                    {
                        "country": country_code,
                        "feed": feed_url,
                        "error": str(ex),
                    }
                )

    unique_items = dedupe(collected)

    primary_items = [
        item
        for item in unique_items
        if _is_primary_topic(item.title, item.summary, item.url)
    ]
    if primary_items:
        unique_items = primary_items

    unique_items = sorted(unique_items, key=lambda i: i.pub_date, reverse=True)[:MAX_ITEMS]

    result = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "version": 1,
        "topic": PRIMARY_TOPIC,
        "maxItems": MAX_ITEMS,
        "total": len(unique_items),
        "errors": errors,
        "items": [item.as_dict() for item in unique_items],
    }

    OUT_PATH.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {OUT_PATH} with {len(unique_items)} items")
    if errors:
        print(f"Feed errors: {len(errors)} (kept in output metadata)")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
