## Repository history rewrite — February 13, 2026

Kort oppsummering
- Jeg omskrev Git-historikken for å fjerne store run-logg-artefakter som var ved et uhell sporet i repoet.
- Endringen ble force-pushet til `main` og flere feature-/backup‑refs ble opprettet og bevart.

Backup-branches som ble opprettet

- `backup-before-rewrite-20260213-120000`
- `backup-before-rewrite-20260213-195609`
- `backup-before-rewrite-main-20260213195919`

Hvorfor
- Flere store run-logs ble lagt inn i en arbeidsgren og gjorde repoet større enn nødvendig. For å redusere repo-størrelse og forhindre nye store opplastinger ble filene fjernet fra historien.

Hva jeg gjorde

1. Installert og brukt `git-filter-repo` for å fjerne matcherende filer (`run-*-logs.zip` og `scripts/tmp_run_logs`).
2. Kjørte `git gc` og repakket repositoryet.
3. Force-pushet de omskrevne referansene til remote.
4. Opprettet backup‑branches som inneholder original historikk.

Størrelsesdata (lokalt og GitHub)

- Lokalt `.git`-mappe: 166.69 MB
- `git count-objects -vH` (in-pack): 4.94 MiB
- GitHub API rapportert repo-størrelse: 5171 KB (~5.05 MB)

Anbefalt handling for andre utviklere

- Den tryggeste fremgangsmåten er å klone repoet på nytt:

  git clone https://github.com/Einars-Apps/Matsjekk.git

- Hvis du har lokale endringer du vil redde, ta en sikkerhetskopi (f.eks. en patch eller en ny branch) før du gjør hard reset:

  git fetch origin --prune
  git checkout main
  git reset --hard origin/main

Lenker

- Issue som forklarer endringen og inneholder detaljer: https://github.com/Einars-Apps/Matsjekk/issues/26

Kontakt meg her i issuet hvis du trenger hjelp med å redde lokale endringer eller re-synce arbeidskopier.
