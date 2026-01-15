# GitHub Pages Oppsettguide

En enkel, trygg måte å opprette en GitHub Pages-side fra ditt repo med docs-mappen.

## Nyttige lenker

- [Opprett nytt repo på GitHub](https://github.com/new)
- [GitHub Pages dokumentasjon](https://docs.github.com/en/pages)
- [Quick start for GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)

## Trinn (anbefalt: bruk docs som Pages-kilde)

### 1. Opprett et nytt repo på GitHub

Gå til [https://github.com/new](https://github.com/new). Velg navn (f.eks. matsjekk), sett det offentligt eller privat etter ønske.

### 2. Initialiser Git lokalt

På din maskin, i prosjektroten (mat_sjekk) kjør disse kommandoene i PowerShell (erstatt `<USERNAME>` og `<REPO>` med ditt brukernavn/repo-navn):

```powershell
# 1) Initialiser git (hvis ikke allerede)
git init
git branch -M main

# 2) Legg til remote (erstatt med din repo-URL fra GitHub)
git remote add origin https://github.com/<USERNAME>/<REPO>.git

# 3) Legg til filer og commit
git add .
git commit -m "Add project and docs site"

# 4) Push til GitHub
git push -u origin main
```

### 3. Aktiver GitHub Pages

1. Gå til ditt repository på GitHub
2. Klikk på **Settings** (Innstillinger)
3. Scroll ned til **Pages** i venstre meny
4. Under **Source** (Kilde), velg:
   - **Branch**: `main`
   - **Folder**: `/docs`
5. Klikk **Save** (Lagre)

### 4. Vent på deployment

GitHub vil bygge og deploye siden din. Dette tar vanligvis 1-2 minutter. Du vil se en melding med URL-en til siden din når den er klar.

## Viktige merknader

- Repoet må være **public** for gratis GitHub Pages, eller du må ha GitHub Pro/Team/Enterprise for private repos
- Alle filer i `docs`-mappen vil være tilgjengelige på nettstedet ditt
- Hovedfilen kan være `index.html` eller `README.md`
- GitHub Pages støtter Jekyll for statiske nettsider

## Oppdatering av nettstedet

For å oppdatere nettstedet ditt, bare gjør endringer i `docs`-mappen og push til GitHub:

```powershell
git add docs/
git commit -m "Oppdater dokumentasjon"
git push
```

Endringene vil automatisk bli publisert etter noen minutter.
