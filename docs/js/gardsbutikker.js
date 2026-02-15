// Simple client to load farmshops dataset and display filters, list and map
(async function(){
  const dataUrl = 'data/farmshops.json';
  const fallbackUrl = 'data/farmshops.example.json';
  let shops = [];
  async function loadShops(url) {
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const payload = await response.json();
    return Array.isArray(payload) ? payload : [];
  }

  function normalizeShop(shop) {
    return {
      ...shop,
      country: (shop.country || shop.countryCode || '').toString().trim(),
      region: (shop.region || shop.county || shop.state || '').toString().trim(),
      municipality: (shop.municipality || shop.city || '').toString().trim(),
      products: Array.isArray(shop.products) ? shop.products : [],
    };
  }

  try {
    shops = (await loadShops(dataUrl)).map(normalizeShop);
    if (shops.length === 0) {
      shops = (await loadShops(fallbackUrl)).map(normalizeShop);
    }
  } catch (e) {
    console.error('Failed to load data/farmshops.json, falling back to example', e);
    try {
      shops = (await loadShops(fallbackUrl)).map(normalizeShop);
    } catch (_) {
      shops = [];
    }
  }

  const countrySelect=document.getElementById('countrySelect');
  const regionSelect=document.getElementById('regionSelect');
  const muniSelect=document.getElementById('municipalitySelect');
  const searchEngineSelect=document.getElementById('searchEngine');
  const sortSelect=document.getElementById('sortSelect');
  const searchInput=document.getElementById('searchInput');
  const listEl=document.getElementById('list');
  const mapEl=document.getElementById('map');
  const mapHeightDown=document.getElementById('mapHeightDown');
  const mapHeightUp=document.getElementById('mapHeightUp');
  const myMunicipalityBtn=document.getElementById('myMunicipalityBtn');
  const webSearchBtn=document.getElementById('webSearchBtn');
  const backBtn=document.getElementById('backBtn');

  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  let currentMapHeight = isMobile ? 110 : 400;
  const minMapHeight = 110;
  const maxMapHeight = 600;
  const mapStep = 30;

  function applyMapHeight(nextHeight){
    currentMapHeight = Math.max(minMapHeight, Math.min(maxMapHeight, nextHeight));
    if (mapEl) {
      mapEl.style.height = `${currentMapHeight}px`;
    }
    if (window._leafletMap) {
      window._leafletMap.invalidateSize();
    }
  }

  applyMapHeight(currentMapHeight);

  const map=L.map('map').setView([59.9,10.7],5);
  window._leafletMap = map;
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:18,attribution:'© OpenStreetMap contributors'}).addTo(map);
  const markers=L.layerGroup().addTo(map);

  const defaultCountries = ['Norge', 'Sverige', 'Danmark', 'Finland', 'Tyskland', 'Nederland', 'Frankrike', 'Italia', 'Portugal', 'Spania', 'Storbritannia'];
  const defaultRegions = ['Oslo', 'Viken', 'Vestland', 'Trøndelag', 'Stockholm', 'Skåne', 'Hovedstaden', 'Greater London'];
  const defaultMunicipalities = ['Oslo', 'Bergen', 'Trondheim', 'Drammen', 'Stockholm', 'København', 'London'];

  function unique(values){ return [...new Set(values.filter(Boolean))].sort(); }

  function populateCountries(){
    const countries=unique(shops.map(s=>s.country));
    const source = countries.length ? countries : defaultCountries;
    countrySelect.innerHTML='<option value="">Velg land</option>' + source.map(c=>`<option>${c}</option>`).join('');
  }

  function populateRegions(country){
    const regions=unique(shops.filter(s=>!country||s.country===country).map(s=>s.region));
    const source = regions.length ? regions : defaultRegions;
    regionSelect.innerHTML='<option value="">Velg fylke/region</option>' + source.map(r=>`<option>${r}</option>`).join('');
    muniSelect.innerHTML='<option value="">Velg kommune</option>';
  }

  function populateMunicipalities(country,region){
    const munis=unique(shops.filter(s=>(!country||s.country===country)&&(!region||s.region===region)).map(s=>s.municipality));
    const source = munis.length ? munis : defaultMunicipalities;
    muniSelect.innerHTML='<option value="">Velg kommune</option>' + source.map(m=>`<option>${m}</option>`).join('');
  }

  function sortShops(items){
    const mode = sortSelect ? sortSelect.value : 'name_asc';
    const sorted = [...items].sort((left, right) => {
      const a = (left?.name || '').toLowerCase();
      const b = (right?.name || '').toLowerCase();
      return a.localeCompare(b, 'nb');
    });
    if (mode === 'name_desc') {
      sorted.reverse();
    }
    return sorted;
  }

  function renderList(filtered){
    listEl.innerHTML='';
    markers.clearLayers();
    if (!filtered.length) {
      const empty=document.createElement('div');
      empty.className='item';
      empty.textContent='Ingen lokale treff i datasettet. Bruk web-søk (Google/AI) for flere resultater.';
      listEl.appendChild(empty);
      return;
    }
    const ordered = sortShops(filtered);
    ordered.forEach(s=>{
      const div=document.createElement('div'); div.className='item';
      const products = (s.products || []).join(', ');
      div.innerHTML=`<strong>${s.name}</strong><br>${s.address||''} ${s.municipality||''}, ${s.region||''}<br>Produkter: ${products}<br><a href='${s.website}' target='_blank'>Nettside</a>`;
      listEl.appendChild(div);
      if(s.lat && s.lon){
        const m=L.marker([s.lat,s.lon]).bindPopup(`<strong>${s.name}</strong><br>${s.address||''}`);
        markers.addLayer(m);
      }
    });
    if(markers.getLayers().length) map.fitBounds(markers.getBounds(),{maxZoom:12});
  }

  function filterShops(){
    const country=countrySelect.value;
    const region=regionSelect.value;
    const muni=muniSelect.value;
    const q=searchInput.value.trim().toLowerCase();
    let filtered=shops.filter(s=>(!country||s.country===country)&&(!region||s.region===region)&&(!muni||s.municipality===muni));
    if(q){ filtered=filtered.filter(s=>(s.name || '').toLowerCase().includes(q) || (s.products || []).join(' ').toLowerCase().includes(q)); }
    renderList(filtered);
    return filtered;
  }

  async function reverseGeocodeMunicipality(lat, lon){
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${encodeURIComponent(lat)}&lon=${encodeURIComponent(lon)}&zoom=10&addressdetails=1`;
    const response = await fetch(url);
    if (!response.ok) return null;
    const payload = await response.json();
    const address = payload?.address || {};
    return {
      countryCode: (address.country_code || '').toUpperCase(),
      region: address.county || address.state || address.region || '',
      municipality: address.municipality || address.city || address.town || address.village || '',
    };
  }

  function chooseBestMunicipality(geo){
    if (!geo) return;
    if (geo.countryCode && [...countrySelect.options].some(o => o.value === geo.countryCode)) {
      countrySelect.value = geo.countryCode;
      populateRegions(geo.countryCode);
    }
    if (geo.region) {
      const regionMatch = [...regionSelect.options].find(o =>
        (o.value || '').toLowerCase().includes(geo.region.toLowerCase()) ||
        geo.region.toLowerCase().includes((o.value || '').toLowerCase())
      );
      if (regionMatch) {
        regionSelect.value = regionMatch.value;
      }
    }
    populateMunicipalities(countrySelect.value, regionSelect.value);
    if (geo.municipality) {
      const muniMatch = [...muniSelect.options].find(o =>
        (o.value || '').toLowerCase().includes(geo.municipality.toLowerCase()) ||
        geo.municipality.toLowerCase().includes((o.value || '').toLowerCase())
      );
      if (muniMatch) {
        muniSelect.value = muniMatch.value;
      }
    }
    filterShops();
  }

  function runAreaWebSearch(){
    const country = countrySelect.value;
    const region = regionSelect.value;
    const muni = muniSelect.value;
    const query = searchInput.value.trim();
    const composed = [query || 'gårdsbutikk', muni, region, country].filter(Boolean).join(' ');
    const engine = searchEngineSelect ? searchEngineSelect.value : 'google';
    const url = engine === 'ai'
      ? `https://www.perplexity.ai/search/new?q=${encodeURIComponent(composed)}`
      : `https://www.google.com/search?q=${encodeURIComponent(composed)}`;
    window.open(url, '_blank', 'noopener');
  }

  countrySelect.addEventListener('change',()=>{ populateRegions(countrySelect.value); populateMunicipalities(countrySelect.value,''); filterShops(); });
  regionSelect.addEventListener('change',()=>{ populateMunicipalities(countrySelect.value,regionSelect.value); filterShops(); });
  muniSelect.addEventListener('change',filterShops);
  if (sortSelect) sortSelect.addEventListener('change', filterShops);
  searchInput.addEventListener('input',()=>{ filterShops(); });

  document.getElementById('resetBtn').addEventListener('click',()=>{ countrySelect.value=''; regionSelect.value=''; muniSelect.value=''; searchInput.value=''; if (sortSelect) sortSelect.value='name_asc'; populateRegions(''); populateMunicipalities('',''); filterShops(); });

  async function geocode(q){
    const url=`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(q)}`;
    const res=await fetch(url); const js=await res.json(); return js[0];
  }

  async function findAlongRoute(from,to){
    if(!from||!to) return;
    const f=await geocode(from); const t=await geocode(to);
    if(!f||!t){ alert('Kunne ikke finne adresser'); return; }
    const osrmUrl=`https://router.project-osrm.org/route/v1/driving/${f.lon},${f.lat};${t.lon},${t.lat}?overview=full&geometries=geojson`;
    let routeGeom=null;
    try{ const r=await fetch(osrmUrl); const j=await r.json(); if(j.routes && j.routes[0]) routeGeom=j.routes[0].geometry; }
    catch(e){ console.warn('OSRM failed',e); }
    if(!routeGeom){ routeGeom={type:'LineString',coordinates:[[+f.lon,+f.lat],[+t.lon,+t.lat]]}; }
    const line=turf.lineString(routeGeom.coordinates);
    const buffer=turf.buffer(line,25, {units:'kilometers'});
    const filtered=shops.filter(s=>{
      if(!s.lat||!s.lon) return false;
      const pt=turf.point([s.lon,s.lat]);
      return turf.booleanPointInPolygon(pt,buffer);
    });
    renderList(filtered);
    if(window._routeLayer) map.removeLayer(window._routeLayer);
    window._routeLayer=L.geoJSON(routeGeom,{style:{color:'blue',weight:3}}).addTo(map);
    const bufLayer=L.geoJSON(buffer,{style:{color:'#00f',weight:1,opacity:0.15}}).addTo(map);
    setTimeout(()=>{ if(bufLayer) map.removeLayer(bufLayer); },10000);
    if(markers.getLayers().length) map.fitBounds(markers.getBounds(),{maxZoom:12});
  }

  document.getElementById('routeBtn').addEventListener('click',()=>{ const f=document.getElementById('routeFrom').value; const t=document.getElementById('routeTo').value; findAlongRoute(f,t); });

  if (myMunicipalityBtn && navigator.geolocation) {
    myMunicipalityBtn.addEventListener('click', () => {
      navigator.geolocation.getCurrentPosition(async (position) => {
        try {
          const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
          chooseBestMunicipality(geo);
        } catch (_) {
          alert('Fant ikke kommune fra posisjon.');
        }
      }, () => {
        alert('Kunne ikke hente posisjon. Sjekk stedstjenester i nettleseren.');
      }, { enableHighAccuracy: true, timeout: 10000 });
    });
  }

  if (webSearchBtn) {
    webSearchBtn.addEventListener('click', runAreaWebSearch);
  }

  if (backBtn) {
    backBtn.addEventListener('click', () => {
      if (window.history.length > 1) {
        window.history.back();
      } else {
        window.location.href = 'index.html';
      }
    });
  }

  if (mapHeightDown) {
    mapHeightDown.addEventListener('click', () => applyMapHeight(currentMapHeight - mapStep));
  }
  if (mapHeightUp) {
    mapHeightUp.addEventListener('click', () => applyMapHeight(currentMapHeight + mapStep));
  }

  populateCountries(); populateRegions(''); populateMunicipalities('','');
  renderList(shops);

})();
