(function () {
  const MANUAL_URL = 'data/eu_decisions.json?v=20260606c';
  const AUTO_URL = 'data/eu_decisions_auto.json?v=20260606c';
  const WINDOW_DAYS = 365 * 3;
  let allDecisions = [];
  let initialUrlState = null;

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
    if (!d) return 'Ukjent dato';
    return d.toLocaleDateString('nb-NO');
  }

  function inWindow(item) {
    const d = parseDate(item.date);
    if (!d) return false;
    const cutoff = new Date(Date.now() - WINDOW_DAYS * 24 * 60 * 60 * 1000);
    return d >= cutoff;
  }

  function normalize(item) {
    return {
      date: item.date || '',
      title: item.title || 'Ukjent oppforing',
      type: item.type || 'Oppdatering',
      topic: item.topic || 'EU-vedtak',
      summary: item.summary || '',
      url: item.url || '#',
      source: item.source || 'Ukjent kilde'
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
    const safeUrl = item.url || '#';
    return `
      <article class="eu-decision-card">
        <div class="eu-decision-topline">
          <span class="eu-decision-date">${formatDate(item.date)}</span>
          <span class="eu-decision-badge">${escapeHtml(item.topic)}</span>
        </div>
        <h3>${escapeHtml(item.title)}</h3>
        <p class="eu-decision-type">${escapeHtml(item.type)}</p>
        <p>${escapeHtml(item.summary)}</p>
        <p class="eu-decision-meta">Kilde: ${escapeHtml(item.source)}</p>
        <p><a href="${safeUrl}" target="_blank" rel="noopener">Les originalkilde</a></p>
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
    countEl.textContent = `Viser ${shown} av ${total} vedtak.`;
  }

  function renderList(items) {
    const listEl = document.getElementById('eu-decisions-list');
    if (!listEl) return;

    if (!items.length) {
      listEl.innerHTML = '<p class="muted">Ingen treff. Prov et annet sokeord eller tema.</p>';
      return;
    }
    listEl.innerHTML = items.map(cardHtml).join('');
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
    topicEl.innerHTML = '<option value="">Alle tema</option>';
    topics.forEach((topic) => {
      const option = document.createElement('option');
      option.value = topic;
      option.textContent = topic;
      topicEl.appendChild(option);
    });

    if (initialUrlState && initialUrlState.topic) {
      const topicExists = topics.includes(initialUrlState.topic);
      topicEl.value = topicExists ? initialUrlState.topic : '';
    }
  }

  function renderFiltered(syncUrl) {
    const { query, topic } = getSearchState();
    const filtered = applyFilters(allDecisions, query, topic);
    renderList(filtered);
    setCountText(allDecisions.length, filtered.length);
    if (syncUrl !== false) {
      updateUrlState(query, topic);
    }
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

      const combined = dedupe([
        ...((manual.items || []).map(normalize)),
        ...((auto.items || []).map(normalize))
      ])
        .filter(inWindow);

      allDecisions = sortByDate(combined);
      populateTopicFilter(allDecisions);

      if (!allDecisions.length) {
        listEl.innerHTML = '<p class="muted">Ingen vedtak funnet i 3-arsvinduet akkurat na.</p>';
        setCountText(0, 0);
      } else {
        renderFiltered(false);
      }

      if (statusEl) {
        const autoUpdated = auto && auto.updated_at ? formatDate(auto.updated_at) : 'ikke tilgjengelig enda';
        statusEl.textContent = `Automatisk oppdatering er aktiv. Siste automatiske sjekk: ${autoUpdated}.`;
      }
    } catch (err) {
      listEl.innerHTML = '<p class="muted">Kunne ikke laste EU-vedtak akkurat na. Proev igjen om litt.</p>';
      setCountText(0, 0);
      if (statusEl) {
        statusEl.textContent = 'Automatisk oppdatering er konfigurert, men datakilden svarte ikke akkurat na.';
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
  });
})();
