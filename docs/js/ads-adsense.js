// AdSense loader: injects AdSense script and ad slot into provided container.
// Configure your AdSense client ID below before deploying (e.g. 'ca-pub-xxxxxxxxxxxx').
(function(){
  const ADSENSE_CLIENT = 'REPLACE_WITH_ADSENSE_CLIENT_ID'; // e.g. ca-pub-1234567890123456

  function injectAdSenseScript(){
    if (document.querySelector('script[data-adsense]')) return;
    const s = document.createElement('script');
    s.async = true;
    s.src = 'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js';
    s.setAttribute('data-adsense', '1');
    if (ADSENSE_CLIENT && ADSENSE_CLIENT.indexOf('ca-pub-') === 0){
      s.setAttribute('data-ad-client', ADSENSE_CLIENT);
    }
    document.head.appendChild(s);
  }

  function renderAdSlot(container){
    // Example responsive ad slot markup for AdSense; replace data-ad-slot with your slot ID
    const adSlot = document.createElement('ins');
    adSlot.className = 'adsbygoogle';
    adSlot.style.display = 'block';
    adSlot.setAttribute('data-ad-client', ADSENSE_CLIENT);
    adSlot.setAttribute('data-ad-slot', container.getAttribute('data-ad-slot') || '');
    adSlot.setAttribute('data-ad-format', 'auto');
    adSlot.setAttribute('data-full-width-responsive', 'true');
    container.innerHTML = '';
    container.appendChild(adSlot);
    try { (adsbygoogle = window.adsbygoogle || []).push({}); } catch(e) { console.warn('adsbygoogle push failed', e); }
  }

  window.MatSjekkAds = window.MatSjekkAds || {};
  window.MatSjekkAds.loadInto = function(container){
    if (!container) return;
    if (!ADSENSE_CLIENT || ADSENSE_CLIENT.indexOf('REPLACE_WITH') === 0){
      // fallback to stub when client ID not configured
      container.innerHTML = '<div class="ad-stub">Sett inn din AdSense client ID i docs/js/ads-adsense.js for å vise annonser.</div>';
      return;
    }
    injectAdSenseScript();
    renderAdSlot(container);
  };

})();
