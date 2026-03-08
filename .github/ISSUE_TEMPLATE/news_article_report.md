---
name: News article report/removal request (moderated)
about: Request correction or removal of an article in the homepage feed
title: '[News Report] <Article title>'
labels: submission, news
assignees: ''
---

Use this template to request correction/removal of a news article. Requests always go through manual moderation.

Required fields: `title`, `url`, `reason`.
Recommended fields: `source`, `language`, `country`.

```yaml
title: "<Article title>"
source: "<Source name>"
url: "https://example.com/article"
language: "nb"
country: "NO"
reason: "Why this needs moderation review"
requested_action: "remove_or_correct"
submitted_from: "index-news-card"
```

Moderation policy:
- Never remove directly from production feed without review.
- Validate factual errors, broken links, duplicates, policy violations, and source credibility.
- Log final moderation decision in the issue thread for auditability.
