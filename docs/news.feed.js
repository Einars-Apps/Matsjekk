// Client-side news feed rendering with geo-aware relevance and moderation-only submission flow.
const NEWS_KEY = 'matsjekk_news_v2';
const NEWS_PENDING_KEY = 'matsjekk_news_pending_submissions_v1';
const NEWS_PENDING_REMOVAL_KEY = 'matsjekk_news_pending_removals_v1';
const NEWS_REMOTE_URL = 'data/news.latest.json';
const NEWS_REMOTE_REGION_URLS = {
  cluster_scandinavia: 'data/news.region.cluster_scandinavia.json',
  cluster_germanic_nl: 'data/news.region.cluster_germanic_nl.json',
  cluster_fr_be_lu_ch: 'data/news.region.cluster_fr_be_lu_ch.json',
  cluster_it_ch_fr: 'data/news.region.cluster_it_ch_fr.json',
  cluster_english: 'data/news.region.cluster_english.json',
  global: 'data/news.region.global.json',
};
const NEWS_MAX_ITEMS = 30;

// Social media domains that should not appear in the food-news feed
const SOCIAL_MEDIA_DOMAINS = [
  'facebook.com', 'instagram.com', 'twitter.com', 'x.com', 'tiktok.com',
  'reddit.com', 'youtube.com', 'linkedin.com', 'pinterest.com', 't.me',
  'telegram.org', 'vk.com', 'snapchat.com',
];

const TRUSTED_NEWS_DOMAINS = [
  'nrk.no', 'svt.se', 'dr.dk', 'yle.fi', 'aftenposten.no', 'vg.no', 'dagbladet.no',
  'nationen.no', 'klassekampen.no', 'dagsavisen.no', 'adresseavisen.no', 'bt.no', 'fvn.no',
  'smp.no', 'itromso.no', 'ranablad.no', 'fremover.no', 'h-a.no',
  'svd.se', 'aftonbladet.se', 'expressen.se', 'gp.se', 'dn.se',
  'jyllands-posten.dk', 'berlingske.dk', 'politiken.dk',
  'hs.fi', 'is.fi',
  'steigan.no', 'document.no', 'inyheter.no', 'samnytt.se', 'friatider.se', '24nyt.dk',
  'reuters.com', 'apnews.com', 'bbc.com', 'theguardian.com', 'dw.com',
  'lemonde.fr', 'lefigaro.fr', 'france24.com', 'corriere.it', 'ansa.it',
  'elpais.com', 'abc.es', 'publico.pt', 'jn.pt', 'nzz.ch',
  'nachdenkseiten.de', 'epochtimes.de', 'dagelijksestandaard.nl',
  'off-guardian.org', 'spiked-online.com'
];

const TOPIC_KEYWORDS = [
  'bovaer', 'insektsmel', 'insektmel', 'insect meal', 'insect protein',
  'gmo-fiskefor', 'gmo fiskefor', 'gmo fish feed', 'genmodifisert fiskefor',
  'genetically modified fish feed', 'raps fra gmo', 'soy feed gmo', 'oppdrettsfor gmo'
];

// Rolling per-region article cache (90 days) so articles don't disappear quickly when they leave the RSS window
const NEWS_FEED_CACHE_KEY = 'matsjekk_news_feed_v2'; // bump version to bust old social-media cache
const NEWS_FEED_CACHE_MAX_AGE_DAYS = 90;
const ENABLE_PINNED_SOURCES = false;

// Permanent pinned sources per region — always shown at bottom, not removable before expiry
const PINNED_SOURCES = {
  cluster_scandinavia: [
    { title: 'Document.no – Søk: Bovaer / GMO / tilsetningsstoffer', source: 'Document.no', url: 'https://document.no/?s=bovaer', language: 'nb', country: 'NO', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Steigan.no – Søk: Bovaer / matproduksjon', source: 'Steigan.no', url: 'https://steigan.no/?s=bovaer', language: 'nb', country: 'NO', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'iNyheter.no – Søk: Bovaer / GMO', source: 'iNyheter.no', url: 'https://inyheter.no/?s=bovaer', language: 'nb', country: 'NO', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Samnytt.se – Sök: Bovaer / GMO', source: 'Samnytt.se', url: 'https://samnytt.se/?s=bovaer', language: 'sv', country: 'SE', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Fria Tider – Sök: Bovaer / GMO', source: 'Fria Tider', url: 'https://www.friatider.se/?s=bovaer', language: 'sv', country: 'SE', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: '24NYT.dk – Søg: Bovaer / GMO', source: '24NYT.dk', url: 'https://24nyt.dk/?s=bovaer', language: 'da', country: 'DK', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
  ],
  cluster_germanic_nl: [
    { title: 'NachDenkSeiten.de – Suche: Bovaer / GVO', source: 'NachDenkSeiten', url: 'https://www.nachdenkseiten.de/?s=bovaer', language: 'de', country: 'DE', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Epoch Times DE – Suche: Bovaer', source: 'Epoch Times DE', url: 'https://www.epochtimes.de/suche?q=bovaer', language: 'de', country: 'DE', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'De Dagelijkse Standaard – Zoek: Bovaer / GMO', source: 'De Dagelijkse Standaard', url: 'https://www.dagelijksestandaard.nl/?s=bovaer', language: 'nl', country: 'NL', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
  ],
  cluster_fr_be_lu_ch: [
    { title: 'Boulevard Voltaire – Recherche: Bovaer / OGM', source: 'Boulevard Voltaire', url: 'https://www.bvoltaire.fr/?s=bovaer', language: 'fr', country: 'FR', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Riposte Laïque – Recherche: Bovaer / OGM', source: 'Riposte Laïque', url: 'https://ripostelaique.com/?s=bovaer', language: 'fr', country: 'FR', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
  ],
  cluster_it_ch_fr: [
    { title: 'Il Paragone – Cerca: Bovaer / OGM', source: 'Il Paragone', url: 'https://www.ilparagone.it/?s=bovaer', language: 'it', country: 'IT', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'ByoBlu – Cerca: Bovaer / OGM', source: 'ByoBlu', url: 'https://www.byoblu.com/?s=bovaer', language: 'it', country: 'IT', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
  ],
  cluster_english: [
    { title: 'Off-Guardian – Search: Bovaer / food additives', source: 'Off-Guardian', url: 'https://off-guardian.org/?s=bovaer', language: 'en', country: 'GB', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
    { title: 'Spiked Online – Search: Bovaer / GMO', source: 'Spiked Online', url: 'https://www.spiked-online.com/search/?q=bovaer', language: 'en', country: 'GB', pubDate: '2026-01-01T00:00:00Z', isPinned: true },
  ],
  global: [],
};

const GEO_CACHE_KEY = 'matsjekk_geo_country';
const GEO_CACHE_MAX_AGE_MS = 24 * 60 * 60 * 1000;

const GITHUB_ISSUE_BASE_URL = 'https://github.com/Einars-Apps/Matsjekk/issues/new';
const NEWS_SUBMISSION_TEMPLATE = 'news_article_submission.md';
const NEWS_REPORT_TEMPLATE = 'news_article_report.md';

const SCANDINAVIA_COUNTRIES = ['NO', 'SE', 'DK', 'FI', 'IS'];
const GERMANIC_NL_COUNTRIES = ['DE', 'AT', 'CH', 'NL', 'LI'];
const FR_BE_LU_CH_COUNTRIES = ['FR', 'BE', 'LU', 'CH', 'NL'];
const IT_CH_FR_COUNTRIES = ['IT', 'CH', 'FR'];
const ENGLISH_SPEAKING_COUNTRIES = ['GB', 'IE', 'US', 'CA', 'AU', 'NZ'];

const REGION_MODES = [
  { value: 'auto', labelNb: 'Auto (naturlig region)', labelEn: 'Auto (natural region)' },
  { value: 'cluster_scandinavia', labelNb: '1. Skandinavia', labelEn: '1. Scandinavia' },
  { value: 'cluster_germanic_nl', labelNb: '2. Tyskspraklige + Nederland', labelEn: '2. German-speaking + Netherlands' },
  { value: 'cluster_fr_be_lu_ch', labelNb: '3. Frankrike + Belgia + Luxembourg + Sveits + Nederland', labelEn: '3. France + Belgium + Luxembourg + Switzerland + Netherlands' },
  { value: 'cluster_it_ch_fr', labelNb: '4. Italia + Sveits + Frankrike', labelEn: '4. Italy + Switzerland + France' },
  { value: 'cluster_english', labelNb: '5. Engelskspraklige', labelEn: '5. English-speaking' },
  { value: 'global', labelNb: 'Globalt', labelEn: 'Global' },
];

const LANGUAGE_LABELS = {
  nb: 'Norsk',
  en: 'English',
  sv: 'Svenska',
  da: 'Dansk',
  fi: 'Suomi',
  de: 'Deutsch',
  nl: 'Nederlands',
  fr: 'Francais',
  it: 'Italiano',
  pt: 'Portugues',
  es: 'Espanol',
};

const SCANDINAVIAN_FALLBACK_ARTICLES = [
  {
    title: 'NRK: Artikler om Bovaer',
    source: 'NRK',
    url: 'https://www.nrk.no/sok/?q=bovaer',
    language: 'nb',
    country: 'NO',
    pubDate: '2026-03-09T09:00:00Z',
    shortSummary: 'Sokeside for norske artikler om Bovaer i norsk kontekst.',
  },
  {
    title: 'SVT: Sok etter Bovaer',
    source: 'SVT',
    url: 'https://www.svt.se/sok?q=bovaer',
    language: 'sv',
    country: 'SE',
    pubDate: '2026-03-09T08:00:00Z',
    shortSummary: 'Sokeside for svenske artikler med lokal dekning.',
  },
  {
    title: 'DR: Sok efter Bovaer',
    source: 'DR',
    url: 'https://www.dr.dk/soeg?query=bovaer',
    language: 'da',
    country: 'DK',
    pubDate: '2026-03-09T07:00:00Z',
    shortSummary: 'Sogeside med danske nyheder og baggrund om emnet.',
  },
];

function safeStorageGet(key) {
  try {
    return localStorage.getItem(key);
  } catch (_) {
    return '';
  }
}

function safeStorageSet(key, value) {
  try {
    localStorage.setItem(key, value);
    return true;
  } catch (_) {
    return false;
  }
}

function safeJsonParse(raw, fallback) {
  try {
    return raw ? JSON.parse(raw) : fallback;
  } catch (_) {
    return fallback;
  }
}

function getNews() {
  return safeJsonParse(safeStorageGet(NEWS_KEY), []);
}

function saveNews(list) {
  safeStorageSet(NEWS_KEY, JSON.stringify(list));
}

function getPendingSubmissions() {
  return safeJsonParse(safeStorageGet(NEWS_PENDING_KEY), []);
}

function savePendingSubmissions(list) {
  safeStorageSet(NEWS_PENDING_KEY, JSON.stringify(list));
}

function getPendingRemovals() {
  return safeJsonParse(safeStorageGet(NEWS_PENDING_REMOVAL_KEY), []);
}

function savePendingRemovals(list) {
  safeStorageSet(NEWS_PENDING_REMOVAL_KEY, JSON.stringify(list));
}

function stripHtml(value) {
  return String(value || '').replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim();
}

function escapeHtml(value) {
  return String(value || '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function normalizeLang(value) {
  return String(value || '').trim().toLowerCase().split('-')[0];
}

function normalizeCountry(value) {
  return String(value || '').trim().toUpperCase();
}

function dedupeByUrl(items) {
  const seen = new Set();
  const out = [];
  for (const item of items || []) {
    const key = String((item && item.url) || '').trim().toLowerCase();
    if (!key || seen.has(key)) continue;
    seen.add(key);
    out.push(item);
  }
  return out;
}

function isSocialMediaUrl(url) {
  if (!url) return false;
  try {
    const host = new URL(String(url)).hostname.toLowerCase();
    return SOCIAL_MEDIA_DOMAINS.some((domain) => host === domain || host.endsWith('.' + domain));
  } catch (_) {
    return false;
  }
}

function isSocialMediaArticle(item) {
  if (!item) return false;
  if (isSocialMediaUrl(item.url)) return true;
  const src = String(item.source || item.sourceName || '').toLowerCase().trim();
  return SOCIAL_MEDIA_DOMAINS.some((domain) => src === domain || src.endsWith('.' + domain));
}

function hostFromUrl(url) {
  try {
    return new URL(String(url || '')).hostname.toLowerCase();
  } catch (_) {
    return '';
  }
}

function isGoogleNewsWrapperHost(host) {
  return host === 'news.google.com' || host.endsWith('.news.google.com');
}

function normalizeSourceHost(sourceText) {
  let src = String(sourceText || '').toLowerCase().trim();
  src = src.replace(/^https?:\/\//, '').replace(/^www\./, '').split(/[\s/]/)[0];
  return src;
}

function isTrustedDomainText(sourceText) {
  const host = normalizeSourceHost(sourceText);
  if (!host || !host.includes('.')) return false;
  return TRUSTED_NEWS_DOMAINS.some((domain) => host === domain || host.endsWith('.' + domain));
}

function isLikelyPublisherSourceText(sourceText) {
  const src = String(sourceText || '').toLowerCase().trim();
  if (!src) return false;
  if (src.length < 3) return false;
  if (SOCIAL_MEDIA_DOMAINS.some((domain) => src === domain || src.endsWith('.' + domain))) {
    return false;
  }
  // If source looks like a hostname/domain, require explicit trusted-domain match.
  if (/^[a-z0-9.-]+\.[a-z]{2,}$/i.test(normalizeSourceHost(src))) {
    return isTrustedDomainText(src);
  }
  // Accept outlet-like source labels from feeds (for example: "Nationen", "Yle", "ATL").
  return true;
}

function isTrustedNewsDomain(item) {
  const host = hostFromUrl(item && item.url);
  const sourceText = String((item && (item.source || item.sourceName)) || '').toLowerCase();
  if (isGoogleNewsWrapperHost(host) && isLikelyPublisherSourceText(sourceText)) {
    return true;
  }
  return TRUSTED_NEWS_DOMAINS.some((domain) =>
    host === domain || host.endsWith('.' + domain) || sourceText.includes(domain.replace(/^www\./, ''))
  );
}

function hasRequiredTopic(article) {
  const haystack = [
    article && article.title,
    article && article.shortSummary,
    article && article.summary,
    article && article.englishSummary,
  ].join(' ').toLowerCase();
  return TOPIC_KEYWORDS.some((keyword) => haystack.includes(keyword));
}

function isRelevantArticle(article) {
  if (!article) return false;
  if (isSocialMediaArticle(article)) return false;
  if (!isTrustedNewsDomain(article)) return false;
  if (!hasRequiredTopic(article)) return false;
  return true;
}

function loadFeedCache(mode) {
  const all = safeJsonParse(safeStorageGet(NEWS_FEED_CACHE_KEY), {});
  return Array.isArray(all[mode]) ? all[mode] : [];
}

function saveFeedCache(mode, items) {
  const all = safeJsonParse(safeStorageGet(NEWS_FEED_CACHE_KEY), {});
  const maxAgeMs = NEWS_FEED_CACHE_MAX_AGE_DAYS * 24 * 60 * 60 * 1000;
  const now = Date.now();
  all[mode] = items
    .filter((item) => {
      const d = new Date(item.pubDate || item.date || 0).getTime();
      return d > 0 && now - d < maxAgeMs;
    })
    .slice(0, 60);
  try { safeStorageSet(NEWS_FEED_CACHE_KEY, JSON.stringify(all)); } catch (_) {}
}

function getPinnedSourcesForMode(resolvedMode) {
  return (PINNED_SOURCES[resolvedMode] || PINNED_SOURCES.cluster_scandinavia).slice();
}

async function fetchRemoteNewsForMode(mode) {
  const key = String(mode || 'global').toLowerCase();
  const url = NEWS_REMOTE_REGION_URLS[key] || NEWS_REMOTE_URL;
  try {
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) return [];
    const payload = await response.json();
    return payload && Array.isArray(payload.items) ? payload.items : [];
  } catch (_) {
    return [];
  }
}

function readGeoCacheCountry() {
  const raw = safeJsonParse(safeStorageGet(GEO_CACHE_KEY), null);
  if (!raw || !raw.country || !raw.ts) return '';
  if (Date.now() - Number(raw.ts) > GEO_CACHE_MAX_AGE_MS) return '';
  return normalizeCountry(raw.country);
}

function writeGeoCacheCountry(countryCode) {
  if (!countryCode) return;
  safeStorageSet(
    GEO_CACHE_KEY,
    JSON.stringify({ country: normalizeCountry(countryCode), ts: Date.now() })
  );
}

function reverseCountryCode(lat, lon) {
  const url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}&zoom=3`;
  return fetch(url, { headers: { Accept: 'application/json' } })
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then((payload) => {
      const address = payload && payload.address ? payload.address : null;
      return normalizeCountry((address && address.country_code) || '');
    })
    .catch(() => '');
}

function detectCountryCodeFromGeo() {
  const cached = readGeoCacheCountry();
  if (cached) return Promise.resolve(cached);
  if (!navigator.geolocation) return Promise.resolve('');

  return new Promise((resolve) => {
    navigator.geolocation.getCurrentPosition(
      async (position) => {
        const code = await reverseCountryCode(position.coords.latitude, position.coords.longitude);
        if (code) writeGeoCacheCountry(code);
        resolve(code);
      },
      () => resolve(''),
      { enableHighAccuracy: false, timeout: 3500, maximumAge: 10 * 60 * 1000 }
    );
  });
}

function inferUserLanguage(preferredLang) {
  const direct = normalizeLang(preferredLang);
  // 'auto' is a placeholder, not a real language code
  if (direct && direct !== 'auto') return direct;
  const fromStorage = normalizeLang(safeStorageGet('matsjekk_lang'));
  if (fromStorage && fromStorage !== 'auto') return fromStorage;
  return normalizeLang(navigator.language || 'nb') || 'nb';
}

function clusterForCountry(countryCode) {
  const cc = normalizeCountry(countryCode);
  if (!cc) return 'cluster_scandinavia';
  if (SCANDINAVIA_COUNTRIES.includes(cc)) return 'cluster_scandinavia';
  if (GERMANIC_NL_COUNTRIES.includes(cc)) return 'cluster_germanic_nl';
  if (FR_BE_LU_CH_COUNTRIES.includes(cc)) return 'cluster_fr_be_lu_ch';
  if (IT_CH_FR_COUNTRIES.includes(cc)) return 'cluster_it_ch_fr';
  if (ENGLISH_SPEAKING_COUNTRIES.includes(cc)) return 'cluster_english';
  return 'cluster_scandinavia';
}

function regionCountriesForMode(mode, userCountry) {
  const normalizedMode = String(mode || 'auto').toLowerCase();
  const resolvedMode = normalizedMode === 'auto' ? clusterForCountry(userCountry) : normalizedMode;

  if (resolvedMode === 'global') return null;
  if (resolvedMode === 'cluster_scandinavia') return new Set(SCANDINAVIA_COUNTRIES);
  if (resolvedMode === 'cluster_germanic_nl') return new Set(GERMANIC_NL_COUNTRIES);
  if (resolvedMode === 'cluster_fr_be_lu_ch') return new Set(FR_BE_LU_CH_COUNTRIES);
  if (resolvedMode === 'cluster_it_ch_fr') return new Set(IT_CH_FR_COUNTRIES);
  if (resolvedMode === 'cluster_english') return new Set(ENGLISH_SPEAKING_COUNTRIES);
  return new Set(SCANDINAVIA_COUNTRIES);
}

function localizeRegionOptionLabel(option, lang) {
  return normalizeLang(lang) === 'en' ? option.labelEn : option.labelNb;
}

function populateRegionSelect(preferredLang) {
  const select = document.getElementById('news-region');
  if (!select) return;

  const stored = String(safeStorageGet('matsjekk_news_region') || 'auto').toLowerCase();
  const current = stored;
  select.innerHTML = '';

  REGION_MODES.forEach((mode) => {
    const option = document.createElement('option');
    option.value = mode.value;
    option.textContent = localizeRegionOptionLabel(mode, preferredLang);
    select.appendChild(option);
  });

  select.value = REGION_MODES.some((entry) => entry.value === current) ? current : 'auto';
}

function yamlQuoted(value) {
  return `"${String(value == null ? '' : value).replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
}

function buildIssueUrl(template, title, body) {
  const params = new URLSearchParams({
    template,
    title,
    labels: 'submission,news',
    body,
  });
  return `${GITHUB_ISSUE_BASE_URL}?${params.toString()}`;
}

function openModerationIssue(url, pendingWindow) {
  if (pendingWindow && !pendingWindow.closed) {
    try {
      pendingWindow.location.href = url;
      return true;
    } catch (_) {
      // Fall through to regular open when direct navigation fails.
    }
  }
  const popup = window.open(url, '_blank', 'noopener');
  return !!popup;
}

function inferCountryFromHost(host) {
  const h = String(host || '').toLowerCase();
  if (!h) return '';
  if (h.endsWith('.no')) return 'NO';
  if (h.endsWith('.se')) return 'SE';
  if (h.endsWith('.dk')) return 'DK';
  if (h.endsWith('.fi')) return 'FI';
  if (h.endsWith('.is')) return 'IS';
  if (h.endsWith('.de') || h.endsWith('.at')) return 'DE';
  if (h.endsWith('.nl')) return 'NL';
  if (h.endsWith('.fr')) return 'FR';
  if (h.endsWith('.it')) return 'IT';
  if (h.endsWith('.ch')) return 'CH';
  if (h.endsWith('.be')) return 'BE';
  if (h.endsWith('.lu')) return 'LU';
  if (h.endsWith('.es')) return 'ES';
  if (h.endsWith('.pt')) return 'PT';
  if (h.endsWith('.uk') || h.endsWith('.co.uk') || h.endsWith('.ie')) return 'GB';
  return '';
}

function inferLanguageFromCountry(country) {
  const c = normalizeCountry(country);
  if (c === 'NO') return 'nb';
  if (c === 'SE') return 'sv';
  if (c === 'DK') return 'da';
  if (c === 'FI') return 'fi';
  if (c === 'DE' || c === 'AT' || c === 'CH') return 'de';
  if (c === 'NL') return 'nl';
  if (c === 'FR' || c === 'BE' || c === 'LU') return 'fr';
  if (c === 'IT') return 'it';
  if (c === 'ES') return 'es';
  if (c === 'PT') return 'pt';
  if (c === 'GB' || c === 'IE') return 'en';
  return '';
}

function inferSubmissionMetadata(url, titleInput, sourceInput, langInput) {
  const host = hostFromUrl(url);
  const country = inferCountryFromHost(host);
  const inferredLang = inferLanguageFromCountry(country);
  const language = normalizeLang(langInput || inferredLang || 'nb') || 'nb';
  const title = String(titleInput || '').trim() || titleFromUrl(url);
  const source = String(sourceInput || '').trim() || sourceFromUrl(url);
  const resolvedMode = clusterForCountry(country);
  return {
    title,
    source,
    language,
    country,
    regionHint: resolvedMode,
  };
}

function sourceFromUrl(url) {
  const host = hostFromUrl(url).replace(/^www\./, '');
  return host || 'Ukjent kilde';
}

function titleFromUrl(url) {
  try {
    const u = new URL(String(url || ''));
    const parts = u.pathname.split('/').filter(Boolean);
    const slug = decodeURIComponent(parts[parts.length - 1] || '').replace(/[-_]+/g, ' ').trim();
    if (slug && slug.length >= 4) {
      return slug.charAt(0).toUpperCase() + slug.slice(1);
    }
  } catch (_) {
    // Ignore URL parse errors and use fallback.
  }
  return 'Ny artikkel foreslaatt';
}

function createNewsSubmissionIssueUrl(payload) {
  const issueTitle = `[News Submission] ${payload.title}`;
  const yamlBody = [
    '```yaml',
    `title: ${yamlQuoted(payload.title)}`,
    `source: ${yamlQuoted(payload.source || '')}`,
    `url: ${yamlQuoted(payload.url)}`,
    `language: ${yamlQuoted(payload.language || 'nb')}`,
    `country: ${yamlQuoted(payload.country || '')}`,
    `region_hint: ${yamlQuoted(payload.regionHint || '')}`,
    `neutrality_rating: ${yamlQuoted((payload.neutrality && payload.neutrality.rating) || 'unknown')}`,
    `neutrality_flags: ${yamlQuoted((((payload.neutrality && payload.neutrality.flags) || []).join(', ')) || 'none')}`,
    `neutrality_notes: ${yamlQuoted((payload.neutrality && payload.neutrality.notes) || '')}`,
    'submitted_from: "index-news-form"',
    'requested_action: "add"',
    '```',
    '',
    'Moderation requirements:',
    '- Verify source quality and relevance.',
    '- Approve before publishing to the feed.',
  ].join('\n');

  return buildIssueUrl(NEWS_SUBMISSION_TEMPLATE, issueTitle, yamlBody);
}

function createNewsReportIssueUrl(article, reason) {
  const moderationTag = classifyReportReason(reason);
  const issueTitle = `[News Report] ${article.title || article.url || 'Untitled article'}`;
  const yamlBody = [
    '```yaml',
    `title: ${yamlQuoted(article.title || '')}`,
    `source: ${yamlQuoted(article.source || article.sourceName || '')}`,
    `url: ${yamlQuoted(article.url || '')}`,
    `language: ${yamlQuoted(article.language || '')}`,
    `country: ${yamlQuoted(article.country || '')}`,
    `reason: ${yamlQuoted(reason || 'Needs moderation review')}`,
    `moderation_priority: ${yamlQuoted(moderationTag)}`,
    'moderation_status: "pending_review"',
    'requested_action: "remove_or_correct"',
    'submitted_from: "index-news-card"',
    '```',
    '',
    'Do not remove directly from production feed before moderator review.',
  ].join('\n');

  return buildIssueUrl(NEWS_REPORT_TEMPLATE, issueTitle, yamlBody);
}

function countryScopeContains(scope, country) {
  if (scope === null) return true;
  if (scope && scope.size === 0) return true; // Europe mode: include all available country-tagged items
  const normalized = normalizeCountry(country);
  if (!normalized) return false;
  return scope.has(normalized);
}

function newsListForDisplay(items, scope) {
  const sorted = [...items].sort((a, b) => new Date(b.pubDate || b.date || 0) - new Date(a.pubDate || a.date || 0));
  const filtered = sorted.filter((item) => countryScopeContains(scope, item.country));
  // Keep all still-valid cached articles visible (newest first, oldest at the bottom).
  if (filtered.length > 0) return filtered.slice(0, Math.max(NEWS_MAX_ITEMS, filtered.length));
  return sorted.slice(0, Math.max(NEWS_MAX_ITEMS, sorted.length));
}

function fallbackNewsForScope(scope) {
  if (scope === null) return SCANDINAVIAN_FALLBACK_ARTICLES;
  return SCANDINAVIAN_FALLBACK_ARTICLES.filter((item) => countryScopeContains(scope, item.country));
}

function classifyReportReason(reason) {
  const text = String(reason || '').toLowerCase();
  const obvious = ['404', 'dead link', 'spam', 'duplicate', 'malware', 'phishing', 'not an article'];
  return obvious.some((token) => text.includes(token))
    ? 'expedite_if_obvious_error'
    : 'normal_moderation_queue';
}

function neutralityAssessment(payload) {
  const text = `${payload.title || ''} ${payload.source || ''}`.toLowerCase();
  const polarizing = [
    'always true', 'always false', 'traitor', 'enemy', 'propaganda only',
    'must boycott', 'must support', 'evil', 'heroic truth'
  ];
  const flags = polarizing.filter((word) => text.includes(word));
  if (flags.length === 0) {
    return {
      rating: 'neutral_or_unclear',
      flags: [],
      notes: 'No strongly polarizing markers detected in submitted title/source text.',
    };
  }
  return {
    rating: 'needs_moderator_attention',
    flags,
    notes: 'Potentially biased wording detected. Keep pending and review against source context.',
  };
}

function languageNameForCard(langCode) {
  const code = normalizeLang(langCode);
  if (!code) return 'nb';
  return code;
}

function languageLabel(code) {
  const normalized = normalizeLang(code);
  return LANGUAGE_LABELS[normalized] || normalized || 'nb';
}

const TRANSLATE_LABEL_TEMPLATES = {
  nb: (t) => `Oversett artikkel til ${t}`,
  en: (t) => `Translate article to ${t}`,
  sv: (t) => `Översätt artikel till ${t}`,
  da: (t) => `Oversæt artikel til ${t}`,
  fi: (t) => `Käännä artikkeli – ${t}`,
  de: (t) => `Artikel übersetzen nach ${t}`,
  nl: (t) => `Vertaal artikel naar ${t}`,
  fr: (t) => `Traduire l'article en ${t}`,
  it: (t) => `Traduci articolo in ${t}`,
  pt: (t) => `Traduzir artigo para ${t}`,
  es: (t) => `Traducir artículo al ${t}`,
};

function translateLinkLabel(uiLang, targetLang) {
  const ui = normalizeLang(uiLang);
  const target = languageLabel(targetLang);
  const template = TRANSLATE_LABEL_TEMPLATES[ui] || TRANSLATE_LABEL_TEMPLATES.nb;
  return template(target);
}

function formatPubDate(pubDate, lang) {
  const d = new Date(pubDate || 0);
  if (isNaN(d.getTime()) || d.getTime() === 0) return '';
  const locale = {
    nb: 'nb-NO', sv: 'sv-SE', da: 'da-DK', fi: 'fi-FI',
    de: 'de-DE', nl: 'nl-NL', fr: 'fr-FR', it: 'it-IT',
    pt: 'pt-PT', es: 'es-ES', en: 'en-GB',
  }[normalizeLang(lang) || 'nb'] || 'nb-NO';
  try {
    return d.toLocaleDateString(locale, { year: 'numeric', month: 'short', day: 'numeric' });
  } catch (_) {
    return d.toLocaleDateString();
  }
}

function createNewsCard(article, preferredLang) {
  const card = document.createElement('article');
  card.className = article.isPinned ? 'news-card news-card--pinned' : 'news-card';

  const title = escapeHtml(article.title || 'Untitled');
  const source = escapeHtml(article.source || article.sourceName || 'Ukjent kilde');
  const uiLang = normalizeLang(preferredLang) || 'nb';
  const dateStr = formatPubDate(article.pubDate || article.date, uiLang);
  const sourceLang = normalizeLang(article.language || 'auto') || 'auto';
  const targetLang = inferUserLanguage(preferredLang);
  const translateUrl = `https://translate.google.com/translate?sl=${encodeURIComponent(sourceLang)}&tl=${encodeURIComponent(targetLang)}&u=${encodeURIComponent(article.url || '')}`;

  const summary = stripHtml(article.shortSummary || article.summary || article.englishSummary || '');
  const summaryHtml = summary ? `<p class="summary">${escapeHtml(summary)}</p>` : '';
  const dateMeta = dateStr ? ` • ${escapeHtml(dateStr)}` : '';
  const pinnedBadge = article.isPinned ? `<span class="pinned-badge">📌</span> ` : '';

  const OPEN_ORIGINAL_LABELS = {
    nb: 'Les original', sv: 'Läs original', da: 'Læs original', fi: 'Lue alkuperäinen',
    de: 'Original lesen', nl: 'Lees origineel', fr: 'Lire l\'original',
    it: 'Leggi originale', pt: 'Ler original', es: 'Leer original', en: 'Read original',
  };
  const openOriginalLabel = OPEN_ORIGINAL_LABELS[uiLang] || OPEN_ORIGINAL_LABELS.en;
  const translateLabel = escapeHtml(translateLinkLabel(preferredLang, targetLang));

  if (article.isPinned) {
    card.innerHTML = `
      <h4>${pinnedBadge}<a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">${title}</a></h4>
      <p class="meta">${source} • ${escapeHtml(languageNameForCard(sourceLang))} • ${escapeHtml(normalizeCountry(article.country || ''))}</p>
      <p class="links">
        <a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">${escapeHtml(openOriginalLabel)}</a>
        <a href="${translateUrl}" target="_blank" rel="noopener">${translateLabel}</a>
      </p>
    `;
    return card;
  }

  const apiLink = article.sourceApi
    ? `<p class="meta">Source/API: <a href="${escapeHtml(article.sourceApi)}" target="_blank" rel="noopener">${escapeHtml(article.sourceApi)}</a></p>`
    : '';

  card.innerHTML = `
    <h4><a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">${title}</a></h4>
    <p class="meta">${source}${dateMeta} • ${escapeHtml(languageNameForCard(sourceLang))} • ${escapeHtml(normalizeCountry(article.country || ''))}</p>
    ${apiLink}
    ${summaryHtml}
    <p class="links">
      <a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">${escapeHtml(openOriginalLabel)}</a>
      <a href="${translateUrl}" target="_blank" rel="noopener">${translateLabel}</a>
      <a href="#" class="news-report-link">Report / request removal</a>
    </p>
  `;

  const reportLink = card.querySelector('.news-report-link');
  if (reportLink) {
    reportLink.addEventListener('click', (event) => {
      event.preventDefault();
      const reason = prompt('Reason for moderation review (remove/correct):', 'Potentially incorrect or low-quality article');
      if (!reason) return;
      const pending = getPendingRemovals();
      pending.push({
        title: article.title || '',
        url: article.url || '',
        reason,
        submittedAt: new Date().toISOString(),
        moderationStatus: 'pending_review',
        moderationPriority: classifyReportReason(reason),
      });
      savePendingRemovals(pending.slice(-200));
      const issueUrl = createNewsReportIssueUrl(article, reason);
      openModerationIssue(issueUrl);
    });
  }

  return card;
}

async function renderNews(preferredLang) {
  const lang = inferUserLanguage(preferredLang);
  // Only persist a real language code, not 'auto'
  if (lang && lang !== 'auto') safeStorageSet('matsjekk_lang', lang);
  populateRegionSelect(lang);

  // Update page UI labels for the reading language (labels like "Lesespråk", nav etc.)
  if (typeof window.applyTranslations === 'function') {
    window.applyTranslations(lang);
  }

  const container = document.getElementById('news-list');
  if (!container) return;

  const regionSelect = document.getElementById('news-region');
  const selectedMode = regionSelect ? regionSelect.value : 'auto';
  const userCountry = await detectCountryCodeFromGeo();
  const resolvedMode = selectedMode === 'auto' ? clusterForCountry(userCountry) : selectedMode;

  const localNews = getNews().filter((item) => isRelevantArticle(item));
  const remoteNews = await fetchRemoteNewsForMode(resolvedMode);

  // Keep only trusted newspaper/net-newspaper coverage of the configured topics.
  const filteredRemote = remoteNews.filter((item) => isRelevantArticle(item));

  // Merge fresh articles with rolling 30-day cache so critical articles don't vanish
  const cachedNews = loadFeedCache(resolvedMode).filter((item) => isRelevantArticle(item));
  const merged = dedupeByUrl([...filteredRemote, ...cachedNews, ...localNews]);

  // Persist fresh articles to rolling cache
  if (filteredRemote.length > 0) saveFeedCache(resolvedMode, merged);

  const scope = regionCountriesForMode(resolvedMode, userCountry);

  let visible = newsListForDisplay(merged, scope);
  if (!visible || visible.length === 0) {
    visible = fallbackNewsForScope(scope);
  }
  container.innerHTML = '';

  if (!visible || visible.length === 0) {
    const muted = document.createElement('p');
    muted.className = 'muted';
    muted.textContent = lang === 'en'
      ? 'No articles available yet. New items load automatically when feeds update.'
      : 'Ingen artikler ennå. Nye artikler lastes inn automatisk når kilder er tilgjengelige.';
    container.appendChild(muted);
    return;
  }

  let renderedCount = 0;
  visible.forEach((article) => {
    try {
      const card = createNewsCard(article, lang);
      if (card) {
        container.appendChild(card);
        renderedCount += 1;
      }
    } catch (error) {
      console.warn('Skipping invalid news item during render', error, article);
    }
  });

  // Append optional pinned sources at the bottom (disabled by default to avoid feed skew).
  const pinnedSources = ENABLE_PINNED_SOURCES ? getPinnedSourcesForMode(resolvedMode) : [];
  if (pinnedSources.length > 0) {
    const separator = document.createElement('p');
    separator.className = 'muted pinned-section-label';
    separator.textContent = lang === 'en' ? 'Additional sources:' : (lang === 'sv' ? 'Ytterligare källor:' : lang === 'da' ? 'Yderligere kilder:' : 'Ytterligere kilder:');
    container.appendChild(separator);
    pinnedSources.forEach((article) => {
      try {
        const card = createNewsCard(article, lang);
        if (card) { container.appendChild(card); renderedCount += 1; }
      } catch (_) {}
    });
  }

  if (renderedCount === 0) {
    const muted = document.createElement('p');
    muted.className = 'muted';
    muted.textContent = lang === 'en'
      ? 'Articles were loaded, but could not be rendered. Please refresh or change region.'
      : 'Artikler ble lastet, men kunne ikke vises. Proev oppdatering eller bytt region.';
    container.appendChild(muted);
  }
}

function initNewsForm() {
  const addBtn = document.getElementById('add-article-btn');
  const form = document.getElementById('news-form');
  const saveBtn = document.getElementById('save-article');
  const cancelBtn = document.getElementById('cancel-article');
  const status = document.getElementById('news-form-status');

  if (addBtn && form && addBtn.dataset.newsFormBound !== '1') {
    addBtn.dataset.newsFormBound = '1';
    // Also mark fallback flag so inline fallback in news.html does not bind a second toggle listener.
    addBtn.dataset.fallbackBound = '1';
    addBtn.addEventListener('click', () => {
      const isHidden = form.classList.contains('hidden');
      if (isHidden) {
        form.classList.remove('hidden');
        form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        const titleEl = document.getElementById('article-title');
        if (titleEl && typeof titleEl.focus === 'function') titleEl.focus();
      } else {
        form.classList.add('hidden');
      }
      if (status) status.textContent = '';
    });
  }

  if (cancelBtn && form && cancelBtn.dataset.newsFormBound !== '1') {
    cancelBtn.dataset.newsFormBound = '1';
    cancelBtn.addEventListener('click', (event) => {
      event.preventDefault();
      form.classList.add('hidden');
      if (status) status.textContent = '';
    });
  }

  if (!saveBtn || saveBtn.dataset.newsFormBound === '1') return;
  saveBtn.dataset.newsFormBound = '1';

  saveBtn.addEventListener('click', (event) => {
    event.preventDefault();

    const titleEl = document.getElementById('article-title');
    const sourceEl = document.getElementById('article-source');
    const urlEl = document.getElementById('article-url');
    const langEl = document.getElementById('article-lang');

    const titleInput = String((titleEl && titleEl.value) || '').trim();
    const sourceInput = String((sourceEl && sourceEl.value) || '').trim();
    const url = String((urlEl && urlEl.value) || '').trim();
    const selectedLanguage = normalizeLang(String((langEl && langEl.value) || ''));

    if (status) {
      status.innerHTML = 'Sender til moderering...';
    }

    const meta = inferSubmissionMetadata(url, titleInput, sourceInput, selectedLanguage);
    const title = meta.title;
    const source = meta.source;
    const language = meta.language;
    const country = meta.country;
    const neutrality = neutralityAssessment({ title, source, url, language });

    if (!url) {
      if (status) status.textContent = 'URL ma fylles ut.';
      return;
    }

    const issueUrl = createNewsSubmissionIssueUrl({
      title,
      source,
      url,
      language,
      country,
      regionHint: meta.regionHint,
      neutrality,
    });

    const pending = getPendingSubmissions();
    const trusted = isTrustedNewsDomain({ url, source, sourceName: source });
    pending.push({
      title,
      source,
      url,
      language,
      country,
      regionHint: meta.regionHint,
      submittedAt: new Date().toISOString(),
      moderationStatus: 'pending_review',
      moderationNeedsEmailReview: !trusted,
      neutrality,
    });
    savePendingSubmissions(pending.slice(-200));

    const opened = openModerationIssue(issueUrl);

    if (status) {
      const base = opened
        ? 'Innsending sendt til moderering. Et GitHub-skjema er aapnet i ny fane.'
        : `Innsending klargjort for moderering. <a href="${escapeHtml(issueUrl)}" target="_blank" rel="noopener">Trykk her for aa aapne modereringsskjema</a>.`;
      const extra = trusted
        ? ''
        : ' Kilden er ikke i kjent avisliste; vennligst varsle redaksjonen via <a href="index.html#contact">Kontakt</a> for manuell e-postvurdering ved tvil.';
      status.innerHTML = base + extra;
    }

    if (titleEl) titleEl.value = '';
    if (sourceEl) sourceEl.value = '';
    if (urlEl) urlEl.value = '';
    if (langEl) langEl.value = selectedLanguage || inferUserLanguage('nb') || 'nb';
    if (form) form.classList.remove('hidden');
  });
}

function initNews() {
  const langSelect = document.getElementById('news-lang');
  const regionSelect = document.getElementById('news-region');

  if (langSelect) {
    langSelect.addEventListener('change', (event) => {
      const val = normalizeLang(event.target.value || '');
      if (!val || val === 'auto') {
        // Auto: use browser language, fall back to stored or nb
        const auto = normalizeLang(navigator.language || safeStorageGet('matsjekk_lang') || 'nb') || 'nb';
        safeStorageSet('matsjekk_lang', 'auto');
        renderNews(auto);
        return;
      }
      safeStorageSet('matsjekk_lang', val);
      renderNews(val);
    });
  }

  if (regionSelect) {
    regionSelect.addEventListener('change', () => {
      safeStorageSet('matsjekk_news_region', regionSelect.value || 'auto');
      const lang = normalizeLang((langSelect && langSelect.value) || safeStorageGet('matsjekk_lang') || 'nb');
      renderNews(lang);
    });
  }

  initNewsForm();

  const initialLang = (() => {
    // Prefer stored real language over the select value (which may be 'auto' at this point)
    const stored = normalizeLang(safeStorageGet('matsjekk_lang') || '');
    if (stored && stored !== 'auto') return stored;
    return normalizeLang(navigator.language || 'nb') || 'nb';
  })();

  renderNews(initialLang).catch((error) => {
    console.error('News initialization failed', error);
    const container = document.getElementById('news-list');
    if (!container) return;
    container.innerHTML = '';
    const muted = document.createElement('p');
    muted.className = 'muted';
    muted.textContent = 'Nyheter kunne ikke lastes. Proev aa oppdatere siden.';
    container.appendChild(muted);
  });
}

window.renderNews = renderNews;
window.addEventListener('DOMContentLoaded', initNews);
