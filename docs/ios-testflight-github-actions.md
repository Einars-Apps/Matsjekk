# iOS TestFlight via GitHub Actions (Windows-friendly)

Denne workflowen lar deg bygge og laste opp iOS fra GitHub (macOS-runner), selv om du sitter på Windows.

## 1) Legg inn GitHub Secrets

Gå til **GitHub repo → Settings → Secrets and variables → Actions → New repository secret**.

Legg inn disse secret-navnene:

- `APPSTORE_KEY_ID`
  - App Store Connect API Key ID
- `APPSTORE_ISSUER_ID`
  - App Store Connect Issuer ID
- `APPSTORE_PRIVATE_KEY`
  - Innholdet i `AuthKey_<KEY_ID>.p8` (hele teksten, inkludert BEGIN/END)
- `IOS_P12_BASE64`
  - Base64 av iOS Distribution Certificate (`.p12`)
- `IOS_P12_PASSWORD`
  - Passordet brukt da `.p12` ble eksportert
- `IOS_PROFILE_BASE64`
  - Base64 av App Store provisioning profile (`.mobileprovision`)
- `KEYCHAIN_PASSWORD`
  - Valgfritt sterkt passord, brukes midlertidig på GitHub-runner

## 2) Hvordan lage base64 på Windows (PowerShell)

Kjør lokalt og kopier output til riktig secret:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\ios_distribution.p12"))
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\AppStore.mobileprovision"))
```

## 3) Kjør workflow

1. Push endringene til GitHub.
2. Gå til **Actions**.
3. Velg workflow: **iOS TestFlight Upload**.
4. Klikk **Run workflow**.
5. (Valgfritt) sett `build_number` (må være høyere enn forrige i App Store Connect).

## 4) Etter kjøring

- Workflow bygger `.ipa` og laster opp til TestFlight.
- Bygget dukker normalt opp i App Store Connect etter noen minutter (av og til 10–30 min).

## 5) Vanlige feil

- **Bundle ID mismatch**: må være lik appens Bundle ID i App Store Connect.
- **Build number already used**: bruk høyere `build_number`.
- **Signing error**: sjekk at cert/profil tilhører samme Team og Bundle ID.
- **API key error**: sjekk `APPSTORE_KEY_ID`, `APPSTORE_ISSUER_ID`, og at `APPSTORE_PRIVATE_KEY` er korrekt.
