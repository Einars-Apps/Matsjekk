// Simple client-side consent + ad loader utility used by the site.
(function(){
  function setConsent(value){
    localStorage.setItem('matsjekk_consent', value);
    const banner = document.getElementById('cookie-consent');
    if (banner) banner.style.display = 'none';
    if (value === 'yes') {
      // Load analytics (consent-gated)
      if (window.MatSjekkAnalytics && typeof window.MatSjekkAnalytics.load === 'function') {
        try { window.MatSjekkAnalytics.load(window.MatSjekkAnalytics.measurementId); } catch(e) {}
      }
      loadAds();
    }
  }

  function loadAds(){
    // Find ad boxes and load scripts if data-ad-src is set
    document.querySelectorAll('.ad-box').forEach(function(el){
      const src = el.getAttribute('data-ad-src');
      if (src) {
        const s = document.createElement('script');
        s.src = src;
        s.async = true;
        el.innerHTML = '';
        el.appendChild(s);
      } else {
        // If no external script is provided, try loading the local ads loader
        if (window.MatSjekkAds && typeof window.MatSjekkAds.loadInto === 'function'){
          window.MatSjekkAds.loadInto(el);
        } else {
          el.innerHTML = '<div class="ad-placeholder">Reklame vil vises her etter samtykke.</div>';
        }
      }
    });
  }

  function renderBanner(){
    if (document.getElementById('cookie-consent')) return;
    const banner = document.createElement('div');
    banner.id = 'cookie-consent';
    banner.className = 'cookie-banner';
    banner.innerHTML = `
      <div class="cookie-inner">
        <p>Vi bruker informasjonskapsler for å vise relevante annonser og forbedre nettstedet. Godtar du bruk av cookies?</p>
        <div class="cookie-actions">
          <button id="cookie-accept" class="btn btn-primary">Aksepter</button>
          <button id="cookie-decline" class="btn">Avslå</button>
          <a href="privacy.html" class="btn small">Les mer</a>
        </div>
      </div>`;
    document.body.appendChild(banner);
    document.getElementById('cookie-accept').addEventListener('click', function(){ setConsent('yes'); });
    document.getElementById('cookie-decline').addEventListener('click', function(){ setConsent('no'); });
  }

  // Expose a small API so external CMP libraries can call into us.
  window.MatSjekkConsent = {
    setConsent: setConsent,
    loadAds: loadAds
  };

  document.addEventListener('DOMContentLoaded', function(){
    const consent = localStorage.getItem('matsjekk_consent');
    if (consent === 'yes') {
      // ensure analytics + ads load if consent already given
      if (window.MatSjekkAnalytics && typeof window.MatSjekkAnalytics.load === 'function') {
        try { window.MatSjekkAnalytics.load(window.MatSjekkAnalytics.measurementId); } catch(e) {}
      }
      loadAds();
    } else if (consent === 'no') {
      // user declined: do nothing
    } else {
      renderBanner();
    }
  });

})();
