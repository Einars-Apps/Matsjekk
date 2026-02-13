const fetch = require('node-fetch');

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).send('Method not allowed');
  try {
    // Optional rate limiting (in-memory) and proxy auth: if PROXY_KEY is set in env, require header 'x-proxy-key'
    const RATE_LIMIT_WINDOW_MS = parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000', 10);
    const RATE_LIMIT_MAX = parseInt(process.env.RATE_LIMIT_MAX || '60', 10);
    const REDIS_URL = process.env.REDIS_URL || '';
    let redisClient = null;
    if (REDIS_URL) {
      try {
        if (!global.__redis) {
          const IORedis = require('ioredis');
          global.__redis = new IORedis(REDIS_URL);
          global.__redis.on('error', (e) => console.error('Redis error', e));
        }
        redisClient = global.__redis;
      } catch (e) {
        console.error('Failed to initialize Redis client in wrapper', e);
        redisClient = null;
      }
    }
    const ip = req.headers['x-forwarded-for']?.split(',')[0].trim() || req.socket.remoteAddress || 'unknown';
    const now = Date.now();
    if (redisClient) {
      try {
        const key = `rate:${ip}`;
        const count = await redisClient.incr(key);
        if (count === 1) await redisClient.pexpire(key, RATE_LIMIT_WINDOW_MS);
        if (count > RATE_LIMIT_MAX) {
          const ttl = await redisClient.pttl(key);
          res.setHeader('Retry-After', Math.ceil(ttl / 1000));
          return res.status(429).json({ error: 'Too Many Requests' });
        }
      } catch (e) {
        console.error('Redis rate limiter error in wrapper, falling back to in-memory', e);
      }
    } else {
      if (!global.__rateLimit) global.__rateLimit = new Map();
      const rlMap = global.__rateLimit;
      const entry = rlMap.get(ip) || { count: 0, windowStart: now };
      if (now - entry.windowStart > RATE_LIMIT_WINDOW_MS) {
        entry.count = 0;
        entry.windowStart = now;
      }
      entry.count += 1;
      rlMap.set(ip, entry);
      if (entry.count > RATE_LIMIT_MAX) {
        res.setHeader('Retry-After', Math.ceil((RATE_LIMIT_WINDOW_MS - (now - entry.windowStart)) / 1000));
        return res.status(429).json({ error: 'Too Many Requests' });
      }
    }

    // Optional proxy auth: if PROXY_KEY is set in env, require header 'x-proxy-key'
    const PROXY_KEY = process.env.PROXY_KEY;
    if (PROXY_KEY) {
      const provided = req.get('x-proxy-key') || '';
      if (provided !== PROXY_KEY) return res.status(401).json({ error: 'Unauthorized' });
    }

    const { name, props, domain } = req.body || {};
    const PLAUSIBLE_API_KEY = process.env.PLAUSIBLE_API_KEY;
    const PLAUSIBLE_DOMAIN = domain || process.env.PLAUSIBLE_DOMAIN;
    if (!PLAUSIBLE_API_KEY) return res.status(500).json({ error: 'Missing API key' });

    const body = {
      name: name || 'event',
      domain: PLAUSIBLE_DOMAIN,
      url: `app://${PLAUSIBLE_DOMAIN}`,
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
    console.error(err);
    res.status(500).json({ error: String(err) });
  }
};
