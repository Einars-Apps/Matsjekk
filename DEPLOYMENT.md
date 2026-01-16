# GitHub Pages Deployment Guide / Veiledning for GitHub Pages

## 🇳🇴 Norsk

### Hvordan sette opp GitHub Pages for Matsjekk

#### Trinn 1: Gå til Repository Settings
1. Naviger til GitHub repository: `https://github.com/einarborsheim-crypto/Matsjekk`
2. Klikk på **"Settings"** (tannhjul-ikonet) øverst til høyre

#### Trinn 2: Åpne Pages-innstillinger
1. I venstre sidemeny, scroll ned og klikk på **"Pages"**

#### Trinn 3: Konfigurer Source
1. Under **"Build and deployment"** seksjonen
2. Ved **"Source"**, velg **"Deploy from a branch"**
3. Ved **"Branch"**:
   - Velg `copilot/create-lage-hjemmeside` fra dropdown (eller `main` etter at PR er merged)
   - Velg `/ (root)` som mappe
4. Klikk **"Save"**

#### Trinn 4: Vent på deployment
- GitHub Actions vil automatisk starte deployment-prosessen
- Du vil se en blå boks med meldingen: "Your site is ready to be published at..."
- Etter 1-3 minutter vil boksen bli grønn: "Your site is live at..."

#### Trinn 5: Besøk siden din
- URL-en vil være: `https://einarborsheim-crypto.github.io/Matsjekk/`
- Klikk på **"Visit site"** knappen eller kopier URL-en
- Siden er nå tilgjengelig for alle på internett! 🎉

### Feilsøking

**Problem: Siden viser ikke riktig**
- Sjekk at `index.html`, `style.css`, og `script.js` er i root-mappen
- Vent noen minutter - deployment kan ta litt tid
- Tøm nettleserens cache (Ctrl+Shift+R / Cmd+Shift+R)

**Problem: 404 Not Found**
- Verifiser at riktig branch er valgt i Pages-innstillingene
- Sjekk at `index.html` eksisterer i root-mappen av branchen

**Problem: CSS eller JavaScript lastes ikke**
- Kontroller at alle filreferanser i `index.html` er relative (ikke absolutte paths)

### Oppdatere siden
Når du gjør endringer i koden:
1. Commit og push endringene til branchen
2. GitHub Pages vil automatisk re-deploye
3. Vent 1-3 minutter før endringene vises

---

## 🇬🇧 English

### How to Set Up GitHub Pages for Matsjekk

#### Step 1: Go to Repository Settings
1. Navigate to GitHub repository: `https://github.com/einarborsheim-crypto/Matsjekk`
2. Click on **"Settings"** (gear icon) in the top right

#### Step 2: Open Pages Settings
1. In the left sidebar, scroll down and click on **"Pages"**

#### Step 3: Configure Source
1. Under the **"Build and deployment"** section
2. For **"Source"**, select **"Deploy from a branch"**
3. For **"Branch"**:
   - Select `copilot/create-lage-hjemmeside` from dropdown (or `main` after PR is merged)
   - Select `/ (root)` as folder
4. Click **"Save"**

#### Step 4: Wait for Deployment
- GitHub Actions will automatically start the deployment process
- You'll see a blue box with the message: "Your site is ready to be published at..."
- After 1-3 minutes, the box will turn green: "Your site is live at..."

#### Step 5: Visit Your Site
- The URL will be: `https://einarborsheim-crypto.github.io/Matsjekk/`
- Click the **"Visit site"** button or copy the URL
- Your site is now available to everyone on the internet! 🎉

### Troubleshooting

**Issue: Site doesn't display correctly**
- Check that `index.html`, `style.css`, and `script.js` are in the root folder
- Wait a few minutes - deployment can take some time
- Clear browser cache (Ctrl+Shift+R / Cmd+Shift+R)

**Issue: 404 Not Found**
- Verify the correct branch is selected in Pages settings
- Check that `index.html` exists in the root of the branch

**Issue: CSS or JavaScript not loading**
- Verify all file references in `index.html` are relative (not absolute paths)

### Updating the Site
When you make code changes:
1. Commit and push changes to the branch
2. GitHub Pages will automatically redeploy
3. Wait 1-3 minutes for changes to appear

---

## Repository URL
When a script asks for the repository URL, use:
```
https://github.com/einarborsheim-crypto/Matsjekk
```

Or the SSH version:
```
git@github.com:einarborsheim-crypto/Matsjekk.git
```

## GitHub Pages URL
Once deployed, the live site URL is:
```
https://einarborsheim-crypto.github.io/Matsjekk/
```
