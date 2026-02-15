// Farmshops client: filters, map, route search and Google/AI area search
(async function () {
  const dataUrl = 'data/farmshops.json';
  const fallbackUrl = 'data/farmshops.example.json';

  const WEST_EUROPE = [
    { code: 'NO', name: 'Norge' },
    { code: 'SE', name: 'Sverige' },
    { code: 'DK', name: 'Danmark' },
    { code: 'FI', name: 'Finland' },
    { code: 'DE', name: 'Tyskland' },
    { code: 'NL', name: 'Nederland' },
    { code: 'BE', name: 'Belgia' },
    { code: 'FR', name: 'Frankrike' },
    { code: 'IT', name: 'Italia' },
    { code: 'PT', name: 'Portugal' },
    { code: 'ES', name: 'Spania' },
    { code: 'GB', name: 'Storbritannia' },
    { code: 'IE', name: 'Irland' },
    { code: 'AT', name: 'Østerrike' },
    { code: 'CH', name: 'Sveits' },
    { code: 'LU', name: 'Luxembourg' },
  ];

  const countryAliases = {
    no: 'NO', norge: 'NO', norway: 'NO',
    se: 'SE', sverige: 'SE', sweden: 'SE',
    dk: 'DK', danmark: 'DK', denmark: 'DK',
    fi: 'FI', finland: 'FI',
    de: 'DE', tyskland: 'DE', germany: 'DE', deutschland: 'DE',
    nl: 'NL', nederland: 'NL', netherlands: 'NL',
    be: 'BE', belgia: 'BE', belgium: 'BE',
    fr: 'FR', frankrike: 'FR', france: 'FR',
    it: 'IT', italia: 'IT', italy: 'IT',
    pt: 'PT', portugal: 'PT',
    es: 'ES', spania: 'ES', spain: 'ES',
    gb: 'GB', uk: 'GB', england: 'GB', storbritannia: 'GB', unitedkingdom: 'GB',
    ie: 'IE', irland: 'IE', ireland: 'IE',
    at: 'AT', østerrike: 'AT', austria: 'AT',
    ch: 'CH', sveits: 'CH', switzerland: 'CH',
    lu: 'LU', luxembourg: 'LU',
  };

  let shops = [];
  let norwayCounties = [];
  let norwayMunicipalities = [];
  let norwayLoaded = false;

  const countrySelect = document.getElementById('countrySelect');
  const regionSelect = document.getElementById('regionSelect');
  const muniSelect = document.getElementById('municipalitySelect');
  const searchEngineSelect = document.getElementById('searchEngine');
  const sortSelect = document.getElementById('sortSelect');
  const searchInput = document.getElementById('searchInput');
  const listEl = document.getElementById('list');
  const mapEl = document.getElementById('map');
  const mapHeightDown = document.getElementById('mapHeightDown');
  const mapHeightUp = document.getElementById('mapHeightUp');
  const myMunicipalityBtn = document.getElementById('myMunicipalityBtn');
  const webSearchBtn = document.getElementById('webSearchBtn');
  const backBtn = document.getElementById('backBtn');

  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  let currentMapHeight = isMobile ? 110 : 400;

  function normalizeCountryCode(raw) {
    const normalized = (raw || '').toString().trim().toLowerCase().replace(/\s+/g, '');
    if (!normalized) return '';
    if (countryAliases[normalized]) return countryAliases[normalized];
    if (normalized.length === 2) return normalized.toUpperCase();
    return '';
  }

  function countryNameByCode(code) {
    const match = WEST_EUROPE.find((entry) => entry.code === code);
    return match ? match.name : code;
  }

  async function loadShops(url) {
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const payload = await response.json();
    return Array.isArray(payload) ? payload : [];
  }

  function normalizeShop(shop) {
    const countryCode = normalizeCountryCode(shop.country || shop.countryCode);
    return {
      ...shop,
      countryCode,
      country: countryCode ? countryNameByCode(countryCode) : (shop.country || '').toString().trim(),
      region: (shop.region || shop.county || shop.state || '').toString().trim(),
      municipality: (shop.municipality || shop.city || '').toString().trim(),
      products: Array.isArray(shop.products) ? shop.products : [],
    };
  }

  async function ensureNorwayGeoData() {
    if (norwayLoaded) return;
    try {
      const [countyRes, muniRes] = await Promise.all([
        fetch('https://ws.geonorge.no/kommuneinfo/v1/fylker', { cache: 'no-cache' }),
        fetch('https://ws.geonorge.no/kommuneinfo/v1/kommuner', { cache: 'no-cache' }),
      ]);
      if (!countyRes.ok || !muniRes.ok) throw new Error('Geonorge API unavailable');

      const countiesPayload = await countyRes.json();
      const municipalitiesPayload = await muniRes.json();

      norwayCounties = (Array.isArray(countiesPayload) ? countiesPayload : [])
        .map((item) => ({
          code: (item.fylkesnummer || '').toString().padStart(2, '0'),
          name: item.fylkesnavn || '',
        }))
        .filter((item) => item.code && item.name)
        .sort((a, b) => a.name.localeCompare(b.name, 'nb'));

      norwayMunicipalities = (Array.isArray(municipalitiesPayload) ? municipalitiesPayload : [])
        .map((item) => {
          const municipalityCode = (item.kommunenummer || '').toString().padStart(4, '0');
          return {
            code: municipalityCode,
            countyCode: municipalityCode.slice(0, 2),
            name: item.kommunenavnNorsk || item.kommunenavn || '',
          };
        })
        .filter((item) => item.code && item.name)
        .sort((a, b) => a.name.localeCompare(b.name, 'nb'));

      norwayLoaded = true;
    } catch (error) {
      console.warn('Could not load full Norway county/municipality list from Geonorge.', error);
      norwayCounties = [];
      norwayMunicipalities = [];
      norwayLoaded = false;
    }
  }

  function unique(values) {
    return [...new Set(values.filter(Boolean))].sort((a, b) => a.localeCompare(b, 'nb'));
  }

  function selectedText(selectEl) {
    return selectEl?.selectedOptions?.[0]?.textContent?.trim() || '';
  }

  function populateCountries() {
    countrySelect.innerHTML = '<option value="">Velg land</option>' +
      WEST_EUROPE.map((country) => `<option value="${country.code}">${country.name}</option>`).join('');
  }

  async function populateRegions(countryCode) {
    if (countryCode === 'NO') {
      await ensureNorwayGeoData();
      if (norwayCounties.length) {
        regionSelect.innerHTML = '<option value="">Velg fylke</option>' +
          norwayCounties.map((county) => `<option value="${county.code}">${county.name}</option>`).join('');
      } else {
        regionSelect.innerHTML = '<option value="">Velg fylke/region</option>';
      }
      muniSelect.innerHTML = '<option value="">Velg kommune</option>';
      return;
    }

    const regions = unique(
      shops
        .filter((shop) => !countryCode || shop.countryCode === countryCode)
        .map((shop) => shop.region)
    );

    regionSelect.innerHTML = '<option value="">Velg fylke/region</option>' +
      regions.map((region) => `<option value="${region}">${region}</option>`).join('');
    muniSelect.innerHTML = '<option value="">Velg kommune</option>';
  }

  async function populateMunicipalities(countryCode, regionValue) {
    if (countryCode === 'NO') {
      await ensureNorwayGeoData();
      const municipalities = norwayMunicipalities.filter((municipality) =>
        !regionValue || municipality.countyCode === regionValue
      );
      muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
        municipalities.map((municipality) => `<option value="${municipality.code}">${municipality.name}</option>`).join('');
      return;
    }

    const municipalities = unique(
      shops
        .filter((shop) => (!countryCode || shop.countryCode === countryCode) && (!regionValue || shop.region === regionValue))
        .map((shop) => shop.municipality)
    );

    muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
      municipalities.map((municipality) => `<option value="${municipality}">${municipality}</option>`).join('');
  }

  function sortShops(items) {
    const mode = sortSelect ? sortSelect.value : 'name_asc';
    const sorted = [...items].sort((left, right) =>
      (left?.name || '').localeCompare((right?.name || ''), 'nb')
    );
    if (mode === 'name_desc') sorted.reverse();
    return sorted;
  }

  // init map
  const map = L.map('map').setView([59.9, 10.7], 5);
  window._leafletMap = map;
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: '© OpenStreetMap contributors',
  }).addTo(map);
  const markers = L.layerGroup().addTo(map);

  function renderList(filtered) {
    listEl.innerHTML = '';
    markers.clearLayers();

    if (!filtered.length) {
      const empty = document.createElement('div');
      empty.className = 'item';
      empty.textContent = 'Ingen lokale treff i datasettet. Bruk web-søk (Google/AI) for flere resultater.';
      listEl.appendChild(empty);
      return;
    }

    const ordered = sortShops(filtered);
    ordered.forEach((shop) => {
      const div = document.createElement('div');
      div.className = 'item';
      const products = (shop.products || []).join(', ');
      div.innerHTML = `<strong>${shop.name}</strong><br>${shop.address || ''} ${shop.municipality || ''}, ${shop.region || ''}<br>Produkter: ${products}<br><a href='${shop.website}' target='_blank' rel='noopener'>Nettside</a>`;
      listEl.appendChild(div);

      if (shop.lat && shop.lon) {
        const marker = L.marker([shop.lat, shop.lon]).bindPopup(`<strong>${shop.name}</strong><br>${shop.address || ''}`);
        markers.addLayer(marker);
      }
    });

    if (markers.getLayers().length) {
      map.fitBounds(markers.getBounds(), { maxZoom: 12 });
    }
  }

  function filterShops() {
    const countryCode = countrySelect.value;
    const regionValue = regionSelect.value;
    const municipalityValue = muniSelect.value;
    const regionText = selectedText(regionSelect);
    const municipalityText = selectedText(muniSelect);
    const query = searchInput.value.trim().toLowerCase();

    let filtered = shops.filter((shop) => {
      const countryMatch = !countryCode || shop.countryCode === countryCode;
      const regionMatch = !regionValue || (countryCode === 'NO'
        ? (shop.region || '').toLowerCase() === (regionText || '').toLowerCase()
        : shop.region === regionValue);
      const municipalityMatch = !municipalityValue || (countryCode === 'NO'
        ? (shop.municipality || '').toLowerCase() === (municipalityText || '').toLowerCase()
        : shop.municipality === municipalityValue);
      return countryMatch && regionMatch && municipalityMatch;
    });

    if (query) {
      filtered = filtered.filter((shop) =>
        (shop.name || '').toLowerCase().includes(query) ||
        (shop.products || []).join(' ').toLowerCase().includes(query)
      );
    }

    renderList(filtered);
    return filtered;
  }

  async function reverseGeocodeMunicipality(lat, lon) {
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

  async function chooseBestMunicipality(geo) {
    if (!geo) return;

    if (geo.countryCode && [...countrySelect.options].some((option) => option.value === geo.countryCode)) {
      countrySelect.value = geo.countryCode;
      await populateRegions(geo.countryCode);
    }

    if (geo.countryCode === 'NO') {
      if (geo.region && norwayCounties.length) {
        const countyMatch = norwayCounties.find((county) =>
          county.name.toLowerCase().includes(geo.region.toLowerCase()) ||
          geo.region.toLowerCase().includes(county.name.toLowerCase())
        );
        if (countyMatch) {
          regionSelect.value = countyMatch.code;
        }
      }

      await populateMunicipalities(countrySelect.value, regionSelect.value);

      if (geo.municipality && norwayMunicipalities.length) {
        const municipalityMatch = norwayMunicipalities.find((municipality) =>
          municipality.name.toLowerCase().includes(geo.municipality.toLowerCase()) ||
          geo.municipality.toLowerCase().includes(municipality.name.toLowerCase())
        );
        if (municipalityMatch) {
          muniSelect.value = municipalityMatch.code;
        }
      }
    } else {
      if (geo.region) {
        const regionMatch = [...regionSelect.options].find((option) =>
          (option.value || '').toLowerCase().includes(geo.region.toLowerCase()) ||
          geo.region.toLowerCase().includes((option.value || '').toLowerCase())
        );
        if (regionMatch) {
          regionSelect.value = regionMatch.value;
        }
      }

      await populateMunicipalities(countrySelect.value, regionSelect.value);

      if (geo.municipality) {
        const municipalityMatch = [...muniSelect.options].find((option) =>
          (option.value || '').toLowerCase().includes(geo.municipality.toLowerCase()) ||
          geo.municipality.toLowerCase().includes((option.value || '').toLowerCase())
        );
        if (municipalityMatch) {
          muniSelect.value = municipalityMatch.value;
        }
      }
    }

    filterShops();
  }

  function runAreaWebSearch() {
    const country = selectedText(countrySelect);
    const region = selectedText(regionSelect);
    const municipality = selectedText(muniSelect);
    const query = searchInput.value.trim();

    const composed = [
      query || 'gårdsbutikk',
      '(gårdsbutikk OR gårdsutsalg OR "farm shop")',
      municipality,
      region,
      country,
      '-oppskrift -meny -restaurant -wikipedia',
    ].filter(Boolean).join(' ');
    const engine = searchEngineSelect ? searchEngineSelect.value : 'google';
    const url = engine === 'ai'
      ? `https://www.perplexity.ai/search/new?q=${encodeURIComponent(composed)}`
      : `https://www.google.com/search?q=${encodeURIComponent(composed)}`;
    window.open(url, '_blank', 'noopener');
  }

  async function geocode(query) {
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`;
    const response = await fetch(url);
    const payload = await response.json();
    return payload[0];
  }

  async function findAlongRoute(from, to) {
    if (!from || !to) return;

    const fromPoint = await geocode(from);
    const toPoint = await geocode(to);
    if (!fromPoint || !toPoint) {
      alert('Kunne ikke finne adresser');
      return;
    }

    const osrmUrl = `https://router.project-osrm.org/route/v1/driving/${fromPoint.lon},${fromPoint.lat};${toPoint.lon},${toPoint.lat}?overview=full&geometries=geojson`;
    let routeGeom = null;
    try {
      const routeResponse = await fetch(osrmUrl);
      const routePayload = await routeResponse.json();
      if (routePayload.routes && routePayload.routes[0]) {
        routeGeom = routePayload.routes[0].geometry;
      }
    } catch (error) {
      console.warn('OSRM failed', error);
    }

    if (!routeGeom) {
      routeGeom = { type: 'LineString', coordinates: [[+fromPoint.lon, +fromPoint.lat], [+toPoint.lon, +toPoint.lat]] };
    }

    const line = turf.lineString(routeGeom.coordinates);
    const buffer = turf.buffer(line, 25, { units: 'kilometers' });

    const filtered = shops.filter((shop) => {
      if (!shop.lat || !shop.lon) return false;
      const point = turf.point([shop.lon, shop.lat]);
      return turf.booleanPointInPolygon(point, buffer);
    });

    renderList(filtered);

    if (window._routeLayer) map.removeLayer(window._routeLayer);
    window._routeLayer = L.geoJSON(routeGeom, { style: { color: 'blue', weight: 3 } }).addTo(map);

    const bufferLayer = L.geoJSON(buffer, { style: { color: '#00f', weight: 1, opacity: 0.15 } }).addTo(map);
    setTimeout(() => {
      if (bufferLayer) map.removeLayer(bufferLayer);
    }, 10000);

    if (markers.getLayers().length) map.fitBounds(markers.getBounds(), { maxZoom: 12 });
  }

  countrySelect.addEventListener('change', async () => {
    await populateRegions(countrySelect.value);
    await populateMunicipalities(countrySelect.value, '');
    filterShops();
  });

  regionSelect.addEventListener('change', async () => {
    await populateMunicipalities(countrySelect.value, regionSelect.value);
    filterShops();
  });

  muniSelect.addEventListener('change', filterShops);
  if (sortSelect) sortSelect.addEventListener('change', filterShops);
  searchInput.addEventListener('input', filterShops);

  document.getElementById('resetBtn').addEventListener('click', async () => {
    countrySelect.value = '';
    regionSelect.value = '';
    muniSelect.value = '';
    searchInput.value = '';
    if (sortSelect) sortSelect.value = 'name_asc';
    await populateRegions('');
    await populateMunicipalities('', '');
    filterShops();
  });

  document.getElementById('routeBtn').addEventListener('click', () => {
    const from = document.getElementById('routeFrom').value;
    const to = document.getElementById('routeTo').value;
    findAlongRoute(from, to);
  });

  if (myMunicipalityBtn && navigator.geolocation) {
    myMunicipalityBtn.addEventListener('click', () => {
      navigator.geolocation.getCurrentPosition(async (position) => {
        try {
          const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
          await chooseBestMunicipality(geo);
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
    mapHeightDown.addEventListener('click', () => applyMapHeight(currentMapHeight - 30));
  }
  if (mapHeightUp) {
    mapHeightUp.addEventListener('click', () => applyMapHeight(currentMapHeight + 30));
  }

  try {
    shops = (await loadShops(dataUrl)).map(normalizeShop);
    if (shops.length === 0) {
      shops = (await loadShops(fallbackUrl)).map(normalizeShop);
    }
  } catch (error) {
    console.error('Failed to load data/farmshops.json, falling back to example', error);
    try {
      shops = (await loadShops(fallbackUrl)).map(normalizeShop);
    } catch (_) {
      shops = [];
    }
  }

  populateCountries();
  await populateRegions('');
  await populateMunicipalities('', '');
  renderList(shops);
})();
