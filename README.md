# mat_sjekk

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Homepage: https://sites.google.com/view/einars-apps/

## Serve `docs/` locally

There is a PowerShell helper script that serves the `docs/` folder on a local HTTP server.

Run from the project root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\serve-docs.ps1 -Port 8000 -Root docs
```

Alternative quick commands:

```powershell
# Using Python (if installed)
python -m http.server 8000 --directory docs

# Using Node.js http-server (if installed)
npx http-server docs -p 8000
```

Optional: create a PowerShell alias for convenience by running `scripts\create-pwsh-alias.ps1` (see below).

## Create a persistent PowerShell alias (optional)

Run this to add an alias `serve-docs` to your PowerShell profile (you'll need to run PowerShell as your user):

```powershell
.\scripts\create-pwsh-alias.ps1
```

This will append an alias to your PowerShell profile if you confirm the prompt.

### AdSense setup (optional)

If you plan to monetize via Google AdSense, configure the loader before publishing:

1. Open `docs/js/ads-adsense.js` and replace `REPLACE_WITH_ADSENSE_CLIENT_ID` with your `ca-pub-...` client id.
2. Optionally set `data-ad-slot` on the ad container in `docs/index.html`.
3. Ensure the cookie consent banner is shown and that users must consent before ads load.

Note: Do not publish live ad scripts until your AdSense account is approved and your privacy page is final.
