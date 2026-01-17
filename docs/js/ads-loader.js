// Minimal ads loader used as a safe stub before real ad network integration
(function(){
  function loadInto(container){
    // Example placeholder content. Replace with network-specific code after obtaining account.
    container.innerHTML = `
      <div class="ad-stub">
        <div class="ad-stub-title">Annonse (stub)</div>
        <div class="ad-stub-body">Dette er en annonse‑plassering. Når du har en annonsekonto, bytt denne stubben med nettverkskoden og sett data-ad-src på .ad-box.</div>
      </div>`;
  }

  window.MatSjekkAds = {
    loadInto: loadInto
  };
})();
