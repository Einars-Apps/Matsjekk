# Premium MVP-plan (Mat Sjekk)

## Mål
- Innføre premium uten å svekke tillit: kjernefunksjonene (skanning + risikovarsel) forblir gratis.
- Starte med enkel, stabil betalingsflyt før familiedeling og avanserte premium-funksjoner.

## Fase 1 (1–2 uker): Betalingsgrunnlag
- Legg inn `in_app_purchase` og opprett produkt-IDer:
  - `matsjekk_premium_monthly`
  - `matsjekk_premium_yearly`
- Lag enkel paywall i appen med:
  - Pris, hva som inngår, og «Fortsett gratis»-valg.
  - Knapper for kjøp og gjenopprett kjøp.
- Lagre lokal entitlement i Hive (`premiumActive`) basert på kvitteringsstatus.

## Fase 2 (1 uke): Premium-funksjoner MVP
- Aktivér 2 tydelige premium-fordeler først:
  - Reklamefri opplevelse.
  - Avanserte varselprofiler (flere profiler/filtre).
- Hold funksjonene bak én feature-gate: `if (premiumActive) ...`.

## Fase 3 (2–3 uker): Familiedeling
- Innfør enkel backend for husstand/familie:
  - Opprette familiegruppe med kode/invitasjon.
  - Maks antall medlemmer (f.eks. 5).
  - Synk av delte lister mellom medlemmer.
- Entitlement-regel:
  - Én eier med aktiv premium kan dele premium i gruppen.

## Avhengigheter (hva er app-avhengig)
- **Må settes opp utenfor appkode:**
  - Google Play Console: abonnementer + testbrukere.
  - App Store Connect: abonnementer + sandbox-brukere.
  - Juridisk: vilkår/abonnementstekst og personvernoppdatering.
- **Må bygges i appen:**
  - Paywall-UI, kjøpslogikk, gjenoppretting og feature-gating.
  - Lokal premium-status og feilhåndtering.
- **Må ha backend (for familiedeling):**
  - Gruppemodell, invitasjoner, medlemskap, og delte entitlements.

## Foreslått teknisk løsning
- Flutter: `in_app_purchase` for kjøp.
- Backend (lett): Supabase/Firebase for familiegrupper + entitlement-sync.
- Kvitteringsvalidering:
  - Start med klient-side validering for MVP.
  - Oppgrader til server-side validering før bred lansering.

## KPI-er fra dag 1
- Konvertering gratis → premium.
- 7/30-dagers retention for premium-brukere.
- Andel «restore purchase» som lykkes.
- Churn per abonnementstype (måned/år).

## Nærmeste neste oppgave
- Implementer Fase 1 i kode:
  - Opprett `PremiumService` i appen.
  - Lag enkel `PremiumScreen` med kjøpsknapper.
  - Koble menyvalget «Premium» til denne skjermen.