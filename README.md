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

Homepage: https://matsjekk.com/app.html

## Automatic EU updates

`EU Decisions Ingest` runs daily at 05:23 UTC and updates
`docs/data/eu_decisions_auto.json` using Google News RSS searches filtered for EU
sources and relevant topics. This is a rule-based collector, not an AI agent or
a complete register of adopted EU legislation.

`Deploy docs to GitHub Pages` publishes after a successful ingest on `main`,
as well as on ordinary pushes and manual runs. The `workflow_run` trigger is
necessary because commits pushed with `GITHUB_TOKEN` do not trigger another
push workflow. Deployment checks out the latest `main`, including the feed
commit produced by ingestion.

The EU page warns when the last automatic check is more than three days old,
when the feed is unavailable, or when the latest check returned no items.
The check timestamp does not mean a new decision was found.

The collector resolves Google News links to direct EU publisher URLs using
`googlenewsdecoder`, retaining `google_news_url` to reuse successful resolutions
on later runs. Only HTTPS sources under `europa.eu` are accepted.
"Read in your language" translates the publisher page, not the Google News
redirect. If resolution fails, the collector logs a warning and the page
suggests opening the original link and using browser translation instead.

Run the status regression tests with `node --test tools/tests/eu_decisions.test.cjs`
(Node.js 22 or newer). Python CI also runs these tests.

## Monday AI risk review

`Weekly AI Risk Review` runs every Monday at 05:23 UTC (07:23 Norwegian summer
time / 06:23 winter time), or manually through Actions. It replaces the old
NGT-only co-occurrence monitor, which never actually called an AI model.

Set the repository secret `OPENAI_API_KEY` before running it. The agent uses
OpenAI `gpt-4.1-mini`, with up to four calls of 5,000 output tokens each per run;
OpenAI charges for input and output tokens. Only public publisher text and
already-public app rule lists are sent, not repository credentials or user data.
GitHub Models is not used: that service was retired on July 30, 2026.

The agent reviews Bovaer, GMO feed, insect protein and NGT, considering red,
yellow, green and unknown for every country in the app's published rules.
It searches a configured, bounded set of EU and producer/feed-supplier domains
over the last 120 days, retrieving at most six sources per topic. This is not
a complete scan of all products, countries or suppliers. The report distinguishes
recent search results from standing EU regulatory reference pages; an undated
reference is never presented as a new weekly event. Each topic reports how many
recent sources were actually retrieved. The report distinguishes
supported proposals from no supported proposal; missing evidence never means
green. A missing topic, API error or invalid/invented citation fails the run.
Partial source failures appear in the report and Actions logs.

Successful runs open/update a **draft PR** with
`scripts/weekly_risk_report.json` and upload the report as an Actions artifact.
No risk rules are changed automatically. A reviewer must verify the original
sources and edit `docs/supplier_rules_v2.json` / `docs/data/ngt_suppliers.json`
with approved changes before merging. Merging the report alone does not change
app warnings. Keep NGT brand warnings yellow/unknown and separate legal
authorisation from evidence about actual products.

`docs/supplier_rules_v2.json` initially mirrors existing app rules, not a new
verification of those claims. Regenerate that initial snapshot only deliberately
with `dart tools/export_supplier_rules.dart`; doing so overwrites manual remote
edits. The app loads this file at scanner startup, and approved NGT entries when
its cache is older than 24 hours. An empty remote category overrides local lists,
so a reviewed removal is not silently restored from bundled fallback data.
Adding remote support for previously ignored categories or empty-list overrides
requires releasing the updated app; existing releases still support the four
original remote categories.

Tests: `python -m pytest -q tools/tests/test_weekly_risk_review.py
tools/tests/test_fetch_eu_decisions.py` and
`flutter test test/remote_risk_rules_service_test.dart`.

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

## iOS TestFlight via GitHub Actions

The repository includes a manual workflow for iOS upload: `iOS TestFlight Upload`.

- Open **Actions** → **iOS TestFlight Upload** → **Run workflow**.
- Keep `build_number` empty to auto-use the GitHub run number (recommended).
- Set `build_number` only when you need to force a specific iOS build number.

Required repository secrets:

- `IOS_P12_BASE64`
- `IOS_P12_PASSWORD`
- `IOS_PROFILE_BASE64`
- `KEYCHAIN_PASSWORD`
- `APPSTORE_KEY_ID`
- `APPSTORE_ISSUER_ID`
- `APPSTORE_PRIVATE_KEY`
