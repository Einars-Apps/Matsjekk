const express = require('express');
const fetch = require('node-fetch');
const app = express();
app.use(express.json());

const PLAUSIBLE_API_KEY = process.env.PLAUSIBLE_API_KEY;
const PLAUSIBLE_DOMAIN = process.env.PLAUSIBLE_DOMAIN;
const PROXY_KEY = process.env.PROXY_KEY; // optional secret for client requests
// Rate limiting config (can use Redis if REDIS_URL present)
const RATE_LIMIT_WINDOW_MS = parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000', 10); // default 60s
const RATE_LIMIT_MAX = parseInt(process.env.RATE_LIMIT_MAX || '60', 10); // default 60 req/window
const REDIS_URL = process.env.REDIS_URL || '';
let redisClient = null;
if (REDIS_URL) {
  try {
    const IORedis = require('ioredis');
    redisClient = new IORedis(REDIS_URL);
    redisClient.on('error', (e) => console.error('Redis error', e));
    console.log('Using Redis for rate limiting');
  } catch (e) {
    console.error('Failed to initialize Redis client, falling back to in-memory limiter', e);
    redisClient = null;
  }
}
const rateLimitMap = new Map();

if (!PLAUSIBLE_API_KEY) {
  console.warn('Warning: PLAUSIBLE_API_KEY not set — proxy will return 500 for forwarding requests.');
}

app.post('/event', async (req, res) => {
  try {
    // Simple rate limiting by IP. Prefer Redis when configured for distributed limiting.
    const ip = req.get('x-forwarded-for')?.split(',')[0].trim() || req.ip || req.socket.remoteAddress || 'unknown';
    const now = Date.now();
    if (redisClient) {
      try {
        const key = `rate:${ip}`;
        const count = await redisClient.incr(key);
        if (count === 1) {
          await redisClient.pexpire(key, RATE_LIMIT_WINDOW_MS);
        }
        if (count > RATE_LIMIT_MAX) {
          const ttl = await redisClient.pttl(key);
          res.set('Retry-After', Math.ceil(ttl / 1000));
          return res.status(429).json({ error: 'Too Many Requests' });
        }
      } catch (e) {
        console.error('Redis rate limiter error, falling back to in-memory', e);
      }
    } else {
      const entry = rateLimitMap.get(ip) || { count: 0, windowStart: now };
      if (now - entry.windowStart > RATE_LIMIT_WINDOW_MS) {
        entry.count = 0;
        entry.windowStart = now;
      }
      entry.count += 1;
      rateLimitMap.set(ip, entry);
      if (entry.count > RATE_LIMIT_MAX) {
        res.set('Retry-After', Math.ceil((RATE_LIMIT_WINDOW_MS - (now - entry.windowStart)) / 1000));
        return res.status(429).json({ error: 'Too Many Requests' });
      }
    }

    // simple proxy auth: if PROXY_KEY is set, require header 'x-proxy-key' to match
    if (PROXY_KEY) {
      const provided = req.get('x-proxy-key') || '';
      if (provided !== PROXY_KEY) {
        return res.status(401).json({ error: 'Unauthorized' });
      }
    }

    const { name, props, domain } = req.body || {};
    const domainToSend = domain || PLAUSIBLE_DOMAIN;
    if (!domainToSend) return res.status(400).json({ error: 'Missing domain in body or PLAUSIBLE_DOMAIN env.' });
    if (!PLAUSIBLE_API_KEY) return res.status(500).json({ error: 'Server missing PLAUSIBLE_API_KEY' });

    const body = {
      name: name || 'event',
      domain: domainToSend,
      url: `app://${domainToSend}`,
      props: props || {}
    };

    const r = await fetch('https://plausible.io/api/event', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${PLAUSIBLE_API_KEY}`
      },
      body: JSON.stringify(body)
    });

    const text = await r.text();
    if (!r.ok) return res.status(r.status).send(text);
    res.status(200).send('ok');
  } catch (err) {
    console.error('Proxy error', err);
    res.status(500).json({ error: String(err) });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Analytics proxy listening on ${port}`));
