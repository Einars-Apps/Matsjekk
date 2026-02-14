# Mat Sjekk V2 — Europa utrulling

## Mål
Bygg samme varsel-opplevelse som i Norge for hele Europa, med lokal språkstøtte, lokale nyheter og gårdsbutikker prioritert etter nærhet.

## Nærmeste gjennomførbare løsning
Fullt automatisk kvalitetssikret dekning i alle land er ikke realistisk uten medieavtaler og redaksjonell kontroll. Nærmeste løsning er:

1. Automatisk ingest av åpne nyhetskilder (RSS/API) per land.
2. Felles datamodell for app + nettside.
3. Land/språk-prioritet med fallback (kommune → region → land).
4. Moderering/score for røde og gule varsler.

## Faseplan

### Fase 1 (nå) — Starter (automatisert grunnmur)
- `docs/data/news_feeds.json`: land/språk/feed-konfig for Vest-Europa.
- `tools/fetch_news.py`: henter og normaliserer nyheter.
- `docs/data/news.latest.json`: publisert nyhetsfeed for frontend.
- `docs/news.js`: leser automatisk feed + fallback til lokale artikler.

### Fase 2 — Land- og kommuneprioritering
- Lag geodata-mapping for kommune/region per artikkel.
- Ranger nyheter: kommune først, så region, så land.
- Knyt gårdsbutikker til brukerens kommune før nabokommuner.

### Fase 3 — Kvalitet og skala
- Koble premium medie-API (når avtaler er klare).
- Legg inn kilde-score, duplikatdeteksjon og faktasjekk-flagg.
- Manuell kontroll kun for høy-risiko varsler med stor spredning.

## Datamodell (minimum)
Hver artikkel bør inneholde:
- `title`, `url`, `pubDate`, `source`
- `language`, `country`
- `summary` (kort)
- senere: `region`, `municipality`, `riskTags[]`, `confidence`

## Operativ drift
- Kjør ingest minst daglig.
- Logg feed-feil, men publiser delvis resultat.
- Behold alltid sist gyldige feed ved kildefeil.

## Neste konkrete steg
1. Legg på GitHub Action med daglig `cron` for `tools/fetch_news.py`.
2. Utvid feed-konfig med flere lokale aviser per land.
3. Legg inn kommune-felt i frontend-filter når geodata er på plass.
