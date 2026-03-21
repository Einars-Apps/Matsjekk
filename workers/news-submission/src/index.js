/**
 * Cloudflare Worker: matsjekk-news-submission
 *
 * Receives article submissions from matsjekk.com and creates GitHub Issues
 * so the auto-moderation pipeline can process them automatically.
 *
 * Env vars/secrets:
 *   GITHUB_TOKEN           — fine-grained PAT (Issues:write)
 *   GITHUB_REPO            — e.g. "Einars-Apps/Matsjekk"
 *   ALLOWED_ORIGINS        — comma-separated allowed origins
 *   MAX_SUBMISSIONS_PER_HOUR — rate limit per IP (default 5)
 */

// ── In-memory rate limiter (per-isolate, best-effort) ────────────────────

const rateBuckets = new Map();
const BUCKET_WINDOW_MS = 60 * 60 * 1000; // 1 hour

function checkRateLimit(ip, maxPerHour) {
  const now = Date.now();
  let bucket = rateBuckets.get(ip);
  if (!bucket || now - bucket.start > BUCKET_WINDOW_MS) {
    bucket = { start: now, count: 0 };
    rateBuckets.set(ip, bucket);
  }
  bucket.count++;
  // Prune old entries periodically
  if (rateBuckets.size > 5000) {
    for (const [k, v] of rateBuckets) {
      if (now - v.start > BUCKET_WINDOW_MS) rateBuckets.delete(k);
    }
  }
  return bucket.count <= maxPerHour;
}

// ── Helpers ──────────────────────────────────────────────────────────────

function corsHeaders(origin, allowedOrigins) {
  const allowed = allowedOrigins.split(',').map(s => s.trim());
  const isAllowed = allowed.includes(origin) ||
    origin === 'http://localhost:8000' || origin === 'http://127.0.0.1:8000';
  return {
    'Access-Control-Allow-Origin': isAllowed ? origin : allowed[0],
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Max-Age': '86400',
  };
}

function jsonResponse(body, status, origin, allowedOrigins) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
      ...corsHeaders(origin, allowedOrigins),
    },
  });
}

function sanitize(str, maxLen = 500) {
  if (typeof str !== 'string') return '';
  return str.trim().slice(0, maxLen);
}

function yamlQuote(s) {
  if (!s) return '""';
  if (/[:#\[\]{}&*!|>',@`"]/.test(s) || s.includes('\n')) {
    return '"' + s.replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
  }
  return s;
}

// ── Main handler ─────────────────────────────────────────────────────────

export default {
  async fetch(request, env) {
    const origin = request.headers.get('Origin') || '';
    const allowedOrigins = env.ALLOWED_ORIGINS || 'https://matsjekk.com';

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        status: 204,
        headers: corsHeaders(origin, allowedOrigins),
      });
    }

    if (request.method !== 'POST') {
      return jsonResponse({ error: 'Method not allowed' }, 405, origin, allowedOrigins);
    }

    // Rate limit
    const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
    const maxPerHour = parseInt(env.MAX_SUBMISSIONS_PER_HOUR || '5', 10);
    if (!checkRateLimit(ip, maxPerHour)) {
      return jsonResponse(
        { error: 'For mange innsendinger. Prøv igjen om en stund.' },
        429, origin, allowedOrigins
      );
    }

    // Parse body
    let data;
    try {
      data = await request.json();
    } catch {
      return jsonResponse({ error: 'Ugyldig JSON' }, 400, origin, allowedOrigins);
    }

    // Validate required fields
    const url = sanitize(data.url, 2000);
    if (!url || !/^https?:\/\/.+/.test(url)) {
      return jsonResponse({ error: 'Gyldig URL er påkrevd.' }, 400, origin, allowedOrigins);
    }

    // Honeypot check (hidden field — bots fill it, humans don't)
    if (data.website) {
      // Silent rejection for bots
      return jsonResponse({ ok: true, issue: 0 }, 200, origin, allowedOrigins);
    }

    // Human check
    if (!data.humanCheck) {
      return jsonResponse({ error: 'Bekreft at du ikke er en robot.' }, 400, origin, allowedOrigins);
    }

    // Sanitize optional fields
    const title = sanitize(data.title, 300) || 'Ukjent tittel';
    const source = sanitize(data.source, 200);
    const language = sanitize(data.language, 10) || 'nb';
    const country = sanitize(data.country, 100);
    const regionHint = sanitize(data.regionHint, 200);
    const neutralityRating = sanitize(data.neutralityRating, 50) || 'unknown';
    const neutralityFlags = sanitize(data.neutralityFlags, 500) || 'none';
    const neutralityNotes = sanitize(data.neutralityNotes, 500);

    // Build issue body (YAML block same format as client-side)
    const issueTitle = `[News Submission] ${title}`;
    const issueBody = [
      '```yaml',
      `title: ${yamlQuote(title)}`,
      `source: ${yamlQuote(source)}`,
      `url: ${yamlQuote(url)}`,
      `language: ${yamlQuote(language)}`,
      `country: ${yamlQuote(country)}`,
      `region_hint: ${yamlQuote(regionHint)}`,
      `neutrality_rating: ${yamlQuote(neutralityRating)}`,
      `neutrality_flags: ${yamlQuote(neutralityFlags)}`,
      `neutrality_notes: ${yamlQuote(neutralityNotes)}`,
      'submitted_from: "worker-proxy"',
      'requested_action: "add"',
      '```',
      '',
      'Submitted via matsjekk.com news form (automatic).',
    ].join('\n');

    // Create GitHub issue
    const repo = env.GITHUB_REPO || 'Einars-Apps/Matsjekk';
    const ghToken = env.GITHUB_TOKEN;
    if (!ghToken) {
      return jsonResponse({ error: 'Server configuration error' }, 500, origin, allowedOrigins);
    }

    try {
      const ghRes = await fetch(`https://api.github.com/repos/${repo}/issues`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${ghToken}`,
          Accept: 'application/vnd.github+json',
          'Content-Type': 'application/json',
          'User-Agent': 'matsjekk-news-worker/1.0',
          'X-GitHub-Api-Version': '2022-11-28',
        },
        body: JSON.stringify({
          title: issueTitle,
          body: issueBody,
          labels: ['submission', 'news'],
        }),
      });

      if (!ghRes.ok) {
        const errText = await ghRes.text();
        console.error('GitHub API error:', ghRes.status, errText);
        return jsonResponse(
          { error: 'Kunne ikke opprette moderasjonssak. Prøv igjen senere.' },
          502, origin, allowedOrigins
        );
      }

      const issue = await ghRes.json();
      return jsonResponse(
        { ok: true, issue: issue.number },
        201, origin, allowedOrigins
      );
    } catch (err) {
      console.error('GitHub API request failed:', err);
      return jsonResponse(
        { error: 'Nettverksfeil ved kontakt med GitHub.' },
        502, origin, allowedOrigins
      );
    }
  },
};
