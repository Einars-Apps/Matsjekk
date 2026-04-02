(function () {
  'use strict';

  const config = {
    appStoreUrl: 'https://apps.apple.com/app/mat-sjekk/id6759604589',
    googlePlayUrl: 'https://play.google.com/store/apps/details?id=com.ebors.matsjekk',
    appGalleryUrl: 'https://appgallery.huawei.com/search/Mat%20Sjekk',
    appLanguageNames: [
      'Norsk',
      'English',
      'Svenska',
      'Dansk',
      'Suomi',
      'Deutsch',
      'Nederlands',
      'Francais',
      'Italiano',
      'Portugues',
      'Espanol',
      '한국어',
      'Polski',
      'Русский',
      '中文',
      'العربية',
      'ภาษาไทย'
    ]
  };

  function applySiteConfig(root) {
    const scope = root || document;

    scope.querySelectorAll('[data-app-store-link]').forEach((el) => {
      el.setAttribute('href', config.appStoreUrl);
    });
    scope.querySelectorAll('[data-google-play-link]').forEach((el) => {
      el.setAttribute('href', config.googlePlayUrl);
    });
    scope.querySelectorAll('[data-app-gallery-link]').forEach((el) => {
      el.setAttribute('href', config.appGalleryUrl);
    });
    scope.querySelectorAll('[data-app-language-count]').forEach((el) => {
      el.textContent = String(config.appLanguageNames.length);
    });
    scope.querySelectorAll('[data-app-language-list]').forEach((el) => {
      el.textContent = config.appLanguageNames.join(', ');
    });
  }

  window.MatSjekkSiteConfig = config;
  window.MatSjekkApplySiteConfig = applySiteConfig;

  window.addEventListener('DOMContentLoaded', function () {
    applySiteConfig(document);
  });
})();