(function () {
  'use strict';

  const STORAGE_KEY = 'matsjekk_lang';
  const SUPPORTED = ['nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es'];
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
    const saved = normalizeLang(localStorage.getItem(STORAGE_KEY));
    if (SUPPORTED.includes(saved)) return saved;
    return detectBrowserLang();
  }

  function translateUrl(targetLang) {
    const clean = window.location.href;
    return 'https://translate.google.com/translate?sl=nb&tl=' + encodeURIComponent(targetLang) + '&u=' + encodeURIComponent(clean);
  }

  function shouldSkipRedirect() {
    const host = String(window.location.hostname || '').toLowerCase();
    if (host.includes('translate.goog') || host.includes('translate.googleusercontent.com')) return true;
    return false;
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
      if (target === 'nb') {
        window.location.href = window.location.pathname + window.location.search + window.location.hash;
        return;
      }
      window.location.href = translateUrl(target);
    });

    wrap.appendChild(label);
    wrap.appendChild(select);
    wrap.appendChild(resetBtn);
    main.insertBefore(wrap, main.firstChild);
  }

  const lang = preferredLang();
  document.documentElement.lang = lang || 'nb';

  // Do not auto-redirect on load; only redirect on explicit user choice.
  injectLanguageSelector(lang);
})();
