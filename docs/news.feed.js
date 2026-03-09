// Client-side news feed rendering with geo-aware relevance and moderation-only submission flow.
const NEWS_KEY = 'matsjekk_news_v2';
const NEWS_PENDING_KEY = 'matsjekk_news_pending_submissions_v1';
const NEWS_PENDING_REMOVAL_KEY = 'matsjekk_news_pending_removals_v1';
const NEWS_REMOTE_URL = 'data/news.latest.json';
const NEWS_MAX_ITEMS = 50;

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
    const key = String(item?.url || '').trim().toLowerCase();
    if (!key || seen.has(key)) continue;
    seen.add(key);
    out.push(item);
  }
  return out;
}

async function fetchRemoteNews() {
  try {
    const response = await fetch(NEWS_REMOTE_URL, { cache: 'no-cache' });
    if (!response.ok) return [];
    const payload = await response.json();
    return Array.isArray(payload?.items) ? payload.items : [];
  } catch (_) {
    return [];
  }
}

function readGeoCacheCountry() {
  const raw = safeJsonParse(safeStorageGet(GEO_CACHE_KEY), null);
  if (!raw?.country || !raw?.ts) return '';
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
    .then((payload) => normalizeCountry(payload?.address?.country_code || ''))
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
  if (direct) return direct;
  const fromStorage = normalizeLang(safeStorageGet('matsjekk_lang'));
  if (fromStorage) return fromStorage;
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
  const current = stored === 'global' ? 'auto' : stored;
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

function openModerationIssue(url) {
  window.open(url, '_blank', 'noopener');
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
    `neutrality_rating: ${yamlQuoted(payload.neutrality?.rating || 'unknown')}`,
    `neutrality_flags: ${yamlQuoted((payload.neutrality?.flags || []).join(', ') || 'none')}`,
    `neutrality_notes: ${yamlQuoted(payload.neutrality?.notes || '')}`,
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
  if (filtered.length > 0) return filtered.slice(0, NEWS_MAX_ITEMS);
  return sorted.slice(0, NEWS_MAX_ITEMS);
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

function translateLinkLabel(uiLang, targetLang) {
  const ui = normalizeLang(uiLang);
  const target = languageLabel(targetLang);
  if (ui === 'en') return `Translate article to ${target}`;
  return `Oversett artikkel til ${target}`;
}

function createNewsCard(article, preferredLang) {
  const card = document.createElement('article');
  card.className = 'news-card';

  const title = escapeHtml(article.title || 'Untitled');
  const source = escapeHtml(article.source || article.sourceName || 'Ukjent kilde');
  const dateStr = new Date(article.pubDate || article.date || Date.now()).toLocaleDateString();
  const sourceLang = normalizeLang(article.language || 'auto') || 'auto';
  const targetLang = inferUserLanguage(preferredLang);
  const translateUrl = `https://translate.google.com/translate?sl=${encodeURIComponent(sourceLang)}&tl=${encodeURIComponent(targetLang)}&u=${encodeURIComponent(article.url || '')}`;

  const summary = stripHtml(article.shortSummary || article.summary || article.englishSummary || '');
  const summaryHtml = summary ? `<p class="summary">${escapeHtml(summary)}</p>` : '';
  const apiLink = article.sourceApi
    ? `<p class="meta">Source/API: <a href="${escapeHtml(article.sourceApi)}" target="_blank" rel="noopener">${escapeHtml(article.sourceApi)}</a></p>`
    : '';

  card.innerHTML = `
    <h4><a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">${title}</a></h4>
    <p class="meta">${source} • ${dateStr} • ${escapeHtml(languageNameForCard(sourceLang))} • ${escapeHtml(normalizeCountry(article.country || ''))}</p>
    ${apiLink}
    ${summaryHtml}
    <p class="links">
      <a href="${escapeHtml(article.url || '')}" target="_blank" rel="noopener">Open original</a>
      <a href="${translateUrl}" target="_blank" rel="noopener">${escapeHtml(translateLinkLabel(preferredLang, targetLang))}</a>
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
  safeStorageSet('matsjekk_lang', lang);
  populateRegionSelect(lang);

  const localNews = getNews();
  const remoteNews = await fetchRemoteNews();
  const merged = dedupeByUrl([...remoteNews, ...localNews]);

  const container = document.getElementById('news-list');
  if (!container) return;

  const regionSelect = document.getElementById('news-region');
  const mode = regionSelect ? regionSelect.value : 'auto';
  const userCountry = await detectCountryCodeFromGeo();
  const scope = regionCountriesForMode(mode, userCountry);

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

  if (addBtn && form) {
    addBtn.addEventListener('click', () => {
      form.classList.toggle('hidden');
      if (status) status.textContent = '';
    });
  }

  if (cancelBtn && form) {
    cancelBtn.addEventListener('click', (event) => {
      event.preventDefault();
      form.classList.add('hidden');
      if (status) status.textContent = '';
    });
  }

  if (!saveBtn) return;

  saveBtn.addEventListener('click', async (event) => {
    event.preventDefault();

    const titleEl = document.getElementById('article-title');
    const sourceEl = document.getElementById('article-source');
    const urlEl = document.getElementById('article-url');
    const langEl = document.getElementById('article-lang');

    const title = String(titleEl?.value || '').trim();
    const source = String(sourceEl?.value || '').trim() || 'Ukjent kilde';
    const url = String(urlEl?.value || '').trim();
    const language = normalizeLang(String(langEl?.value || 'nb')) || 'nb';
    const neutrality = neutralityAssessment({ title, source, url, language });

    if (!title || !url) {
      if (status) status.textContent = 'Tittel og URL ma fylles ut.';
      return;
    }

    const userCountry = await detectCountryCodeFromGeo();
    const issueUrl = createNewsSubmissionIssueUrl({ title, source, url, language, country: userCountry, neutrality });

    const pending = getPendingSubmissions();
    pending.push({
      title,
      source,
      url,
      language,
      country: userCountry,
      submittedAt: new Date().toISOString(),
      moderationStatus: 'pending_review',
      neutrality,
    });
    savePendingSubmissions(pending.slice(-200));

    openModerationIssue(issueUrl);

    if (status) {
      status.textContent = 'Innsending sendt til moderering. Redaksjonen ma godkjenne for publisering.';
    }

    if (titleEl) titleEl.value = '';
    if (sourceEl) sourceEl.value = '';
    if (urlEl) urlEl.value = '';
    if (form) form.classList.add('hidden');
  });
}

function initNews() {
  const langSelect = document.getElementById('news-lang');
  const regionSelect = document.getElementById('news-region');

  if (langSelect) {
    langSelect.addEventListener('change', (event) => {
      const nextLang = normalizeLang(event.target.value || 'nb') || 'nb';
      safeStorageSet('matsjekk_lang', nextLang);
      renderNews(nextLang);
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

  const initialLang = normalizeLang(
    (document.getElementById('news-lang') && document.getElementById('news-lang').value) ||
    safeStorageGet('matsjekk_lang') ||
    navigator.language ||
    'nb'
  ) || 'nb';

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
