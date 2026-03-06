---
name: Immigrant shop listing report (moderated)
about: Report an immigrant shop entry that should be removed or corrected
title: '[Report] <Shop name>'
labels: submission
assignees: ''
---

Use this template to report an incorrect immigrant shop listing. This always goes through manual review before any change.

Required fields: `name`, `reason`.
Recommended fields: `address`, `website`.

```yaml
name: "Shop name"
country_code: "NO"
reason: "Why this listing is wrong"
address: "Optional address"
website: "Optional website"
```

Moderation rules:
- If there is doubt, verify against the official website.
- Place location by the submitted address (not only by name).
- Names may be identical in different districts: resolve duplicates using name + address and/or coordinates.
