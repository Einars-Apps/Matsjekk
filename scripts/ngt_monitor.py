#!/usr/bin/env python3
"""
NGT / hidden-GMO supplier monitor (simple starter).

Goal
----
Watch a small set of producers/retailers and flag one ONLY when a source
documents a link between that actor and a KNOWN GMO supplier (companies with
Monsanto/Bayer-type agreements). The monitor produces PROPOSALS for human
review — it never publishes anything to the app on its own.

How it works (deliberately simple to start)
-------------------------------------------
1. Read config (known GMO suppliers, watch actors, sources).
2. Fetch each enabled source's text.
3. If a watched actor AND a known GMO supplier are mentioned in the same
   source, emit a proposal with the source URL + the surrounding snippet.
4. Write all proposals to scripts/ngt_proposals.json.

A human then reviews ngt_proposals.json (e.g. in the PR opened by the
workflow) and, if verified, promotes the entry into the published list
docs/data/ngt_suppliers.json. Only then does the app show a yellow signal.

Optional LLM refinement
-----------------------
If the environment variable OPENAI_API_KEY is set, an optional refinement step
can be added later. The default path uses no external API and no API key, so it
is free and deterministic.

Usage
-----
    python scripts/ngt_monitor.py
    python scripts/ngt_monitor.py --config scripts/ngt_monitor_config.json
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CONFIG = Path(__file__).resolve().parent / "ngt_monitor_config.json"
PROPOSALS_PATH = Path(__file__).resolve().parent / "ngt_proposals.json"

SNIPPET_RADIUS = 200  # characters of context around a match
HTTP_TIMEOUT = 15
USER_AGENT = "MatsjekkNGTMonitor/1.0 (+https://matsjekk.com)"


def load_config(path: Path) -> dict:
    if not path.exists():
        print(f"ERROR: config not found: {path}", file=sys.stderr)
        sys.exit(1)
    return json.loads(path.read_text(encoding="utf-8"))


def fetch_text(url: str) -> str:
    """Fetch a URL and return plain-ish text (HTML tags stripped)."""
    req = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(req, timeout=HTTP_TIMEOUT) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        raw = resp.read().decode(charset, errors="replace")
    # Strip scripts/styles then tags.
    raw = re.sub(r"<(script|style)[^>]*>.*?</\1>", " ", raw, flags=re.I | re.S)
    text = re.sub(r"<[^>]+>", " ", raw)
    text = re.sub(r"\s+", " ", text)
    return text


def find_aliases(text_lower: str, group: list[dict]) -> list[tuple[str, str, int]]:
    """Return list of (canonical_name, matched_alias, index) for the group."""
    hits: list[tuple[str, str, int]] = []
    for item in group:
        name = item.get("name", "")
        for alias in item.get("aliases", []):
            a = alias.strip().lower()
            if not a:
                continue
            idx = text_lower.find(a)
            if idx != -1:
                hits.append((name, alias, idx))
                break  # one hit per item is enough
    return hits


def make_snippet(text: str, index: int) -> str:
    start = max(0, index - SNIPPET_RADIUS)
    end = min(len(text), index + SNIPPET_RADIUS)
    snippet = text[start:end].strip()
    return ("..." if start > 0 else "") + snippet + ("..." if end < len(text) else "")


def analyze_source(source: dict, suppliers: list[dict], actors: list[dict]) -> list[dict]:
    url = source.get("url", "")
    name = source.get("name", url)
    try:
        text = fetch_text(url)
    except (URLError, HTTPError, ValueError, TimeoutError) as exc:
        print(f"  WARN: could not fetch {url}: {exc}", file=sys.stderr)
        return []

    text_lower = text.lower()
    actor_hits = find_aliases(text_lower, actors)
    supplier_hits = find_aliases(text_lower, suppliers)

    if not actor_hits or not supplier_hits:
        return []

    proposals: list[dict] = []
    for actor_name, actor_alias, actor_idx in actor_hits:
        for supplier_name, supplier_alias, _supplier_idx in supplier_hits:
            proposals.append(
                {
                    "actor": actor_name,
                    "matched_actor_alias": actor_alias,
                    "gmo_supplier": supplier_name,
                    "matched_supplier_alias": supplier_alias,
                    "source_name": name,
                    "source_url": url,
                    "snippet": make_snippet(text, actor_idx),
                    "detected_at": datetime.now(timezone.utc).isoformat(),
                    "confidence": "low",
                    "status": "needs_review",
                    "note": "Co-occurrence in the same source. VERIFY the source manually before promoting.",
                }
            )
    return proposals


def main() -> int:
    parser = argparse.ArgumentParser(description="NGT/hidden-GMO supplier monitor")
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--out", type=Path, default=PROPOSALS_PATH)
    args = parser.parse_args()

    config = load_config(args.config)
    suppliers = config.get("known_gmo_suppliers", [])
    actors = config.get("watch_actors", [])
    sources = [s for s in config.get("sources", []) if s.get("enabled")]

    if not sources:
        print("No enabled sources in config. Add real source URLs and set "
              '"enabled": true to start monitoring.')
        # Still write an empty proposals file so downstream steps are stable.
        args.out.write_text(
            json.dumps(
                {
                    "generated_at": datetime.now(timezone.utc).isoformat(),
                    "proposals": [],
                },
                ensure_ascii=False,
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        return 0

    all_proposals: list[dict] = []
    for source in sources:
        print(f"Scanning: {source.get('name', source.get('url'))}")
        all_proposals.extend(analyze_source(source, suppliers, actors))

    payload = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "proposal_count": len(all_proposals),
        "proposals": all_proposals,
    }
    args.out.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(f"\nWrote {len(all_proposals)} proposal(s) to {args.out}")
    print("NOTE: these are PROPOSALS only. A human must verify each source and "
          "promote it into docs/data/ngt_suppliers.json before the app shows it.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
