Analytics Proxy (recommended, production-safe)

Overview

This repository includes a tiny example Node/Express proxy that forwards anonymized analytics events from the app to Plausible's server-side API. Using a server-side proxy prevents embedding server API keys in the mobile app and lets you apply rate-limiting, logging, and access control.

Files

- `analytics-proxy/server.js` — minimal Express app exposing `POST /event`.
- `analytics-proxy/package.json` — npm manifest for the proxy.

Environment variables

- `PLAUSIBLE_API_KEY` (required) — Plausible server-side API key used to authenticate to `https://plausible.io/api/event`.
- `PLAUSIBLE_DOMAIN` (optional) — default domain to send in events if the client doesn't provide one.
- `PORT` (optional) — port to listen on (default 3000).

Deploy

You can deploy this to any Node-compatible host (Vercel Serverless Functions, Cloud Run, Heroku, DigitalOcean App Platform, etc.).

Vercel (quick):
1. Create a new Vercel project from this folder, or copy `server.js` into a serverless function.
2. Set environment variables in the Vercel dashboard: `PLAUSIBLE_API_KEY` and `PLAUSIBLE_DOMAIN`.
3. Set the app's Hive key `analytics_proxy_url` to the HTTPS endpoint of your deployed function (e.g. `https://my-proxy.vercel.app/event`).

Google Cloud Run (quick):
1. Build a Docker image (or use a small Node image) and deploy, setting the `PLAUSIBLE_API_KEY` secret.
2. Note the HTTPS URL and set `analytics_proxy_url` in the app accordingly.

Local run (development)

```bash
cd analytics-proxy
npm install
PLAUSIBLE_API_KEY=your_plausible_server_key PLAUSIBLE_DOMAIN=example.com node server.js
# server will listen on http://localhost:3000
```

Client configuration

- Set Hive key `analytics_proxy_url` to the full proxy endpoint including `/event`, for example: `https://my-proxy.example.com/event`.
- Keep `analytics_opt_in` toggled by the user. Events will only be sent when the user opted-in.

Security notes

- Do NOT embed `PLAUSIBLE_API_KEY` in client apps; keep it server-side.
- Consider protecting the proxy with an additional secret or IP allowlist to prevent abuse.
- Add rate limiting and logging to detect misuse.

Proxy authentication

- You can secure the proxy by setting the `PROXY_KEY` environment variable on the server. When set, the proxy will only accept requests that include the header `x-proxy-key: <value>` matching `PROXY_KEY`.
- For local/debug clients you may set a Hive key `analytics_proxy_key` (via the `Personvern` dialog in debug builds) so the client will automatically include the `x-proxy-key` header when sending events. Storing the proxy key in the client is insecure — prefer server-side protections (short-lived tokens, IP allowlists, or requiring a backend-to-backend integration).

Example: to set `PROXY_KEY` in a Cloud Run or Vercel deployment, use the platform's environment variables/secret manager and rotate the value regularly.

Rate limiting

- The proxy includes a simple in-memory IP rate limiter. Configure with environment variables:
  - `RATE_LIMIT_MAX` — number of requests allowed per window (default: `60`).
  - `RATE_LIMIT_WINDOW_MS` — window size in milliseconds (default: `60000`).
- Important: the built-in limiter is in-memory and works only per-process. For multi-instance deployments use a distributed store (Redis) or a managed API gateway rate limiter.

Example (Cloud Run / Vercel env):

```bash
# allow 120 requests per minute per IP
RATE_LIMIT_MAX=120 RATE_LIMIT_WINDOW_MS=60000
```

Redis (distributed rate limiting)

- To enable distributed rate limiting across multiple instances, set `REDIS_URL` in your deployment environment to a Redis connection string (e.g. `redis://:password@redis.example:6379/0`). The proxy will use Redis for counting requests per IP when `REDIS_URL` is present.
- Example (Cloud Run): provision a Redis instance (Memorystore or managed Redis), store credentials in Secret Manager, and set `REDIS_URL` accordingly in Cloud Run env.

Note: the proxy falls back to in-memory limiter if Redis is not available.

Google Search Console verification note

- The project already contains the Search Console verification meta tag in `web/index.html`:

  ```html
  <meta name="google-site-verification" content="pli1FYdsuMTZNkcy28ngBFHpcSdQw_JMNMkDIRaSuZs">
  ```

- To verify: deploy the app (so `web/index.html` is served at the site's root), then in Google Search Console add a `URL prefix` property matching your site and click `Verify`.
- If you prefer DNS verification instead (recommended for domain‑wide coverage), add a TXT record with the same `google-site-verification=...` value to your domain's DNS and verify the `Domain` property in Search Console.

If you want, I can add a short README snippet for your specific DNS provider with exact steps.

Example request body (client -> proxy):

```json
{
  "name": "scan",
  "props": { "ean": "1234567890123" },
  "domain": "example.com"
}
```

The proxy forwards this to Plausible's `/api/event` with the server API key.

Docker / Cloud Run example

Dockerfile (included):

1. Build the image locally:

```bash
docker build -t matsjekk-analytics-proxy:latest analytics-proxy/
```

2. Run locally:

```bash
docker run -e PLAUSIBLE_API_KEY="$PLAUSIBLE_API_KEY" -e PLAUSIBLE_DOMAIN=example.com -p 3000:3000 matsjekk-analytics-proxy:latest
```

Google Cloud Run quick deploy (gcloud):

```bash
# Build and push to Google Container Registry (or use Artifact Registry)
gcloud builds submit --tag gcr.io/PROJECT_ID/matsjekk-analytics-proxy

# Deploy to Cloud Run (allow unauthenticated or configure auth)
gcloud run deploy matsjekk-analytics-proxy \
  --image gcr.io/PROJECT_ID/matsjekk-analytics-proxy \
  --platform managed --region europe-north1 \
  --set-env-vars PLAUSIBLE_API_KEY=projects/PROJECT_ID/secrets/PLAUSIBLE_API_KEY:latest,PLAUSIBLE_DOMAIN=example.com
```

After deploying, set the app's Hive key `analytics_proxy_url` to `https://<service>-<hash>-uc.a.run.app/event` (or the URL returned by your provider).

CI / GitHub Actions

This repository includes a workflow that builds the `analytics-proxy` Docker image and uploads it as a workflow artifact. It can also push the image to GitHub Container Registry (GHCR) when a `GHCR_PAT` secret is provided.

- Workflow file: `.github/workflows/build-proxy.yml`
- To enable pushing to GHCR:
  1. Create a Personal Access Token with `write:packages` permission (or use an appropriate repository-scoped token).
  2. Add it as repository secret `GHCR_PAT`.
  3. The workflow will push `ghcr.io/<owner>/matsjekk-analytics-proxy:latest` when `GHCR_PAT` is present.

You can trigger the workflow manually from the Actions tab or by pushing changes to the `analytics-proxy/` folder.

For details on creating the required `GHCR_PAT` secret, see the GitHub Actions secrets guide: `docs/ghcr_setup.md`.
