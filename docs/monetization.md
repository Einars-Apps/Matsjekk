Monetization recommendations for mat_sjekk

Goal: Generate sustainable revenue while preserving trust and privacy.

1) Priority (MVP): Freemium + optional donation
- Offer a small paid tier: remove ads, enable offline barcode lookup cache, favorites sync across devices.
- Add an in-app "Donate / Support" flow (Stripe/Apple/Google).
- Keep core scanning and risk info free to maintain trust.

2) Medium term: Ads (careful) + affiliate/local partnerships
- Non-intrusive banner ads in shopping list view (already present), and interstitials only sparingly.
- Consider local partners / grocery affiliate links for "Finn gårdsbutikk" clicks. Use explicit labeling and opt-in.
- Ensure GDPR compliance and provide simple consent settings.

3) Longer term / higher value: B2B data & premium features
- License anonymized, opt-in aggregated data to retailers/NGOs (consent + clear T&Cs). Avoid selling personal data.
- Add premium features: advanced alerts, multi-list sharing for households, store price-tracking, shopping suggestions.

Implementation steps (first 30 days)
- Add a `docs/monetization.md` (this file).
- Implement feature flag and a simple paywall for `Remove Ads` using Stripe/Play Billing/App Store.
- Add Analytics + Consent (privacy-first) and track conversion funnel.
- Run A/B test for pricing and messaging (e.g., one-time vs subscription).

Privacy & legal notes
- Do not share PII; require explicit opt-in for any data licensing.
- Follow Open Food Facts license rules when redistributing product data; attribute as required.

Metrics to track
- Conversion rate (free→paid), ARPU, churn, Donate click-through, ad eCPM, engagement (daily active scans).

Risks
- Ads may reduce trust — place carefully and provide ad-free paid option.
- Regulatory: app must support data subject requests if collecting personal data.

Next actions I can take now
- Prototype a paywall screen and Stripe integration (Android + iOS) and open a PR.
- Wire up consent modal + analytics and run a small experiment.
- Draft pricing experiments and mockups for the product page.

Which next action should I start?