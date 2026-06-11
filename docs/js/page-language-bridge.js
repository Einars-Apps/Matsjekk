(function () {
  'use strict';

  const STORAGE_KEY = 'matsjekk_lang';
  const SUPPORTED = ['nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es', 'ko', 'pl', 'ru', 'zh', 'ar', 'th'];
  const LABELS = {
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
    ko: '한국어',
    pl: 'Polski',
    ru: 'Русский',
    zh: '中文',
    ar: 'العربية',
    th: 'ภาษาไทย',
  };

  function normalizeLang(value) {
    return String(value || '').trim().toLowerCase().split('-')[0];
  }

  function detectBrowserLang() {
    const candidates = [];
    if (Array.isArray(navigator.languages)) candidates.push(...navigator.languages);
    if (navigator.language) candidates.push(navigator.language);
    if (navigator.userLanguage) candidates.push(navigator.userLanguage);

    for (const entry of candidates) {
      const code = normalizeLang(entry);
      if (SUPPORTED.includes(code)) return code;
    }
    return 'nb';
  }

  function preferredLang() {
    // URL ?lang= wins (the app links here with ?lang=<code>), then stored, then browser.
    try {
      const urlLang = normalizeLang(new URLSearchParams(window.location.search || '').get('lang'));
      if (SUPPORTED.includes(urlLang)) return urlLang;
    } catch (_) {
      // Ignore malformed query strings.
    }
    const saved = normalizeLang(localStorage.getItem(STORAGE_KEY));
    if (SUPPORTED.includes(saved)) return saved;
    return detectBrowserLang();
  }

  function updateLangInUrl(lang) {
    try {
      const url = new URL(window.location.href);
      if (lang && lang !== 'nb' && SUPPORTED.includes(lang)) {
        url.searchParams.set('lang', lang);
      } else {
        url.searchParams.delete('lang');
      }
      window.history.replaceState(null, '', url.toString());
    } catch (_) {
      // history.replaceState may be unavailable in some embeddings.
    }
  }

  function applyTranslations(lang) {
    const dicts = window.PAGE_BRIDGE_TRANSLATIONS;
    if (!dicts || typeof dicts !== 'object') return;
    const nbDict = dicts.nb || {};
    const enDict = dicts.en || {};
    const langDict = dicts[lang] || {};
    const pick = (key) => {
      if (langDict[key] != null) return langDict[key];
      if (enDict[key] != null) return enDict[key];
      return nbDict[key];
    };
    document.querySelectorAll('[data-translate]').forEach((el) => {
      const value = pick(el.getAttribute('data-translate'));
      if (typeof value === 'string') el.textContent = value;
    });
    document.querySelectorAll('[data-translate-html]').forEach((el) => {
      const value = pick(el.getAttribute('data-translate-html'));
      if (typeof value === 'string') el.innerHTML = value;
    });
  }

  function isGoogleTranslatedHost() {
    const host = String(window.location.hostname || '').toLowerCase();
    return host.includes('translate.goog') || host.includes('translate.googleusercontent.com');
  }

  function buildOriginalUrlFromTranslateProxy() {
    const host = String(window.location.hostname || '').toLowerCase();
    if (!isGoogleTranslatedHost()) return '';

    let originHost = '';
    if (host.endsWith('.translate.goog')) {
      originHost = host.slice(0, -'.translate.goog'.length);
    }
    if (!originHost) return '';

    const params = new URLSearchParams(window.location.search || '');
    Array.from(params.keys()).forEach((key) => {
      if (key.startsWith('_x_tr_')) params.delete(key);
    });

    const query = params.toString();
    return `${window.location.protocol}//${originHost}${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
  }

  function injectLanguageSelector(currentLang) {
    const main = document.querySelector('main') || document.body;
    if (!main) return;

    const wrap = document.createElement('div');
    wrap.style.display = 'flex';
    wrap.style.justifyContent = 'flex-end';
    wrap.style.gap = '8px';
    wrap.style.alignItems = 'center';
    wrap.style.margin = '12px 0';

    const label = document.createElement('label');
    label.textContent = currentLang === 'en' ? 'Language:' : 'Sprak:';
    label.setAttribute('for', 'page-lang-bridge-select');

    const select = document.createElement('select');
    select.id = 'page-lang-bridge-select';
    select.style.padding = '6px 10px';

    const resetBtn = document.createElement('button');
    resetBtn.type = 'button';
    resetBtn.textContent = currentLang === 'en' ? 'Reset to Norwegian' : 'Tilbakestill til norsk';
    resetBtn.style.padding = '6px 10px';
    resetBtn.addEventListener('click', function () {
      localStorage.setItem(STORAGE_KEY, 'nb');
      const originUrl = isGoogleTranslatedHost() ? buildOriginalUrlFromTranslateProxy() : '';
      if (originUrl) {
        window.location.assign(originUrl);
        return;
      }
      if (window.PAGE_BRIDGE_TRANSLATIONS) {
        select.value = 'nb';
        document.documentElement.lang = 'nb';
        updateLangInUrl('nb');
        applyTranslations('nb');
        if (label) label.textContent = 'Spr\u00e5k:';
        if (resetBtn) resetBtn.textContent = 'Tilbakestill til norsk';
        return;
      }
      window.location.href = window.location.pathname + window.location.search + window.location.hash;
    });

    SUPPORTED.forEach((code) => {
      const option = document.createElement('option');
      option.value = code;
      option.textContent = LABELS[code] || code;
      select.appendChild(option);
    });

    select.value = SUPPORTED.includes(currentLang) ? currentLang : 'nb';

    select.addEventListener('change', function () {
      const next = normalizeLang(select.value);
      const target = SUPPORTED.includes(next) ? next : 'nb';
      localStorage.setItem(STORAGE_KEY, target);

      if (window.PAGE_BRIDGE_TRANSLATIONS) {
        document.documentElement.lang = target;
        updateLangInUrl(target);
        applyTranslations(target);
        if (label) label.textContent = target === 'en' ? 'Language:' : 'Spr\u00e5k:';
        if (resetBtn) resetBtn.textContent = target === 'en' ? 'Reset to Norwegian' : 'Tilbakestill til norsk';
        return;
      }

      window.location.href = window.location.pathname + window.location.search + window.location.hash;
    });

    wrap.appendChild(label);
    wrap.appendChild(select);
    wrap.appendChild(resetBtn);
    main.insertBefore(wrap, main.firstChild);
  }

  const lang = preferredLang();
  document.documentElement.lang = lang || 'nb';

  if (isGoogleTranslatedHost()) {
    const originUrl = buildOriginalUrlFromTranslateProxy();
    if (originUrl) {
      window.location.replace(originUrl);
      return;
    }
  }

  if (!SUPPORTED.includes(lang)) {
    return;
  }

  // Bridge selector stores language preferences locally on static pages.
  injectLanguageSelector(lang);
  updateLangInUrl(lang);
  applyTranslations(lang);
})();
