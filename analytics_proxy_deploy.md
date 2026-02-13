Analytics Proxy — Vercel example, secrets rotation, and automated deploy

1) Vercel Serverless Function Example

You can deploy `analytics-proxy/server.js` as a Vercel Serverless Function instead of running a dedicated Node service. This keeps deployment simple and free-tier friendly.

- Create a new Vercel project and point it to this repository (or copy `server.js` into an `api/event.js` function).
- Project layout suggestion:
  - `api/event.js` — the handler that imports the forwarding logic and responds to `POST /api/event`.

Minimal `api/event.js` wrapper (example):

```js
// api/event.js
const fetch = require('node-fetch');

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send('Method not allowed');
  try {
    const { name, props, domain } = req.body || {};
    const PLAUSIBLE_API_KEY = process.env.PLAUSIBLE_API_KEY;
    const PLAUSIBLE_DOMAIN = domain || process.env.PLAUSIBLE_DOMAIN;
    if (!PLAUSIBLE_API_KEY) return res.status(500).json({ error: 'Missing API key' });

    const body = {
      name: name || 'event',
      domain: PLAUSIBLE_DOMAIN,
      url: `app://${PLAUSIBLE_DOMAIN}`,
      props: props || {}
    };

    const r = await fetch('https://plausible.io/api/event', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${PLAUSIBLE_API_KEY}`
      },
      body: JSON.stringify(body)
    });

    const text = await r.text();
    if (!r.ok) return res.status(r.status).send(text);
    res.status(200).send('ok');
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: String(err) });
  }
};
```

Vercel env vars

- Set `PLAUSIBLE_API_KEY` and `PLAUSIBLE_DOMAIN` in the Vercel project settings (Environment Variables).
- Use `Production`/`Preview`/`Development` scopes appropriately.
- The function endpoint will be `https://<project>.vercel.app/api/event` — use this as `analytics_proxy_url` in the app.

2) Secrets rotation & best practices

- Never embed server API keys in the client app. Keep keys in environment variables or a secrets manager.
- Short-lived credentials: prefer short expiry tokens where supported; rotate regularly.
- Use platform features: GitHub Actions has `secrets`, Vercel has Environment Variables with limited visibility, GCP/Cloud Run can use Secret Manager.
- Rotation workflow (recommended):
  1. Generate new secret in provider (Plausible or secret store).
  2. Update the secret in deployment platform (Vercel/GCP) using their API or console.
  3. Deploy (or Vercel will pick up new envs on commit) and verify the proxy POSTs succeed.
  4. Revoke old secret.
- Auditing: enable audit logs where possible (cloud provider / Vercel Enterprise) to track usage.
- Rate limiting / abuse protection: add simple per-IP rate limits or an API key layer on the proxy to avoid abuse.

3) Sample automated deploy steps

A) GitHub Actions → Google Cloud Run (sketch)

- Requirements:
  - A GCP service account JSON key with `roles/run.admin` and `roles/storage.admin` (for Cloud Build) or use Workload Identity.
  - Add the JSON as `GCP_SA_KEY` secret in GitHub repo (or configure OIDC for better security).

Sample workflow snippet (deploy-cloud-run.yml):

```yaml
name: Deploy Analytics Proxy to Cloud Run
on:
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v1
        with:
          service_account_key: ${{ secrets.GCP_SA_KEY }}
          project_id: YOUR_GCP_PROJECT
      - name: Build & submit image
        run: |
          gcloud builds submit --tag gcr.io/YOUR_GCP_PROJECT/matsjekk-analytics-proxy
      - name: Deploy to Cloud Run
        run: |
          gcloud run deploy matsjekk-analytics-proxy \
            --image gcr.io/YOUR_GCP_PROJECT/matsjekk-analytics-proxy \
            --platform managed --region europe-north1 --allow-unauthenticated \
            --set-secrets PLAUSIBLE_API_KEY=projects/YOUR_GCP_PROJECT/secrets/PLAUSIBLE_API_KEY:latest
```

B) GitHub Actions → Vercel (sketch)

- Requirements:
  - Vercel project configured and `VERCEL_TOKEN` secret added to GitHub.

Sample workflow snippet (deploy-vercel.yml):

```yaml
name: Deploy analytics-proxy to Vercel
on:
  push:
    paths:
      - 'analytics-proxy/**'
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Vercel CLI
        run: npm install -g vercel
      - name: Deploy to Vercel
        env:
          VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}
        run: |
          cd analytics-proxy
          vercel --prod --confirm
```

Notes

- Use provider-managed deploy integrations when possible (Vercel Git integration, Cloud Run triggers) instead of storing long-lived credentials in GitHub secrets.
- Prefer OIDC or short-lived service account keys where available.

4) What I changed

- Added `docs/analytics_proxy_deploy.md` with examples and guidance.

---

If you want, I can now:
- Add the `api/event.js` wrapper into the repo as an example for Vercel.
- Create the sample `deploy-vercel.yml` and `deploy-cloud-run.yml` workflows in `.github/workflows/`.
Which of these should I add next? (Short choice: `add-wrapper`, `add-vercel-workflow`, `add-cloudrun-workflow`, `none`)
