# Farmshops shared locality cache (MVP)

Dette er første steg mot en delt, lærende søkeløsning for gårdsbutikker.

## Hva som er lagt inn nå

- Frontend bruker både:
  - lokal cache i nettleser (per bruker), og
  - delt cache-fil i repoet: `docs/data/farmshops_area_cache.json`.
- Ved lokalt område-fallback (f.eks. kommune-søk) blir treff lagret lokalt og brukt ved neste like søk.
- Ved oppstart lastes delt cache-fil og brukes før nye nettkall.

## Hvordan cache bygges

Script:
- `tools/build_farmshops_area_cache.py`

Input:
- `docs/data/farmshops.json`

Output:
- `docs/data/farmshops_area_cache.json`

## CI-integrasjon

Følgende workflows bygger nå både hoveddatasett og område-cache:
- `.github/workflows/fetch_farmshops.yml`
- `.github/workflows/farmshops-ingest.yml`

## Begrensning i MVP

Denne løsningen er delt via statisk datafil og oppdateres når CI kjører.
Den skriver ikke direkte fra brukerens nettleser tilbake til server/database.

## Neste steg (global, ekte læring)

For at «neste bruker» skal få helt ferske treff umiddelbart etter noens søk, trengs backend:

1. API-endepunkt for områdeforespørsel (`country/region/municipality/query`).
2. Database-tabeller for kandidater + kvalitets-score + kilde + sist verifisert.
3. Bakgrunnsjobb som beriker områder (Overpass/Nominatim + evt. moderert AI-ekstraksjon).
4. Klienten leser fra API først, og kan trigge asynkron oppfriskning.
