(function () {
  const MANUAL_URL = 'data/eu_decisions.json?v=20260606f';
  const AUTO_URL = 'data/eu_decisions_auto.json?v=20260606f';
  const WINDOW_DAYS = 365 * 3;
  let allDecisions = [];
  let initialUrlState = null;
  const translationCache = new Map();
  let activeRenderToken = 0;

  const UI_TEXT = {
    nb: {
      unknownDate: 'Ukjent dato',
      unknownEntry: 'Ukjent oppforing',
      update: 'Oppdatering',
      topicDefault: 'EU-vedtak',
      unknownSource: 'Ukjent kilde',
      allTopics: 'Alle tema',
      readInLocalLanguage: 'Les i ditt språk',
      sourceLabel: 'Kilde',
      openSource: 'Les originalkilde',
      originalTitle: 'Original tittel',
      topicHeadings: {
        gmo: 'GMO / NGT',
        bovaer: 'Bovaer',
        insect: 'Insektsmel / Insektprotein',
        other: 'Andre EU-vedtak',
      },
      emptyTopic: 'Ingen vedtak i denne kategorien i valgt periode.',
      insectWindowNone: 'Ingen insektsmel-vedtak i rullerende 3-arsvindu akkurat na.',
      insectLatestPrefix: 'Siste registrerte insektsmel-vedtak:',
      count: (shown, total) => `Viser ${shown} av ${total} vedtak.`,
      noHits: 'Ingen treff. Prov et annet sokeord eller tema.',
      noItems: 'Ingen vedtak funnet i 3-arsvinduet akkurat na.',
      loadError: 'Kunne ikke laste EU-vedtak akkurat na. Proev igjen om litt.',
      statusOk: (d) => `Automatisk oppdatering er aktiv. Siste automatiske sjekk: ${d}.`,
      statusFail: 'Automatisk oppdatering er konfigurert, men datakilden svarte ikke akkurat na.',
      statusMissing: 'ikke tilgjengelig enda',
    },
    en: {
      unknownDate: 'Unknown date',
      unknownEntry: 'Unknown entry',
      update: 'Update',
      topicDefault: 'EU decision',
      unknownSource: 'Unknown source',
      allTopics: 'All topics',
      readInLocalLanguage: 'Read in your language',
      sourceLabel: 'Source',
      openSource: 'Open original source',
      originalTitle: 'Original title',
      topicHeadings: {
        gmo: 'GMO / NGT',
        bovaer: 'Bovaer',
        insect: 'Insect meal / Insect protein',
        other: 'Other EU decisions',
      },
      emptyTopic: 'No decisions in this category for the selected period.',
      insectWindowNone: 'No insect-meal decisions in the rolling 3-year window right now.',
      insectLatestPrefix: 'Latest registered insect-meal decision:',
      count: (shown, total) => `Showing ${shown} of ${total} decisions.`,
      noHits: 'No results. Try another search term or topic.',
      noItems: 'No decisions found in the current 3-year window.',
      loadError: 'Could not load EU decisions right now. Please try again shortly.',
      statusOk: (d) => `Automatic updates are active. Last automatic check: ${d}.`,
      statusFail: 'Automatic updates are configured, but the data source did not respond right now.',
      statusMissing: 'not available yet',
    }
  };

  function activeLang() {
    const htmlLang = String(document.documentElement.lang || '').toLowerCase();
    return UI_TEXT[htmlLang] ? htmlLang : 'en';
  }

  function t() {
    return UI_TEXT[activeLang()] || UI_TEXT.en;
  }

  function escapeHtml(value) {
    return String(value || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function parseDate(input) {
    const d = new Date(input || '');
    return Number.isNaN(d.getTime()) ? null : d;
  }

  function formatDate(input) {
    const d = parseDate(input);
    if (!d) return t().unknownDate;
    const locale = activeLang() === 'nb' ? 'nb-NO' : activeLang();
    return d.toLocaleDateString(locale);
  }

  function topicKey(topic) {
    const lower = String(topic || '').toLowerCase();
    if (lower.includes('gmo') || lower.includes('ngt') || lower.includes('genomic')) return 'gmo';
    if (lower.includes('bovaer') || lower.includes('3-nop') || lower.includes('3 nop')) return 'bovaer';
    if (lower.includes('insekt') || lower.includes('insect') || lower.includes('novel food')) return 'insect';
    return 'other';
  }

  function topicLabel(topic) {
    const key = topicKey(topic);
    const headings = t().topicHeadings || UI_TEXT.en.topicHeadings;
    return headings[key] || topic || t().topicDefault;
  }

  function mapLangCode(code) {
    const normalized = String(code || 'en').toLowerCase();
    const map = {
      nb: 'no',
      zh: 'zh-CN',
    };
    return map[normalized] || normalized;
  }

  function translatedSourceUrl(url) {
    const lang = activeLang();
    if (!url || url === '#') return '#';
    if (lang === 'en') return url;
    return `https://translate.google.com/translate?sl=auto&tl=${encodeURIComponent(mapLangCode(lang))}&u=${encodeURIComponent(url)}`;
  }

  async function translateText(text) {
    const value = String(text || '').trim();
    const lang = activeLang();
    if (!value || lang === 'en') return value;

    const cacheKey = `${lang}|${value}`;
    if (translationCache.has(cacheKey)) return translationCache.get(cacheKey);

    try {
      const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=${encodeURIComponent(mapLangCode(lang))}&dt=t&q=${encodeURIComponent(value)}`;
      const response = await fetch(url, { cache: 'force-cache' });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const payload = await response.json();
      const translated = Array.isArray(payload?.[0])
        ? payload[0].map((part) => (Array.isArray(part) ? String(part[0] || '') : '')).join('')
        : value;
      const out = translated || value;
      translationCache.set(cacheKey, out);
      return out;
    } catch (_err) {
      translationCache.set(cacheKey, value);
      return value;
    }
  }

  function inWindow(item) {
    const d = parseDate(item.date);
    if (!d) return false;
    const cutoff = new Date(Date.now() - WINDOW_DAYS * 24 * 60 * 60 * 1000);
    return d >= cutoff;
  }

  function normalize(item) {
    const originalTitle = item.originalTitle || item.title || '';
    const originalSummary = item.originalSummary || item.summary || '';
    return {
      date: item.date || '',
      title: originalTitle || t().unknownEntry,
      type: item.type || t().update,
      topic: item.topic || t().topicDefault,
      summary: originalSummary || '',
      url: item.url || '#',
      source: item.source || t().unknownSource,
      originalTitle,
      originalSummary,
      translatedTitle: item.translatedTitle || '',
      translatedSummary: item.translatedSummary || '',
    };
  }

  function dedupe(items) {
    const seen = new Set();
    const out = [];
    for (const item of items) {
      const key = `${(item.title || '').toLowerCase()}|${(item.url || '').toLowerCase()}`;
      if (seen.has(key)) continue;
      seen.add(key);
      out.push(item);
    }
    return out;
  }

  function cardHtml(item) {
    const langText = t();
    const safeUrl = item.url || '#';
    const localReadUrl = translatedSourceUrl(safeUrl);
    const displayTitle = item.translatedTitle || item.title;
    const displaySummary = item.translatedSummary || item.summary;
    return `
      <article class="eu-decision-card">
        <div class="eu-decision-topline">
          <span class="eu-decision-date">${formatDate(item.date)}</span>
          <span class="eu-decision-badge">${escapeHtml(topicLabel(item.topic))}</span>
        </div>
        <h3>${escapeHtml(displayTitle)}</h3>
        <p class="eu-decision-type">${escapeHtml(item.type)}</p>
        <p>${escapeHtml(displaySummary)}</p>
        <p class="eu-decision-meta">${escapeHtml(langText.sourceLabel)}: ${escapeHtml(item.source)}</p>
        <p class="eu-decision-origin">${escapeHtml(langText.originalTitle)}: ${escapeHtml(item.originalTitle || item.title)}</p>
        <p class="eu-decision-links">
          <a href="${localReadUrl}" target="_blank" rel="noopener">${escapeHtml(langText.readInLocalLanguage)}</a>
          <a href="${safeUrl}" target="_blank" rel="noopener">${escapeHtml(langText.openSource)}</a>
        </p>
      </article>
    `;
  }

  function sortByDate(items) {
    return items.sort((a, b) => {
      const da = parseDate(a.date);
      const db = parseDate(b.date);
      if (!da && !db) return 0;
      if (!da) return 1;
      if (!db) return -1;
      return db.getTime() - da.getTime();
    });
  }

  function setCountText(total, shown) {
    const countEl = document.getElementById('eu-decisions-count');
    if (!countEl) return;
    countEl.textContent = t().count(shown, total);
  }

  function groupByTopic(items) {
    const map = new Map();
    for (const item of items) {
      const key = topicKey(item.topic);
      if (!map.has(key)) map.set(key, []);
      map.get(key).push(item);
    }
    return map;
  }

  function renderList(items) {
    const listEl = document.getElementById('eu-decisions-list');
    if (!listEl) return;

    if (!items.length) {
      listEl.innerHTML = `<p class="muted">${escapeHtml(t().noHits)}</p>`;
      return;
    }
    const groups = groupByTopic(items);
    const order = ['gmo', 'bovaer', 'insect', 'other'];
    const ids = {
      gmo: 'topic-gmo',
      bovaer: 'topic-bovaer',
      insect: 'topic-insect',
      other: 'topic-other',
    };
    const html = order
      .map((key) => {
        const heading = topicLabel(key);
        const groupItems = groups.get(key) || [];
        const cards = groupItems.length
          ? groupItems.map(cardHtml).join('')
          : `<p class="muted">${escapeHtml(t().emptyTopic)}</p>`;
        return `
          <section id="${ids[key]}" class="eu-topic-group" aria-label="${escapeHtml(heading)}">
            <h3 class="eu-topic-heading">${escapeHtml(heading)}</h3>
            <div class="eu-topic-grid">${cards}</div>
          </section>
        `;
      })
      .join('');
    listEl.innerHTML = html;
  }

  function setInsectStatus(filteredItems, allItems) {
    const insectEl = document.getElementById('eu-insect-status');
    if (!insectEl) return;

    const inWindowInsect = filteredItems.some((item) => topicKey(item.topic) === 'insect');
    if (inWindowInsect) {
      insectEl.textContent = '';
      return;
    }

    const latestInsect = allItems
      .filter((item) => topicKey(item.topic) === 'insect')
      .sort((a, b) => {
        const da = parseDate(a.date);
        const db = parseDate(b.date);
        if (!da && !db) return 0;
        if (!da) return 1;
        if (!db) return -1;
        return db.getTime() - da.getTime();
      })[0];

    if (latestInsect && latestInsect.date) {
      insectEl.textContent = `${t().insectWindowNone} ${t().insectLatestPrefix} ${formatDate(latestInsect.date)}.`;
      return;
    }
    insectEl.textContent = t().insectWindowNone;
  }

  function getSearchState() {
    const queryEl = document.getElementById('eu-decisions-search');
    const topicEl = document.getElementById('eu-decisions-topic');
    const query = (queryEl && queryEl.value ? queryEl.value : '').trim().toLowerCase();
    const topic = topicEl && topicEl.value ? topicEl.value : '';
    return { query, topic };
  }

  function getUrlState() {
    const params = new URLSearchParams(window.location.search);
    return {
      query: (params.get('q') || '').trim(),
      topic: (params.get('topic') || '').trim()
    };
  }

  function updateUrlState(query, topic) {
    const params = new URLSearchParams(window.location.search);
    if (query) params.set('q', query);
    else params.delete('q');
    if (topic) params.set('topic', topic);
    else params.delete('topic');

    const queryString = params.toString();
    const nextUrl = `${window.location.pathname}${queryString ? `?${queryString}` : ''}${window.location.hash || ''}`;
    window.history.replaceState({}, '', nextUrl);
  }

  function applyFilters(items, query, topic) {
    return items.filter((item) => {
      if (topic && item.topic !== topic) return false;
      if (!query) return true;
      const haystack = [item.title, item.topic, item.type, item.source, item.summary]
        .join(' ')
        .toLowerCase();
      return haystack.includes(query);
    });
  }

  function populateTopicFilter(items) {
    const topicEl = document.getElementById('eu-decisions-topic');
    if (!topicEl) return;

    const topics = Array.from(new Set(items.map((item) => item.topic).filter(Boolean))).sort();
    topicEl.innerHTML = `<option value="">${escapeHtml(t().allTopics)}</option>`;
    topics.forEach((topic) => {
      const option = document.createElement('option');
      option.value = topic;
      option.textContent = topicLabel(topic);
      topicEl.appendChild(option);
    });

    if (initialUrlState && initialUrlState.topic) {
      const topicExists = topics.includes(initialUrlState.topic);
      topicEl.value = topicExists ? initialUrlState.topic : '';
    }
  }

  function renderFiltered(syncUrl) {
    activeRenderToken += 1;
    const currentToken = activeRenderToken;
    const { query, topic } = getSearchState();
    const filtered = applyFilters(allDecisions, query, topic);
    renderList(filtered);
    setCountText(allDecisions.length, filtered.length);
    if (syncUrl !== false) {
      updateUrlState(query, topic);
    }

    void Promise.all(filtered.map(async (item) => {
      const nextTitle = await translateText(item.originalTitle || item.title);
      const nextSummary = await translateText(item.originalSummary || item.summary);
      item.translatedTitle = nextTitle || item.title;
      item.translatedSummary = nextSummary || item.summary;
    })).then(() => {
      if (currentToken !== activeRenderToken) return;
      renderList(filtered);
    });
  }

  function bindSearchUi() {
    const queryEl = document.getElementById('eu-decisions-search');
    const topicEl = document.getElementById('eu-decisions-topic');
    const clearEl = document.getElementById('eu-decisions-clear');

    if (queryEl) queryEl.addEventListener('input', () => renderFiltered(true));
    if (topicEl) topicEl.addEventListener('change', () => renderFiltered(true));
    if (clearEl) {
      clearEl.addEventListener('click', () => {
        if (queryEl) queryEl.value = '';
        if (topicEl) topicEl.value = '';
        renderFiltered(true);
      });
    }
  }

  async function fetchJson(url) {
    const response = await fetch(url, { cache: 'no-store' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
  }

  async function renderEuDecisions() {
    const listEl = document.getElementById('eu-decisions-list');
    const statusEl = document.getElementById('eu-decisions-status');
    if (!listEl) return;

    try {
      const [manual, auto] = await Promise.all([
        fetchJson(MANUAL_URL),
        fetchJson(AUTO_URL).catch(() => ({ items: [], updated_at: null }))
      ]);

      const allCombined = dedupe([
        ...((manual.items || []).map(normalize)),
        ...((auto.items || []).map(normalize))
      ]);

      const combined = allCombined.filter(inWindow);

      allDecisions = sortByDate(combined);
      populateTopicFilter(allDecisions);
      setInsectStatus(allDecisions, allCombined);

      if (!allDecisions.length) {
        listEl.innerHTML = `<p class="muted">${escapeHtml(t().noItems)}</p>`;
        setCountText(0, 0);
      } else {
        renderFiltered(false);
      }

      if (statusEl) {
        const autoUpdated = auto && auto.updated_at ? formatDate(auto.updated_at) : t().statusMissing;
        statusEl.textContent = t().statusOk(autoUpdated);
      }
    } catch (err) {
      listEl.innerHTML = `<p class="muted">${escapeHtml(t().loadError)}</p>`;
      setCountText(0, 0);
      setInsectStatus([], []);
      if (statusEl) {
        statusEl.textContent = t().statusFail;
      }
    }
  }

  window.addEventListener('load', function () {
    initialUrlState = getUrlState();
    const queryEl = document.getElementById('eu-decisions-search');
    if (queryEl && initialUrlState.query) {
      queryEl.value = initialUrlState.query;
    }
    bindSearchUi();
    renderEuDecisions();

    const langSelect = document.getElementById('lang-select');
    if (langSelect) {
      langSelect.addEventListener('change', () => {
        window.setTimeout(() => {
          populateTopicFilter(allDecisions);
          renderFiltered(false);
        }, 0);
      });
    }
  });
})();
