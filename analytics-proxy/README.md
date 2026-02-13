# analytics-proxy — Vercel deployment

Quick steps to deploy the analytics proxy to Vercel and configure secrets.

1. Install and login to Vercel CLI:

```bash
npm install -g vercel
vercel login
```

2. From the `analytics-proxy` folder deploy:

```bash
cd analytics-proxy
vercel --prod
```

3. Add required environment variables (Project Settings or CLI):

- `PLAUSIBLE_API_KEY` — server-side Plausible API key (keep secret)
- `PLAUSIBLE_DOMAIN` — your domain configured in Plausible
- `PROXY_KEY` — optional secret the client will include in `x-proxy-key`
- `REDIS_URL` — optional, for distributed rate limiting
- `RATE_LIMIT_MAX`, `RATE_LIMIT_WINDOW_MS` — optional rate-limit tuning

Example using the CLI:

```bash
vercel env add PLAUSIBLE_API_KEY production
vercel env add PLAUSIBLE_DOMAIN production
vercel env add PROXY_KEY production
```

4. Update the app to point to the deployed proxy:

- Set the Hive key `analytics_proxy_url` to your proxy base URL (e.g. `https://<project>.vercel.app`).
- Ensure `analytics_opt_in` is `true` before events are sent.

5. Verify: trigger the GitHub Actions smoke-test workflow or scan a product in a dev build and confirm events appear in Plausible (or the proxy logs).

Security note: never store `PLAUSIBLE_API_KEY` inside the mobile app. Use the proxy so the key remains server-side.
