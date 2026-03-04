#!/usr/bin/env python3

from __future__ import annotations

import json
import os
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parents[1]
AREA_CACHE_FILE = ROOT / "docs" / "data" / "farmshops_area_cache.json"


def must_env(name: str) -> str:
    value = os.getenv(name, "").strip()
    if not value:
        raise RuntimeError(f"Missing required env var: {name}")
    return value


def parse_cache_key(cache_key: str) -> dict[str, str]:
    parts = (cache_key or "").split("|")
    while len(parts) < 4:
        parts.append("-")
    country_code, region_text, municipality_text, query_text = parts[:4]
    return {
        "country_code": country_code if country_code and country_code != "ANY" else "",
        "region_text": "" if region_text == "-" else region_text,
        "municipality_text": "" if municipality_text == "-" else municipality_text,
        "query_text": "" if query_text == "-" else query_text,
    }


def read_area_cache_rows() -> list[dict]:
    if not AREA_CACHE_FILE.exists():
        raise FileNotFoundError(f"Missing area cache file: {AREA_CACHE_FILE}")
    with AREA_CACHE_FILE.open("r", encoding="utf-8") as fh:
        payload = json.load(fh)
    if not isinstance(payload, list):
        raise ValueError("Expected area cache payload to be a JSON array")
    return payload


def build_upsert_payload(rows: list[dict]) -> list[dict]:
    output = []
    for row in rows:
        cache_key = str(row.get("key") or "").strip()
        shops = row.get("shops")
        if not cache_key or not isinstance(shops, list):
            continue
        parsed = parse_cache_key(cache_key)
        output.append(
            {
                "cache_key": cache_key,
                "country_code": parsed["country_code"],
                "region_text": parsed["region_text"],
                "municipality_text": parsed["municipality_text"],
                "query_text": parsed["query_text"],
                "shops": shops,
                "result_count": len(shops),
                "source": "pipeline",
            }
        )
    return output


def chunked(values: list[dict], size: int) -> list[list[dict]]:
    return [values[idx: idx + size] for idx in range(0, len(values), size)]


def upsert_rows(supabase_url: str, service_key: str, rows: list[dict], chunk_size: int = 200) -> int:
    endpoint = f"{supabase_url}/rest/v1/farmshops_area_cache"
    headers = {
        "apikey": service_key,
        "Authorization": f"Bearer {service_key}",
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates",
    }
    total = 0
    for batch in chunked(rows, chunk_size):
        response = requests.post(
            endpoint,
            params={"on_conflict": "cache_key"},
            headers=headers,
            json=batch,
            timeout=60,
        )
        response.raise_for_status()
        total += len(batch)
    return total


def main() -> None:
    supabase_url = must_env("SUPABASE_URL").rstrip("/")
    service_key = must_env("SUPABASE_SERVICE_ROLE_KEY")

    area_rows = read_area_cache_rows()
    upsert_payload = build_upsert_payload(area_rows)
    if not upsert_payload:
        print("No rows to ingest")
        return

    written = upsert_rows(supabase_url, service_key, upsert_payload)
    print(f"Upserted {written} rows into farmshops_area_cache")


if __name__ == "__main__":
    main()
