#!/usr/bin/env python3
"""
Theme digest agent for Mat Sjekk.

Goal
----
Follow the app's core themes (Bovaer, GMO feed, insect meal) and keep a small,
market-driven editorial digest up to date based on what is ACTUALLY happening,
reusing the existing news pipeline instead of fetching anew.

What it does
------------
1. Reads the already-published news feeds in ``docs/data/news*.json`` (produced
   by ``tools/fetch_news.py``).
2. Buckets every item into one or more themes using the same keyword families
   used by ``fetch_news.py``.
3. Writes a FACTUAL, source-only digest to
   ``docs/data/theme_digest.latest.json`` (no prose, only real links + counts).
   This is safe to auto-publish because it contains no generated claims.
4. OPTIONAL: if ``OPENAI_API_KEY`` is set, it drafts a short, neutral summary
   per theme and writes it to ``scripts/theme_digest_proposals.json`` as a
   PROPOSAL for human review. Generated prose is NEVER auto-published.

Design notes
------------
- Stdlib only by default (no extra dependencies), like ``scripts/ngt_monitor.py``.
- Deterministic and free unless an API key is explicitly provided.
- Human-in-the-loop for any editorial text, matching the project's sourcing
  discipline.

Usage
-----
    python tools/theme_digest.py
    python tools/theme_digest.py --window-days 90 --max-items 12
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "docs" / "data"
DIGEST_OUT = DATA_DIR / "theme_digest.latest.json"
PROPOSALS_OUT = ROOT / "scripts" / "theme_digest_proposals.json"

# Keyword families mirror tools/fetch_news.py so the digest stays consistent
# with the feed the site already shows.
THEMES: tuple[dict[str, Any], ...] = (
    {
        "key": "bovaer",
        "label": "Bovaer (metanhemmer i fôr)",
        "keywords": ("bovaer",),
    },
    {
        "key": "insect_meal",
        "label": "Insektsmel i fôr",
        "keywords": (
            "insect meal",
            "insektsmel",
            "insektsmjol",
            "insektsmjöl",
            "insektenmehl",
            "farine d'insectes",
            "farina di insetti",
            "harina de insecto",
            "farinha de inseto",
            "hyonteisjauho",
            "innovafeed",
            "ynsect",
        ),
    },
    {
        "key": "gmo_feed",
        "label": "GMO i fôr / fiskefôr",
        "keywords": (
            "gmo fish feed",
            "gmo-fiskefor",
            "gmo fiskefor",
            "gmo fishmeal feed",
            "genetically modified feed",
            "gmo fodder",
            "gmo foder",
            "gmo feed",
            "gmo-for",
            "gmo fôr",
            "gmo for",
            "genmodifisert",
        ),
    },
)

EXCLUDED_NOISE_KEYWORDS = (
    "payment gateway",
    "stock",
    "ticker",
    "crypto",
    "casino",
    "forex",
)


def _parse_dt(value: str) -> datetime | None:
    if not value:
        return None
    try:
        dt = datetime.fromisoformat(value.replace("Z", "+00:00"))
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        return dt
    except (ValueError, TypeError):
        return None


def load_all_items() -> list[dict[str, Any]]:
    """Collect items from every news*.json feed, de-duplicated by id/url."""
    items: dict[str, dict[str, Any]] = {}
    if not DATA_DIR.exists():
        return []
    for path in sorted(DATA_DIR.glob("news*.json")):
        try:
            payload = json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            continue
        for item in payload.get("items", []) or []:
            key = str(item.get("id") or item.get("url") or item.get("title") or "")
            if not key:
                continue
            # Keep the newest variant if duplicated across feeds.
            existing = items.get(key)
            if existing is None:
                items[key] = item
                continue
            new_dt = _parse_dt(str(item.get("pubDate", "")))
            old_dt = _parse_dt(str(existing.get("pubDate", "")))
            if new_dt and (old_dt is None or new_dt > old_dt):
                items[key] = item
    return list(items.values())


def _is_noise(text: str) -> bool:
    return any(noise in text for noise in EXCLUDED_NOISE_KEYWORDS)


def classify(item: dict[str, Any]) -> list[str]:
    """Return the list of theme keys an item belongs to."""
    text = f"{item.get('title', '')} {item.get('summary', '')}".lower()
    if _is_noise(text):
        return []
    matched: list[str] = []
    for theme in THEMES:
        if any(k in text for k in theme["keywords"]):
            matched.append(theme["key"])
    return matched


def _clean_item(item: dict[str, Any]) -> dict[str, Any]:
    return {
        "title": item.get("title", "").strip(),
        "url": item.get("url", ""),
        "source": item.get("source", ""),
        "pubDate": item.get("pubDate", ""),
        "language": item.get("language", ""),
        "country": item.get("country", ""),
        "id": item.get("id", ""),
    }


def build_digest(window_days: int, max_items: int) -> dict[str, Any]:
    now = datetime.now(timezone.utc)
    all_items = load_all_items()

    buckets: dict[str, list[dict[str, Any]]] = {t["key"]: [] for t in THEMES}
    for item in all_items:
        for key in classify(item):
            buckets[key].append(item)

    themes_out: list[dict[str, Any]] = []
    for theme in THEMES:
        bucket = buckets[theme["key"]]
        bucket.sort(key=lambda it: (_parse_dt(str(it.get("pubDate", ""))) or now), reverse=True)
        recent = 0
        latest_date = ""
        for it in bucket:
            dt = _parse_dt(str(it.get("pubDate", "")))
            if dt is None:
                continue
            if not latest_date:
                latest_date = dt.isoformat()
            if (now - dt).days <= window_days:
                recent += 1
        themes_out.append(
            {
                "key": theme["key"],
                "label": theme["label"],
                "total": len(bucket),
                "recent": recent,
                "latestDate": latest_date,
                "items": [_clean_item(it) for it in bucket[:max_items]],
            }
        )

    return {
        "generatedAt": now.isoformat(),
        "version": 1,
        "windowDays": window_days,
        "maxItems": max_items,
        "themes": themes_out,
    }


def _openai_summary(theme: dict[str, Any], api_key: str, model: str) -> str | None:
    """Draft a short neutral summary for one theme. Returns None on failure."""
    import urllib.request
    import urllib.error

    headlines = "\n".join(f"- {it['title']} ({it['source']})" for it in theme["items"][:10])
    if not headlines:
        return None
    prompt = (
        "Du er en nøktern norsk redaksjonell assistent for matsjekk-appen. "
        "Skriv et kort, nøytralt sammendrag (maks 3 setninger) av hva som "
        "skjer i markedet rundt temaet under, basert KUN på overskriftene. "
        "Ikke overdriv risiko, ikke påstå noe som ikke står i overskriftene, "
        "og ikke gi helseråd.\n\n"
        f"Tema: {theme['label']}\nOverskrifter:\n{headlines}\n"
    )
    body = json.dumps(
        {
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "temperature": 0.2,
            "max_tokens": 220,
        }
    ).encode("utf-8")
    req = urllib.request.Request(
        "https://api.openai.com/v1/chat/completions",
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            payload = json.loads(resp.read().decode("utf-8"))
        return payload["choices"][0]["message"]["content"].strip()
    except (urllib.error.URLError, KeyError, IndexError, json.JSONDecodeError) as exc:
        print(f"WARN: LLM summary failed for {theme['key']}: {exc}", file=sys.stderr)
        return None


def build_proposals(digest: dict[str, Any]) -> dict[str, Any] | None:
    api_key = os.environ.get("OPENAI_API_KEY", "").strip()
    if not api_key:
        return None
    model = os.environ.get("OPENAI_MODEL", "gpt-4o-mini").strip() or "gpt-4o-mini"
    proposals: list[dict[str, Any]] = []
    for theme in digest["themes"]:
        if not theme["items"]:
            continue
        summary = _openai_summary(theme, api_key, model)
        if not summary:
            continue
        proposals.append(
            {
                "key": theme["key"],
                "label": theme["label"],
                "summary": summary,
                "sourceCount": theme["total"],
                "sources": [it["url"] for it in theme["items"][:10]],
            }
        )
    if not proposals:
        return None
    return {
        "generatedAt": digest["generatedAt"],
        "model": model,
        "note": "PROPOSALS ONLY — review before publishing as editorial content.",
        "themes": proposals,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Mat Sjekk theme digest agent")
    parser.add_argument("--window-days", type=int, default=90,
                        help="Days counted as 'recent' (default 90)")
    parser.add_argument("--max-items", type=int, default=12,
                        help="Max items kept per theme (default 12)")
    args = parser.parse_args(argv)

    digest = build_digest(args.window_days, args.max_items)
    DIGEST_OUT.parent.mkdir(parents=True, exist_ok=True)
    DIGEST_OUT.write_text(json.dumps(digest, ensure_ascii=False, indent=2) + "\n",
                          encoding="utf-8")
    totals = ", ".join(f"{t['key']}={t['total']}" for t in digest["themes"])
    print(f"Wrote {DIGEST_OUT.relative_to(ROOT)} ({totals})")

    proposals = build_proposals(digest)
    if proposals is not None:
        PROPOSALS_OUT.parent.mkdir(parents=True, exist_ok=True)
        PROPOSALS_OUT.write_text(json.dumps(proposals, ensure_ascii=False, indent=2) + "\n",
                                 encoding="utf-8")
        print(f"Wrote {PROPOSALS_OUT.relative_to(ROOT)} ({len(proposals['themes'])} proposals)")
    else:
        print("No LLM proposals (set OPENAI_API_KEY to enable editorial drafts).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
