// AdSense loader — integrates with the consent system in consent.js
(function(){
  var CLIENT_ID = 'ca-pub-2847767410024665';
  var scriptLoaded = false;

  function ensureAdSenseScript(callback) {
    if (scriptLoaded) { if (callback) callback(); return; }
    var s = document.createElement('script');
    s.src = 'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=' + CLIENT_ID;
    s.crossOrigin = 'anonymous';
    s.async = true;
    s.onload = function() {
      scriptLoaded = true;
      if (callback) callback();
    };
    s.onerror = function() {
      console.warn('AdSense script failed to load');
    };
    document.head.appendChild(s);
  }

  function loadInto(container) {
    ensureAdSenseScript(function() {
      var slot = container.getAttribute('data-ad-slot') || '';
      container.innerHTML = '';
      var ins = document.createElement('ins');
      ins.className = 'adsbygoogle';
      ins.style.display = 'block';
      ins.setAttribute('data-ad-client', CLIENT_ID);
      if (slot) ins.setAttribute('data-ad-slot', slot);
      ins.setAttribute('data-ad-format', 'auto');
      ins.setAttribute('data-full-width-responsive', 'true');
      container.appendChild(ins);
      try { (window.adsbygoogle = window.adsbygoogle || []).push({}); } catch(e) {}
    });
  }

  window.MatSjekkAds = {
    loadInto: loadInto,
    ensureScript: ensureAdSenseScript
  };
})();
