---
name: Immigrant shop suggestion (moderated)
about: Suggest a missing immigrant shop for manual review before any data change
title: '[Suggestion] <Shop name>'
labels: submission
assignees: ''
---

Use this template to suggest a missing immigrant shop. This goes to moderation first; no data is changed automatically.

Required fields: `name`, `country`, `municipality`.
Recommended fields for faster approval: `address`, `website`.

```yaml
name: "Shop name"
country: "Norway"
municipality: "Oslo"
region: "Oslo"
address: "Street 1, 0001 Oslo"
website: "https://example.com"
notes: "Optional context"
```

Moderation rules:
- If there is doubt, verify against the official website.
- Place location by the submitted address (not only by name).
- Names may be identical in different districts: resolve duplicates using name + address and/or coordinates.
