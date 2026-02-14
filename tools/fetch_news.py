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


@dataclass
class FeedItem:
    title: str
    url: str
    pub_date: str
    source: str
    language: str
    country: str
    summary: str = ""

    def as_dict(self) -> dict[str, Any]:
        return {
            "title": self.title,
            "url": self.url,
            "pubDate": self.pub_date,
            "source": self.source,
            "language": self.language,
            "country": self.country,
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

    result = {
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "version": 1,
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
