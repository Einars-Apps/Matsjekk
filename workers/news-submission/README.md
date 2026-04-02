# Matsjekk News Submission Worker

Cloudflare Worker that bridges the matsjekk.com news form to GitHub Issues,
enabling fully automatic moderation without requiring users to have a GitHub account.

## Flow

```
User fills form → POST to Worker → Worker creates GitHub Issue →
  auto-label-submissions.yml adds labels → auto-moderate-news.yml runs →
  approve / review / reject
```

## Setup

### 1. Install Wrangler CLI

```bash
npm install -g wrangler
```

### 2. Login to Cloudflare

```bash
wrangler login
```

### 3. Create a GitHub fine-grained PAT

Go to https://github.com/settings/tokens?type=beta and create a token with:
- **Repository access**: `Einars-Apps/Matsjekk` only
- **Permissions**: Issues → Read and Write

### 4. Deploy the Worker

```bash
cd workers/news-submission
wrangler deploy
```

### 5. Set the GitHub token secret

```bash
wrangler secret put GITHUB_TOKEN
# Paste your fine-grained PAT when prompted
```

### 6. Verify

```bash
curl -X POST https://matsjekk-news-submission.matsjekk-apps.workers.dev \
  -H "Content-Type: application/json" \
  -d '{"url":"https://example.com/test","title":"Test","humanCheck":true}'
```

Should return `{"ok":true,"issue":123}`.

## Configuration

Environment variables in `wrangler.toml`:

| Variable | Default | Description |
|---|---|---|
| `ALLOWED_ORIGINS` | matsjekk.com | CORS allowed origins |
| `MAX_SUBMISSIONS_PER_HOUR` | 5 | Rate limit per IP |
| `GITHUB_REPO` | Einars-Apps/Matsjekk | Target repo for issues |

Secret (set via `wrangler secret put`):

| Secret | Description |
|---|---|
| `GITHUB_TOKEN` | Fine-grained PAT with Issues:write |

## Anti-Abuse

- **Rate limiting**: 5 submissions/hour/IP (in-memory, per-isolate)
- **Honeypot field**: Hidden `website` field — bots fill it, humans don't
- **Human checkbox**: Required `humanCheck` boolean
- **Input sanitization**: All fields truncated to safe max lengths
- **CORS**: Only allowed origins can POST
