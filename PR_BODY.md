Add consent-gated Google Analytics (GA4) and analytics page

Summary
- Adds a consent-gated GA4 loader and a simple analytics/help page, and wires analytics loading to the existing cookie-consent flow.

Changes
- Added: `docs/js/analytics-loader.js` — loader for GA4 (Measurement ID: G-9WY28H5L81).
- Added: `docs/analytics.html` — documentation and instructions for Analytics/verification.
- Modified: `docs/consent.js` — calls analytics loader after the user gives consent.
- Modified: `docs/index.html` — includes analytics-loader and a visible link to the analytics page.

Testing
- Start the local server and open http://localhost:8000. Accept cookies and confirm `googletagmanager.com/gtag/js` loads in DevTools → Network.
- After Pages publishes, verify in Analytics → Realtime that pageviews appear.

Privacy
- Analytics is only loaded after user consent via the cookie banner.
- Update `docs/privacy.html` as needed to describe tracking and retention.

Notes
- The repository already contains a Google Search Console meta tag in `docs/index.html`; ensure the site is published before clicking Verify in Search Console.
