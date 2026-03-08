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
from datetime import datetime, timezone, timedelta
from email.utils import parsedate_to_datetime
from pathlib import Path
from typing import Any
import xml.etree.ElementTree as ET
from urllib.parse import quote_plus, urlparse, parse_qs, urlencode, urlunparse

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
FOOD_CONTEXT_KEYWORDS = (
    "food",
    "mat",
    "dairy",
    "milk",
    "fôr",
    "feed",
    "foder",
    "rehu",
    "agri",
    "agric",
    "landbruk",
    "landbouw",
    "agriculture",
    "farming",
    "farm",
    "livestock",
    "cattle",
    "cow",
    "ku",
    "husdyr",
    "salmon",
    "oppdrett",
)
EXCLUDED_NOISE_KEYWORDS = (
    "payment gateway",
    "stock",
    "ticker",
    "crypto",
    "casino",
    "forex",
)
PRIMARY_TOPIC = "bovaer"
MAX_ITEMS = 120
RECENT_DAYS = 31
PER_COUNTRY_LIMIT = 6

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


def _is_relevant(title: str, summary: str, *, strict: bool = True) -> bool:
    text = f"{title} {summary}".lower()
    if any(noise in text for noise in EXCLUDED_NOISE_KEYWORDS):
        return False
    has_topic = any(k in text for k in TOPIC_KEYWORDS)
    if not strict:
        return has_topic
    has_context = any(k in text for k in FOOD_CONTEXT_KEYWORDS)
    return has_topic and has_context


def _is_primary_topic(title: str, summary: str, url: str) -> bool:
    text = f"{title} {summary} {url}".lower()
    return PRIMARY_TOPIC in text


def _ensure_recent_google_query(url: str) -> str:
    try:
        parsed = urlparse(url)
        if "news.google.com" not in parsed.netloc.lower():
            return url
        params = parse_qs(parsed.query, keep_blank_values=True)
        query_values = params.get("q", [])
        if not query_values:
            return url
        query = query_values[0]
        if "when:" in query.lower():
            return url
        query = f"{query} when:{RECENT_DAYS}d"
        params["q"] = [query]
        rebuilt = parsed._replace(query=urlencode(params, doseq=True))
        return urlunparse(rebuilt)
    except Exception:
        return url


def _google_search_page_url_from_feed(url: str) -> str:
    normalized = _ensure_recent_google_query(url)
    return normalized.replace('/rss/search?', '/search?')


def _is_recent(pub_date_iso: str) -> bool:
    try:
        parsed = datetime.fromisoformat(pub_date_iso)
        cutoff = datetime.now(timezone.utc) - timedelta(days=RECENT_DAYS)
        return parsed >= cutoff
    except Exception:
        return False


def _fallback_topic_page_item(country: str, language: str, feed_url: str) -> FeedItem:
    now_iso = datetime.now(timezone.utc).isoformat()
    page_url = _google_search_page_url_from_feed(feed_url)
    return FeedItem(
        title=f"Temaoversikt siste {RECENT_DAYS} dager ({country})",
        url=page_url,
        pub_date=now_iso,
        source="Google News",
        language=language,
        country=country,
        source_api=feed_url,
        summary=(
            f"Neutral fallback page for {country}. Shows recent items for Bovaer, GMO, insect meal, and food traceability."
        ),
    )


def fetch_rss(url: str, country: str, language: str, *, strict: bool = True) -> list[FeedItem]:
    source_url = _ensure_recent_google_query(url)
    response = requests.get(source_url, timeout=25)
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
        if not _is_relevant(title, summary, strict=strict):
            continue

        items.append(
            FeedItem(
                title=title,
                url=link,
                pub_date=pub_date,
                source=source,
                language=language,
                country=country,
                source_api=source_url,
                summary=summary,
            )
        )
    return items


def dedupe(items: list[FeedItem]) -> list[FeedItem]:
    seen: set[str] = set()
    out: list[FeedItem] = []
    for item in sorted(items, key=lambda i: i.pub_date, reverse=True):
        key = f"{item.country}|{item.url.strip().lower()}"
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
                collected.extend(fetch_rss(feed_url, country_code, language, strict=True))
            except Exception as ex:
                errors.append(
                    {
                        "country": country_code,
                        "feed": feed_url,
                        "error": str(ex),
                    }
                )

    unique_items = dedupe(collected)

    unique_items = [item for item in unique_items if _is_recent(item.pub_date)]

    present_after_strict = {item.country for item in unique_items}
    missing_countries = [code for code in countries.keys() if code not in present_after_strict]

    for country_code in missing_countries:
        payload = countries.get(country_code, {})
        language = payload.get("language", "en")
        feeds = payload.get("feeds", [])
        if not feeds:
            continue
        for feed_url in feeds[:2]:
            try:
                relaxed_items = fetch_rss(feed_url, country_code, language, strict=False)
                relaxed_recent = [item for item in relaxed_items if _is_recent(item.pub_date)]
                if relaxed_recent:
                    unique_items.extend(relaxed_recent[:2])
                    break
            except Exception as ex:
                errors.append(
                    {
                        "country": country_code,
                        "feed": feed_url,
                        "error": str(ex),
                    }
                )

    present_after_fallback = {item.country for item in unique_items}
    still_missing = [code for code in countries.keys() if code not in present_after_fallback]
    for country_code in still_missing:
        payload = countries.get(country_code, {})
        language = payload.get("language", "en")
        feeds = payload.get("feeds", [])
        if not feeds:
            continue
        unique_items.append(_fallback_topic_page_item(country_code, language, feeds[0]))

    unique_items = dedupe(unique_items)

    by_country: dict[str, list[FeedItem]] = {}
    for item in sorted(unique_items, key=lambda i: i.pub_date, reverse=True):
        by_country.setdefault(item.country, []).append(item)

    balanced: list[FeedItem] = []
    for country_code in sorted(by_country.keys()):
        balanced.extend(by_country[country_code][:PER_COUNTRY_LIMIT])

    unique_items = sorted(balanced, key=lambda i: i.pub_date, reverse=True)[:MAX_ITEMS]

    result = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "version": 1,
        "topic": PRIMARY_TOPIC,
        "recentDays": RECENT_DAYS,
        "perCountryLimit": PER_COUNTRY_LIMIT,
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
