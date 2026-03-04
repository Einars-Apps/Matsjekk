from __future__ import annotations

import math
import os
import re
from typing import Any

import requests
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, Field

app = FastAPI(title="Matsjekk Farmshops API", version="0.1.0")


def env(name: str, default: str = "") -> str:
    return os.getenv(name, default).strip()


def require_env(name: str) -> str:
    value = env(name)
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


def locality_token(value: str) -> str:
    return (
        (value or "")
        .strip()
        .lower()
        .replace("ø", "o")
        .replace("æ", "ae")
        .replace("å", "a")
    )


def build_cache_key(country_code: str, region: str, municipality: str, query_text: str) -> str:
    cc = (country_code or "ANY").upper()
    region_token = locality_token(region) or "-"
    municipality_token = locality_token(municipality) or "-"
    query_token = locality_token(query_text) or "-"
    return "|".join([cc, region_token, municipality_token, query_token])


def haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    to_rad = math.pi / 180.0
    d_lat = (lat2 - lat1) * to_rad
    d_lon = (lon2 - lon1) * to_rad
    a = (
        math.sin(d_lat / 2) ** 2
        + math.cos(lat1 * to_rad) * math.cos(lat2 * to_rad) * math.sin(d_lon / 2) ** 2
    )
    return 6371.0 * (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)))


class SupabaseClient:
    def __init__(self) -> None:
        self.base_url = require_env("SUPABASE_URL").rstrip("/") + "/rest/v1"
        self.api_key = require_env("SUPABASE_SERVICE_ROLE_KEY")

    @property
    def headers(self) -> dict[str, str]:
        return {
            "apikey": self.api_key,
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }

    def select(
        self,
        table: str,
        query_params: dict[str, str] | None = None,
    ) -> list[dict[str, Any]]:
        params = {"select": "*"}
        if query_params:
            params.update({k: v for k, v in query_params.items() if v is not None and v != ""})
        response = requests.get(
            f"{self.base_url}/{table}",
            params=params,
            headers=self.headers,
            timeout=30,
        )
        response.raise_for_status()
        payload = response.json()
        return payload if isinstance(payload, list) else []

    def insert(self, table: str, payload: dict[str, Any]) -> dict[str, Any]:
        headers = {**self.headers, "Prefer": "return=representation"}
        response = requests.post(
            f"{self.base_url}/{table}",
            headers=headers,
            json=payload,
            timeout=30,
        )
        response.raise_for_status()
        body = response.json()
        if isinstance(body, list) and body:
            return body[0]
        if isinstance(body, dict):
            return body
        return {}


def safe_client() -> SupabaseClient:
    try:
        return SupabaseClient()
    except RuntimeError as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


def optional_client() -> SupabaseClient | None:
    try:
        return SupabaseClient()
    except RuntimeError:
        return None


class Farmshop(BaseModel):
    name: str
    countryCode: str = ""
    country: str = ""
    region: str = ""
    municipality: str = ""
    address: str = ""
    products: list[str] = Field(default_factory=list)
    website: str = ""
    lat: float
    lon: float
    category: str = ""
    phone: str = ""
    openingHours: str = ""
    mapsUrl: str = ""
    qualityScore: int = 0
    source: str = ""
    distanceKm: float | None = None


class SearchResponse(BaseModel):
    source: str
    cacheKey: str
    total: int
    results: list[Farmshop]


class EnrichRequest(BaseModel):
    countryCode: str = Field(min_length=2, max_length=2)
    region: str = ""
    municipality: str = ""
    query: str = ""
    requestedBy: str = ""


class EnrichQueuedResponse(BaseModel):
    jobId: str
    status: str
    cacheKey: str


class EnrichStatusResponse(BaseModel):
    jobId: str
    status: str
    resultCount: int | None = None
    errorMessage: str | None = None


def to_farmshop_model(row: dict[str, Any], source: str = "") -> Farmshop:
    return Farmshop(
        name=str(row.get("name") or ""),
        countryCode=str(row.get("countryCode") or row.get("country_code") or ""),
        country=str(row.get("country") or ""),
        region=str(row.get("region") or ""),
        municipality=str(row.get("municipality") or ""),
        address=str(row.get("address") or ""),
        products=row.get("products") if isinstance(row.get("products"), list) else [],
        website=str(row.get("website") or ""),
        lat=float(row.get("lat")),
        lon=float(row.get("lon")),
        category=str(row.get("category") or ""),
        phone=str(row.get("phone") or ""),
        openingHours=str(row.get("openingHours") or row.get("opening_hours") or ""),
        mapsUrl=str(row.get("mapsUrl") or row.get("maps_url") or ""),
        qualityScore=int(row.get("qualityScore") or row.get("quality_score") or 0),
        source=source or str(row.get("source") or ""),
        distanceKm=float(row.get("distanceKm")) if row.get("distanceKm") is not None else None,
    )


def candidate_cache_keys(country_code: str, region: str, municipality: str, query_text: str) -> list[str]:
    return [
        build_cache_key(country_code, region, municipality, query_text),
        build_cache_key(country_code, region, municipality, ""),
        build_cache_key(country_code, "", municipality, ""),
        build_cache_key(country_code, region, "", query_text),
        build_cache_key(country_code, "", "", query_text),
    ]


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/v1/farmshops/search", response_model=SearchResponse)
def search_farmshops(
    countryCode: str = Query(default="", min_length=0, max_length=2),
    region: str = "",
    municipality: str = "",
    query: str = "",
    lat: float | None = None,
    lon: float | None = None,
    radiusKm: float = Query(default=50, ge=1, le=250),
    limit: int = Query(default=120, ge=1, le=300),
) -> SearchResponse:
    cc = (countryCode or "").upper()
    cache_key = build_cache_key(cc or "ANY", region, municipality, query)
    client = optional_client()

    if client is None:
        return SearchResponse(source="canonical-dataset", cacheKey=cache_key, total=0, results=[])

    for key in candidate_cache_keys(cc or "ANY", region, municipality, query):
        rows = client.select("farmshops_area_cache", {"cache_key": f"eq.{key}", "limit": "1"})
        if not rows:
            continue
        shops = rows[0].get("shops") if isinstance(rows[0], dict) else []
        normalized = [to_farmshop_model(item, source="shared-cache") for item in (shops or []) if isinstance(item, dict)]

        if lat is not None and lon is not None:
            filtered = []
            for shop in normalized:
                distance = haversine_km(lat, lon, shop.lat, shop.lon)
                if distance <= radiusKm:
                    shop.distanceKm = distance
                    filtered.append(shop)
            filtered.sort(key=lambda s: (s.distanceKm if s.distanceKm is not None else 10_000_000, s.name))
            normalized = filtered

        return SearchResponse(source="shared-cache", cacheKey=key, total=min(len(normalized), limit), results=normalized[:limit])

    params: dict[str, str] = {"limit": str(max(limit * 2, 200))}
    if cc:
        params["country_code"] = f"eq.{cc}"
    if municipality:
        municipality_pattern = re.sub(r"\s+", "%", municipality.strip())
        params["municipality"] = f"ilike.*{municipality_pattern}*"
    if region:
        region_pattern = re.sub(r"\s+", "%", region.strip())
        params["region"] = f"ilike.*{region_pattern}*"

    if lat is not None and lon is not None:
        lat_delta = radiusKm / 111.0
        cos_lat = max(0.2, math.cos(math.radians(lat)))
        lon_delta = radiusKm / (111.0 * cos_lat)
        params["lat"] = f"gte.{lat - lat_delta}"
        params["lon"] = f"gte.{lon - lon_delta}"
        params["and"] = f"(lat.lte.{lat + lat_delta},lon.lte.{lon + lon_delta})"

    rows = client.select("farmshops", params)

    result = [to_farmshop_model(row, source="canonical-dataset") for row in rows]

    if query:
        q = query.strip().lower()
        result = [
            shop
            for shop in result
            if q in shop.name.lower()
            or q in shop.municipality.lower()
            or q in shop.region.lower()
            or q in shop.address.lower()
            or any(q in product.lower() for product in shop.products)
        ]

    if lat is not None and lon is not None:
        filtered = []
        for shop in result:
            distance = haversine_km(lat, lon, shop.lat, shop.lon)
            if distance <= radiusKm:
                shop.distanceKm = distance
                filtered.append(shop)
        filtered.sort(key=lambda s: (s.distanceKm if s.distanceKm is not None else 10_000_000, s.name))
        result = filtered
    else:
        result.sort(key=lambda s: s.name)

    return SearchResponse(source="canonical-dataset", cacheKey=cache_key, total=min(len(result), limit), results=result[:limit])


@app.post("/v1/farmshops/enrich", response_model=EnrichQueuedResponse, status_code=202)
def queue_enrich_job(body: EnrichRequest) -> EnrichQueuedResponse:
    cc = body.countryCode.strip().upper()
    if len(cc) != 2:
        raise HTTPException(status_code=400, detail="countryCode must be ISO-2")

    client = safe_client()
    key = build_cache_key(cc, body.region, body.municipality, body.query)

    payload = {
        "cache_key": key,
        "country_code": cc,
        "region_text": body.region,
        "municipality_text": body.municipality,
        "query_text": body.query,
        "status": "queued",
        "requested_by": body.requestedBy,
    }

    created = client.insert("farmshops_enrich_jobs", payload)
    job_id = str(created.get("id") or "")
    if not job_id:
        raise HTTPException(status_code=500, detail="Could not create enrich job")

    return EnrichQueuedResponse(jobId=job_id, status=str(created.get("status") or "queued"), cacheKey=key)


@app.get("/v1/farmshops/enrich/{jobId}", response_model=EnrichStatusResponse)
def get_enrich_job(jobId: str) -> EnrichStatusResponse:
    client = safe_client()
    rows = client.select("farmshops_enrich_jobs", {"id": f"eq.{jobId}", "limit": "1"})
    if not rows:
        raise HTTPException(status_code=404, detail="Job not found")
    row = rows[0]
    return EnrichStatusResponse(
        jobId=str(row.get("id")),
        status=str(row.get("status") or "queued"),
        resultCount=row.get("result_count"),
        errorMessage=row.get("error_message"),
    )
