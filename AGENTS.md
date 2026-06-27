# AGENTS.md — Les dette FØR du endrer noe

> Formål: hindre unødvendige app-oppdateringer. Tidligere har agenter justert
> kun «siste spørsmål» og trigget nye app-bygg uten grunn. Sjekk status under
> før du foreslår eller bygger en ny app-versjon.

## ⛔ Før du endrer app-koden (lib/**) — sjekkliste
1. **Krever endringen virkelig en ny app-versjon?** Kun endringer i `lib/**`,
   `android/**`, `ios/**`, `pubspec.yaml` når til brukere via Store-bygg.
   Nettside (`docs/**`), workflows og data-filer deployes UTEN ny app-versjon.
2. **Er det allerede gjort?** Se «Byggestatus» under. Ikke re-implementer.
3. **Bump versjon kun når du faktisk lager et release-bygg.**
   `pubspec.yaml` → `version:` (format `x.y.z+build`).
4. **Valider med `get_errors`**, ikke `flutter analyze` (analyze feiler ofte på
   lav minne på denne maskinen — det er IKKE kodefeil).

## Hva trer i kraft hvor (ingen app-versjon nødvendig for disse)
| Endring | Hvordan den når brukere |
|---|---|
| `docs/**` (nettside) | GitHub Pages deploy fra `main` (deploy_docs.yml) — live på minutter |
| `.github/workflows/**` | Aktiv neste schedule / workflow_dispatch |
| `docs/data/**` (feeds, digest) | Hentes av nettsiden runtime |
| `lib/**`, `pubspec.yaml`, `android/**`, `ios/**` | **KREVER nytt Store-bygg + versjonsbump** |

## Byggestatus (oppdater når noe fullføres)
> Sist oppdatert: 2026-06-27 · app-versjon i pubspec: `1.1.6+63`

### App (lib/) — venter på neste Store-bygg for å nå brukere
- ✅ Annonse skjules i fullskjerm (widgets.dart `HandlelisteOverlay`).
- ✅ NPA (ikke-personaliserte annonser) når bruker ikke har samtykket.
- ✅ Dedikerte annonse-enheter i `ad_helper.dart`.
- ✅ UMP/CMP samtykkeflyt (`lib/ump_consent.dart`) — gathers consent før annonser.
- 🌐 i18n: alle 11 app-språk komplette på morsmålsnivå (72/72 nøkler).

### Nettside (docs/) — allerede LIVE
- ✅ Gårdsbutikk-resultater gjenopprettet, tomt «Annonse»-felt fjernet.
- ✅ Alle 17 UI-språk har nå ekte morsmålsoversettelser (ko, pl, ru, zh, ar, th
  fullført — 72/72 nøkler hver). RTL aktivert for arabisk i `applyTranslations`.

### Automatisering (workflows/) — aktiv
- ✅ `theme-digest.yml` (ukentlig): følger Bovaer/GMO/insektsmel, oppdaterer
  faktabasert digest auto; AI-redaksjonelle sammendrag → PR for menneskelig
  review (krever `OPENAI_API_KEY`-secret). Du får GitHub-varsel på PR.
- ✅ `ngt-monitor.yml`, `news-ingest.yml` m.fl.

## Eksterne avhengigheter / manuelle steg som IKKE kan automatiseres
- **AdMob personvern-melding (UMP)**: må opprettes i AdMob-konsollet (web).
  Se README-seksjon / agentens instruksjoner. Koden er klar; meldingen må
  publiseres i konsollet for at skjemaet skal vises i EØS.
- **`OPENAI_API_KEY`**: legges som GitHub repo-secret for AI-sammendrag.
- **Kassalapp API**: HOLD som test til budsjett → da Bedrift-lisens (kommersiell
  bruk forbudt på gratis-tier). Token `kassalapp.token` er git-ignorert.

## Verktøy
- `tools/arb_audit.py` — manglende/ekstra ARB-nøkler per språk.
- `tools/arb_untranslated.py` — verdier som fortsatt er engelske.
- `tools/theme_digest.py` — bygg tema-digest fra eksisterende nyhetsfeed.
- Etter ARB-endring: `flutter gen-l10n`.
