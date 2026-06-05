#!/usr/bin/env python3
from __future__ import annotations

import json
import hashlib
import re
from datetime import datetime, timezone, timedelta
from email.utils import parsedate_to_datetime
from pathlib import Path
from typing import Any
import xml.etree.ElementTree as ET

import requests

ROOT = Path(__file__).resolve().parents[1]
OUT_PATH = ROOT / 'docs' / 'data' / 'eu_decisions_auto.json'

WINDOW_DAYS = 365 * 3
MAX_ITEMS = 60

QUERIES = [
    'site:eur-lex.europa.eu (gmo OR ngt OR "novel food" OR "3-nitrooxypropanol" OR insect) when:1095d',
    'site:eur-lex.europa.eu ("3-nitrooxypropanol" OR "3-NOP" OR bovaer OR "feed additive") when:1095d',
    'site:eur-lex.europa.eu ("novel food" OR insect OR mealworm OR "Acheta domesticus" OR "Tenebrio molitor" OR "Locusta migratoria" OR "Alphitobius diaperinus") when:1095d',
    'site:europarl.europa.eu (new genomic techniques OR NGT OR GMO) when:1095d',
    'site:europarl.europa.eu (novel food OR insect OR food additive) when:1095d',
    'site:consilium.europa.eu (gmo OR ngt OR genomic techniques) when:1095d',
    'site:food.ec.europa.eu (novel food OR insect OR "new genomic techniques" OR biotechnology) when:1095d',
]

NEWS_RSS_TEMPLATE = 'https://news.google.com/rss/search?q={q}&hl=en-US&gl=US&ceid=US:en'

TOPIC_KEYWORDS = {
    'Bovaer': ('3-nitrooxypropanol', '3-nop', 'bovaer', 'feed additive', 'zootechnical additive'),
    'GMO/NGT': ('gmo', 'new genomic techniques', 'ngt', 'gene editing', 'genomic'),
    'Insektsmel': (
        'novel food',
        'insect',
        'acheta domesticus',
        'mealworm',
        'tenebrio molitor',
        'locusta migratoria',
        'alphitobius diaperinus',
        'hermetia illucens',
        'yellow mealworm',
        'house cricket',
    ),
}

NOISE_TERMS = (
    'agenda',
    'newsletter',
    'work in progress',
    'minutes',
    'coreper',
    'foreign affairs council',
    'document com(',
)

ALLOWED_SOURCE_HINTS = (
    'eur-lex',
    'european parliament',
    'consilium',
    'council of the european union',
    'european commission',
    'food.ec.europa.eu',
    'efsa',
)


def to_iso(raw: str) -> str:
    if not raw:
        return datetime.now(timezone.utc).isoformat()
    try:
        dt = parsedate_to_datetime(raw)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt.astimezone(timezone.utc).isoformat()
    except Exception:
        return datetime.now(timezone.utc).isoformat()


def parse_items(xml_text: str) -> list[dict[str, Any]]:
    root = ET.fromstring(xml_text)
    items: list[dict[str, Any]] = []
    for node in root.findall('.//item'):
        title = (node.findtext('title') or '').strip()
        link = (node.findtext('link') or '').strip()
        pub = to_iso((node.findtext('pubDate') or '').strip())
        source = (node.findtext('source') or '').strip() or 'Google News'
        description = (node.findtext('description') or '').strip()
        items.append({
            'title': title,
            'url': link,
            'date': pub,
            'source': source,
            'summary': description,
        })
    return items


def strip_html(text: str) -> str:
    if not text:
        return ''
    return re.sub(r'<[^>]+>', ' ', text)


def is_recent(item: dict[str, Any]) -> bool:
    try:
        dt = datetime.fromisoformat(item['date'])
        return dt >= datetime.now(timezone.utc) - timedelta(days=WINDOW_DAYS)
    except Exception:
        return False


def detect_topic(text: str) -> str:
    lower = text.lower()
    for topic, keywords in TOPIC_KEYWORDS.items():
        if any(k in lower for k in keywords):
            return topic
    return 'EU-vedtak'


def is_noisy(text: str) -> bool:
    lower = text.lower()
    return any(term in lower for term in NOISE_TERMS)


def allowed_source(source: str, title: str, summary: str) -> bool:
    blob = f'{source} {title} {summary}'.lower()
    return any(hint in blob for hint in ALLOWED_SOURCE_HINTS)


def normalize(item: dict[str, Any]) -> dict[str, Any]:
    clean_summary = strip_html(item.get('summary', ''))
    text_blob = f"{item.get('title', '')} {clean_summary}"
    topic = detect_topic(text_blob)
    return {
        'date': item.get('date'),
        'title': item.get('title') or 'Ukjent EU-oppdatering',
        'type': 'Automatisk oppdaget oppdatering',
        'topic': topic,
        'summary': clean_summary[:400],
        'url': item.get('url') or '#',
        'source': item.get('source') or 'Google News',
        'id': hashlib.sha1(f"{item.get('title','')}|{item.get('url','')}".encode('utf-8')).hexdigest()[:16],
    }


def dedupe(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    seen: set[str] = set()
    out: list[dict[str, Any]] = []
    for item in items:
        key = f"{item.get('title','').lower()}|{item.get('url','').lower()}"
        if key in seen:
            continue
        seen.add(key)
        out.append(item)
    return out


def main() -> None:
    collected: list[dict[str, Any]] = []

    for query in QUERIES:
        url = NEWS_RSS_TEMPLATE.format(q=requests.utils.quote(query, safe=''))
        try:
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            collected.extend(parse_items(response.text))
        except Exception:
            continue

    normalized = []
    for item in collected:
        if not is_recent(item):
            continue
        if not allowed_source(item.get('source', ''), item.get('title', ''), item.get('summary', '')):
            continue
        text_blob = f"{item.get('title', '')} {strip_html(item.get('summary', ''))}"
        if is_noisy(text_blob):
            continue
        topic = detect_topic(text_blob)
        if topic == 'EU-vedtak':
            continue
        normalized.append(normalize(item))

    normalized = dedupe(normalized)
    normalized.sort(key=lambda x: x.get('date', ''), reverse=True)
    normalized = normalized[:MAX_ITEMS]

    payload = {
        'updated_at': datetime.now(timezone.utc).isoformat(),
        'source': 'google-news-rss-eu-filter',
        'window_days': WINDOW_DAYS,
        'items': normalized,
    }

    OUT_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Wrote {len(normalized)} auto EU decision items to {OUT_PATH}')


if __name__ == '__main__':
    main()
