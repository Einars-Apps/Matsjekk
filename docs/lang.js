const supportedLanguages = [
  { code: 'nb', label: 'Norsk' },
  { code: 'en', label: 'English' },
  { code: 'sv', label: 'Svenska' },
  { code: 'da', label: 'Dansk' },
  { code: 'fi', label: 'Suomi' },
  { code: 'de', label: 'Deutsch' },
  { code: 'nl', label: 'Nederlands' },
  { code: 'fr', label: 'Français' },
  { code: 'it', label: 'Italiano' },
  { code: 'pt', label: 'Português' },
  { code: 'es', label: 'Español' },
];

const translations = {
  nb: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skann mat, velg bevisst',
    privacy: 'Personvern',
    newsHeading: 'Nyheter og media',
    newsIntro: 'Hold deg oppdatert — legg til relevante artikler om Bovaer, GMO, insektmel og bærekraft.'
  },
  en: {
    title: '🛒 Mat Check',
    tagline: 'Scan food, choose consciously',
    privacy: 'Privacy',
    newsHeading: 'News & Media',
    newsIntro: 'Stay updated — add relevant articles about Bovaer, GMO, insect meal and sustainability.'
  }
};

function applyTranslations(lang) {
  const dict = translations[lang] || translations.nb;
  document.querySelectorAll('[data-translate]').forEach(el => {
    const key = el.getAttribute('data-translate');
    if (dict[key]) el.textContent = dict[key];
  });
}

function populateLangSelects() {
  const sel = document.getElementById('lang-select');
  const newsSel = document.getElementById('news-lang');
  const articleLang = document.getElementById('article-lang');
  supportedLanguages.forEach(l => {
    const o = document.createElement('option'); o.value = l.code; o.textContent = l.label; sel.appendChild(o);
    const o2 = o.cloneNode(true); newsSel.appendChild(o2);
    const o3 = o.cloneNode(true); articleLang.appendChild(o3);
  });
}

function loadLanguage() {
  const saved = localStorage.getItem('matsjekk_lang') || navigator.language.split('-')[0] || 'nb';
  const lang = translations[saved] ? saved : 'nb';
  document.getElementById('lang-select').value = lang;
  document.getElementById('news-lang').value = lang;
  applyTranslations(lang);
}

function initLanguage() {
  populateLangSelects();
  loadLanguage();
  document.getElementById('lang-select').addEventListener('change', (e) => {
    const v = e.target.value;
    localStorage.setItem('matsjekk_lang', v);
    applyTranslations(v);
    renderNews(v);
  });
}

window.addEventListener('DOMContentLoaded', initLanguage);
