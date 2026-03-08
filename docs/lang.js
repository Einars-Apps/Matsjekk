const supportedLanguages = [
  { code: 'nb', label: 'Norsk' },
  { code: 'en', label: 'English' },
  { code: 'sv', label: 'Svenska' },
  { code: 'da', label: 'Dansk' },
  { code: 'fi', label: 'Suomi' },
  { code: 'de', label: 'Deutsch' },
  { code: 'nl', label: 'Nederlands' },
  { code: 'fr', label: 'Francais' },
  { code: 'it', label: 'Italiano' },
  { code: 'pt', label: 'Portugues' },
  { code: 'es', label: 'Espanol' },
];

const translations = {
  nb: {
    title: '🛒 Mat Sjekk',
    tagline: 'Skann mat, velg bevisst',
    privacy: 'Personvern',
    terms: 'Vilkår',
    analytics: 'Analytics',
    navHome: 'Hjem',
    navFarmshops: 'Gardsbutikker',
    navOrganicFarmshops: 'Okologiske gardsbutikker',
    navImmigrantShops: 'Innvandrerbutikker',
    navNews: 'Nyheter og media',
    navContact: 'Kontakt oss',
    heroHeading: 'Din personlige matvareguide',
    heroIntro: 'Skann strekkoder og fa umiddelbar informasjon om Bovaer, GMO-fiskefor og insektmel i matvarene dine.',
    ctaAppStore: '📱 Last ned pa App Store',
    ctaGooglePlay: '🤖 Last ned pa Google Play',
    ctaFindFarmshops: '🏬 Finn Gardsbutikker',
    ctaFindOrganicFarmshops: '🌿 Finn Okologiske Gardsbutikker',
    ctaFindImmigrantShops: '🛒 Finn Innvandrerbutikker',
    featuresHeading: 'Funksjoner',
    featureScanTitle: 'Strekkodeskanning',
    featureScanText: 'Skann produkter direkte i butikken med mobilkameraet ditt',
    featureBovaerTitle: 'Bovaer-varsler',
    featureBovaerText: 'Umiddelbar informasjon om produkter fra produsenter som bruker Bovaer',
    featureGmoTitle: 'GMO-fiskefor',
    featureGmoText: 'Sjekk om oppdrettslaks inneholder GMO-fiskefor',
    featureInsectTitle: 'Insektmel',
    featureInsectText: 'Varsler om produkter med insektinnhold',
    featureListTitle: 'Handlelister',
    featureListText: 'Lag og administrer flere handlelister samtidig',
    featureLangTitle: '11 sprak',
    featureLangText: 'Stotte for norsk, engelsk, svensk, dansk, finsk, tysk, nederlandsk, fransk, italiensk, portugisisk og spansk',
    adPlaceholder: 'Reklameplass (vises etter at du godtar informasjonskapsler)',
    howHeading: 'Slik fungerer det',
    howStep1Title: 'Last ned appen',
    howStep1Text: '- Gratis pa App Store og Google Play',
    howStep2Title: 'Skann strekkoden',
    howStep2Text: '- Rett pa produktet i butikken',
    howStep3Title: 'Se resultatet',
    howStep3Text: '- Fa umiddelbar informasjon om risikoniva',
    howStep4Title: 'Velg bevisst',
    howStep4Text: '- Bestem selv hva du vil kjope',
    aboutHeading: 'Om Mat Sjekk',
    aboutText1: 'Mat Sjekk er utviklet for bevisste forbrukere som onsker full kontroll over hva de kjoper. Appen bruker data fra OpenFoodFacts og andre apne kilder for a gi deg aerlig informasjon om matvarene dine.',
    aboutText2: 'Vi tar ikke stilling til om Bovaer, GMO eller insektmel er bra eller darlig - vi gir deg bare informasjonen du trenger for a ta dine egne valg.',
    faqHeading: 'Vanlige sporsmal',
    faq1Q: 'Er appen helt gratis?',
    faq1A: 'Ja, Mat Sjekk er helt gratis a laste ned og bruke. Vi finansieres gjennom annonser.',
    faq2Q: 'Hvor kommer dataene fra?',
    faq2A: 'Vi bruker primaert OpenFoodFacts, en apen database med produktinformasjon. For enkelte land bruker vi ogsa nasjonale matvarebaser som Matvaretabellen (Norge) og Fineli (Finland).',
    faq3Q: 'Hvordan vet jeg om informasjonen er korrekt?',
    faq3A: 'Vi baserer oss pa offentlig tilgjengelig informasjon om hvilke produsenter som bruker Bovaer, GMO-fiskefor eller insektmel. Produktdatabasen oppdateres kontinuerlig.',
    faq4Q: 'Hvilke land stottes?',
    faq4A: 'Appen fungerer i hele verden, men vi har spesialdata for Norge, Sverige, Danmark, Finland, Tyskland, Nederland, Frankrike, Italia, Portugal, Spania og Storbritannia.',
    faq5Q: 'Lagrer dere personlig informasjon?',
    faq5A: 'Nei. Alt lagres lokalt pa din telefon. Vi samler ikke inn eller deler persondata.',
    contactHeading: 'Kontakt',
    contactIntro: 'Har du sporsmal, tilbakemeldinger eller forslag?',
    newsHeading: 'Nyheter og media',
    newsIntro: 'Hold deg oppdatert - legg til relevante artikler om Bovaer, GMO, insektmel og baerekraft.',
    newsModerationNote: 'Innsendte artikler publiseres ikke direkte. De gar til moderering forst.',
    newsLanguageLabel: 'Lesesprak / oversett til:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Legg til artikkel',
    newsFormHeading: 'Legg til artikkel',
    newsFormTitleLabel: 'Tittel',
    newsFormSourceLabel: 'Kilde',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Sprak',
    newsSubmitForModerationBtn: 'Send til moderering',
    cancel: 'Avbryt',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. Alle rettigheter reservert.',
  },
  en: {
    title: '🛒 Mat Check',
    tagline: 'Scan food, choose consciously',
    privacy: 'Privacy',
    terms: 'Terms',
    analytics: 'Analytics',
    navHome: 'Home',
    navFarmshops: 'Farm Shops',
    navOrganicFarmshops: 'Organic Farm Shops',
    navImmigrantShops: 'Immigrant Shops',
    navNews: 'News and media',
    navContact: 'Contact us',
    heroHeading: 'Your personal food guide',
    heroIntro: 'Scan barcodes and get instant information about Bovaer, GMO fish feed, and insect meal in your groceries.',
    ctaAppStore: '📱 Download on the App Store',
    ctaGooglePlay: '🤖 Download on Google Play',
    ctaFindFarmshops: '🏬 Find Farm Shops',
    ctaFindOrganicFarmshops: '🌿 Find Organic Farm Shops',
    ctaFindImmigrantShops: '🛒 Find Immigrant Shops',
    featuresHeading: 'Features',
    featureScanTitle: 'Barcode scanning',
    featureScanText: 'Scan products directly in stores with your camera',
    featureBovaerTitle: 'Bovaer alerts',
    featureBovaerText: 'Instant information about producers using Bovaer',
    featureGmoTitle: 'GMO fish feed',
    featureGmoText: 'Check whether farmed fish includes GMO fish feed',
    featureInsectTitle: 'Insect meal',
    featureInsectText: 'Warnings for products containing insect ingredients',
    featureListTitle: 'Shopping lists',
    featureListText: 'Create and manage multiple shopping lists',
    featureLangTitle: '11 languages',
    featureLangText: 'Supports Norwegian, English, Swedish, Danish, Finnish, German, Dutch, French, Italian, Portuguese, and Spanish',
    adPlaceholder: 'Ad space (shown after cookie consent)',
    howHeading: 'How it works',
    howStep1Title: 'Download the app',
    howStep1Text: '- Free on the App Store and Google Play',
    howStep2Title: 'Scan the barcode',
    howStep2Text: '- Point your phone at a product in store',
    howStep3Title: 'See the result',
    howStep3Text: '- Get instant risk-level information',
    howStep4Title: 'Choose consciously',
    howStep4Text: '- Decide what you want to buy',
    aboutHeading: 'About Mat Check',
    aboutText1: 'Mat Check is made for conscious consumers who want full control over what they buy. The app uses OpenFoodFacts and other open sources to provide transparent information.',
    aboutText2: 'We do not tell you whether Bovaer, GMO, or insect meal is good or bad. We provide information so you can make your own choices.',
    faqHeading: 'FAQ',
    faq1Q: 'Is the app completely free?',
    faq1A: 'Yes. Mat Check is free to download and use. We are funded by ads.',
    faq2Q: 'Where does the data come from?',
    faq2A: 'We primarily use OpenFoodFacts and, for some countries, national food databases.',
    faq3Q: 'How do I know the information is correct?',
    faq3A: 'We use publicly available information and continuously update the product database.',
    faq4Q: 'Which countries are supported?',
    faq4A: 'The app works worldwide, with dedicated datasets for several European countries and the UK.',
    faq5Q: 'Do you store personal information?',
    faq5A: 'No. Data is stored locally on your phone. We do not collect or share personal data.',
    contactHeading: 'Contact',
    contactIntro: 'Questions, feedback, or suggestions?',
    newsHeading: 'News and media',
    newsIntro: 'Stay updated - add relevant articles about Bovaer, GMO, insect meal, and sustainability.',
    newsModerationNote: 'Submitted articles are not published directly. They go to moderation first.',
    newsLanguageLabel: 'Reading language / translate to:',
    newsRegionLabel: 'Region:',
    newsAddArticleBtn: 'Add article',
    newsFormHeading: 'Add article',
    newsFormTitleLabel: 'Title',
    newsFormSourceLabel: 'Source',
    newsFormUrlLabel: 'URL',
    newsFormLanguageLabel: 'Language',
    newsSubmitForModerationBtn: 'Send for moderation',
    cancel: 'Cancel',
    footerCopyright: '© 2026 Mat Sjekk / Einar\'s Apps. All rights reserved.',
  },
};

const LANG_STORAGE_KEY = 'matsjekk_lang';
const GEO_CACHE_KEY = 'matsjekk_geo_country';
const GEO_CACHE_MAX_AGE_MS = 24 * 60 * 60 * 1000;

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

function safeStorageRemove(key) {
  try {
    localStorage.removeItem(key);
    return true;
  } catch (_) {
    return false;
  }
}

const countryToLanguage = {
  NO: 'nb',
  SE: 'sv',
  DK: 'da',
  FI: 'fi',
  DE: 'de',
  AT: 'de',
  NL: 'nl',
  BE: 'nl',
  FR: 'fr',
  IT: 'it',
  PT: 'pt',
  ES: 'es',
  GB: 'en',
  IE: 'en',
};

function hasNativeDictionary(code) {
  const normalized = normalizeLanguageCode(code);
  return Boolean(translations[normalized]);
}

function isGoogleTranslatedHost() {
  const host = String(window.location.hostname || '').toLowerCase();
  return host.includes('translate.goog') || host.includes('translate.googleusercontent.com');
}

function redirectToGoogleTranslate(targetLang) {
  const normalized = normalizeLanguageCode(targetLang);
  if (!normalized || normalized === 'nb' || hasNativeDictionary(normalized)) return false;
  if (isGoogleTranslatedHost()) return false;
  const url = `https://translate.google.com/translate?sl=nb&tl=${encodeURIComponent(normalized)}&u=${encodeURIComponent(window.location.href)}`;
  window.location.assign(url);
  return true;
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
  const translatedTo = normalizeLanguageCode(params.get('_x_tr_tl'));

  const keys = Array.from(params.keys());
  keys.forEach((key) => {
    if (key.startsWith('_x_tr_')) params.delete(key);
  });

  if (translatedTo && isSupportedLanguage(translatedTo)) {
    params.set('lang', translatedTo);
  }

  const query = params.toString();
  return `${window.location.protocol}//${originHost}${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
}

function normalizeLanguageCode(value) {
  const raw = String(value || '').trim().toLowerCase();
  if (!raw) return '';
  return raw.split('-')[0];
}

function isSupportedLanguage(code) {
  return supportedLanguages.some((entry) => entry.code === code);
}

function detectBrowserLanguage() {
  const candidates = [
    ...(Array.isArray(navigator.languages) ? navigator.languages : []),
    navigator.language,
    navigator.userLanguage,
  ].filter(Boolean);

  for (const candidate of candidates) {
    const normalized = normalizeLanguageCode(candidate);
    if (isSupportedLanguage(normalized)) return normalized;
  }
  return 'nb';
}

function readGeoCacheCountry() {
  try {
    const raw = safeStorageGet(GEO_CACHE_KEY);
    if (!raw) return '';
    const parsed = JSON.parse(raw);
    if (!parsed || !parsed.country || !parsed.ts) return '';
    if (Date.now() - Number(parsed.ts) > GEO_CACHE_MAX_AGE_MS) return '';
    return String(parsed.country).toUpperCase();
  } catch (_) {
    return '';
  }
}

function writeGeoCacheCountry(countryCode) {
  if (!countryCode) return;
  try {
    safeStorageSet(
      GEO_CACHE_KEY,
      JSON.stringify({ country: String(countryCode).toUpperCase(), ts: Date.now() })
    );
  } catch (_) {
    // Ignore storage failures.
  }
}

function reverseCountryCode(lat, lon) {
  const url = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}&zoom=3`;
  return fetch(url, {
    headers: {
      Accept: 'application/json',
    },
  })
    .then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    })
    .then((payload) => String(payload?.address?.country_code || '').toUpperCase())
    .catch(() => '');
}

function detectCountryCodeFromGeo() {
  const cached = readGeoCacheCountry();
  if (cached) return Promise.resolve(cached);

  if (!navigator.geolocation) return Promise.resolve('');

  return new Promise((resolve) => {
    navigator.geolocation.getCurrentPosition(
      async (position) => {
        const countryCode = await reverseCountryCode(position.coords.latitude, position.coords.longitude);
        if (countryCode) writeGeoCacheCountry(countryCode);
        resolve(countryCode);
      },
      () => resolve(''),
      { enableHighAccuracy: false, timeout: 3500, maximumAge: 10 * 60 * 1000 }
    );
  });
}

function dictForLanguage(lang) {
  const normalized = normalizeLanguageCode(lang);
  if (translations[normalized]) return translations[normalized];
  if (normalized !== 'nb' && isSupportedLanguage(normalized)) return translations.en;
  return translations.nb;
}

function applyTranslations(lang) {
  const dict = dictForLanguage(lang);
  document.querySelectorAll('[data-translate]').forEach((el) => {
    const key = el.getAttribute('data-translate');
    if (key && dict[key]) {
      el.textContent = dict[key];
    }
  });
  document.documentElement.lang = normalizeLanguageCode(lang) || 'nb';
}

function populateSelect(selectElement) {
  if (!selectElement) return;
  selectElement.innerHTML = '';
  supportedLanguages.forEach((entry) => {
    const option = document.createElement('option');
    option.value = entry.code;
    option.textContent = entry.label;
    selectElement.appendChild(option);
  });
}

function populateLangSelects() {
  populateSelect(document.getElementById('lang-select'));
  populateSelect(document.getElementById('news-lang'));
  populateSelect(document.getElementById('article-lang'));
}

async function resolveAutoLanguage() {
  const browserLang = detectBrowserLanguage();
  if (browserLang && isSupportedLanguage(browserLang)) return browserLang;

  const country = await detectCountryCodeFromGeo();
  const geoLang = countryToLanguage[country] || '';
  if (geoLang && isSupportedLanguage(geoLang)) return geoLang;

  return 'nb';
}

async function loadLanguage() {
  const params = new URLSearchParams(window.location.search || '');
  const queryLang = normalizeLanguageCode(params.get('lang'));
  const saved = normalizeLanguageCode(safeStorageGet(LANG_STORAGE_KEY));
  const picked = queryLang && isSupportedLanguage(queryLang) ? queryLang : saved;
  const lang = picked && isSupportedLanguage(picked) ? picked : await resolveAutoLanguage();

  safeStorageSet(LANG_STORAGE_KEY, lang);

  if (queryLang) {
    params.delete('lang');
    const query = params.toString();
    const cleanUrl = `${window.location.pathname}${query ? `?${query}` : ''}${window.location.hash || ''}`;
    window.history.replaceState({}, document.title, cleanUrl);
  }

  const langSelect = document.getElementById('lang-select');
  const newsSelect = document.getElementById('news-lang');
  const articleSelect = document.getElementById('article-lang');

  if (langSelect) langSelect.value = lang;
  if (newsSelect) newsSelect.value = lang;
  if (articleSelect) articleSelect.value = lang;

  applyTranslations(lang);
  return lang;
}

function initLanguage() {
  if (isGoogleTranslatedHost()) {
    const originUrl = buildOriginalUrlFromTranslateProxy();
    if (originUrl) {
      window.location.replace(originUrl);
      return;
    }
  }

  populateLangSelects();
  loadLanguage().then((lang) => {
    if (typeof window.renderNews === 'function') {
      window.renderNews(lang);
    }
  });

  const langSelect = document.getElementById('lang-select');
  if (!langSelect) return;

  langSelect.addEventListener('change', (event) => {
    const selected = normalizeLanguageCode(event.target.value);
    const nextLang = isSupportedLanguage(selected) ? selected : 'nb';
    safeStorageSet(LANG_STORAGE_KEY, nextLang);

    const newsSelect = document.getElementById('news-lang');
    const articleSelect = document.getElementById('article-lang');
    if (newsSelect) newsSelect.value = nextLang;
    if (articleSelect) articleSelect.value = nextLang;

    // Language menu controls on-site language preferences only.
    // Full-page machine translation is intentionally not triggered here.
    applyTranslations(nextLang);
    if (typeof window.renderNews === 'function') {
      window.renderNews(nextLang);
    }
  });
}

function resetLanguagePreference() {
  safeStorageRemove(LANG_STORAGE_KEY);
  window.location.href = window.location.pathname + window.location.search + window.location.hash;
}

window.resetLanguagePreference = resetLanguagePreference;

window.addEventListener('DOMContentLoaded', initLanguage);
