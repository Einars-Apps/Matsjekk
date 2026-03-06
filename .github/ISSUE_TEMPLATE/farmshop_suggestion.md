---
name: Farmshop suggestion (moderated)
about: Suggest a missing farm shop/place for manual review before any data change
title: '[Suggestion] <Place name>'
labels: submission
assignees: ''
---

Use this template to suggest a missing place. This goes to moderation first; no data is changed automatically.

Required fields: `name`, `country`, `municipality`.
Recommended fields for faster approval: `address`, `website`.

```yaml
name: "Solheim Gard"
country: "Norway"
municipality: "Asker"
region: "Akershus"
notes: "Optional context or opening hours"
```

Optional: add map links, website links, or photos below the YAML block to help validation.

Moderation rules:
- If there is doubt, verify against the official website.
- Place location by the submitted address (not only by name).
- Names may be identical in different districts: resolve duplicates using name + address and/or coordinates.
