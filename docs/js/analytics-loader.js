// Consent-gated Google Analytics (GA4) loader for Matsjekk
(function(window){
  var measurementId = 'G-9WY28H5L81';

  function load(measurementId){
    if (!measurementId) return;
    if (document.querySelector('script[data-ga="1"]')) return;
    var s = document.createElement('script');
    s.async = true;
    s.dataset.ga = '1';
    s.src = 'https://www.googletagmanager.com/gtag/js?id=' + measurementId;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    window.gtag = function(){ dataLayer.push(arguments); };
    gtag('js', new Date());
    gtag('config', measurementId, { 'send_page_view': true });
  }

  window.MatSjekkAnalytics = {
    load: load,
    measurementId: measurementId
  };
})(window);
