---
name: Gårdsbutikk / Producer submission
about: Submit a farm shop or producer for inclusion in the "Gårdsbutikker" directory
title: '[Submission] <Farm / Producer name>'
labels: submission
assignees: ''
---

Thank you for submitting a farm shop or producer. Please fill the structured YAML block below (use the fenced block) with the details. Maintainers will review the submission; once approved a maintainer should add the label `create-data-pr` to create an automated PR with the submission file.

Required fields: `name`, `country`, `lat`, `lon`, `products`.

Example (copy & edit):

```yaml
name: "Solheim Gård"
country: "Norway"
region: "Vestland"
municipality: "Bergen"
address: "Solheimvegen 12, 5003 Bergen"
lat: 60.39126
lon: 5.32205
products:
  - "milk"
  - "eggs"
  - "cheese"
website: "https://solheimgard.example"
contact: "post@solheimgard.example"
notes: "Open weekends. Sells organic cheese."
```

Optional: include photos or additional verification links in the issue body (outside the YAML block).

Maintainers: after review, add the label `create-data-pr` to trigger the automated PR creation workflow.
