# Farmshops Backend MVP

Dette er backend-MVP for delt/lærende gårdsbutikk-søk.

## Innhold

- SQL-skjema: `backend/supabase/farmshops_schema.sql`
- API-kontrakt: `backend/openapi/farmshops-api.yaml`
- FastAPI-app: `backend/api/main.py`
- Ingest-jobb: `tools/ingest_area_cache_to_supabase.py`

## Oppsett (Supabase)

1. Kjør SQL fra `backend/supabase/farmshops_schema.sql` i Supabase SQL Editor.
2. Sett miljøvariabler:
   - `SUPABASE_URL`
   - `SUPABASE_SERVICE_ROLE_KEY`
3. Kjør ingest:

```powershell
c:/Users/ebors/mat_sjekk/.venv/Scripts/python.exe tools/ingest_area_cache_to_supabase.py
```

## API-kontrakt

OpenAPI-filen definerer:
- `GET /v1/farmshops/search`
- `POST /v1/farmshops/enrich`
- `GET /v1/farmshops/enrich/{jobId}`

Neste steg er å implementere disse endepunktene i valgt runtime (Edge Function, FastAPI eller tilsvarende).

## Kjør API lokalt (FastAPI MVP)

Installer dependencies:

```powershell
c:/Users/ebors/mat_sjekk/.venv/Scripts/python.exe -m pip install -r backend/requirements.txt
```

Sett miljøvariabler (se `backend/.env.example`), deretter start:

```powershell
$env:SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
$env:SUPABASE_SERVICE_ROLE_KEY="YOUR_SERVICE_ROLE_KEY"
c:/Users/ebors/mat_sjekk/.venv/Scripts/python.exe -m uvicorn backend.api.main:app --host 0.0.0.0 --port 8080 --reload
```

Swagger UI:

`http://localhost:8080/docs`
