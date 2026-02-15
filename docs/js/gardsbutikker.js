// Farmshops client: filters, map, route search and Google/AI area search
(async function () {
  const dataUrl = 'data/farmshops.json';
  const fallbackUrl = 'data/farmshops.example.json';
  let activeFiltered = [];
  let filterRunId = 0;
  const webCandidateCache = new Map();

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

  const NORWAY_MERGED_MUNICIPALITIES = {
    asker: ['asker', 'hurum', 'røyken', 'royken'],
    hurum: ['asker', 'hurum', 'røyken', 'royken'],
    'røyken': ['asker', 'hurum', 'røyken', 'royken'],
    royken: ['asker', 'hurum', 'røyken', 'royken'],
  };

  const TRUSTED_NORWAY_SEEDS = [
    { name: 'Bergvang Gård', municipality: 'Asker', region: 'Akershus', address: 'Bergvangveien 21, Asker', products: ['Egg', 'Kjøtt', 'Honning'], website: 'https://www.google.com/search?q=Bergvang+G%C3%A5rd+Asker' },
    { name: 'Grønnsletta Gård', municipality: 'Hurum', region: 'Akershus', address: 'Tofteveien 40, Hurum/Asker', products: ['Lam', 'Pølser', 'Honning', 'Egg'], website: 'https://www.google.com/search?q=Gr%C3%B8nnsletta+G%C3%A5rd+Hurum' },
    { name: 'Hurum Hjort – Solberg Gård', municipality: 'Hurum', region: 'Akershus', address: 'Solbergveien 2, Hurum/Asker', products: ['Hjortekjøtt'], website: 'https://www.google.com/search?q=Hurum+Hjort+Solberg+G%C3%A5rd' },
    { name: 'Sand Gård', municipality: 'Hurum', region: 'Akershus', address: 'Storengene 2/4, Kana', products: ['Bakerivarer', 'Lokale produkter'], website: 'https://www.google.com/search?q=Sand+G%C3%A5rd+Kana' },
    { name: 'Biffgården', municipality: 'Hurum', region: 'Akershus', address: 'Holmsbu-området', products: ['Kjøtt', 'Skinn', 'Ved'], website: 'https://www.google.com/search?q=Biffg%C3%A5rden+Holmsbu' },
    { name: 'Bergsmyrene Gård', municipality: 'Hurum', region: 'Akershus', address: 'Søndre Hurum/Asker', products: ['Grønnsaker'], website: 'https://www.google.com/search?q=Bergsmyrene+G%C3%A5rd' },
    { name: 'Bonden Jens', municipality: 'Røyken', region: 'Akershus', address: 'Hurumveien 13, 3440 Røyken', products: ['Grønnsaker', 'Bær', 'Selvplukk'], website: 'https://www.google.com/search?q=Bonden+Jens+R%C3%B8yken' },
    { name: 'Hyggen Gård / Hyggen Eplemost', municipality: 'Røyken', region: 'Akershus', address: 'Hyggen, Røyken/Asker', products: ['Eplemost', 'Epleprodukter'], website: 'https://www.google.com/search?q=Hyggen+Eplemost' },
    { name: 'Bryggerhuset på Frøtvedt', municipality: 'Røyken', region: 'Akershus', address: 'Røyken-området', products: ['Bakerivarer'], website: 'https://www.google.com/search?q=Bryggerhuset+p%C3%A5+Fr%C3%B8tvedt' },
    { name: 'Syse Gard', municipality: 'Ulvik', region: 'Vestland', address: 'Apalvegen, 5730 Ulvik', products: ['Eplesider', 'Eplemost', 'Frukt'], website: 'https://sysegard.no' },
    { name: 'Ulvik Frukt & Cideri', municipality: 'Ulvik', region: 'Vestland', address: 'Håkastad, Ulvik', products: ['Eplesorter', 'Eplemost', 'Sider'], website: 'https://hakastadsider.no' },
    { name: 'Hardanger Saft- og Siderfabrikk', municipality: 'Ulvik', region: 'Vestland', address: 'Lekve, Ulvik', products: ['Eplemost', 'Sider', 'Saft'], website: 'https://hardangersider.no' },
    { name: 'Voss Gardsslakteri (Selheim Gard)', municipality: 'Voss', region: 'Vestland', address: 'Selheim Gard, Voss', products: ['Kjøtt', 'Spekemat', 'Lam'], website: 'https://www.google.com/search?q=Voss+Gardsslakteri+Selheim+Gard' },
    { name: 'Een Gard', municipality: 'Voss', region: 'Vestland', address: 'Voss-området', products: ['Økologisk kjøtt', 'Lokale produkter'], website: 'https://eengard.no' },
    { name: 'Smalahovetunet', municipality: 'Voss', region: 'Vestland', address: 'Voss', products: ['Spekemat', 'Kjøttprodukter'], website: 'https://smalahovetunet.no' },
    { name: 'Store Ringheim Gardsmat', municipality: 'Voss', region: 'Vestland', address: 'Voss-området', products: ['Gardsmat', 'Lokalmat'], website: 'https://storeringheim.no/gardsmat' },
    { name: 'Evanger Landhandleri', municipality: 'Voss', region: 'Vestland', address: 'Evanger, Voss', products: ['Gardsmat', 'Drikke', 'Lokalvarer'], website: 'https://www.google.com/search?q=Evanger+Landhandleri' },
    { name: 'Voss Gardsmat', municipality: 'Voss', region: 'Vestland', address: 'Vossevangen', products: ['Lokalmat'], website: 'https://www.google.com/search?q=Voss+Gardsmat' },
    { name: 'Kjerland Gardsbutikk', municipality: 'Voss', region: 'Vestland', address: 'Granvin/Voss-området', products: ['Lokalvarer'], website: 'https://www.google.com/search?q=Kjerland+Gardsbutikk' },
  ];

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

  function ensureAiSearchEngineDefault() {
    if (!searchEngineSelect) return;
    const aiOption = [...searchEngineSelect.options].find((option) => option.value === 'ai');
    if (aiOption && searchEngineSelect.options[0]?.value !== 'ai') {
      searchEngineSelect.insertBefore(aiOption, searchEngineSelect.options[0]);
    }
    searchEngineSelect.value = 'ai';
  }

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
    const lat = shop.lat != null ? Number(shop.lat) : null;
    const lon = shop.lon != null ? Number(shop.lon) : null;
    const mapsUrl = (lat != null && lon != null)
      ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${lat},${lon}`)}`
      : '';
    return {
      ...shop,
      countryCode,
      country: countryCode ? countryNameByCode(countryCode) : (shop.country || '').toString().trim(),
      region: (shop.region || shop.county || shop.state || '').toString().trim(),
      municipality: (shop.municipality || shop.city || '').toString().trim(),
      products: Array.isArray(shop.products) ? shop.products : [],
      phone: (shop.phone || '').toString().trim(),
      openingHours: (shop.openingHours || '').toString().trim(),
      category: (shop.category || 'Gårdsutsalg').toString().trim(),
      lat,
      lon,
      mapsUrl,
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

  function municipalityKey(value) {
    return (value || '')
      .toString()
      .trim()
      .toLowerCase()
      .replace(/ø/g, 'o')
      .replace(/æ/g, 'ae')
      .replace(/å/g, 'a')
      .replace(/\s+/g, ' ');
  }

  function municipalityVariants(countryCode, municipalityLabel) {
    const label = (municipalityLabel || '').toString().trim();
    if (!label) return [];
    if (countryCode !== 'NO') return [label];
    const key = municipalityKey(label);
    const aliases = NORWAY_MERGED_MUNICIPALITIES[key] || [label];
    return [...new Set(aliases)];
  }

  function municipalityMatches(shopMunicipality, municipalityTerms) {
    if (!municipalityTerms.length) return true;
    const shopKey = municipalityKey(shopMunicipality || '');
    if (!shopKey) return false;
    return municipalityTerms.some((term) =>
      shopKey === term ||
      shopKey.includes(term) ||
      term.includes(shopKey)
    );
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

  function normalizeKey(value) {
    return (value || '')
      .toString()
      .toLowerCase()
      .replace(/\s+/g, ' ')
      .trim();
  }

  function mergeShopLists(primary, secondary) {
    const seen = new Set();
    const output = [];
    [...primary, ...secondary].forEach((shop) => {
      const key = `${normalizeKey(shop.name)}|${normalizeKey(shop.address)}|${shop.lat || ''}|${shop.lon || ''}`;
      if (seen.has(key)) return;
      seen.add(key);
      output.push(shop);
    });
    return output;
  }

  async function searchNominatim(term, countryCode) {
    const countryParam = countryCode ? `&countrycodes=${encodeURIComponent(countryCode.toLowerCase())}` : '';
    const url = `https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&extratags=1&limit=25${countryParam}&q=${encodeURIComponent(term)}`;
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) return [];
    const payload = await response.json();
    return Array.isArray(payload) ? payload : [];
  }

  function buildWebsiteFallback(name, municipality, region, countryLabel) {
    const query = [
      name,
      municipality,
      region,
      countryLabel,
      'offisiell nettside',
    ].filter(Boolean).join(' ');
    return `https://www.google.com/search?q=${encodeURIComponent(query)}`;
  }

  function normalizeWebsite(url) {
    const value = (url || '').toString().trim();
    if (!value) return '';
    if (/^https?:\/\//i.test(value)) return value;
    if (/^www\./i.test(value)) return `https://${value}`;
    if (/^[a-z0-9.-]+\.[a-z]{2,}(\/.*)?$/i.test(value)) return `https://${value}`;
    return value;
  }

  function isFallbackWebsite(url) {
    return /google\.com\/search\?q=/i.test((url || '').toString());
  }

  function buildStaticMapImage(lat, lon) {
    if (lat == null || lon == null) return '';
    return `https://staticmap.openstreetmap.de/staticmap.php?center=${encodeURIComponent(`${lat},${lon}`)}&zoom=15&size=320x180&markers=${encodeURIComponent(`${lat},${lon},red-pushpin`)}`;
  }

  function buildImageUrlFromTags(tags, lat, lon) {
    const direct = tags.image || tags['image:0'] || tags['contact:image'];
    if (direct && /^https?:\/\//i.test(direct)) return direct;

    const commonsFile = tags.wikimedia_commons || tags['wikimedia:commons'];
    if (commonsFile) {
      const fileName = commonsFile.replace(/^File:/i, '').trim();
      return `https://commons.wikimedia.org/wiki/Special:FilePath/${encodeURIComponent(fileName)}?width=640`;
    }

    if (direct && /^File:/i.test(direct)) {
      const fileName = direct.replace(/^File:/i, '').trim();
      return `https://commons.wikimedia.org/wiki/Special:FilePath/${encodeURIComponent(fileName)}?width=640`;
    }

    return buildStaticMapImage(lat, lon);
  }

  function inferProducts(name, category, existingProducts) {
    if (Array.isArray(existingProducts) && existingProducts.length) return existingProducts;
    const text = `${name || ''} ${category || ''}`.toLowerCase();
    const inferred = [];
    if (/cider|sider/.test(text)) inferred.push('Cider/sider');
    if (/frukt|eple|apple/.test(text)) inferred.push('Frukt og epleprodukter');
    if (/ost|cheese|ysteri/.test(text)) inferred.push('Ost og meieri');
    if (/kjøtt|kjott|meat/.test(text)) inferred.push('Kjøttprodukter');
    if (/egg/.test(text)) inferred.push('Egg');
    if (/honning|honey/.test(text)) inferred.push('Honning');
    return inferred.length ? inferred : ['Lokale gårdsprodukter'];
  }

  function candidateScore(shop) {
    let score = 0;
    const category = (shop.category || '').toLowerCase();
    if (category.includes('farm') || category.includes('gård') || category.includes('gards')) score += 3;
    if (shop.lat != null && shop.lon != null) score += 2;
    if (shop.phone) score += 2;
    if (shop.openingHours) score += 2;
    if (shop.products && shop.products.length) score += 2;
    if (shop.imageUrl) score += 1;
    if (shop.website && !isFallbackWebsite(shop.website)) score += 3;
    if (/restaurant|kafe|cafe|supermarket|grocery/.test(category)) score -= 4;
    return score;
  }

  function keepHighQuality(shop) {
    const text = `${shop.name || ''} ${shop.category || ''} ${shop.address || ''}`.toLowerCase();
    if (/restaurant|kafe|cafe|supermarket|grocery|school|kindergarten|museum|hotel/.test(text)) {
      return false;
    }
    if (/gård|gard|farm|selvplukk|frukt/.test(text) && shop.lat != null && shop.lon != null) {
      return true;
    }
    return candidateScore(shop) >= 3;
  }

  function toSeedShop(seed, countryLabel) {
    const website = normalizeWebsite(seed.website) || buildWebsiteFallback(seed.name, seed.municipality, seed.region, countryLabel);
    return {
      id: `seed-${municipalityKey(seed.name)}`,
      name: seed.name,
      country: countryLabel,
      region: seed.region,
      municipality: seed.municipality,
      products: seed.products || ['Lokale gårdsprodukter'],
      website,
      lat: null,
      lon: null,
      address: seed.address || '',
      phone: '',
      openingHours: '',
      category: 'Gårdsutsalg',
      mapsUrl: seed.address
        ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(seed.address)}`
        : '',
      imageUrl: '',
    };
  }

  function getTrustedSeedCandidates(countryCode, countryLabel, municipalityLabel) {
    if (countryCode !== 'NO' || !municipalityLabel) return [];
    const variants = municipalityVariants(countryCode, municipalityLabel).map((value) => municipalityKey(value));
    const seeds = TRUSTED_NORWAY_SEEDS.filter((entry) => {
      const muniKey = municipalityKey(entry.municipality);
      return variants.includes(muniKey) || variants.some((value) => muniKey.includes(value) || value.includes(muniKey));
    });
    return seeds.map((entry) => toSeedShop(entry, countryLabel));
  }

  function bboxArea(box) {
    if (!box) return 0;
    const latSpan = Math.max(0, box.north - box.south);
    const lonSpan = Math.max(0, box.east - box.west);
    return latSpan * lonSpan;
  }

  function looksLikeFarmOutlet(item) {
    const text = `${item.name || ''} ${item.display_name || ''} ${item.type || ''} ${item.class || ''}`.toLowerCase();
    const strong = [
      'gårdsbutikk', 'gårdsutsalg', 'farm shop', 'farmshop', 'farm store',
      'hofladen', 'ferme', 'vente directe', 'venta directa', 'cider', 'sider',
    ];
    const medium = ['farm', 'gård', 'gard', 'frukt', 'apple', 'local food', 'gardsmat'];
    return strong.some((keyword) => text.includes(keyword)) || medium.some((keyword) => text.includes(keyword));
  }

  function toWebShop(item, municipality, region, countryLabel) {
    const osmTypeMap = { node: 'node', way: 'way', relation: 'relation', N: 'node', W: 'way', R: 'relation' };
    const osmType = osmTypeMap[item.osm_type] || 'node';
    const osmId = item.osm_id || '';
    const name = item.name || (item.display_name || '').split(',')[0] || 'Ukjent gårdsutsalg';
    const lat = item.lat ? Number(item.lat) : null;
    const lon = item.lon ? Number(item.lon) : null;
    const mapsUrl = (lat != null && lon != null)
      ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${lat},${lon}`)}`
      : (osmId ? `https://www.openstreetmap.org/${osmType}/${osmId}` : '');
    const website = normalizeWebsite(item?.extratags?.website || item?.extratags?.['contact:website']) || buildWebsiteFallback(name, municipality, region, countryLabel);
    const category = item?.type || 'Gårdsutsalg';
    const products = inferProducts(name, category, []);
    const imageUrl = buildImageUrlFromTags(item?.extratags || {}, lat, lon);
    return {
      id: `web-${osmType}-${osmId}`,
      name,
      country: countryLabel,
      region,
      municipality,
      products,
      website,
      lat,
      lon,
      address: item.display_name || '',
      phone: item?.extratags?.phone || item?.extratags?.['contact:phone'] || '',
      openingHours: item?.extratags?.opening_hours || '',
      category,
      mapsUrl,
      imageUrl,
    };
  }

  function buildAddressFromTags(tags, fallback = '') {
    const parts = [
      [tags['addr:street'], tags['addr:housenumber']].filter(Boolean).join(' ').trim(),
      tags['addr:postcode'],
      tags['addr:city'] || tags['addr:municipality'] || fallback,
    ].filter(Boolean);
    return parts.join(', ');
  }

  function toOverpassShop(element, municipality, region, countryLabel) {
    const tags = element?.tags || {};
    const lat = element?.lat ?? element?.center?.lat ?? null;
    const lon = element?.lon ?? element?.center?.lon ?? null;
    const osmUrl = `https://www.openstreetmap.org/${element.type}/${element.id}`;
    const name = tags.name || tags.brand || tags.operator || 'Ukjent gårdsutsalg';
    const website = normalizeWebsite(tags.website || tags['contact:website']) || buildWebsiteFallback(name, municipality, region, countryLabel);
    const category = tags.shop || tags.amenity || 'Gårdsutsalg';
    const products = inferProducts(name, category, tags.produce
      ? tags.produce.split(/[;,]/).map((part) => part.trim()).filter(Boolean)
      : []);
    const imageUrl = buildImageUrlFromTags(tags, lat, lon);
    const mapsUrl = (lat != null && lon != null)
      ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${lat},${lon}`)}`
      : osmUrl;
    return {
      id: `web-overpass-${element.type}-${element.id}`,
      name,
      country: countryLabel,
      region,
      municipality,
      products,
      website,
      lat: lat ? Number(lat) : null,
      lon: lon ? Number(lon) : null,
      address: buildAddressFromTags(tags, municipality) || tags.description || municipality,
      phone: tags.phone || tags['contact:phone'] || '',
      openingHours: tags.opening_hours || '',
      category,
      mapsUrl,
      imageUrl,
    };
  }

  async function searchOverpassInBoundingBox({ south, west, north, east }) {
    const overpassQuery = `
[out:json][timeout:25];
(
  node["shop"="farm"](${south},${west},${north},${east});
  way["shop"="farm"](${south},${west},${north},${east});
  relation["shop"="farm"](${south},${west},${north},${east});
  node["shop"="farmshop"](${south},${west},${north},${east});
  way["shop"="farmshop"](${south},${west},${north},${east});
  relation["shop"="farmshop"](${south},${west},${north},${east});
  node["produce"](${south},${west},${north},${east});
  way["produce"](${south},${west},${north},${east});
  relation["produce"](${south},${west},${north},${east});
  node["description"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|selvplukk|frukt",i](${south},${west},${north},${east});
  way["description"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|selvplukk|frukt",i](${south},${west},${north},${east});
  node["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider",i](${south},${west},${north},${east});
  way["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider",i](${south},${west},${north},${east});
  relation["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider",i](${south},${west},${north},${east});
);
out center tags 120;
    `.trim();

    const response = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
      body: overpassQuery,
    });
    if (!response.ok) return [];
    const payload = await response.json();
    return Array.isArray(payload?.elements) ? payload.elements : [];
  }

  async function searchOverpassAroundPoint(lat, lon, radiusMeters = 45000) {
    const overpassQuery = `
[out:json][timeout:25];
(
  node["shop"="farm"](around:${radiusMeters},${lat},${lon});
  way["shop"="farm"](around:${radiusMeters},${lat},${lon});
  relation["shop"="farm"](around:${radiusMeters},${lat},${lon});
  node["shop"="farmshop"](around:${radiusMeters},${lat},${lon});
  way["shop"="farmshop"](around:${radiusMeters},${lat},${lon});
  relation["shop"="farmshop"](around:${radiusMeters},${lat},${lon});
  node["produce"](around:${radiusMeters},${lat},${lon});
  way["produce"](around:${radiusMeters},${lat},${lon});
  relation["produce"](around:${radiusMeters},${lat},${lon});
  node["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider|local farm",i](around:${radiusMeters},${lat},${lon});
  way["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider|local farm",i](around:${radiusMeters},${lat},${lon});
  relation["name"~"gårdsbutikk|gårdsutsalg|farm shop|farmstore|fruktgård|cider|local farm",i](around:${radiusMeters},${lat},${lon});
);
out center tags 150;
    `.trim();

    const response = await fetch('https://overpass-api.de/api/interpreter', {
      method: 'POST',
      headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
      body: overpassQuery,
    });
    if (!response.ok) return [];
    const payload = await response.json();
    return Array.isArray(payload?.elements) ? payload.elements : [];
  }

  async function fetchMunicipalityCenter(countryCode, municipalityLabel, regionLabel) {
    if (!municipalityLabel) return null;
    const variants = municipalityVariants(countryCode, municipalityLabel);
    for (const municipalityName of variants) {
      const hits = await searchNominatim(`${municipalityName} ${regionLabel || ''} ${countryNameByCode(countryCode)}`, countryCode);
      const best = hits.find((item) => item.lat && item.lon);
      if (!best) continue;
      const lat = Number(best.lat);
      const lon = Number(best.lon);
      if (Number.isFinite(lat) && Number.isFinite(lon)) {
        return { lat, lon };
      }
    }
    return null;
  }

  async function fetchMunicipalityBoundingBox(countryCode, municipalityLabel, regionLabel) {
    if (!municipalityLabel) return null;
    const variants = municipalityVariants(countryCode, municipalityLabel);
    const collectedBoxes = [];

    for (const municipalityName of variants) {
      const hits = await searchNominatim(`${municipalityName} ${regionLabel || ''} ${countryNameByCode(countryCode)}`, countryCode);
      const candidates = hits
        .filter((item) => Array.isArray(item.boundingbox) && item.boundingbox.length === 4)
        .map((item) => {
          const [south, north, west, east] = item.boundingbox.map((v) => Number(v));
          return {
            south,
            north,
            west,
            east,
            classType: `${item.class || ''} ${item.type || ''}`.toLowerCase(),
          };
        })
        .filter((box) => [box.south, box.north, box.west, box.east].every((v) => Number.isFinite(v)))
        .sort((left, right) => bboxArea(right) - bboxArea(left));

      const adminCandidate = candidates.find((box) => /boundary|administrative|municipality/.test(box.classType));
      const selected = adminCandidate || candidates[0];
      if (selected) collectedBoxes.push(selected);
    }

    if (!collectedBoxes.length) return null;

    return {
      south: Math.min(...collectedBoxes.map((box) => box.south)),
      north: Math.max(...collectedBoxes.map((box) => box.north)),
      west: Math.min(...collectedBoxes.map((box) => box.west)),
      east: Math.max(...collectedBoxes.map((box) => box.east)),
    };
  }

  async function fetchOverpassMunicipalityCandidates({ countryCode, countryLabel, regionLabel, municipalityLabel }) {
    if (!municipalityLabel) return [];
    const bbox = await fetchMunicipalityBoundingBox(countryCode, municipalityLabel, regionLabel);
    let mapped = [];

    if (bbox) {
      const elements = await searchOverpassInBoundingBox(bbox);
      mapped = elements
        .map((element) => toOverpassShop(element, municipalityLabel, regionLabel, countryLabel))
        .filter((shop) => {
          const syntheticItem = {
            name: shop.name,
            display_name: `${shop.name} ${shop.address || ''}`,
            type: '',
            class: '',
          };
          return looksLikeFarmOutlet(syntheticItem) && keepHighQuality(shop);
        });
    }

    if (mapped.length < 10) {
      const center = await fetchMunicipalityCenter(countryCode, municipalityLabel, regionLabel);
      if (center) {
        const aroundElements = await searchOverpassAroundPoint(center.lat, center.lon, 50000);
        const aroundMapped = aroundElements
          .map((element) => toOverpassShop(element, municipalityLabel, regionLabel, countryLabel))
          .filter((shop) => {
            const syntheticItem = {
              name: shop.name,
              display_name: `${shop.name} ${shop.address || ''}`,
              type: '',
              class: '',
            };
            return looksLikeFarmOutlet(syntheticItem) && keepHighQuality(shop);
          });
        mapped = mergeShopLists(mapped, aroundMapped);
      }
    }

    const unique = mergeShopLists([], mapped)
      .sort((left, right) => candidateScore(right) - candidateScore(left))
      .slice(0, 80);
    return unique;
  }

  async function fetchLiveCandidates({ countryCode, countryLabel, regionLabel, municipalityLabel, query }) {
    const muni = municipalityLabel || '';
    const region = regionLabel || '';
    const country = countryLabel || '';
    const q = query || '';
    const cacheKey = `${countryCode}|${muni}|${region}|${q}`;
      const seedCandidates = getTrustedSeedCandidates(countryCode, country, muni);

    if (webCandidateCache.has(cacheKey)) {
      return webCandidateCache.get(cacheKey);
    }

    const municipalityTerms = municipalityVariants(countryCode, muni);
    const locationTerms = municipalityTerms.length ? municipalityTerms : [muni];

    const terms = [
      `${q || 'gårdsbutikk'} ${muni} ${region} ${country}`,
      `gårdsutsalg ${muni} ${country}`,
      `farm shop ${muni} ${country}`,
      `local farm store ${muni} ${country}`,
      `gård ${muni} ${country}`,
      `fruktgård ${muni} ${country}`,
      `cidergård ${muni} ${country}`,
      ...locationTerms.map((name) => `${q || 'gårdsbutikk'} ${name} ${region} ${country}`),
      ...locationTerms.map((name) => `gårdsutsalg ${name} ${country}`),
      ...locationTerms.map((name) => `gård ${name} ${country}`),
      ...locationTerms.map((name) => `fruktgård ${name} ${country}`),
    ];

    const [results, overpassCandidates] = await Promise.all([
      Promise.all(terms.map((term) => searchNominatim(term, countryCode))),
      fetchOverpassMunicipalityCandidates({
        countryCode,
        countryLabel: country,
        regionLabel: region,
        municipalityLabel: muni,
      }),
    ]);
    const flattened = results.flat();
    const filtered = flattened.filter((item) => looksLikeFarmOutlet(item));
    const mapped = filtered
      .map((item) => toWebShop(item, muni, region, country))
      .filter((shop) => keepHighQuality(shop));
    let unique = mergeShopLists(mergeShopLists(seedCandidates, mapped), overpassCandidates)
      .sort((left, right) => candidateScore(right) - candidateScore(left))
      .slice(0, 40);

    if (unique.length < 8) {
      const relaxed = filtered
        .map((item) => toWebShop(item, muni, region, country))
        .filter((shop) => candidateScore(shop) >= 2)
        .sort((left, right) => candidateScore(right) - candidateScore(left));
      unique = mergeShopLists(unique, relaxed).slice(0, 60);
    }

    webCandidateCache.set(cacheKey, unique);
    return unique;
  }

  // init map
  const map = L.map('map').setView([59.9, 10.7], 5);
  window._leafletMap = map;
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: '© OpenStreetMap contributors',
  }).addTo(map);
  const markers = L.layerGroup().addTo(map);

  function escapeHtml(value) {
    return (value || '')
      .toString()
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

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
      const location = [shop.address, shop.municipality, shop.region].filter(Boolean).join(', ');
      const phoneLine = shop.phone ? `<div class="item-sub">📞 ${escapeHtml(shop.phone)}</div>` : '';
      const openingLine = shop.openingHours ? `<div class="item-sub">🕒 ${escapeHtml(shop.openingHours)}</div>` : '';
      const productsLine = products ? `<div class="item-sub">🌾 ${escapeHtml(products)}</div>` : '';
      const mapsLink = shop.mapsUrl ? `<a class="item-link" href="${shop.mapsUrl}" target="_blank" rel="noopener">Kart</a>` : '';
      const image = shop.imageUrl ? `<img class="item-thumb" src="${shop.imageUrl}" alt="${escapeHtml(shop.name)}" loading="lazy" />` : '';
      div.innerHTML = `
        <div class="item-row">
          ${image}
          <div class="item-content">
            <div class="item-title">${escapeHtml(shop.name)}</div>
            <div class="item-meta">${escapeHtml(shop.category || 'Gårdsutsalg')} · ${escapeHtml(location)}</div>
            ${phoneLine}
            ${openingLine}
            ${productsLine}
          </div>
        </div>
        <div class="item-actions">
          <a class="item-link" href="${shop.website}" target="_blank" rel="noopener">Nettside</a>
          ${mapsLink}
        </div>
      `;
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

  async function filterShops() {
    const runId = ++filterRunId;
    const countryCode = countrySelect.value;
    const regionValue = regionSelect.value;
    const municipalityValue = muniSelect.value;
    const regionText = selectedText(regionSelect);
    const municipalityText = selectedText(muniSelect);
    const countryText = selectedText(countrySelect);
    const query = searchInput.value.trim().toLowerCase();

    const municipalityTerms = municipalityVariants(countryCode, municipalityText)
      .map((name) => municipalityKey(name));

    let filtered = shops.filter((shop) => {
      const countryMatch = !countryCode || shop.countryCode === countryCode;
      const regionMatch = !regionValue || (countryCode === 'NO'
        ? (shop.region || '').toLowerCase() === (regionText || '').toLowerCase()
        : shop.region === regionValue);
      const municipalityMatch = !municipalityValue || (countryCode === 'NO'
        ? municipalityMatches(shop.municipality || '', municipalityTerms)
        : shop.municipality === municipalityValue);
      return countryMatch && regionMatch && municipalityMatch;
    });

    if (query) {
      filtered = filtered.filter((shop) =>
        (shop.name || '').toLowerCase().includes(query) ||
        (shop.products || []).join(' ').toLowerCase().includes(query)
      );
    }

    activeFiltered = filtered;
    renderList(filtered);

    const shouldEnrich = Boolean(municipalityText || (query && query.length >= 2));
    if (!shouldEnrich) return filtered;

    try {
      const liveCandidates = await fetchLiveCandidates({
        countryCode,
        countryLabel: countryText,
        regionLabel: regionText,
        municipalityLabel: municipalityText,
        query,
      });
      if (runId !== filterRunId) return filtered;
      const merged = mergeShopLists(filtered, liveCandidates);
      activeFiltered = merged;
      renderList(merged);

      if (countryCode === 'NO' && municipalityText && merged.length <= 2) {
        const regionWideCandidates = await fetchLiveCandidates({
          countryCode,
          countryLabel: countryText,
          regionLabel: regionText,
          municipalityLabel: '',
          query: query || 'gårdsbutikk',
        });
        if (runId !== filterRunId) return merged;
        const mergedRegionWide = mergeShopLists(merged, regionWideCandidates);
        activeFiltered = mergedRegionWide;
        renderList(mergedRegionWide);
        return mergedRegionWide;
      }

      return merged;
    } catch (error) {
      console.warn('Could not enrich farmshop list with live web candidates.', error);
      return filtered;
    }
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
    const municipalityTerms = municipalityVariants(countrySelect.value, municipality);
    const municipalityQuery = municipalityTerms.length > 1
      ? `(${municipalityTerms.join(' OR ')})`
      : municipality;

    const composed = [
      query || 'gårdsbutikk',
      '(gårdsbutikk OR gårdsutsalg OR "farm shop" OR "farm store" OR "ferme boutique" OR hofladen OR "vente directe" OR "venta directa")',
      municipalityQuery,
      region,
      country,
      '-oppskrift -meny -restaurant -wikipedia',
    ].filter(Boolean).join(' ');
    const googleActionable = [
      query || 'gårdsbutikk',
      '(gårdsbutikk OR gårdsutsalg OR "farm shop")',
      municipalityQuery,
      region,
      country,
      '(nettside OR åpningstider OR adresse)',
      '-oppskrift -meny -restaurant -wikipedia',
    ].filter(Boolean).join(' ');
    const engine = searchEngineSelect ? searchEngineSelect.value : 'google';
    const aiPrompt = `Finn minst 12 faktiske gårdsbutikker/gårdsutsalg i eller nær ${municipalityQuery} ${region} ${country}. Krav per oppføring: navn, kommune, adresse eller tydelig sted, produkter (hvis kjent), samt direkte lenke til offisiell nettside eller kart. Filtrer bort restauranter, oppskrifter, hotell og generelle artikler. Returner kun verifiserbare steder.`;
    if (engine === 'ai') {
      const aiUrl = `https://www.perplexity.ai/search/new?q=${encodeURIComponent(aiPrompt)}`;
      const googleUrl = `https://www.google.com/search?q=${encodeURIComponent(googleActionable)}`;
      window.open(aiUrl, '_blank', 'noopener');
      window.open(googleUrl, '_blank', 'noopener');
      return;
    }

    const url = `https://www.google.com/search?q=${encodeURIComponent(composed)}`;
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

  muniSelect.addEventListener('change', () => {
    filterShops();
  });
  if (sortSelect) {
    sortSelect.addEventListener('change', () => {
      renderList(activeFiltered);
    });
  }
  let searchDebounce = null;
  searchInput.addEventListener('input', () => {
    if (searchDebounce) clearTimeout(searchDebounce);
    searchDebounce = setTimeout(() => {
      filterShops();
    }, 300);
  });

  document.getElementById('resetBtn').addEventListener('click', async () => {
    countrySelect.value = '';
    regionSelect.value = '';
    muniSelect.value = '';
    searchInput.value = '';
    ensureAiSearchEngineDefault();
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
          runAreaWebSearch();
        } catch (_) {
          alert('Fant ikke kommune fra posisjon.');
        }
      }, () => {
        alert('Kunne ikke hente posisjon. Sjekk stedstjenester i nettleseren.');
      }, { enableHighAccuracy: true, timeout: 10000 });
    });
  } else if (myMunicipalityBtn) {
    myMunicipalityBtn.addEventListener('click', () => {
      alert('Stedstjenester er ikke tilgjengelig i denne nettleseren. Åpne siden over HTTPS og tillat posisjon.');
      runAreaWebSearch();
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
  ensureAiSearchEngineDefault();
  await populateRegions('');
  await populateMunicipalities('', '');
  activeFiltered = shops;
  renderList(shops);
})();
