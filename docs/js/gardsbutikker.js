// Farmshops client: filters, map, route search and Google Maps area search
(async function () {
  const pageConfig = (window.MAT_SJEKK_PAGE_CONFIG && typeof window.MAT_SJEKK_PAGE_CONFIG === 'object')
    ? window.MAT_SJEKK_PAGE_CONFIG
    : {};
  const defaultDataUrls = [
    'data/farmshops.json',
    '/data/farmshops.json',
    '../../docs/data/farmshops.json',
  ];
  const defaultFallbackUrls = [
    'data/farmshops.example.json',
    '/data/farmshops.example.json',
    '../../docs/data/farmshops.example.json',
  ];
  const defaultExtraMergeDataUrls = [
    'data/organic_farmshops.json',
    '/data/organic_farmshops.json',
    '../../docs/data/organic_farmshops.json',
  ];

  const dataUrls = Array.isArray(pageConfig.dataUrls) && pageConfig.dataUrls.length
    ? pageConfig.dataUrls
    : defaultDataUrls;
  const fallbackUrls = Array.isArray(pageConfig.fallbackUrls) && pageConfig.fallbackUrls.length
    ? pageConfig.fallbackUrls
    : defaultFallbackUrls;
  const extraMergeDataUrls = Array.isArray(pageConfig.extraMergeDataUrls)
    ? pageConfig.extraMergeDataUrls
    : defaultExtraMergeDataUrls;

  const areaCacheUrls = [
    'data/farmshops_area_cache.json',
    '/data/farmshops_area_cache.json',
    '../../docs/data/farmshops_area_cache.json',
  ];
  const defaultCountrySliceBasePaths = [
    'data/farmshops_by_country',
    '/data/farmshops_by_country',
    '../../docs/data/farmshops_by_country',
  ];
  const hasCustomCountrySliceBasePaths = Array.isArray(pageConfig.countrySliceBasePaths);
  const countrySliceBasePaths = hasCustomCountrySliceBasePaths
    ? pageConfig.countrySliceBasePaths
    : defaultCountrySliceBasePaths;
  let activeFiltered = [];
  let filterRunId = 0;
  const webCandidateCache = new Map();
  const sharedLocalityCache = new Map();
  const countrySliceCache = new Map();
  const countrySliceInFlight = new Map();
  let allShopsCache = null;
  let allShopsLoaded = false;
  let extraMergeCache = null;
  let extraMergeLoaded = false;
  const COUNTRY_INITIAL_PREVIEW_LIMIT_MOBILE = 200;
  const COUNTRY_INITIAL_PREVIEW_LIMIT_DESKTOP = 500;
  let loadedScopeCountryCode = '';
  let loadedScopeIsPreview = false;
  const LOCALITY_CACHE_STORAGE_KEY = 'matsjekk_farmshops_locality_cache_v1';
  const LOCALITY_CACHE_MAX_AREAS = 60;
  const LOCALITY_CACHE_MAX_ITEMS_PER_AREA = 120;

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
    { code: 'LI', name: 'Liechtenstein' },
    { code: 'LU', name: 'Luxembourg' },
  ];

  const COUNTRY_TLD_BY_CODE = {
    NO: 'no',
    SE: 'se',
    DK: 'dk',
    FI: 'fi',
    DE: 'de',
    NL: 'nl',
    BE: 'be',
    FR: 'fr',
    IT: 'it',
    PT: 'pt',
    ES: 'es',
    GB: 'uk',
    IE: 'ie',
    AT: 'at',
    CH: 'ch',
    LI: 'li',
    LU: 'lu',
  };

  const COUNTRY_ENGLISH_BY_CODE = {
    NO: 'Norway',
    SE: 'Sweden',
    DK: 'Denmark',
    FI: 'Finland',
    DE: 'Germany',
    NL: 'Netherlands',
    BE: 'Belgium',
    FR: 'France',
    IT: 'Italy',
    PT: 'Portugal',
    ES: 'Spain',
    GB: 'United Kingdom',
    IE: 'Ireland',
    AT: 'Austria',
    CH: 'Switzerland',
    LI: 'Liechtenstein',
    LU: 'Luxembourg',
  };

  const COUNTRY_REGIONS_FALLBACK = {
    NO: ['Akershus', 'Buskerud', 'Finnmark', 'Innlandet', 'Møre og Romsdal', 'Nordland', 'Oslo', 'Rogaland', 'Telemark', 'Troms', 'Trøndelag', 'Vestfold', 'Vestland', 'Østfold'],
    SE: ['Stockholms län', 'Västra Götalands län', 'Skåne län', 'Uppsala län', 'Östergötlands län', 'Jönköpings län', 'Hallands län', 'Dalarnas län'],
    DK: ['Hovedstaden', 'Sjælland', 'Syddanmark', 'Midtjylland', 'Nordjylland'],
    FI: ['Uusimaa', 'Varsinais-Suomi', 'Pirkanmaa', 'Pohjois-Pohjanmaa', 'Keski-Suomi', 'Lappi'],
    DE: ['Bayern', 'Baden-Württemberg', 'Nordrhein-Westfalen', 'Niedersachsen', 'Hessen', 'Sachsen', 'Berlin', 'Hamburg'],
    NL: ['Noord-Holland', 'Zuid-Holland', 'Utrecht', 'Gelderland', 'Noord-Brabant', 'Limburg'],
    BE: ['Vlaanderen', 'Wallonie', 'Bruxelles-Capitale'],
    FR: ['Île-de-France', 'Normandie', 'Bretagne', 'Nouvelle-Aquitaine', 'Occitanie', 'Auvergne-Rhône-Alpes', 'Provence-Alpes-Côte d’Azur'],
    IT: ['Abruzzo', 'Basilicata', 'Calabria', 'Campania', 'Emilia-Romagna', 'Friuli-Venezia Giulia', 'Lazio', 'Liguria', 'Lombardia', 'Marche', 'Molise', 'Piemonte', 'Puglia', 'Sardegna', 'Sicilia', 'Toscana', 'Trentino-Alto Adige', 'Umbria', "Valle d'Aosta", 'Veneto'],
    PT: ['Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve'],
    ES: ['Andalucía', 'Cataluña', 'Comunidad de Madrid', 'Comunitat Valenciana', 'Galicia', 'País Vasco'],
    GB: ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    IE: ['Leinster', 'Munster', 'Connacht', 'Ulster'],
    AT: ['Wien', 'Niederösterreich', 'Oberösterreich', 'Steiermark', 'Tirol', 'Salzburg'],
    CH: ['Zürich', 'Bern', 'Vaud', 'Aargau', 'Ticino', 'Genève'],
    LU: ['Luxembourg', 'Esch-sur-Alzette', 'Diekirch', 'Grevenmacher'],
  };

  const COUNTRY_MUNICIPALITIES_FALLBACK = {
    SE: ['Stockholm', 'Göteborg', 'Malmö', 'Uppsala', 'Västerås'],
    DK: ['København', 'Aarhus', 'Odense', 'Aalborg', 'Esbjerg'],
    FI: ['Helsinki', 'Espoo', 'Tampere', 'Turku', 'Oulu'],
    DE: ['Berlin', 'München', 'Hamburg', 'Köln', 'Frankfurt am Main'],
    NL: ['Amsterdam', 'Rotterdam', 'Utrecht', 'Den Haag', 'Eindhoven'],
    BE: ['Brussel', 'Antwerpen', 'Gent', 'Liège', 'Brugge'],
    FR: ['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Bordeaux'],
    IT: ['Roma', 'Milano', 'Torino', 'Bologna', 'Firenze'],
    PT: ['Lisboa', 'Porto', 'Braga', 'Coimbra', 'Faro'],
    ES: ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'],
    GB: ['London', 'Manchester', 'Birmingham', 'Bristol', 'Edinburgh'],
    IE: ['Dublin', 'Cork', 'Galway', 'Limerick', 'Waterford'],
    AT: ['Wien', 'Graz', 'Linz', 'Salzburg', 'Innsbruck'],
    CH: ['Zürich', 'Genève', 'Basel', 'Bern', 'Lausanne'],
    LU: ['Luxembourg', 'Esch-sur-Alzette', 'Differdange', 'Dudelange', 'Ettelbruck'],
  };

  const COUNTRY_REGION_MUNICIPALITIES_FALLBACK = {
    NO: {
      Akershus: ['Asker', 'Bærum', 'Lillestrøm', 'Lørenskog', 'Nittedal', 'Nesodden', 'Eidsvoll', 'Ullensaker', 'Nannestad', 'Gjerdrum', 'Aurskog-Høland'],
      Buskerud: ['Drammen', 'Kongsberg', 'Ringerike', 'Lier', 'Hole', 'Modum', 'Øvre Eiker', 'Nedre Eiker', 'Flesberg', 'Rollag', 'Nore og Uvdal'],
      Innlandet: ['Hamar', 'Lillehammer', 'Gjøvik', 'Elverum', 'Ringsaker', 'Stange', 'Øyer', 'Trysil', 'Kongsvinger'],
      Oslo: ['Oslo'],
      Vestfold: ['Tønsberg', 'Sandefjord', 'Larvik', 'Horten', 'Holmestrand', 'Færder'],
      Østfold: ['Fredrikstad', 'Sarpsborg', 'Halden', 'Moss', 'Indre Østfold', 'Rakkestad'],
      Telemark: ['Skien', 'Porsgrunn', 'Notodden', 'Bamble', 'Kragerø', 'Midt-Telemark'],
      Rogaland: ['Stavanger', 'Sandnes', 'Sola', 'Randaberg', 'Klepp', 'Time', 'Eigersund', 'Haugesund'],
      Agder: ['Kristiansand', 'Arendal', 'Lillesand', 'Grimstad', 'Farsund', 'Lyngdal'],
      Vestland: ['Bergen', 'Voss', 'Ulvik', 'Kvam', 'Sogndal', 'Alver', 'Øygarden', 'Sunnfjord'],
      'Møre og Romsdal': ['Ålesund', 'Molde', 'Kristiansund', 'Volda', 'Ørsta', 'Surnadal'],
      Trøndelag: ['Trondheim', 'Stjørdal', 'Levanger', 'Steinkjer', 'Verdal', 'Orkland', 'Namsos'],
      Nordland: ['Bodø', 'Narvik', 'Vefsn', 'Rana', 'Vestvågøy', 'Hadsel'],
      Troms: ['Tromsø', 'Harstad', 'Målselv', 'Senja', 'Balsfjord'],
      Finnmark: ['Alta', 'Hammerfest', 'Sør-Varanger', 'Vadsø', 'Porsanger'],
    },
    SE: {
      'Stockholms län': ['Stockholm', 'Södertälje', 'Norrtälje', 'Nacka', 'Täby'],
      'Västra Götalands län': ['Göteborg', 'Borås', 'Skövde', 'Uddevalla', 'Lidköping'],
      'Skåne län': ['Malmö', 'Lund', 'Helsingborg', 'Ystad', 'Kristianstad'],
      'Uppsala län': ['Uppsala', 'Enköping', 'Tierp', 'Östhammar', 'Knivsta'],
      'Östergötlands län': ['Linköping', 'Norrköping', 'Motala', 'Mjölby', 'Söderköping'],
      'Jönköpings län': ['Jönköping', 'Värnamo', 'Nässjö', 'Eksjö', 'Tranås'],
      'Hallands län': ['Halmstad', 'Varberg', 'Falkenberg', 'Kungsbacka', 'Laholm'],
      'Dalarnas län': ['Falun', 'Borlänge', 'Mora', 'Leksand', 'Avesta'],
    },
    DK: {
      'Hovedstaden': ['København', 'Frederiksberg', 'Helsingør', 'Hillerød', 'Bornholm'],
      'Sjælland': ['Roskilde', 'Køge', 'Næstved', 'Slagelse', 'Holbæk'],
      'Syddanmark': ['Odense', 'Esbjerg', 'Kolding', 'Vejle', 'Svendborg'],
      'Midtjylland': ['Aarhus', 'Randers', 'Silkeborg', 'Herning', 'Viborg'],
      'Nordjylland': ['Aalborg', 'Hjørring', 'Frederikshavn', 'Thisted', 'Brønderslev'],
    },
    FI: {
      'Uusimaa': ['Helsinki', 'Espoo', 'Vantaa', 'Porvoo', 'Lohja'],
      'Varsinais-Suomi': ['Turku', 'Salo', 'Kaarina', 'Raisio', 'Naantali'],
      'Pirkanmaa': ['Tampere', 'Nokia', 'Ylöjärvi', 'Valkeakoski', 'Sastamala'],
      'Pohjois-Pohjanmaa': ['Oulu', 'Raahe', 'Kuusamo', 'Kempele', 'Ii'],
      'Keski-Suomi': ['Jyväskylä', 'Jämsä', 'Äänekoski', 'Saarijärvi', 'Keuruu'],
      'Lappi': ['Rovaniemi', 'Kemi', 'Tornio', 'Sodankylä', 'Kemijärvi'],
    },
    DE: {
      'Bayern': ['München', 'Nürnberg', 'Augsburg', 'Regensburg', 'Würzburg'],
      'Baden-Württemberg': ['Stuttgart', 'Karlsruhe', 'Mannheim', 'Freiburg im Breisgau', 'Ulm'],
      'Nordrhein-Westfalen': ['Köln', 'Düsseldorf', 'Dortmund', 'Essen', 'Bonn'],
      'Niedersachsen': ['Hannover', 'Braunschweig', 'Osnabrück', 'Oldenburg', 'Göttingen'],
      'Hessen': ['Frankfurt am Main', 'Wiesbaden', 'Kassel', 'Darmstadt', 'Marburg'],
      'Sachsen': ['Leipzig', 'Dresden', 'Chemnitz', 'Zwickau', 'Görlitz'],
      'Berlin': ['Berlin'],
      'Hamburg': ['Hamburg'],
    },
    NL: {
      'Noord-Holland': ['Amsterdam', 'Haarlem', 'Alkmaar', 'Hilversum', 'Hoorn'],
      'Zuid-Holland': ['Rotterdam', 'Den Haag', 'Leiden', 'Dordrecht', 'Delft'],
      'Utrecht': ['Utrecht', 'Amersfoort', 'Nieuwegein', 'Zeist', 'Veenendaal'],
      'Gelderland': ['Arnhem', 'Nijmegen', 'Apeldoorn', 'Ede', 'Zutphen'],
      'Noord-Brabant': ['Eindhoven', 'Tilburg', 'Breda', "'s-Hertogenbosch", 'Helmond'],
      'Limburg': ['Maastricht', 'Venlo', 'Sittard-Geleen', 'Roermond', 'Heerlen'],
    },
    BE: {
      'Vlaanderen': ['Antwerpen', 'Gent', 'Brugge', 'Leuven', 'Hasselt'],
      'Wallonie': ['Liège', 'Namur', 'Charleroi', 'Mons', 'Arlon'],
      'Bruxelles-Capitale': ['Brussel', 'Anderlecht', 'Ixelles', 'Schaerbeek', 'Uccle'],
    },
    FR: {
      'Île-de-France': ['Paris', 'Versailles', 'Nanterre', 'Créteil', 'Saint-Denis'],
      'Normandie': ['Rouen', 'Caen', 'Le Havre', 'Cherbourg-en-Cotentin', 'Évreux'],
      'Bretagne': ['Rennes', 'Brest', 'Quimper', 'Saint-Malo', 'Vannes'],
      'Nouvelle-Aquitaine': ['Bordeaux', 'Limoges', 'Poitiers', 'Pau', 'La Rochelle'],
      'Occitanie': ['Toulouse', 'Montpellier', 'Nîmes', 'Perpignan', 'Albi'],
      'Auvergne-Rhône-Alpes': ['Lyon', 'Grenoble', 'Clermont-Ferrand', 'Annecy', 'Saint-Étienne'],
      'Provence-Alpes-Côte d’Azur': ['Marseille', 'Nice', 'Toulon', 'Avignon', 'Aix-en-Provence'],
    },
    IT: {
      'Lombardia': ['Milano', 'Bergamo', 'Brescia', 'Como', 'Pavia'],
      'Piemonte': ['Torino', 'Cuneo', 'Asti', 'Alessandria', 'Novara'],
      'Veneto': ['Venezia', 'Verona', 'Padova', 'Treviso', 'Vicenza'],
      'Emilia-Romagna': ['Bologna', 'Parma', 'Modena', 'Ravenna', 'Rimini'],
      'Toscana': ['Firenze', 'Siena', 'Pisa', 'Lucca', 'Arezzo'],
      'Lazio': ['Roma', 'Viterbo', 'Rieti', 'Latina', 'Frosinone'],
      'Sicilia': ['Palermo', 'Catania', 'Messina', 'Siracusa', 'Trapani'],
    },
    PT: {
      'Norte': ['Porto', 'Braga', 'Guimarães', 'Viana do Castelo', 'Vila Real'],
      'Centro': ['Coimbra', 'Aveiro', 'Leiria', 'Viseu', 'Castelo Branco'],
      'Lisboa': ['Lisboa', 'Sintra', 'Cascais', 'Loures', 'Amadora'],
      'Alentejo': ['Évora', 'Beja', 'Portalegre', 'Sines', 'Elvas'],
      'Algarve': ['Faro', 'Portimão', 'Lagos', 'Tavira', 'Albufeira'],
    },
    ES: {
      'Andalucía': ['Sevilla', 'Málaga', 'Granada', 'Córdoba', 'Almería'],
      'Cataluña': ['Barcelona', 'Girona', 'Lleida', 'Tarragona', 'Sabadell'],
      'Comunidad de Madrid': ['Madrid', 'Alcalá de Henares', 'Getafe', 'Móstoles', 'Leganés'],
      'Comunitat Valenciana': ['Valencia', 'Alicante', 'Castellón de la Plana', 'Elche', 'Gandia'],
      'Galicia': ['A Coruña', 'Vigo', 'Santiago de Compostela', 'Lugo', 'Ourense'],
      'País Vasco': ['Bilbao', 'San Sebastián', 'Vitoria-Gasteiz', 'Getxo', 'Irun'],
    },
    GB: {
      'England': ['London', 'Manchester', 'Birmingham', 'Bristol', 'York'],
      'Scotland': ['Edinburgh', 'Glasgow', 'Aberdeen', 'Inverness', 'Dundee'],
      'Wales': ['Cardiff', 'Swansea', 'Newport', 'Wrexham', 'Bangor'],
      'Northern Ireland': ['Belfast', 'Derry', 'Lisburn', 'Newry', 'Armagh'],
    },
    IE: {
      'Leinster': ['Dublin', 'Kilkenny', 'Wexford', 'Drogheda', 'Bray'],
      'Munster': ['Cork', 'Limerick', 'Waterford', 'Tralee', 'Ennis'],
      'Connacht': ['Galway', 'Sligo', 'Castlebar', 'Ballina', 'Roscommon'],
      'Ulster': ['Letterkenny', 'Monaghan', 'Cavan', 'Donegal', 'Buncrana'],
    },
    AT: {
      'Wien': ['Wien'],
      'Niederösterreich': ['St. Pölten', 'Wiener Neustadt', 'Krems an der Donau', 'Baden', 'Amstetten'],
      'Oberösterreich': ['Linz', 'Wels', 'Steyr', 'Gmunden', 'Freistadt'],
      'Steiermark': ['Graz', 'Leoben', 'Bruck an der Mur', 'Kapfenberg', 'Judenburg'],
      'Tirol': ['Innsbruck', 'Kufstein', 'Lienz', 'Hall in Tirol', 'Kitzbühel'],
      'Salzburg': ['Salzburg', 'Hallein', 'Saalfelden am Steinernen Meer', 'Bischofshofen', 'Zell am See'],
    },
    CH: {
      'Zürich': ['Zürich', 'Winterthur', 'Uster', 'Dübendorf', 'Wetzikon'],
      'Bern': ['Bern', 'Biel/Bienne', 'Thun', 'Köniz', 'Burgdorf'],
      'Vaud': ['Lausanne', 'Yverdon-les-Bains', 'Montreux', 'Nyon', 'Vevey'],
      'Aargau': ['Aarau', 'Baden', 'Wettingen', 'Zofingen', 'Brugg'],
      'Ticino': ['Lugano', 'Bellinzona', 'Locarno', 'Mendrisio', 'Chiasso'],
      'Genève': ['Genève', 'Carouge', 'Lancy', 'Vernier', 'Meyrin'],
    },
    LU: {
      'Luxembourg': ['Luxembourg', 'Esch-sur-Alzette', 'Differdange', 'Dudelange', 'Hesperange'],
      'Esch-sur-Alzette': ['Esch-sur-Alzette', 'Schifflange', 'Sanem', 'Mondercange', 'Bettembourg'],
      'Diekirch': ['Diekirch', 'Ettelbruck', 'Vianden', 'Clervaux', 'Wiltz'],
      'Grevenmacher': ['Grevenmacher', 'Echternach', 'Remich', 'Junglinster', 'Wormeldange'],
    },
  };

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
    li: 'LI', liechtenstein: 'LI',
    lu: 'LU', luxembourg: 'LU',
  };

  const NORWAY_MERGED_MUNICIPALITIES = {
    asker: ['asker', 'hurum', 'røyken', 'royken', 'slemmestad', 'tofte', 'holmsbu', 'vettre', 'hyggen', 'klokkarstua', 'sætre', 'saetre'],
    hurum: ['asker', 'hurum', 'røyken', 'royken', 'slemmestad', 'tofte', 'holmsbu', 'vettre', 'hyggen', 'klokkarstua', 'sætre', 'saetre'],
    'røyken': ['asker', 'hurum', 'røyken', 'royken', 'slemmestad', 'tofte', 'holmsbu', 'vettre', 'hyggen', 'klokkarstua', 'sætre', 'saetre'],
    royken: ['asker', 'hurum', 'røyken', 'royken', 'slemmestad', 'tofte', 'holmsbu', 'vettre', 'hyggen', 'klokkarstua', 'sætre', 'saetre'],
    slemmestad: ['asker', 'hurum', 'røyken', 'royken', 'slemmestad'],
    tofte: ['asker', 'hurum', 'tofte', 'holmsbu', 'klokkarstua'],
    holmsbu: ['asker', 'hurum', 'tofte', 'holmsbu', 'klokkarstua'],
    vettre: ['asker', 'vettre', 'røyken', 'royken'],
    hyggen: ['asker', 'hyggen', 'røyken', 'royken'],
  };

  const NORWAY_REGION_VARIANTS = {
    akershus: ['akershus', 'viken'],
    buskerud: ['buskerud', 'viken'],
    ostfold: ['østfold', 'ostfold', 'viken'],
    viken: ['akershus', 'buskerud', 'østfold', 'ostfold', 'viken'],
  };

  const TRUSTED_NORWAY_SEEDS = [
    { name: 'Bergvang Gård', municipality: 'Asker', region: 'Akershus', address: 'Bergvangveien 21, Asker', products: ['Egg', 'Kjøtt', 'Honning'], website: 'https://www.google.com/search?q=Bergvang+G%C3%A5rd+Asker' },
    { name: 'Grønnsletta Gård', municipality: 'Hurum', region: 'Akershus', address: 'Tofteveien 40, Hurum/Asker', products: ['Lam', 'Pølser', 'Honning', 'Egg'], website: 'https://www.google.com/maps/place/Gr%C3%B8nnsletta+G%C3%A5rd/', lat: 59.5553052, lon: 10.5049039 },
    { name: 'Værby gård', municipality: 'Hurum', region: 'Akershus', address: 'Værby, Asker', products: ['Lokalmat'], website: 'https://www.google.com/maps/place/V%C3%A6rby+g%C3%A5rd/', lat: 59.5445009, lon: 10.4801604 },
    { name: 'Bergsmyrene', municipality: 'Hurum', region: 'Akershus', address: 'Søndre Hurum/Asker', products: ['Grønnsaker'], website: 'https://www.google.com/maps/place/Bergsmyrene/', lat: 59.5502616, lon: 10.4556426 },
    { name: 'Biffgården', municipality: 'Hurum', region: 'Akershus', address: 'Holmsbu-området', products: ['Kjøtt', 'Skinn', 'Ved'], website: 'https://www.google.com/maps/place/Biffg%C3%A5rden/', lat: 59.538206, lon: 10.4433703 },
    { name: 'Thor Graff', municipality: 'Røyken', region: 'Akershus', address: 'Asker', products: ['Lokalmat'], website: 'https://www.google.com/maps/place/Thor+Graff/', lat: 59.7301368, lon: 10.4432877 },
    { name: 'Hyggen eplemost', municipality: 'Røyken', region: 'Akershus', address: 'Hyggen, Asker', products: ['Eplemost', 'Epleprodukter'], website: 'https://www.google.com/maps/place/Hyggen+eplemost/', lat: 59.7148197, lon: 10.3500528 },
    { name: 'Bonden Jens', municipality: 'Røyken', region: 'Akershus', address: 'Hurumveien 13, 3440 Røyken', products: ['Grønnsaker', 'Bær', 'Selvplukk'], website: 'https://www.google.com/maps/place/Bonden+Jens/', lat: 59.7290416, lon: 10.4415312 },
    { name: 'Jordbær fra Nedre Gjerdal Gård', municipality: 'Røyken', region: 'Akershus', address: 'Asker', products: ['Jordbær', 'Bær'], website: 'https://www.google.com/maps/place/Jordb%C3%A6r+fra+Nedre+Gjerdal+G%C3%A5rd/', lat: 59.7461658, lon: 10.434421 },
    { name: 'Hurum hjort', municipality: 'Hurum', region: 'Akershus', address: 'Asker', products: ['Hjortekjøtt'], website: 'https://www.google.com/maps/place/Hurum+hjort/', lat: 59.594239, lon: 10.6028242 },
    { name: 'Eplegården AS', municipality: 'Hurum', region: 'Akershus', address: 'Asker', products: ['Epleprodukter'], website: 'https://www.google.com/maps/place/Epleg%C3%A5rden+AS/', lat: 59.6498675, lon: 10.5972649 },
    { name: 'Bryggerhuset på Frøtvedt', municipality: 'Røyken', region: 'Akershus', address: 'Røyken-området', products: ['Bakerivarer'], website: 'https://www.google.com/maps/place/Bryggerhuset+p%C3%A5+Fr%C3%B8tvedt/', lat: 59.710323, lon: 10.4954476 },
    { name: 'Aaby Gård', municipality: 'Asker', region: 'Akershus', address: 'Asker', products: ['Lokalmat'], website: 'https://www.google.com/maps/place/Aaby+G%C3%A5rd/', lat: 59.8208933, lon: 10.4644799 },
    { name: 'Grisehuset gårdsutsalg', municipality: 'Asker', region: 'Akershus', address: 'Asker', products: ['Gårdsutsalg'], website: 'https://www.google.com/maps/place/Grisehuset+g%C3%A5rdsutsalg/', lat: 59.8262596, lon: 10.4794243 },
    { name: 'Sand Gård', municipality: 'Hurum', region: 'Akershus', address: 'Storengene 2/4, Kana', products: ['Bakerivarer', 'Lokale produkter'], website: 'https://www.google.com/maps/place/Sand+G%C3%A5rd/', lat: 59.5636043, lon: 10.4641891 },
    { name: 'Vinnulstad Gård', municipality: 'Asker', region: 'Akershus', address: 'Asker', products: ['Lokalmat'], website: 'https://www.google.com/maps/place/Vinnulstad+G%C3%A5rd/', lat: 59.8016602, lon: 10.4261885 },
    { name: 'Skarrbo gård', municipality: 'Holmestrand', region: 'Vestfold', address: 'Holmestrand, Vestfold', products: ['Lokalmat'], website: 'https://www.google.com/search?q=Skarrbo+g%C3%A5rd+Holmestrand' },
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

  const TRUSTED_SWEDEN_SEEDS = [
    { name: 'Bondens Egen Marknad Södermalm', municipality: 'Stockholm', region: 'Stockholms län', address: 'Katarina Bangata, Stockholm', products: ['Lokalmat', 'Grønnsaker'], website: 'https://www.google.com/maps/search/?api=1&query=Bondens+Egen+Marknad+S%C3%B6dermalm+Stockholm' },
    { name: 'Sanda Gårdsbutik', municipality: 'Stockholm', region: 'Stockholms län', address: 'Stockholm-området', products: ['Kjøtt', 'Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=Sanda+G%C3%A5rdsbutik+Stockholm' },
    { name: 'Nääs Gårdsbutik', municipality: 'Göteborg', region: 'Västra Götalands län', address: 'Göteborg-området', products: ['Ost', 'Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=N%C3%A4%C3%A4s+G%C3%A5rdsbutik+G%C3%B6teborg' },
    { name: 'Möllegården Gårdsbutik', municipality: 'Malmö', region: 'Skåne län', address: 'Malmö-området', products: ['Kjøtt', 'Egg'], website: 'https://www.google.com/maps/search/?api=1&query=M%C3%B6lleg%C3%A5rden+G%C3%A5rdsbutik+Malm%C3%B6' },
    { name: 'Hällestad Gårdsbutik', municipality: 'Lund', region: 'Skåne län', address: 'Lund-området', products: ['Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=H%C3%A4llestad+G%C3%A5rdsbutik+Lund' },
    { name: 'Sävne Gårdsbutik', municipality: 'Uppsala', region: 'Uppsala län', address: 'Uppsala-området', products: ['Grønnsaker', 'Bær'], website: 'https://www.google.com/maps/search/?api=1&query=S%C3%A4vne+G%C3%A5rdsbutik+Uppsala' },
    { name: 'Ängavallen Gårdsbutik', municipality: 'Malmö', region: 'Skåne län', address: 'Skåne', products: ['Kjøtt', 'Meieri'], website: 'https://www.google.com/maps/search/?api=1&query=%C3%84ngavallen+G%C3%A5rdsbutik+Sk%C3%A5ne' },
    { name: 'Ekenäs Gårdsbutik', municipality: 'Västerås', region: 'Västmanlands län', address: 'Västerås-området', products: ['Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=Eken%C3%A4s+G%C3%A5rdsbutik+V%C3%A4ster%C3%A5s' },
  ];

  const TRUSTED_DENMARK_SEEDS = [
    { name: 'Kildegården Gårdbutik', municipality: 'København', region: 'Hovedstaden', address: 'København-området', products: ['Lokalmat', 'Grønnsaker'], website: 'https://www.google.com/maps/search/?api=1&query=Kildeg%C3%A5rden+G%C3%A5rdbutik+K%C3%B8benhavn' },
    { name: 'Krogerup Avlsgård', municipality: 'Helsingør', region: 'Hovedstaden', address: 'Helsingør', products: ['Grønnsaker', 'Bakervarer'], website: 'https://www.google.com/maps/search/?api=1&query=Krogerup+Avlsg%C3%A5rd+Helsing%C3%B8r' },
    { name: 'Aarstiderne Gårdbutik', municipality: 'Roskilde', region: 'Sjælland', address: 'Roskilde-området', products: ['Økologisk mat'], website: 'https://www.google.com/maps/search/?api=1&query=Aarstiderne+G%C3%A5rdbutik+Roskilde' },
    { name: 'Skjold Burne Gårdbutik', municipality: 'Odense', region: 'Syddanmark', address: 'Odense-området', products: ['Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=G%C3%A5rdbutik+Odense' },
    { name: 'Birkemosehus Gårdbutik', municipality: 'Aarhus', region: 'Midtjylland', address: 'Aarhus-området', products: ['Kjøtt', 'Egg'], website: 'https://www.google.com/maps/search/?api=1&query=Birkemosehus+G%C3%A5rdbutik+Aarhus' },
    { name: 'Fru Møllers Mølleri', municipality: 'Aarhus', region: 'Midtjylland', address: 'Midtjylland', products: ['Mel', 'Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=Fru+M%C3%B8llers+M%C3%B8lleri' },
    { name: 'Aabybro Mejeriudsalg', municipality: 'Aalborg', region: 'Nordjylland', address: 'Aalborg-området', products: ['Meieri'], website: 'https://www.google.com/maps/search/?api=1&query=G%C3%A5rdbutik+Aalborg' },
    { name: 'Hjorths Gårdbutik', municipality: 'Esbjerg', region: 'Syddanmark', address: 'Esbjerg-området', products: ['Lokalmat'], website: 'https://www.google.com/maps/search/?api=1&query=G%C3%A5rdbutik+Esbjerg' },
  ];

  const TRUSTED_SEEDS_BY_COUNTRY = {
    NO: TRUSTED_NORWAY_SEEDS,
    SE: TRUSTED_SWEDEN_SEEDS,
    DK: TRUSTED_DENMARK_SEEDS,
    FI: [],
    DE: [],
    NL: [],
    BE: [],
    FR: [],
    IT: [],
    PT: [],
    ES: [],
    GB: [],
    IE: [],
    AT: [],
    CH: [],
    LU: [],
  };

  let shops = [];
  let norwayCounties = [];
  let norwayMunicipalities = [];
  let norwayLoaded = false;
  const regionCache = new Map();
  const municipalityCache = new Map();
  const municipalityBoundsCache = new Map();
  const regionBoundsCache = new Map();

  const countrySelect = document.getElementById('countrySelect');
  const regionSelect = document.getElementById('regionSelect');
  const muniSelect = document.getElementById('municipalitySelect');
  const applyFiltersBtn = document.getElementById('applyFiltersBtn');
  const sortSelect = document.getElementById('sortSelect');
  const searchInput = document.getElementById('searchInput');
  const listEl = document.getElementById('list');
  const resultsHeadingEl = document.getElementById('resultsHeading');
  const mapEl = document.getElementById('map');
  const mapStatusEl = document.getElementById('mapStatus');
  const debugStatsEl = document.getElementById('debugStats');
  const mapHeightDown = document.getElementById('mapHeightDown');
  const mapHeightUp = document.getElementById('mapHeightUp');
  const myMunicipalityBtn = document.getElementById('myMunicipalityBtn');
  const nearMeBtn = document.getElementById('nearMeBtn');
  const nearRadiusSelect = document.getElementById('nearRadiusSelect');
  const openGoogleMapBtn = document.getElementById('openGoogleMapBtn');
  const backBtn = document.getElementById('backBtn');
  const languageSelect = document.getElementById('languageSelect');
  const languageLabelEl = document.getElementById('languageLabel');
  const pageTitleEl = document.getElementById('pageTitle');
  const introTextEl = document.getElementById('introText');
  const topHomeTabEl = document.getElementById('topHomeTab');
  const topFarmshopsTabEl = document.getElementById('topFarmshopsTab');
  const topOrganicTabEl = document.getElementById('topOrganicTab');
  const topImmigrantTabEl = document.getElementById('topImmigrantTab');
  const topNewsTabEl = document.getElementById('topNewsTab');
  const topContactTabEl = document.getElementById('topContactTab');
  const distanceLabelEl = document.getElementById('distanceLabel');
  const suggestionHeadingEl = document.getElementById('suggestionHeading');
  const suggestionIntroEl = document.getElementById('suggestionIntro');
  const suggestNameLabelEl = document.getElementById('suggestNameLabel');
  const suggestMunicipalityLabelEl = document.getElementById('suggestMunicipalityLabel');
  const suggestCountryLabelEl = document.getElementById('suggestCountryLabel');
  const suggestAddressLabelEl = document.getElementById('suggestAddressLabel');
  const suggestWebsiteLabelEl = document.getElementById('suggestWebsiteLabel');
  const suggestNameEl = document.getElementById('suggestName');
  const suggestMunicipalityEl = document.getElementById('suggestMunicipality');
  const suggestCountryEl = document.getElementById('suggestCountry');
  const suggestAddressEl = document.getElementById('suggestAddress');
  const suggestWebsiteEl = document.getElementById('suggestWebsite');
  const submitSuggestionBtn = document.getElementById('submitSuggestionBtn');
  const suggestionStatusEl = document.getElementById('suggestionStatus');
  const reportHeadingEl = document.getElementById('reportHeading');
  const reportIntroEl = document.getElementById('reportIntro');
  const reportNameLabelEl = document.getElementById('reportNameLabel');
  const reportReasonLabelEl = document.getElementById('reportReasonLabel');
  const reportAddressLabelEl = document.getElementById('reportAddressLabel');
  const reportWebsiteLabelEl = document.getElementById('reportWebsiteLabel');
  const reportNameEl = document.getElementById('reportName');
  const reportReasonEl = document.getElementById('reportReason');
  const reportAddressEl = document.getElementById('reportAddress');
  const reportWebsiteEl = document.getElementById('reportWebsite');
  const submitReportBtn = document.getElementById('submitReportBtn');
  const reportStatusEl = document.getElementById('reportStatus');

  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  let currentMapHeight = isMobile ? 110 : 400;
  let regionPopulateRequestId = 0;
  let municipalityPopulateRequestId = 0;
  let userPosition = null;
  let userDetectedCountryCode = '';
  let activeNearRadiusKm = null;
  const ENABLE_AUTO_COUNTRY_FROM_POSITION = true;
  const ENABLE_LIVE_ENRICHMENT = false;
  const OVERPASS_FETCH_TIMEOUT_MS = 5500;

  const LANGUAGE_STORAGE_KEY = (pageConfig.languageStorageKey || 'matsjekk_farmshops_lang').toString();
  const SUPPORTED_LANGUAGES = ['nb', 'en', 'sv', 'da', 'fi', 'de', 'nl', 'fr', 'it', 'pt', 'es', 'ko', 'pl', 'ru', 'zh', 'ar', 'th'];
  const PAGE_TRANSLATIONS = {
    nb: {
      languageLabel: 'Språk',
      pageTitle: 'Gårdsbutikker',
      introText: 'Finn lokale produsenter og gårdsbutikker. Sorter etter land → fylke/region → kommune, søk etter produkter og planlegg reiser.',
      topHomeTab: 'Hjem',
      topFarmshopsTab: 'Gårdsbutikker',
      topOrganicTab: 'Økologiske gårdsbutikker',
      topImmigrantTab: 'Innvandrerbutikker',
      topNewsTab: 'Nyheter og media',
      topContactTab: 'Kontakt oss',
      backBtn: '← Tilbake',
      homeLinkText: '🏠 Hjem',
      newsLinkText: '📰 Nyheter',
      applyFiltersBtn: 'Oppdater søk',
      sortNameAsc: 'Sorter: Navn A-Å',
      sortNameDesc: 'Sorter: Navn Å-A',
      sortDistance: 'Sorter: Nærmest deg',
      searchPlaceholder: 'Søk butikk',
      myMunicipalityBtn: 'Søk i feltet',
      nearMeBtn: 'Finn nær min posisjon',
      distanceLabel: 'Avstand',
      routeFromPlaceholder: 'Fra (adresse eller by)',
      routeToPlaceholder: 'Til (adresse eller by)',
      routeBtn: 'Finn langs rute',
      resetBtn: 'Tilbakestill',
      mapSizeLabel: 'Kart-høyde',
      countryPlaceholder: 'Velg land',
      regionPlaceholder: 'Velg fylke/region',
      municipalityPlaceholder: 'Velg kommune',
      resultsHeadingDefault: 'Gårdsbutikker nær deg',
      nearbyHeadingPrefix: 'Gårdsbutikker nær deg',
      suggestionHeading: 'Foreslå nytt sted',
      suggestionIntro: 'Mangler det et gårdsutsalg? Send inn navn, kommune og land til moderering.',
      suggestNameLabel: 'Navn',
      suggestMunicipalityLabel: 'Kommune',
      suggestCountryLabel: 'Land',
      suggestAddressLabel: 'Adresse (anbefalt)',
      suggestWebsiteLabel: 'Hjemmeside (anbefalt)',
      suggestNamePlaceholder: 'F.eks. Solheim gård',
      suggestMunicipalityPlaceholder: 'F.eks. Asker',
      suggestCountryPlaceholder: 'F.eks. Norway',
      suggestAddressPlaceholder: 'F.eks. Gate 1, Poststed',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Send forslag til moderering',
      suggestionMissingFields: 'Fyll inn navn, kommune og land før innsending.',
      suggestionOpeningIssue: 'Åpner GitHub-issue for moderering ...',
      reportHeading: 'Rapporter feil oppføring',
      reportIntro: 'Rapporter steder som ikke bør være listet. Endringer gjøres først etter manuell kontroll.',
      reportNameLabel: 'Stedsnavn',
      reportReasonLabel: 'Hva er feil?',
      reportAddressLabel: 'Adresse (hvis kjent)',
      reportWebsiteLabel: 'Hjemmeside (hvis kjent)',
      reportNamePlaceholder: 'F.eks. Farm shop 12345',
      reportReasonPlaceholder: 'Kort begrunnelse',
      reportAddressPlaceholder: 'F.eks. Gate 1, Poststed',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Send rapport til moderering',
      reportMissingFields: 'Fyll inn stedsnavn og begrunnelse før innsending.',
      reportOpeningIssue: 'Åpner GitHub-issue for moderering ...',
      quickReportBtn: 'Rapporter',
      quickReportDefaultReason: 'Virker ikke som et faktisk gårdsutsalg.',
    },
    en: {
      languageLabel: 'Language',
      pageTitle: 'Farm Shops',
      introText: 'Find local producers and farm shops. Filter by country → county/region → municipality, search products, and plan routes.',
      topHomeTab: 'Home',
      topFarmshopsTab: 'Farm Shops',
      topOrganicTab: 'Organic Farm Shops',
      topImmigrantTab: 'Immigrant Shops',
      topNewsTab: 'News & Media',
      topContactTab: 'Contact us',
      backBtn: '← Back',
      homeLinkText: '🏠 Home',
      newsLinkText: '📰 News',
      applyFiltersBtn: 'Update search',
      sortNameAsc: 'Sort: Name A-Z',
      sortNameDesc: 'Sort: Name Z-A',
      sortDistance: 'Sort: Nearest first',
      searchPlaceholder: 'Search shop',
      myMunicipalityBtn: 'Search in area',
      nearMeBtn: 'Find near my position',
      distanceLabel: 'Distance',
      routeFromPlaceholder: 'From (address or city)',
      routeToPlaceholder: 'To (address or city)',
      routeBtn: 'Find along route',
      resetBtn: 'Reset',
      mapSizeLabel: 'Map height',
      countryPlaceholder: 'Select country',
      regionPlaceholder: 'Select county/region',
      municipalityPlaceholder: 'Select municipality',
      resultsHeadingDefault: 'Farm shops near you',
      nearbyHeadingPrefix: 'Farm shops near you',
      suggestionHeading: 'Suggest a missing place',
      suggestionIntro: 'Missing a farm outlet? Submit name, municipality and country for moderation.',
      suggestNameLabel: 'Name',
      suggestMunicipalityLabel: 'Municipality',
      suggestCountryLabel: 'Country',
      suggestAddressLabel: 'Address (recommended)',
      suggestWebsiteLabel: 'Website (recommended)',
      suggestNamePlaceholder: 'E.g. Solheim farm',
      suggestMunicipalityPlaceholder: 'E.g. Asker',
      suggestCountryPlaceholder: 'E.g. Norway',
      suggestAddressPlaceholder: 'E.g. Street 1, City',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Send suggestion for moderation',
      suggestionMissingFields: 'Please fill in name, municipality and country.',
      suggestionOpeningIssue: 'Opening GitHub issue for moderation ...',
      reportHeading: 'Report incorrect listing',
      reportIntro: 'Report places that should not be listed. Changes are only made after manual review.',
      reportNameLabel: 'Place name',
      reportReasonLabel: 'What is wrong?',
      reportAddressLabel: 'Address (if known)',
      reportWebsiteLabel: 'Website (if known)',
      reportNamePlaceholder: 'E.g. Farm shop 12345',
      reportReasonPlaceholder: 'Short reason',
      reportAddressPlaceholder: 'E.g. Street 1, City',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Send report for moderation',
      reportMissingFields: 'Please fill in place name and reason.',
      reportOpeningIssue: 'Opening GitHub issue for moderation ...',
      quickReportBtn: 'Report',
      quickReportDefaultReason: 'Does not appear to be a real farm shop.',
    },
    fr: {
      languageLabel: 'Langue',
      pageTitle: 'Fermes & March\u00e9s',
      introText: 'Trouvez des producteurs locaux et des boutiques de ferme. Filtrez par pays \u2192 r\u00e9gion \u2192 commune, recherchez des produits et planifiez vos itin\u00e9raires.',
      topHomeTab: 'Accueil',
      topFarmshopsTab: 'Fermes & March\u00e9s',
      topOrganicTab: 'Fermes Bio',
      topImmigrantTab: '\u00c9piceries immigrantes',
      topNewsTab: 'Actualit\u00e9s',
      topContactTab: 'Nous contacter',
      backBtn: '\u2190 Retour',
      homeLinkText: '\ud83c\udfe0 Accueil',
      newsLinkText: '\ud83d\udcf0 Actualit\u00e9s',
      applyFiltersBtn: 'Mettre \u00e0 jour',
      sortNameAsc: 'Trier\u00a0: Nom A-Z',
      sortNameDesc: 'Trier\u00a0: Nom Z-A',
      sortDistance: 'Trier\u00a0: Plus proche',
      searchPlaceholder: 'Rechercher une boutique',
      myMunicipalityBtn: 'Rechercher dans la zone',
      nearMeBtn: 'Trouver pr\u00e8s de moi',
      distanceLabel: 'Distance',
      routeFromPlaceholder: 'De (adresse ou ville)',
      routeToPlaceholder: '\u00c0 (adresse ou ville)',
      routeBtn: 'Trouver sur l\'itin\u00e9raire',
      resetBtn: 'R\u00e9initialiser',
      mapSizeLabel: 'Hauteur de la carte',
      countryPlaceholder: 'Choisir un pays',
      regionPlaceholder: 'Choisir une r\u00e9gion',
      municipalityPlaceholder: 'Choisir une commune',
      resultsHeadingDefault: 'Fermes pr\u00e8s de chez vous',
      nearbyHeadingPrefix: 'Fermes pr\u00e8s de chez vous',
      suggestionHeading: 'Sugg\u00e9rer un lieu manquant',
      suggestionIntro: 'Un lieu manque\u00a0? Envoyez le nom, la commune et le pays pour mod\u00e9ration.',
      suggestNameLabel: 'Nom',
      suggestMunicipalityLabel: 'Commune',
      suggestCountryLabel: 'Pays',
      suggestAddressLabel: 'Adresse (recommand\u00e9e)',
      suggestWebsiteLabel: 'Site web (recommand\u00e9)',
      suggestNamePlaceholder: 'Ex. Ferme Solheim',
      suggestMunicipalityPlaceholder: 'Ex. Asker',
      suggestCountryPlaceholder: 'Ex. Norv\u00e8ge',
      suggestAddressPlaceholder: 'Ex. Rue 1, Ville',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Envoyer pour mod\u00e9ration',
      suggestionMissingFields: 'Veuillez remplir le nom, la commune et le pays.',
      suggestionOpeningIssue: 'Ouverture d\'un ticket GitHub pour mod\u00e9ration\u00a0...',
      reportHeading: 'Signaler un listing incorrect',
      reportIntro: 'Signalez des lieux qui ne devraient pas \u00eatre list\u00e9s. Les modifications sont effectu\u00e9es apr\u00e8s v\u00e9rification manuelle.',
      reportNameLabel: 'Nom du lieu',
      reportReasonLabel: 'Quel est le probl\u00e8me\u00a0?',
      reportAddressLabel: 'Adresse (si connue)',
      reportWebsiteLabel: 'Site web (si connu)',
      reportNamePlaceholder: 'Ex. Ferme 12345',
      reportReasonPlaceholder: 'Br\u00e8ve raison',
      reportAddressPlaceholder: 'Ex. Rue 1, Ville',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Envoyer un rapport pour mod\u00e9ration',
      reportMissingFields: 'Veuillez remplir le nom du lieu et la raison.',
      reportOpeningIssue: 'Ouverture d\'un ticket GitHub pour mod\u00e9ration\u00a0...',
      quickReportBtn: 'Signaler',
      quickReportDefaultReason: 'Ne semble pas \u00eatre un vrai march\u00e9 de ferme.',
    },
    de: {
      languageLabel: 'Sprache',
      pageTitle: 'Hofl\u00e4den',
      introText: 'Finden Sie lokale Produzenten und Hofl\u00e4den. Filtern nach Land \u2192 Region \u2192 Gemeinde, Produkte suchen und Routen planen.',
      topHomeTab: 'Startseite',
      topFarmshopsTab: 'Hofl\u00e4den',
      topOrganicTab: 'Bio-Hofl\u00e4den',
      topImmigrantTab: 'Einwandererl\u00e4den',
      topNewsTab: 'Neuigkeiten',
      topContactTab: 'Kontakt',
      backBtn: '\u2190 Zur\u00fcck',
      homeLinkText: '\ud83c\udfe0 Startseite',
      newsLinkText: '\ud83d\udcf0 Neuigkeiten',
      applyFiltersBtn: 'Suche aktualisieren',
      sortNameAsc: 'Sortieren: Name A-Z',
      sortNameDesc: 'Sortieren: Name Z-A',
      sortDistance: 'Sortieren: N\u00e4chste zuerst',
      searchPlaceholder: 'Gesch\u00e4ft suchen',
      myMunicipalityBtn: 'Im Bereich suchen',
      nearMeBtn: 'In meiner N\u00e4he finden',
      distanceLabel: 'Entfernung',
      routeFromPlaceholder: 'Von (Adresse oder Stadt)',
      routeToPlaceholder: 'Nach (Adresse oder Stadt)',
      routeBtn: 'Auf der Route finden',
      resetBtn: 'Zur\u00fccksetzen',
      mapSizeLabel: 'Kartenh\u00f6he',
      countryPlaceholder: 'Land ausw\u00e4hlen',
      regionPlaceholder: 'Region ausw\u00e4hlen',
      municipalityPlaceholder: 'Gemeinde ausw\u00e4hlen',
      resultsHeadingDefault: 'Hofl\u00e4den in Ihrer N\u00e4he',
      nearbyHeadingPrefix: 'Hofl\u00e4den in Ihrer N\u00e4he',
      suggestionHeading: 'Fehlenden Ort vorschlagen',
      suggestionIntro: 'Fehlt ein Hofladen? Name, Gemeinde und Land zur Moderation einsenden.',
      suggestNameLabel: 'Name',
      suggestMunicipalityLabel: 'Gemeinde',
      suggestCountryLabel: 'Land',
      suggestAddressLabel: 'Adresse (empfohlen)',
      suggestWebsiteLabel: 'Webseite (empfohlen)',
      suggestNamePlaceholder: 'Z.B. Solheim-Hof',
      suggestMunicipalityPlaceholder: 'Z.B. Asker',
      suggestCountryPlaceholder: 'Z.B. Norwegen',
      suggestAddressPlaceholder: 'Z.B. Stra\u00dfe 1, Stadt',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Zur Moderation senden',
      suggestionMissingFields: 'Bitte Name, Gemeinde und Land ausf\u00fcllen.',
      suggestionOpeningIssue: '\u00d6ffne GitHub-Issue zur Moderation\u00a0...',
      reportHeading: 'Fehlerhaften Eintrag melden',
      reportIntro: 'Melden Sie Orte, die nicht aufgef\u00fchrt werden sollten. \u00c4nderungen erfolgen erst nach manueller Pr\u00fcfung.',
      reportNameLabel: 'Ortsname',
      reportReasonLabel: 'Was ist falsch?',
      reportAddressLabel: 'Adresse (falls bekannt)',
      reportWebsiteLabel: 'Webseite (falls bekannt)',
      reportNamePlaceholder: 'Z.B. Hofladen 12345',
      reportReasonPlaceholder: 'Kurze Begr\u00fcndung',
      reportAddressPlaceholder: 'Z.B. Stra\u00dfe 1, Stadt',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Bericht zur Moderation senden',
      reportMissingFields: 'Bitte Ortsname und Begr\u00fcndung ausf\u00fcllen.',
      reportOpeningIssue: '\u00d6ffne GitHub-Issue zur Moderation\u00a0...',
      quickReportBtn: 'Melden',
      quickReportDefaultReason: 'Scheint kein echter Hofladen zu sein.',
    },
    sv: {
      languageLabel: 'Spr\u00e5k',
      pageTitle: 'G\u00e5rdsbutiker',
      introText: 'Hitta lokala producenter och g\u00e5rdsbutiker. Filtrera efter land \u2192 region \u2192 kommun, s\u00f6k produkter och planera resor.',
      topHomeTab: 'Hem',
      topFarmshopsTab: 'G\u00e5rdsbutiker',
      topOrganicTab: 'Ekologiska g\u00e5rdsbutiker',
      topImmigrantTab: 'Invandringsbutiker',
      topNewsTab: 'Nyheter',
      topContactTab: 'Kontakta oss',
      backBtn: '\u2190 Tillbaka',
      homeLinkText: '\ud83c\udfe0 Hem',
      newsLinkText: '\ud83d\udcf0 Nyheter',
      applyFiltersBtn: 'Uppdatera s\u00f6kning',
      sortNameAsc: 'Sortera: Namn A-\u00d6',
      sortNameDesc: 'Sortera: Namn \u00d6-A',
      sortDistance: 'Sortera: N\u00e4rmast dig',
      searchPlaceholder: 'S\u00f6k butik',
      myMunicipalityBtn: 'S\u00f6k i omr\u00e5det',
      nearMeBtn: 'Hitta n\u00e4ra mig',
      distanceLabel: 'Avst\u00e5nd',
      routeFromPlaceholder: 'Fr\u00e5n (adress eller stad)',
      routeToPlaceholder: 'Till (adress eller stad)',
      routeBtn: 'Hitta l\u00e4ngs v\u00e4gen',
      resetBtn: '\u00c5terst\u00e4ll',
      mapSizeLabel: 'Karth\u00f6jd',
      countryPlaceholder: 'V\u00e4lj land',
      regionPlaceholder: 'V\u00e4lj region',
      municipalityPlaceholder: 'V\u00e4lj kommun',
      resultsHeadingDefault: 'G\u00e5rdsbutiker n\u00e4ra dig',
      nearbyHeadingPrefix: 'G\u00e5rdsbutiker n\u00e4ra dig',
      suggestionHeading: 'F\u00f6resl\u00e5 en plats som saknas',
      suggestionIntro: 'Saknas ett g\u00e5rdsutsalg? Skicka in namn, kommun och land f\u00f6r moderering.',
      suggestNameLabel: 'Namn',
      suggestMunicipalityLabel: 'Kommun',
      suggestCountryLabel: 'Land',
      suggestAddressLabel: 'Adress (rekommenderas)',
      suggestWebsiteLabel: 'Webbplats (rekommenderas)',
      suggestNamePlaceholder: 'T.ex. Solheims g\u00e5rd',
      suggestMunicipalityPlaceholder: 'T.ex. Asker',
      suggestCountryPlaceholder: 'T.ex. Norge',
      suggestAddressPlaceholder: 'T.ex. Gata 1, Stad',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Skicka f\u00f6rslag f\u00f6r moderering',
      suggestionMissingFields: 'Fyll i namn, kommun och land.',
      suggestionOpeningIssue: '\u00d6ppnar GitHub-\u00e4rende f\u00f6r moderering\u00a0...',
      reportHeading: 'Rapportera felaktig post',
      reportIntro: 'Rapportera platser som inte borde vara listade. \u00c4ndringar g\u00f6rs efter manuell kontroll.',
      reportNameLabel: 'Platsnamn',
      reportReasonLabel: 'Vad \u00e4r fel?',
      reportAddressLabel: 'Adress (om k\u00e4nd)',
      reportWebsiteLabel: 'Webbplats (om k\u00e4nd)',
      reportNamePlaceholder: 'T.ex. G\u00e5rdsbutik 12345',
      reportReasonPlaceholder: 'Kort anledning',
      reportAddressPlaceholder: 'T.ex. Gata 1, Stad',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Skicka rapport f\u00f6r moderering',
      reportMissingFields: 'Fyll i platsnamn och anledning.',
      reportOpeningIssue: '\u00d6ppnar GitHub-\u00e4rende f\u00f6r moderering\u00a0...',
      quickReportBtn: 'Rapportera',
      quickReportDefaultReason: 'Verkar inte vara en riktig g\u00e5rdsbutik.',
    },
    da: {
      languageLabel: 'Sprog',
      pageTitle: 'G\u00e5rdsbutikker',
      introText: 'Find lokale producenter og g\u00e5rdsbutikker. Filtrer efter land \u2192 region \u2192 kommune, s\u00f8g produkter og planl\u00e6g ruter.',
      topHomeTab: 'Hjem',
      topFarmshopsTab: 'G\u00e5rdsbutikker',
      topOrganicTab: '\u00d8kologiske g\u00e5rdsbutikker',
      topImmigrantTab: 'Indvandrerbutikker',
      topNewsTab: 'Nyheder',
      topContactTab: 'Kontakt os',
      backBtn: '\u2190 Tilbage',
      homeLinkText: '\ud83c\udfe0 Hjem',
      newsLinkText: '\ud83d\udcf0 Nyheder',
      applyFiltersBtn: 'Opdater s\u00f8gning',
      sortNameAsc: 'Sorter: Navn A-\u00c5',
      sortNameDesc: 'Sorter: Navn \u00c5-A',
      sortDistance: 'Sorter: N\u00e6rmest dig',
      searchPlaceholder: 'S\u00f8g butik',
      myMunicipalityBtn: 'S\u00f8g i omr\u00e5det',
      nearMeBtn: 'Find n\u00e6r mig',
      distanceLabel: 'Afstand',
      routeFromPlaceholder: 'Fra (adresse eller by)',
      routeToPlaceholder: 'Til (adresse eller by)',
      routeBtn: 'Find langs ruten',
      resetBtn: 'Nulstil',
      mapSizeLabel: 'Korths\u00f8jde',
      countryPlaceholder: 'V\u00e6lg land',
      regionPlaceholder: 'V\u00e6lg region',
      municipalityPlaceholder: 'V\u00e6lg kommune',
      resultsHeadingDefault: 'G\u00e5rdsbutikker n\u00e6r dig',
      nearbyHeadingPrefix: 'G\u00e5rdsbutikker n\u00e6r dig',
      suggestionHeading: 'Foresl\u00e5 et manglende sted',
      suggestionIntro: 'Mangler der et g\u00e5rdsudsalg? Indsend navn, kommune og land til moderering.',
      suggestNameLabel: 'Navn',
      suggestMunicipalityLabel: 'Kommune',
      suggestCountryLabel: 'Land',
      suggestAddressLabel: 'Adresse (anbefalet)',
      suggestWebsiteLabel: 'Hjemmeside (anbefalet)',
      suggestNamePlaceholder: 'F.eks. Solheim g\u00e5rd',
      suggestMunicipalityPlaceholder: 'F.eks. Asker',
      suggestCountryPlaceholder: 'F.eks. Norge',
      suggestAddressPlaceholder: 'F.eks. Gade 1, By',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Send forslag til moderering',
      suggestionMissingFields: 'Udfyld navn, kommune og land f\u00f8r indsendelse.',
      suggestionOpeningIssue: '\u00c5bner GitHub-sag til moderering\u00a0...',
      reportHeading: 'Rapporter forkert opf\u00f8ring',
      reportIntro: 'Rapporter steder, der ikke b\u00f8r v\u00e6re listet. \u00c6ndringer foretages kun efter manuel kontrol.',
      reportNameLabel: 'Stedsnavn',
      reportReasonLabel: 'Hvad er forkert?',
      reportAddressLabel: 'Adresse (hvis kendt)',
      reportWebsiteLabel: 'Hjemmeside (hvis kendt)',
      reportNamePlaceholder: 'F.eks. G\u00e5rdsbutik 12345',
      reportReasonPlaceholder: 'Kort begrundelse',
      reportAddressPlaceholder: 'F.eks. Gade 1, By',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Send rapport til moderering',
      reportMissingFields: 'Udfyld stedsnavn og begrundelse f\u00f8r indsendelse.',
      reportOpeningIssue: '\u00c5bner GitHub-sag til moderering\u00a0...',
      quickReportBtn: 'Rapporter',
      quickReportDefaultReason: 'Ser ikke ud til at v\u00e6re en rigtig g\u00e5rdsbutik.',
    },
    fi: {
      languageLabel: 'Kieli',
      pageTitle: 'Tilakaupat',
      introText: 'L\u00f6yd\u00e4 paikallisia tuottajia ja tilakauppoja. Suodata maan \u2192 alueen \u2192 kunnan mukaan, etsi tuotteita ja suunnittele reittej\u00e4.',
      topHomeTab: 'Koti',
      topFarmshopsTab: 'Tilakaupat',
      topOrganicTab: 'Luomutilat',
      topImmigrantTab: 'Maahanmuuttajakaupat',
      topNewsTab: 'Uutiset',
      topContactTab: 'Yhteystiedot',
      backBtn: '\u2190 Takaisin',
      homeLinkText: '\ud83c\udfe0 Koti',
      newsLinkText: '\ud83d\udcf0 Uutiset',
      applyFiltersBtn: 'P\u00e4ivit\u00e4 haku',
      sortNameAsc: 'Lajittele: Nimi A-\u00d6',
      sortNameDesc: 'Lajittele: Nimi \u00d6-A',
      sortDistance: 'Lajittele: L\u00e4hin ensin',
      searchPlaceholder: 'Etsi kauppa',
      myMunicipalityBtn: 'Etsi alueelta',
      nearMeBtn: 'L\u00f6yd\u00e4 l\u00e4helt\u00e4 minua',
      distanceLabel: 'Et\u00e4isyys',
      routeFromPlaceholder: 'L\u00e4ht\u00f6paikka (osoite tai kaupunki)',
      routeToPlaceholder: 'P\u00e4\u00e4tepaikka (osoite tai kaupunki)',
      routeBtn: 'L\u00f6yd\u00e4 reitin varrelta',
      resetBtn: 'Nollaa',
      mapSizeLabel: 'Kartan korkeus',
      countryPlaceholder: 'Valitse maa',
      regionPlaceholder: 'Valitse alue',
      municipalityPlaceholder: 'Valitse kunta',
      resultsHeadingDefault: 'Tilakaupat l\u00e4hell\u00e4 sinua',
      nearbyHeadingPrefix: 'Tilakaupat l\u00e4hell\u00e4 sinua',
      suggestionHeading: 'Ehdota puuttuvaa paikkaa',
      suggestionIntro: 'Puuttuuko tilakauppa? L\u00e4het\u00e4 nimi, kunta ja maa moderointia varten.',
      suggestNameLabel: 'Nimi',
      suggestMunicipalityLabel: 'Kunta',
      suggestCountryLabel: 'Maa',
      suggestAddressLabel: 'Osoite (suositeltava)',
      suggestWebsiteLabel: 'Verkkosivusto (suositeltava)',
      suggestNamePlaceholder: 'Esim. Solheimin tila',
      suggestMunicipalityPlaceholder: 'Esim. Asker',
      suggestCountryPlaceholder: 'Esim. Norja',
      suggestAddressPlaceholder: 'Esim. Katu 1, Kaupunki',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'L\u00e4het\u00e4 ehdotus moderointiin',
      suggestionMissingFields: 'T\u00e4yt\u00e4 nimi, kunta ja maa ennen l\u00e4hettämist\u00e4.',
      suggestionOpeningIssue: 'Avataan GitHub-ongelma moderointia varten\u00a0...',
      reportHeading: 'Ilmoita v\u00e4\u00e4r\u00e4st\u00e4 merkinn\u00e4st\u00e4',
      reportIntro: 'Ilmoita paikoista, joita ei pitäisi listata. Muutokset tehd\u00e4\u00e4n vasta manuaalisen tarkistuksen j\u00e4lkeen.',
      reportNameLabel: 'Paikan nimi',
      reportReasonLabel: 'Mikä on vialla?',
      reportAddressLabel: 'Osoite (jos tiedossa)',
      reportWebsiteLabel: 'Verkkosivusto (jos tiedossa)',
      reportNamePlaceholder: 'Esim. Tilakauppa 12345',
      reportReasonPlaceholder: 'Lyhyt syy',
      reportAddressPlaceholder: 'Esim. Katu 1, Kaupunki',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'L\u00e4het\u00e4 raportti moderointiin',
      reportMissingFields: 'T\u00e4yt\u00e4 paikan nimi ja syy ennen l\u00e4hettämistä.',
      reportOpeningIssue: 'Avataan GitHub-ongelma moderointia varten\u00a0...',
      quickReportBtn: 'Ilmoita',
      quickReportDefaultReason: 'Ei vaikuta oikealta tilakaupalta.',
    },
    nl: {
      languageLabel: 'Taal',
      pageTitle: 'Boerderijwinkels',
      introText: 'Vind lokale producenten en boerderijwinkels. Filter op land \u2192 regio \u2192 gemeente, zoek producten en plan routes.',
      topHomeTab: 'Startpagina',
      topFarmshopsTab: 'Boerderijwinkels',
      topOrganicTab: 'Biologische boerderijwinkels',
      topImmigrantTab: 'Immigrantenwinkels',
      topNewsTab: 'Nieuws',
      topContactTab: 'Neem contact op',
      backBtn: '\u2190 Terug',
      homeLinkText: '\ud83c\udfe0 Startpagina',
      newsLinkText: '\ud83d\udcf0 Nieuws',
      applyFiltersBtn: 'Zoekresultaten bijwerken',
      sortNameAsc: 'Sorteren: Naam A-Z',
      sortNameDesc: 'Sorteren: Naam Z-A',
      sortDistance: 'Sorteren: Dichtsbijzijnde',
      searchPlaceholder: 'Winkel zoeken',
      myMunicipalityBtn: 'Zoeken in het gebied',
      nearMeBtn: 'Vinden in mijn buurt',
      distanceLabel: 'Afstand',
      routeFromPlaceholder: 'Van (adres of stad)',
      routeToPlaceholder: 'Naar (adres of stad)',
      routeBtn: 'Vinden langs de route',
      resetBtn: 'Resetten',
      mapSizeLabel: 'Kaarthoogte',
      countryPlaceholder: 'Selecteer land',
      regionPlaceholder: 'Selecteer regio',
      municipalityPlaceholder: 'Selecteer gemeente',
      resultsHeadingDefault: 'Boerderijwinkels bij u in de buurt',
      nearbyHeadingPrefix: 'Boerderijwinkels bij u in de buurt',
      suggestionHeading: 'Ontbrekende plek voorstellen',
      suggestionIntro: 'Mist u een boerderijwinkel? Stuur naam, gemeente en land ter moderatie in.',
      suggestNameLabel: 'Naam',
      suggestMunicipalityLabel: 'Gemeente',
      suggestCountryLabel: 'Land',
      suggestAddressLabel: 'Adres (aanbevolen)',
      suggestWebsiteLabel: 'Website (aanbevolen)',
      suggestNamePlaceholder: 'Bijv. Boerderij Solheim',
      suggestMunicipalityPlaceholder: 'Bijv. Asker',
      suggestCountryPlaceholder: 'Bijv. Noorwegen',
      suggestAddressPlaceholder: 'Bijv. Straat 1, Stad',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Voorstel ter moderatie sturen',
      suggestionMissingFields: 'Vul naam, gemeente en land in.',
      suggestionOpeningIssue: 'GitHub-issue openen ter moderatie\u00a0...',
      reportHeading: 'Onjuiste vermelding melden',
      reportIntro: 'Meld plaatsen die niet vermeld zouden moeten zijn. Wijzigingen worden pas na handmatige controle doorgevoerd.',
      reportNameLabel: 'Plaatsnaam',
      reportReasonLabel: 'Wat is er fout?',
      reportAddressLabel: 'Adres (indien bekend)',
      reportWebsiteLabel: 'Website (indien bekend)',
      reportNamePlaceholder: 'Bijv. Boerderijwinkel 12345',
      reportReasonPlaceholder: 'Korte reden',
      reportAddressPlaceholder: 'Bijv. Straat 1, Stad',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Rapport ter moderatie sturen',
      reportMissingFields: 'Vul plaatsnaam en reden in.',
      reportOpeningIssue: 'GitHub-issue openen ter moderatie\u00a0...',
      quickReportBtn: 'Melden',
      quickReportDefaultReason: 'Lijkt geen echte boerderijwinkel te zijn.',
    },
    it: {
      languageLabel: 'Lingua',
      pageTitle: 'Negozi di Fattoria',
      introText: 'Trova produttori locali e negozi di fattoria. Filtra per paese \u2192 regione \u2192 comune, cerca prodotti e pianifica percorsi.',
      topHomeTab: 'Home',
      topFarmshopsTab: 'Negozi di Fattoria',
      topOrganicTab: 'Fattorie Biologiche',
      topImmigrantTab: 'Negozi Immigranti',
      topNewsTab: 'Notizie',
      topContactTab: 'Contattaci',
      backBtn: '\u2190 Indietro',
      homeLinkText: '\ud83c\udfe0 Home',
      newsLinkText: '\ud83d\udcf0 Notizie',
      applyFiltersBtn: 'Aggiorna ricerca',
      sortNameAsc: 'Ordina: Nome A-Z',
      sortNameDesc: 'Ordina: Nome Z-A',
      sortDistance: 'Ordina: Pi\u00f9 vicino',
      searchPlaceholder: 'Cerca negozio',
      myMunicipalityBtn: 'Cerca nell\'area',
      nearMeBtn: 'Trova vicino a me',
      distanceLabel: 'Distanza',
      routeFromPlaceholder: 'Da (indirizzo o citt\u00e0)',
      routeToPlaceholder: 'A (indirizzo o citt\u00e0)',
      routeBtn: 'Trova lungo il percorso',
      resetBtn: 'Reimposta',
      mapSizeLabel: 'Altezza mappa',
      countryPlaceholder: 'Seleziona paese',
      regionPlaceholder: 'Seleziona regione',
      municipalityPlaceholder: 'Seleziona comune',
      resultsHeadingDefault: 'Negozi di fattoria vicino a te',
      nearbyHeadingPrefix: 'Negozi di fattoria vicino a te',
      suggestionHeading: 'Suggerisci un luogo mancante',
      suggestionIntro: 'Manca un negozio di fattoria? Invia nome, comune e paese per la moderazione.',
      suggestNameLabel: 'Nome',
      suggestMunicipalityLabel: 'Comune',
      suggestCountryLabel: 'Paese',
      suggestAddressLabel: 'Indirizzo (consigliato)',
      suggestWebsiteLabel: 'Sito web (consigliato)',
      suggestNamePlaceholder: 'Es. Fattoria Solheim',
      suggestMunicipalityPlaceholder: 'Es. Asker',
      suggestCountryPlaceholder: 'Es. Norvegia',
      suggestAddressPlaceholder: 'Es. Via 1, Citt\u00e0',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Invia per moderazione',
      suggestionMissingFields: 'Compila nome, comune e paese.',
      suggestionOpeningIssue: 'Apertura issue GitHub per moderazione\u00a0...',
      reportHeading: 'Segnala inserimento errato',
      reportIntro: 'Segnala luoghi che non dovrebbero essere elencati. Le modifiche vengono apportate solo dopo revisione manuale.',
      reportNameLabel: 'Nome del luogo',
      reportReasonLabel: 'Qual \u00e8 il problema?',
      reportAddressLabel: 'Indirizzo (se noto)',
      reportWebsiteLabel: 'Sito web (se noto)',
      reportNamePlaceholder: 'Es. Fattoria 12345',
      reportReasonPlaceholder: 'Breve motivo',
      reportAddressPlaceholder: 'Es. Via 1, Citt\u00e0',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Invia rapporto per moderazione',
      reportMissingFields: 'Compila nome del luogo e motivo.',
      reportOpeningIssue: 'Apertura issue GitHub per moderazione\u00a0...',
      quickReportBtn: 'Segnala',
      quickReportDefaultReason: 'Non sembra essere un vero negozio di fattoria.',
    },
    pt: {
      languageLabel: 'Idioma',
      pageTitle: 'Lojas de Quinta',
      introText: 'Encontre produtores locais e lojas de quinta. Filtre por pa\u00eds \u2192 regi\u00e3o \u2192 munic\u00edpio, pesquise produtos e planeie rotas.',
      topHomeTab: 'In\u00edcio',
      topFarmshopsTab: 'Lojas de Quinta',
      topOrganicTab: 'Quintas Biol\u00f3gicas',
      topImmigrantTab: 'Lojas de Imigrantes',
      topNewsTab: 'Not\u00edcias',
      topContactTab: 'Contacto',
      backBtn: '\u2190 Voltar',
      homeLinkText: '\ud83c\udfe0 In\u00edcio',
      newsLinkText: '\ud83d\udcf0 Not\u00edcias',
      applyFiltersBtn: 'Atualizar pesquisa',
      sortNameAsc: 'Ordenar: Nome A-Z',
      sortNameDesc: 'Ordenar: Nome Z-A',
      sortDistance: 'Ordenar: Mais pr\u00f3ximo',
      searchPlaceholder: 'Pesquisar loja',
      myMunicipalityBtn: 'Pesquisar na \u00e1rea',
      nearMeBtn: 'Encontrar perto de mim',
      distanceLabel: 'Dist\u00e2ncia',
      routeFromPlaceholder: 'De (endere\u00e7o ou cidade)',
      routeToPlaceholder: 'Para (endere\u00e7o ou cidade)',
      routeBtn: 'Encontrar ao longo da rota',
      resetBtn: 'Repor',
      mapSizeLabel: 'Altura do mapa',
      countryPlaceholder: 'Selecionar pa\u00eds',
      regionPlaceholder: 'Selecionar regi\u00e3o',
      municipalityPlaceholder: 'Selecionar munic\u00edpio',
      resultsHeadingDefault: 'Lojas de quinta perto de si',
      nearbyHeadingPrefix: 'Lojas de quinta perto de si',
      suggestionHeading: 'Sugerir um lugar em falta',
      suggestionIntro: 'Falta uma loja de quinta? Envie o nome, munic\u00edpio e pa\u00eds para modera\u00e7\u00e3o.',
      suggestNameLabel: 'Nome',
      suggestMunicipalityLabel: 'Munic\u00edpio',
      suggestCountryLabel: 'Pa\u00eds',
      suggestAddressLabel: 'Endere\u00e7o (recomendado)',
      suggestWebsiteLabel: 'S\u00edtio web (recomendado)',
      suggestNamePlaceholder: 'Ex. Quinta Solheim',
      suggestMunicipalityPlaceholder: 'Ex. Asker',
      suggestCountryPlaceholder: 'Ex. Noruega',
      suggestAddressPlaceholder: 'Ex. Rua 1, Cidade',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Enviar para modera\u00e7\u00e3o',
      suggestionMissingFields: 'Preencha o nome, munic\u00edpio e pa\u00eds.',
      suggestionOpeningIssue: 'A abrir issue no GitHub para modera\u00e7\u00e3o\u00a0...',
      reportHeading: 'Reportar listagem incorreta',
      reportIntro: 'Reporte locais que n\u00e3o devem estar listados. As altera\u00e7\u00f5es s\u00f3 s\u00e3o feitas ap\u00f3s revis\u00e3o manual.',
      reportNameLabel: 'Nome do local',
      reportReasonLabel: 'O que est\u00e1 errado?',
      reportAddressLabel: 'Endere\u00e7o (se conhecido)',
      reportWebsiteLabel: 'S\u00edtio web (se conhecido)',
      reportNamePlaceholder: 'Ex. Loja de quinta 12345',
      reportReasonPlaceholder: 'Breve motivo',
      reportAddressPlaceholder: 'Ex. Rua 1, Cidade',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Enviar relat\u00f3rio para modera\u00e7\u00e3o',
      reportMissingFields: 'Preencha o nome do local e o motivo.',
      reportOpeningIssue: 'A abrir issue no GitHub para modera\u00e7\u00e3o\u00a0...',
      quickReportBtn: 'Reportar',
      quickReportDefaultReason: 'N\u00e3o parece ser uma loja de quinta real.',
    },
    es: {
      languageLabel: 'Idioma',
      pageTitle: 'Tiendas de Granja',
      introText: 'Encuentra productores locales y tiendas de granja. Filtra por pa\u00eds \u2192 regi\u00f3n \u2192 municipio, busca productos y planifica rutas.',
      topHomeTab: 'Inicio',
      topFarmshopsTab: 'Tiendas de Granja',
      topOrganicTab: 'Granjas Ecol\u00f3gicas',
      topImmigrantTab: 'Tiendas de Inmigrantes',
      topNewsTab: 'Noticias',
      topContactTab: 'Cont\u00e1ctanos',
      backBtn: '\u2190 Volver',
      homeLinkText: '\ud83c\udfe0 Inicio',
      newsLinkText: '\ud83d\udcf0 Noticias',
      applyFiltersBtn: 'Actualizar b\u00fasqueda',
      sortNameAsc: 'Ordenar: Nombre A-Z',
      sortNameDesc: 'Ordenar: Nombre Z-A',
      sortDistance: 'Ordenar: M\u00e1s cercano',
      searchPlaceholder: 'Buscar tienda',
      myMunicipalityBtn: 'Buscar en el \u00e1rea',
      nearMeBtn: 'Encontrar cerca de m\u00ed',
      distanceLabel: 'Distancia',
      routeFromPlaceholder: 'Desde (direcci\u00f3n o ciudad)',
      routeToPlaceholder: 'Hasta (direcci\u00f3n o ciudad)',
      routeBtn: 'Encontrar a lo largo de la ruta',
      resetBtn: 'Restablecer',
      mapSizeLabel: 'Altura del mapa',
      countryPlaceholder: 'Seleccionar pa\u00eds',
      regionPlaceholder: 'Seleccionar regi\u00f3n',
      municipalityPlaceholder: 'Seleccionar municipio',
      resultsHeadingDefault: 'Tiendas de granja cerca de ti',
      nearbyHeadingPrefix: 'Tiendas de granja cerca de ti',
      suggestionHeading: 'Sugerir un lugar que falta',
      suggestionIntro: '\u00bfFalta una tienda de granja? Env\u00eda nombre, municipio y pa\u00eds para moderaci\u00f3n.',
      suggestNameLabel: 'Nombre',
      suggestMunicipalityLabel: 'Municipio',
      suggestCountryLabel: 'Pa\u00eds',
      suggestAddressLabel: 'Direcci\u00f3n (recomendada)',
      suggestWebsiteLabel: 'Sitio web (recomendado)',
      suggestNamePlaceholder: 'P.ej. Granja Solheim',
      suggestMunicipalityPlaceholder: 'P.ej. Asker',
      suggestCountryPlaceholder: 'P.ej. Noruega',
      suggestAddressPlaceholder: 'P.ej. Calle 1, Ciudad',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Enviar para moderaci\u00f3n',
      suggestionMissingFields: 'Por favor, rellena nombre, municipio y pa\u00eds.',
      suggestionOpeningIssue: 'Abriendo issue en GitHub para moderaci\u00f3n\u00a0...',
      reportHeading: 'Reportar listado incorrecto',
      reportIntro: 'Reporta lugares que no deber\u00edan estar listados. Los cambios solo se realizan tras revisi\u00f3n manual.',
      reportNameLabel: 'Nombre del lugar',
      reportReasonLabel: '\u00bfCu\u00e1l es el problema?',
      reportAddressLabel: 'Direcci\u00f3n (si se conoce)',
      reportWebsiteLabel: 'Sitio web (si se conoce)',
      reportNamePlaceholder: 'P.ej. Tienda de granja 12345',
      reportReasonPlaceholder: 'Breve motivo',
      reportAddressPlaceholder: 'P.ej. Calle 1, Ciudad',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Enviar informe para moderaci\u00f3n',
      reportMissingFields: 'Por favor, rellena el nombre del lugar y el motivo.',
      reportOpeningIssue: 'Abriendo issue en GitHub para moderaci\u00f3n\u00a0...',
      quickReportBtn: 'Reportar',
      quickReportDefaultReason: 'No parece ser una tienda de granja real.',
    },
    ko: {
      languageLabel: '언어',
      pageTitle: '농장 상점',
      introText: '지역 생산자와 농장 상점을 찾아보세요. 국가 → 주/지역 → 시군구로 필터링하고, 제품을 검색하며 경로를 계획하세요.',
      topHomeTab: '홈',
      topFarmshopsTab: '농장 상점',
      topOrganicTab: '유기농 농장 상점',
      topImmigrantTab: '이민자 상점',
      topNewsTab: '뉴스 & 미디어',
      topContactTab: '문의하기',
      backBtn: '← 뒤로',
      homeLinkText: '🏠 홈',
      newsLinkText: '📰 뉴스',
      applyFiltersBtn: '검색 업데이트',
      sortNameAsc: '정렬: 이름 A-Z',
      sortNameDesc: '정렬: 이름 Z-A',
      sortDistance: '정렬: 가장 가까운',
      searchPlaceholder: '상점 검색',
      myMunicipalityBtn: '이 지역에서 검색',
      nearMeBtn: '내 위치 근처 찾기',
      distanceLabel: '거리',
      routeFromPlaceholder: '출발지 (주소 또는 도시)',
      routeToPlaceholder: '목적지 (주소 또는 도시)',
      routeBtn: '경로를 따라 찾기',
      resetBtn: '초기화',
      mapSizeLabel: '지도 높이',
      countryPlaceholder: '국가 선택',
      regionPlaceholder: '주/지역 선택',
      municipalityPlaceholder: '시군구 선택',
      resultsHeadingDefault: '내 근처 농장 상점',
      nearbyHeadingPrefix: '내 근처 농장 상점',
      suggestionHeading: '누락된 장소 제안',
      suggestionIntro: '농장 상점이 없나요? 검토를 위해 이름, 시군구, 국가를 제출하세요.',
      suggestNameLabel: '이름',
      suggestMunicipalityLabel: '시군구',
      suggestCountryLabel: '국가',
      suggestAddressLabel: '주소 (권장)',
      suggestWebsiteLabel: '웹사이트 (권장)',
      suggestNamePlaceholder: '예: 솔하임 농장',
      suggestMunicipalityPlaceholder: '예: 서울',
      suggestCountryPlaceholder: '예: South Korea',
      suggestAddressPlaceholder: '예: 거리 1, 도시',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: '검토를 위해 제안 보내기',
      suggestionMissingFields: '이름, 시군구, 국가를 입력해 주세요.',
      suggestionOpeningIssue: '검토를 위해 GitHub issue 열기 ...',
      reportHeading: '잘못된 항목 신고',
      reportIntro: '목록에 없어야 할 장소를 신고하세요. 변경은 수동 검토 후에만 이루어집니다.',
      reportNameLabel: '장소 이름',
      reportReasonLabel: '무엇이 잘못되었나요?',
      reportAddressLabel: '주소 (알고 있는 경우)',
      reportWebsiteLabel: '웹사이트 (알고 있는 경우)',
      reportNamePlaceholder: '예: 농장 상점 12345',
      reportReasonPlaceholder: '짧은 이유',
      reportAddressPlaceholder: '예: 거리 1, 도시',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: '검토를 위해 신고 보내기',
      reportMissingFields: '장소 이름과 이유를 입력해 주세요.',
      reportOpeningIssue: '검토를 위해 GitHub issue 열기 ...',
      quickReportBtn: '신고',
      quickReportDefaultReason: '실제 농장 상점처럼 보이지 않습니다.',
    },
    pl: {
      languageLabel: 'Język',
      pageTitle: 'Sklepy farmerskie',
      introText: 'Znajdź lokalnych producentów i sklepy farmerskie. Filtruj według kraju → województwa/regionu → gminy, szukaj produktów i planuj trasy.',
      topHomeTab: 'Strona główna',
      topFarmshopsTab: 'Sklepy farmerskie',
      topOrganicTab: 'Ekologiczne sklepy farmerskie',
      topImmigrantTab: 'Sklepy imigrantów',
      topNewsTab: 'Aktualności i media',
      topContactTab: 'Kontakt',
      backBtn: '← Wstecz',
      homeLinkText: '🏠 Strona główna',
      newsLinkText: '📰 Aktualności',
      applyFiltersBtn: 'Aktualizuj wyszukiwanie',
      sortNameAsc: 'Sortuj: Nazwa A-Z',
      sortNameDesc: 'Sortuj: Nazwa Z-A',
      sortDistance: 'Sortuj: Najbliżej',
      searchPlaceholder: 'Szukaj sklepu',
      myMunicipalityBtn: 'Szukaj w obszarze',
      nearMeBtn: 'Znajdź blisko mnie',
      distanceLabel: 'Odległość',
      routeFromPlaceholder: 'Z (adres lub miasto)',
      routeToPlaceholder: 'Do (adres lub miasto)',
      routeBtn: 'Znajdź wzdłuż trasy',
      resetBtn: 'Resetuj',
      mapSizeLabel: 'Wysokość mapy',
      countryPlaceholder: 'Wybierz kraj',
      regionPlaceholder: 'Wybierz województwo/region',
      municipalityPlaceholder: 'Wybierz gminę',
      resultsHeadingDefault: 'Sklepy farmerskie w pobliżu',
      nearbyHeadingPrefix: 'Sklepy farmerskie w pobliżu',
      suggestionHeading: 'Zaproponuj brakujące miejsce',
      suggestionIntro: 'Brakuje sklepu farmerskiego? Wyślij nazwę, gminę i kraj do moderacji.',
      suggestNameLabel: 'Nazwa',
      suggestMunicipalityLabel: 'Gmina',
      suggestCountryLabel: 'Kraj',
      suggestAddressLabel: 'Adres (zalecane)',
      suggestWebsiteLabel: 'Strona internetowa (zalecane)',
      suggestNamePlaceholder: 'Np. Farma Słoneczna',
      suggestMunicipalityPlaceholder: 'Np. Kraków',
      suggestCountryPlaceholder: 'Np. Poland',
      suggestAddressPlaceholder: 'Np. ul. 1, Miasto',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Wyślij propozycję do moderacji',
      suggestionMissingFields: 'Proszę podać nazwę, gminę i kraj.',
      suggestionOpeningIssue: 'Otwieranie zgłoszenia GitHub do moderacji ...',
      reportHeading: 'Zgłoś błędny wpis',
      reportIntro: 'Zgłoś miejsca, które nie powinny być wymienione. Zmiany są dokonywane tylko po ręcznym przeglądzie.',
      reportNameLabel: 'Nazwa miejsca',
      reportReasonLabel: 'Co jest nie tak?',
      reportAddressLabel: 'Adres (jeśli znany)',
      reportWebsiteLabel: 'Strona internetowa (jeśli znana)',
      reportNamePlaceholder: 'Np. Sklep farmerski 12345',
      reportReasonPlaceholder: 'Krótki powód',
      reportAddressPlaceholder: 'Np. ul. 1, Miasto',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Wyślij raport do moderacji',
      reportMissingFields: 'Proszę podać nazwę miejsca i powód.',
      reportOpeningIssue: 'Otwieranie zgłoszenia GitHub do moderacji ...',
      quickReportBtn: 'Zgłoś',
      quickReportDefaultReason: 'Nie wygląda na prawdziwy sklep farmerski.',
    },
    ru: {
      languageLabel: 'Язык',
      pageTitle: 'Фермерские магазины',
      introText: 'Найдите местных производителей и фермерские магазины. Фильтруйте по стране → региону → муниципалитету, ищите продукты и планируйте маршруты.',
      topHomeTab: 'Главная',
      topFarmshopsTab: 'Фермерские магазины',
      topOrganicTab: 'Органические фермерские магазины',
      topImmigrantTab: 'Магазины иммигрантов',
      topNewsTab: 'Новости и медиа',
      topContactTab: 'Связаться с нами',
      backBtn: '← Назад',
      homeLinkText: '🏠 Главная',
      newsLinkText: '📰 Новости',
      applyFiltersBtn: 'Обновить поиск',
      sortNameAsc: 'Сортировка: Имя А-Я',
      sortNameDesc: 'Сортировка: Имя Я-А',
      sortDistance: 'Сортировка: Ближайшие',
      searchPlaceholder: 'Поиск магазина',
      myMunicipalityBtn: 'Поиск в районе',
      nearMeBtn: 'Найти рядом со мной',
      distanceLabel: 'Расстояние',
      routeFromPlaceholder: 'Откуда (адрес или город)',
      routeToPlaceholder: 'Куда (адрес или город)',
      routeBtn: 'Найти вдоль маршрута',
      resetBtn: 'Сброс',
      mapSizeLabel: 'Высота карты',
      countryPlaceholder: 'Выберите страну',
      regionPlaceholder: 'Выберите регион',
      municipalityPlaceholder: 'Выберите муниципалитет',
      resultsHeadingDefault: 'Фермерские магазины рядом с вами',
      nearbyHeadingPrefix: 'Фермерские магазины рядом с вами',
      suggestionHeading: 'Предложить отсутствующее место',
      suggestionIntro: 'Нет фермерского магазина? Отправьте название, муниципалитет и страну на модерацию.',
      suggestNameLabel: 'Название',
      suggestMunicipalityLabel: 'Муниципалитет',
      suggestCountryLabel: 'Страна',
      suggestAddressLabel: 'Адрес (рекомендуется)',
      suggestWebsiteLabel: 'Сайт (рекомендуется)',
      suggestNamePlaceholder: 'Напр. Ферма Солнечная',
      suggestMunicipalityPlaceholder: 'Напр. Москва',
      suggestCountryPlaceholder: 'Напр. Russia',
      suggestAddressPlaceholder: 'Напр. ул. 1, Город',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'Отправить предложение на модерацию',
      suggestionMissingFields: 'Пожалуйста, заполните название, муниципалитет и страну.',
      suggestionOpeningIssue: 'Открытие GitHub issue для модерации ...',
      reportHeading: 'Сообщить о некорректной записи',
      reportIntro: 'Сообщите о местах, которые не должны быть в списке. Изменения вносятся только после ручной проверки.',
      reportNameLabel: 'Название места',
      reportReasonLabel: 'Что не так?',
      reportAddressLabel: 'Адрес (если известен)',
      reportWebsiteLabel: 'Сайт (если известен)',
      reportNamePlaceholder: 'Напр. Фермерский магазин 12345',
      reportReasonPlaceholder: 'Краткая причина',
      reportAddressPlaceholder: 'Напр. ул. 1, Город',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'Отправить отчёт на модерацию',
      reportMissingFields: 'Пожалуйста, заполните название места и причину.',
      reportOpeningIssue: 'Открытие GitHub issue для модерации ...',
      quickReportBtn: 'Пожаловаться',
      quickReportDefaultReason: 'Не похоже на настоящий фермерский магазин.',
    },
    zh: {
      languageLabel: '语言',
      pageTitle: '农场商店',
      introText: '查找本地生产商和农场商店。按国家 → 县/地区 → 市过滤，搜索产品并规划路线。',
      topHomeTab: '首页',
      topFarmshopsTab: '农场商店',
      topOrganicTab: '有机农场商店',
      topImmigrantTab: '移民商店',
      topNewsTab: '新闻与媒体',
      topContactTab: '联系我们',
      backBtn: '← 返回',
      homeLinkText: '🏠 首页',
      newsLinkText: '📰 新闻',
      applyFiltersBtn: '更新搜索',
      sortNameAsc: '排序：名称 A-Z',
      sortNameDesc: '排序：名称 Z-A',
      sortDistance: '排序：最近',
      searchPlaceholder: '搜索商店',
      myMunicipalityBtn: '在此区域搜索',
      nearMeBtn: '查找附近',
      distanceLabel: '距离',
      routeFromPlaceholder: '出发地（地址或城市）',
      routeToPlaceholder: '目的地（地址或城市）',
      routeBtn: '沿途查找',
      resetBtn: '重置',
      mapSizeLabel: '地图高度',
      countryPlaceholder: '选择国家',
      regionPlaceholder: '选择县/地区',
      municipalityPlaceholder: '选择市',
      resultsHeadingDefault: '附近的农场商店',
      nearbyHeadingPrefix: '附近的农场商店',
      suggestionHeading: '建议添加缺失地点',
      suggestionIntro: '缺少农场商店？提交名称、市和国家以供审核。',
      suggestNameLabel: '名称',
      suggestMunicipalityLabel: '市',
      suggestCountryLabel: '国家',
      suggestAddressLabel: '地址（推荐）',
      suggestWebsiteLabel: '网站（推荐）',
      suggestNamePlaceholder: '例如 阳光农场',
      suggestMunicipalityPlaceholder: '例如 北京',
      suggestCountryPlaceholder: '例如 China',
      suggestAddressPlaceholder: '例如 街道 1，城市',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: '提交建议以供审核',
      suggestionMissingFields: '请填写名称、市和国家。',
      suggestionOpeningIssue: '正在打开 GitHub issue 进行审核 ...',
      reportHeading: '举报错误条目',
      reportIntro: '举报不应列出的地点。更改仅在人工审核后进行。',
      reportNameLabel: '地点名称',
      reportReasonLabel: '有什么问题？',
      reportAddressLabel: '地址（如已知）',
      reportWebsiteLabel: '网站（如已知）',
      reportNamePlaceholder: '例如 农场商店 12345',
      reportReasonPlaceholder: '简短原因',
      reportAddressPlaceholder: '例如 街道 1，城市',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: '提交举报以供审核',
      reportMissingFields: '请填写地点名称和原因。',
      reportOpeningIssue: '正在打开 GitHub issue 进行审核 ...',
      quickReportBtn: '举报',
      quickReportDefaultReason: '看起来不像真正的农场商店。',
    },
    ar: {
      languageLabel: 'اللغة',
      pageTitle: 'متاجر المزارع',
      introText: 'ابحث عن المنتجين المحليين ومتاجر المزارع. صفّ حسب الدولة ← المنطقة ← البلدية، وابحث عن المنتجات وخطط للرحلات.',
      topHomeTab: 'الرئيسية',
      topFarmshopsTab: 'متاجر المزارع',
      topOrganicTab: 'متاجر المزارع العضوية',
      topImmigrantTab: 'متاجر المهاجرين',
      topNewsTab: 'الأخبار والإعلام',
      topContactTab: 'اتصل بنا',
      backBtn: '→ رجوع',
      homeLinkText: '🏠 الرئيسية',
      newsLinkText: '📰 الأخبار',
      applyFiltersBtn: 'تحديث البحث',
      sortNameAsc: 'ترتيب: الاسم أ-ي',
      sortNameDesc: 'ترتيب: الاسم ي-أ',
      sortDistance: 'ترتيب: الأقرب أولاً',
      searchPlaceholder: 'البحث عن متجر',
      myMunicipalityBtn: 'البحث في المنطقة',
      nearMeBtn: 'ابحث بالقرب مني',
      distanceLabel: 'المسافة',
      routeFromPlaceholder: 'من (عنوان أو مدينة)',
      routeToPlaceholder: 'إلى (عنوان أو مدينة)',
      routeBtn: 'ابحث على طول المسار',
      resetBtn: 'إعادة تعيين',
      mapSizeLabel: 'ارتفاع الخريطة',
      countryPlaceholder: 'اختر الدولة',
      regionPlaceholder: 'اختر المنطقة',
      municipalityPlaceholder: 'اختر البلدية',
      resultsHeadingDefault: 'متاجر المزارع بالقرب منك',
      nearbyHeadingPrefix: 'متاجر المزارع بالقرب منك',
      suggestionHeading: 'اقتراح مكان مفقود',
      suggestionIntro: 'هل تفتقد متجر مزرعة؟ أرسل الاسم والبلدية والدولة للمراجعة.',
      suggestNameLabel: 'الاسم',
      suggestMunicipalityLabel: 'البلدية',
      suggestCountryLabel: 'الدولة',
      suggestAddressLabel: 'العنوان (مستحسن)',
      suggestWebsiteLabel: 'الموقع الإلكتروني (مستحسن)',
      suggestNamePlaceholder: 'مثال: مزرعة سولهايم',
      suggestMunicipalityPlaceholder: 'مثال: الرياض',
      suggestCountryPlaceholder: 'مثال: Saudi Arabia',
      suggestAddressPlaceholder: 'مثال: شارع 1، المدينة',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'إرسال الاقتراح للمراجعة',
      suggestionMissingFields: 'الرجاء ملء الاسم والبلدية والدولة.',
      suggestionOpeningIssue: 'فتح مشكلة على GitHub للمراجعة ...',
      reportHeading: 'الإبلاغ عن إدخال غير صحيح',
      reportIntro: 'أبلغ عن الأماكن التي لا ينبغي أن تكون مدرجة. تُجرى التغييرات فقط بعد المراجعة اليدوية.',
      reportNameLabel: 'اسم المكان',
      reportReasonLabel: 'ما هي المشكلة؟',
      reportAddressLabel: 'العنوان (إذا كان معروفاً)',
      reportWebsiteLabel: 'الموقع الإلكتروني (إذا كان معروفاً)',
      reportNamePlaceholder: 'مثال: متجر مزرعة 12345',
      reportReasonPlaceholder: 'سبب مختصر',
      reportAddressPlaceholder: 'مثال: شارع 1، المدينة',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'إرسال التقرير للمراجعة',
      reportMissingFields: 'الرجاء ملء اسم المكان والسبب.',
      reportOpeningIssue: 'فتح مشكلة على GitHub للمراجعة ...',
      quickReportBtn: 'إبلاغ',
      quickReportDefaultReason: 'لا يبدو أنه متجر مزرعة حقيقي.',
    },
    th: {
      languageLabel: 'ภาษา',
      pageTitle: 'ร้านฟาร์ม',
      introText: 'ค้นหาผู้ผลิตในท้องถิ่นและร้านฟาร์ม กรองตามประเทศ → จังหวัด/ภูมิภาค → เขต ค้นหาสินค้า และวางแผนเส้นทาง',
      topHomeTab: 'หน้าหลัก',
      topFarmshopsTab: 'ร้านฟาร์ม',
      topOrganicTab: 'ร้านฟาร์มออร์แกนิก',
      topImmigrantTab: 'ร้านผู้อพยพ',
      topNewsTab: 'ข่าวและสื่อ',
      topContactTab: 'ติดต่อเรา',
      backBtn: '← กลับ',
      homeLinkText: '🏠 หน้าหลัก',
      newsLinkText: '📰 ข่าว',
      applyFiltersBtn: 'อัปเดตการค้นหา',
      sortNameAsc: 'เรียง: ชื่อ A-Z',
      sortNameDesc: 'เรียง: ชื่อ Z-A',
      sortDistance: 'เรียง: ใกล้ที่สุด',
      searchPlaceholder: 'ค้นหาร้าน',
      myMunicipalityBtn: 'ค้นหาในพื้นที่',
      nearMeBtn: 'ค้นหาใกล้ฉัน',
      distanceLabel: 'ระยะทาง',
      routeFromPlaceholder: 'จาก (ที่อยู่หรือเมือง)',
      routeToPlaceholder: 'ถึง (ที่อยู่หรือเมือง)',
      routeBtn: 'ค้นหาตามเส้นทาง',
      resetBtn: 'รีเซ็ต',
      mapSizeLabel: 'ความสูงแผนที่',
      countryPlaceholder: 'เลือกประเทศ',
      regionPlaceholder: 'เลือกจังหวัด/ภูมิภาค',
      municipalityPlaceholder: 'เลือกเขต',
      resultsHeadingDefault: 'ร้านฟาร์มใกล้คุณ',
      nearbyHeadingPrefix: 'ร้านฟาร์มใกล้คุณ',
      suggestionHeading: 'แนะนำสถานที่ที่หายไป',
      suggestionIntro: 'ไม่มีร้านฟาร์ม? ส่งชื่อ เขต และประเทศเพื่อการตรวจสอบ',
      suggestNameLabel: 'ชื่อ',
      suggestMunicipalityLabel: 'เขต',
      suggestCountryLabel: 'ประเทศ',
      suggestAddressLabel: 'ที่อยู่ (แนะนำ)',
      suggestWebsiteLabel: 'เว็บไซต์ (แนะนำ)',
      suggestNamePlaceholder: 'เช่น ฟาร์มซอลไฮม์',
      suggestMunicipalityPlaceholder: 'เช่น กรุงเทพฯ',
      suggestCountryPlaceholder: 'เช่น Thailand',
      suggestAddressPlaceholder: 'เช่น ถนน 1, เมือง',
      suggestWebsitePlaceholder: 'https://...',
      submitSuggestionBtn: 'ส่งคำแนะนำเพื่อตรวจสอบ',
      suggestionMissingFields: 'กรุณากรอกชื่อ เขต และประเทศ',
      suggestionOpeningIssue: 'กำลังเปิด GitHub issue เพื่อตรวจสอบ ...',
      reportHeading: 'รายงานรายการที่ไม่ถูกต้อง',
      reportIntro: 'รายงานสถานที่ที่ไม่ควรอยู่ในรายการ การเปลี่ยนแปลงจะทำหลังการตรวจสอบด้วยตนเองเท่านั้น',
      reportNameLabel: 'ชื่อสถานที่',
      reportReasonLabel: 'มีอะไรผิดปกติ?',
      reportAddressLabel: 'ที่อยู่ (ถ้าทราบ)',
      reportWebsiteLabel: 'เว็บไซต์ (ถ้าทราบ)',
      reportNamePlaceholder: 'เช่น ร้านฟาร์ม 12345',
      reportReasonPlaceholder: 'เหตุผลสั้นๆ',
      reportAddressPlaceholder: 'เช่น ถนน 1, เมือง',
      reportWebsitePlaceholder: 'https://...',
      submitReportBtn: 'ส่งรายงานเพื่อตรวจสอบ',
      reportMissingFields: 'กรุณากรอกชื่อสถานที่และเหตุผล',
      reportOpeningIssue: 'กำลังเปิด GitHub issue เพื่อตรวจสอบ ...',
      quickReportBtn: 'รายงาน',
      quickReportDefaultReason: 'ดูเหมือนไม่ใช่ร้านฟาร์มจริง',
    },
  };
  if (pageConfig.translationOverrides && typeof pageConfig.translationOverrides === 'object') {
    Object.entries(pageConfig.translationOverrides).forEach(([code, overrides]) => {
      if (!overrides || typeof overrides !== 'object') return;
      const base = PAGE_TRANSLATIONS[code] || PAGE_TRANSLATIONS.en;
      PAGE_TRANSLATIONS[code] = { ...base, ...overrides };
    });
  }
  let currentPageLanguage = 'nb';

  function languageDict(languageCode) {
    const code = (languageCode || '').toLowerCase();
    if (PAGE_TRANSLATIONS[code]) return PAGE_TRANSLATIONS[code];
    if (SUPPORTED_LANGUAGES.includes(code) && code !== 'nb') return PAGE_TRANSLATIONS.en;
    return PAGE_TRANSLATIONS.nb;
  }

  function hasNativeDictionary(languageCode) {
    const code = (languageCode || '').toLowerCase();
    return Boolean(PAGE_TRANSLATIONS[code]);
  }

  function translate(key) {
    return languageDict(currentPageLanguage)[key] || languageDict('nb')[key] || '';
  }

  function detectPreferredLanguage() {
    const saved = String(localStorage.getItem('matsjekk_lang') || '').toLowerCase().split('-')[0];
    if (SUPPORTED_LANGUAGES.includes(saved)) return saved;

    const raw = [
      ...(Array.isArray(navigator.languages) ? navigator.languages : []),
      navigator.language,
      navigator.userLanguage,
    ].filter(Boolean);

    for (const entry of raw) {
      const code = String(entry).toLowerCase().split('-')[0];
      if (SUPPORTED_LANGUAGES.includes(code)) return code;
    }

    try {
      const geo = JSON.parse(localStorage.getItem('matsjekk_geo_country') || '{}');
      const cc = String(geo?.country || '').toUpperCase();
      const byCountry = { NO: 'nb', SE: 'sv', DK: 'da', FI: 'fi', DE: 'de', NL: 'nl', FR: 'fr', IT: 'it', PT: 'pt', ES: 'es', PL: 'pl', RU: 'ru', CN: 'zh', KR: 'ko', TH: 'th', SA: 'ar', EG: 'ar', AE: 'ar', MA: 'ar' };
      if (byCountry[cc] && SUPPORTED_LANGUAGES.includes(byCountry[cc])) return byCountry[cc];
    } catch (_) {
      // Ignore invalid geo cache values.
    }

    return 'nb';
  }

  function optionByValue(selectElement, value) {
    return [...(selectElement?.options || [])].find((option) => option.value === value) || null;
  }

  function applyPageLanguage(languageCode) {
    const fallbackCode = SUPPORTED_LANGUAGES.includes(languageCode) ? languageCode : 'nb';
    currentPageLanguage = PAGE_TRANSLATIONS[fallbackCode] ? fallbackCode : 'en';
    document.documentElement.lang = currentPageLanguage;

    if (languageLabelEl) languageLabelEl.textContent = translate('languageLabel');
    if (pageTitleEl) pageTitleEl.textContent = translate('pageTitle');
    if (introTextEl) introTextEl.textContent = translate('introText');
    if (topHomeTabEl) topHomeTabEl.textContent = translate('topHomeTab');
    if (topFarmshopsTabEl) topFarmshopsTabEl.textContent = translate('topFarmshopsTab');
    if (topOrganicTabEl) topOrganicTabEl.textContent = translate('topOrganicTab');
    if (topImmigrantTabEl) topImmigrantTabEl.textContent = translate('topImmigrantTab');
    if (topNewsTabEl) topNewsTabEl.textContent = translate('topNewsTab');
    if (topContactTabEl) topContactTabEl.textContent = translate('topContactTab');
    if (backBtn) backBtn.textContent = translate('backBtn');
    if (applyFiltersBtn) applyFiltersBtn.textContent = translate('applyFiltersBtn');
    if (searchInput) searchInput.placeholder = translate('searchPlaceholder');
    if (myMunicipalityBtn) myMunicipalityBtn.textContent = translate('myMunicipalityBtn');
    if (nearMeBtn) nearMeBtn.textContent = translate('nearMeBtn');
    if (distanceLabelEl) distanceLabelEl.textContent = translate('distanceLabel');

    const routeFromEl = document.getElementById('routeFrom');
    const routeToEl = document.getElementById('routeTo');
    const routeBtnEl = document.getElementById('routeBtn');
    const resetBtnEl = document.getElementById('resetBtn');
    if (routeFromEl) routeFromEl.placeholder = translate('routeFromPlaceholder');
    if (routeToEl) routeToEl.placeholder = translate('routeToPlaceholder');
    if (routeBtnEl) routeBtnEl.textContent = translate('routeBtn');
    if (resetBtnEl) resetBtnEl.textContent = translate('resetBtn');
    if (resultsHeadingEl) resultsHeadingEl.textContent = translate('resultsHeadingDefault');

    const mapSizeLabelEl = document.querySelector('.map-size-label');
    if (mapSizeLabelEl) mapSizeLabelEl.textContent = translate('mapSizeLabel');

    const sortAsc = optionByValue(sortSelect, 'name_asc');
    const sortDesc = optionByValue(sortSelect, 'name_desc');
    const sortDistance = optionByValue(sortSelect, 'distance_asc');
    if (sortAsc) sortAsc.textContent = translate('sortNameAsc');
    if (sortDesc) sortDesc.textContent = translate('sortNameDesc');
    if (sortDistance) sortDistance.textContent = translate('sortDistance');

    const countryOption = optionByValue(countrySelect, '');
    const regionOption = optionByValue(regionSelect, '');
    const municipalityOption = optionByValue(muniSelect, '');
    if (countryOption) countryOption.textContent = translate('countryPlaceholder');
    if (regionOption) regionOption.textContent = translate('regionPlaceholder');
    if (municipalityOption) municipalityOption.textContent = translate('municipalityPlaceholder');

    if (suggestionHeadingEl) suggestionHeadingEl.textContent = translate('suggestionHeading');
    if (suggestionIntroEl) suggestionIntroEl.textContent = translate('suggestionIntro');
    if (suggestNameLabelEl) suggestNameLabelEl.textContent = translate('suggestNameLabel');
    if (suggestMunicipalityLabelEl) suggestMunicipalityLabelEl.textContent = translate('suggestMunicipalityLabel');
    if (suggestCountryLabelEl) suggestCountryLabelEl.textContent = translate('suggestCountryLabel');
    if (suggestAddressLabelEl) suggestAddressLabelEl.textContent = translate('suggestAddressLabel');
    if (suggestWebsiteLabelEl) suggestWebsiteLabelEl.textContent = translate('suggestWebsiteLabel');
    if (suggestNameEl) suggestNameEl.placeholder = translate('suggestNamePlaceholder');
    if (suggestMunicipalityEl) suggestMunicipalityEl.placeholder = translate('suggestMunicipalityPlaceholder');
    if (suggestCountryEl) suggestCountryEl.placeholder = translate('suggestCountryPlaceholder');
    if (suggestAddressEl) suggestAddressEl.placeholder = translate('suggestAddressPlaceholder');
    if (suggestWebsiteEl) suggestWebsiteEl.placeholder = translate('suggestWebsitePlaceholder');
    if (submitSuggestionBtn) submitSuggestionBtn.textContent = translate('submitSuggestionBtn');

    if (reportHeadingEl) reportHeadingEl.textContent = translate('reportHeading');
    if (reportIntroEl) reportIntroEl.textContent = translate('reportIntro');
    if (reportNameLabelEl) reportNameLabelEl.textContent = translate('reportNameLabel');
    if (reportReasonLabelEl) reportReasonLabelEl.textContent = translate('reportReasonLabel');
    if (reportAddressLabelEl) reportAddressLabelEl.textContent = translate('reportAddressLabel');
    if (reportWebsiteLabelEl) reportWebsiteLabelEl.textContent = translate('reportWebsiteLabel');
    if (reportNameEl) reportNameEl.placeholder = translate('reportNamePlaceholder');
    if (reportReasonEl) reportReasonEl.placeholder = translate('reportReasonPlaceholder');
    if (reportAddressEl) reportAddressEl.placeholder = translate('reportAddressPlaceholder');
    if (reportWebsiteEl) reportWebsiteEl.placeholder = translate('reportWebsitePlaceholder');
    if (submitReportBtn) submitReportBtn.textContent = translate('submitReportBtn');

    const homeLinkEl = document.getElementById('homeLink');
    const newsLinkEl = document.getElementById('newsLink');
    if (homeLinkEl) homeLinkEl.textContent = translate('homeLinkText');
    if (newsLinkEl) newsLinkEl.textContent = translate('newsLinkText');
  }

  function initLanguageSelector() {
    if (!languageSelect) return;
    const saved = (localStorage.getItem(LANGUAGE_STORAGE_KEY) || 'auto').toLowerCase();
    const selectedMode = saved === 'auto' || SUPPORTED_LANGUAGES.includes(saved) ? saved : 'auto';
    languageSelect.value = selectedMode;
    const initialLanguage = selectedMode === 'auto' ? detectPreferredLanguage() : selectedMode;
    localStorage.setItem('matsjekk_lang', initialLanguage);
    applyPageLanguage(initialLanguage);

    languageSelect.addEventListener('change', () => {
      const nextMode = (languageSelect.value || 'auto').toLowerCase();
      const normalizedMode = nextMode === 'auto' || SUPPORTED_LANGUAGES.includes(nextMode) ? nextMode : 'auto';
      localStorage.setItem(LANGUAGE_STORAGE_KEY, normalizedMode);
      const nextLanguage = normalizedMode === 'auto' ? detectPreferredLanguage() : normalizedMode;
      localStorage.setItem('matsjekk_lang', nextLanguage);
      applyPageLanguage(nextLanguage);
      filterShops();
    });
  }

  function selectedNearRadiusKm() {
    const raw = Number.parseInt(nearRadiusSelect?.value || '50', 10);
    if (!Number.isFinite(raw) || raw <= 0) return 50;
    return raw;
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

  function countryQueryVariants(countryCode, countryLabel) {
    const variants = new Set();
    const selected = (countryLabel || '').toString().trim();
    if (selected) variants.add(selected);
    const localized = countryNameByCode(countryCode);
    if (localized) variants.add(localized);
    const english = COUNTRY_ENGLISH_BY_CODE[countryCode] || '';
    if (english) variants.add(english);
    if (countryCode) variants.add(countryCode);
    return [...variants].filter(Boolean);
  }

  function shopMatchesCountry(shop, selectedCountryCode, selectedCountryLabel) {
    if (!selectedCountryCode) return true;
    const shopCountryCode = normalizeCountryCode(shop?.countryCode || shop?.country);
    if (shopCountryCode && shopCountryCode === selectedCountryCode) return true;

    const shopCountryLabel = (shop?.country || '').toString().trim().toLowerCase();
    const selectedLabel = (selectedCountryLabel || '').toString().trim().toLowerCase();
    if (shopCountryLabel && selectedLabel && shopCountryLabel === selectedLabel) return true;

    return false;
  }

  function shopMatchesCountryRelaxed(shop, selectedCountryCode) {
    if (!selectedCountryCode) return true;
    const candidates = [
      shop?.countryCode,
      shop?.country,
      shop?.country_name,
      shop?.countryName,
      shop?.['addr:country'],
    ]
      .map((value) => normalizeCountryCode(value))
      .filter(Boolean);

    if (candidates.includes(selectedCountryCode)) return true;

    const countryText = (shop?.country || '').toString().toLowerCase();
    if (selectedCountryCode === 'NO' && (countryText.includes('norway') || countryText.includes('norge'))) return true;
    if (selectedCountryCode === 'SE' && (countryText.includes('sweden') || countryText.includes('sverige'))) return true;
    if (selectedCountryCode === 'DK' && (countryText.includes('denmark') || countryText.includes('danmark'))) return true;

    return false;
  }

  function getCountrySearchLexicon(countryCode) {
    const defaults = {
      baseTerm: 'farm shop',
      outletTerms: ['"farm shop"', '"farm store"', '"local farm"'],
      signalTerms: ['official website', 'address', 'opening hours', 'contact'],
      negativeTerms: ['-recipe', '-restaurant', '-hotel', '-wikipedia'],
      domainExclusions: [],
    };

    const lexiconByCountry = {
      NO: {
        baseTerm: 'gårdsbutikk gårdsutsalg',
        outletTerms: ['"gårdsbutikk"', '"gårdsutsalg"', '"gårdsmat"', '"bondens marked"'],
        signalTerms: ['offisiell nettside', 'adresse', 'åpningstider', 'kontakt', 'bestilling'],
        negativeTerms: ['-oppskrift', '-meny', '-restaurant', '-hotell', '-wikipedia', '-rapport'],
        domainExclusions: [
          '-site:statsforvalteren.no', '-site:regjeringen.no', '-site:ssb.no',
          '-site:mattilsynet.no', '-site:landbruksdirektoratet.no', '-site:lovdata.no',
        ],
      },
      SE: {
        baseTerm: 'gårdsbutik gårdsförsäljning',
        outletTerms: ['"gårdsbutik"', '"gårdsförsäljning"', '"gårdsbutik med självbetjäning"'],
        signalTerms: ['officiell webbplats', 'adress', 'öppettider', 'kontakt'],
        negativeTerms: ['-recept', '-restaurang', '-hotell', '-wikipedia'],
      },
      DK: {
        baseTerm: 'gårdbutik gårdsalg',
        outletTerms: ['"gårdbutik"', '"gårdsalg"', '"lokale råvarer"'],
        signalTerms: ['officiel hjemmeside', 'adresse', 'åbningstider', 'kontakt'],
        negativeTerms: ['-opskrift', '-restaurant', '-hotel', '-wikipedia'],
      },
      FI: {
        baseTerm: 'tilapuoti suoramyynti',
        outletTerms: ['"tilapuoti"', '"suoramyynti"', '"maatilamyymälä"', '"farm shop"'],
        signalTerms: ['virallinen sivusto', 'osoite', 'aukioloajat', 'yhteystiedot'],
        negativeTerms: ['-resepti', '-ravintola', '-hotelli', '-wikipedia'],
      },
      IT: {
        baseTerm: 'azienda agricola vendita diretta',
        outletTerms: ['"azienda agricola"', '"vendita diretta"', '"spaccio aziendale"', '"farm shop"'],
        signalTerms: ['sito ufficiale', 'indirizzo', 'orari', 'contatti'],
        negativeTerms: ['-ricetta', '-ristorante', '-hotel', '-wikipedia'],
      },
      FR: {
        baseTerm: 'ferme boutique vente directe',
        outletTerms: ['"ferme boutique"', '"vente directe"', '"magasin à la ferme"', '"farm shop"'],
        signalTerms: ['site officiel', 'adresse', 'horaires', 'contact'],
        negativeTerms: ['-recette', '-restaurant', '-hôtel', '-wikipedia'],
      },
      DE: {
        baseTerm: 'hofladen direktvermarktung',
        outletTerms: ['hofladen', '"direktvermarktung"', '"bauernladen"', '"farm shop"'],
        signalTerms: ['offizielle website', 'adresse', 'öffnungszeiten', 'kontakt'],
        negativeTerms: ['-rezept', '-restaurant', '-hotel', '-wikipedia'],
      },
      NL: {
        baseTerm: 'boerderijwinkel streekproducten',
        outletTerms: ['"boerderijwinkel"', '"streekproducten"', '"farm shop"'],
        signalTerms: ['officiële website', 'adres', 'openingstijden', 'contact'],
        negativeTerms: ['-recept', '-restaurant', '-hotel', '-wikipedia'],
      },
      BE: {
        baseTerm: 'hoevewinkel ferme boutique',
        outletTerms: ['"hoevewinkel"', '"ferme boutique"', '"vente directe"', '"farm shop"'],
        signalTerms: ['site officiel', 'adresse', 'horaires', 'contact'],
        negativeTerms: ['-recette', '-restaurant', '-hôtel', '-wikipedia'],
      },
      ES: {
        baseTerm: 'tienda granja venta directa',
        outletTerms: ['"tienda granja"', '"venta directa"', '"granja"', '"farm shop"'],
        signalTerms: ['sitio oficial', 'dirección', 'horario', 'contacto'],
        negativeTerms: ['-receta', '-restaurante', '-hotel', '-wikipedia'],
      },
      PT: {
        baseTerm: 'loja da quinta venda direta',
        outletTerms: ['"loja da quinta"', '"venda direta"', '"produtor local"', '"farm shop"'],
        signalTerms: ['site oficial', 'morada', 'horário', 'contacto'],
        negativeTerms: ['-receita', '-restaurante', '-hotel', '-wikipedia'],
      },
      GB: {
        baseTerm: 'farm shop local produce',
        outletTerms: ['"farm shop"', '"farm store"', '"local produce"'],
        signalTerms: ['official website', 'address', 'opening hours', 'contact'],
        negativeTerms: ['-recipe', '-restaurant', '-hotel', '-wikipedia'],
      },
      IE: {
        baseTerm: 'farm shop local food',
        outletTerms: ['"farm shop"', '"farm store"', '"local food"'],
        signalTerms: ['official website', 'address', 'opening hours', 'contact'],
        negativeTerms: ['-recipe', '-restaurant', '-hotel', '-wikipedia'],
      },
      AT: {
        baseTerm: 'hofladen direktvermarktung',
        outletTerms: ['hofladen', '"direktvermarktung"', '"bauernladen"'],
        signalTerms: ['offizielle website', 'adresse', 'öffnungszeiten', 'kontakt'],
        negativeTerms: ['-rezept', '-restaurant', '-hotel', '-wikipedia'],
      },
      CH: {
        baseTerm: 'hofladen ferme boutique vendita diretta',
        outletTerms: ['hofladen', '"ferme boutique"', '"vendita diretta"', '"farm shop"'],
        signalTerms: ['offizielle website', 'site officiel', 'sito ufficiale', 'adresse', 'horaires', 'orari'],
        negativeTerms: ['-rezept', '-recette', '-ricetta', '-restaurant', '-hotel', '-wikipedia'],
      },
      LU: {
        baseTerm: 'ferme boutique hofladen',
        outletTerms: ['"ferme boutique"', 'hofladen', '"farm shop"'],
        signalTerms: ['site officiel', 'adresse', 'horaires', 'contact'],
        negativeTerms: ['-recette', '-restaurant', '-hotel', '-wikipedia'],
        domainExclusions: [],
      },
    };

    return lexiconByCountry[countryCode] || defaults;
  }

  function resolveCountryCode(preferredCode) {
    const normalizedPreferred = normalizeCountryCode(preferredCode);
    if (normalizedPreferred) return normalizedPreferred;
    const selectedCountryLabel = selectedText(countrySelect);
    return normalizeCountryCode(selectedCountryLabel);
  }

  function regionFallbackMunicipalities(countryCode, regionLabel) {
    if (!countryCode || !regionLabel) return [];
    const byRegion = COUNTRY_REGION_MUNICIPALITIES_FALLBACK[countryCode] || {};
    if (byRegion[regionLabel]) return byRegion[regionLabel];
    const normalized = (regionLabel || '').toLowerCase().trim();
    const matched = Object.entries(byRegion).find(([key]) => key.toLowerCase().trim() === normalized);
    return matched ? matched[1] : [];
  }

  async function loadShops(url) {
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const payload = await response.json();
    return Array.isArray(payload) ? payload : [];
  }

  async function loadAreaCacheEntries(url) {
    const response = await fetch(url, { cache: 'no-cache' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const payload = await response.json();
    return Array.isArray(payload) ? payload : [];
  }

  async function loadFirstAvailableAreaCache(urls) {
    let lastError = null;
    for (const url of urls) {
      try {
        const payload = await loadAreaCacheEntries(url);
        if (Array.isArray(payload) && payload.length > 0) {
          return payload;
        }
      } catch (error) {
        lastError = error;
      }
    }
    if (lastError) throw lastError;
    return [];
  }

  async function loadFirstAvailable(urls) {
    let lastError = null;
    for (const url of urls) {
      try {
        const payload = await loadShops(url);
        if (Array.isArray(payload) && payload.length > 0) {
          return payload;
        }
      } catch (error) {
        lastError = error;
      }
    }
    if (lastError) throw lastError;
    return [];
  }

  async function loadFirstReachable(urls) {
    let lastError = null;
    for (const url of urls) {
      try {
        const payload = await loadShops(url);
        if (Array.isArray(payload)) {
          return payload;
        }
      } catch (error) {
        lastError = error;
      }
    }
    if (lastError) throw lastError;
    return [];
  }

  function countrySliceUrls(countryCode) {
    const cc = normalizeCountryCode(countryCode);
    if (!cc) return [];
    return countrySliceBasePaths.map((base) => `${base}/${cc.toLowerCase()}.json`);
  }

  function initialPreviewLimit() {
    return window.matchMedia('(max-width: 768px)').matches
      ? COUNTRY_INITIAL_PREVIEW_LIMIT_MOBILE
      : COUNTRY_INITIAL_PREVIEW_LIMIT_DESKTOP;
  }

  function buildCountryPreview(items, limit = initialPreviewLimit()) {
    const rows = Array.isArray(items) ? items : [];
    if (rows.length <= limit) return rows;

    const uniqueByMunicipality = [];
    const seenMunicipality = new Set();
    for (const shop of rows) {
      const municipality = (shop?.municipality || '').toString().trim().toLowerCase();
      if (!municipality || seenMunicipality.has(municipality)) continue;
      seenMunicipality.add(municipality);
      uniqueByMunicipality.push(shop);
      if (uniqueByMunicipality.length >= limit) {
        return uniqueByMunicipality;
      }
    }

    const selected = [...uniqueByMunicipality];
    const selectedKeys = new Set(selected.map((shop) => `${normalizeKey(shop?.name)}|${Number(shop?.lat) || ''}|${Number(shop?.lon) || ''}`));
    const remaining = rows.filter((shop) => {
      const key = `${normalizeKey(shop?.name)}|${Number(shop?.lat) || ''}|${Number(shop?.lon) || ''}`;
      return !selectedKeys.has(key);
    });

    const slotsLeft = Math.max(0, limit - selected.length);
    if (!slotsLeft || !remaining.length) return selected.slice(0, limit);

    const stride = Math.max(1, Math.floor(remaining.length / slotsLeft));
    for (let index = 0; index < remaining.length && selected.length < limit; index += stride) {
      selected.push(remaining[index]);
    }
    return selected.slice(0, limit);
  }

  async function loadCountrySlice(countryCode) {
    const cc = normalizeCountryCode(countryCode);
    if (!cc) return [];
    if (countrySliceCache.has(cc)) return countrySliceCache.get(cc);
    if (countrySliceInFlight.has(cc)) return countrySliceInFlight.get(cc);

    const loader = (async () => {
      const payload = await loadFirstReachable(countrySliceUrls(cc));
      const normalized = (Array.isArray(payload) ? payload : [])
        .map(normalizeShop)
        .filter((shop) => !shop.countryCode || shop.countryCode === cc);
      countrySliceCache.set(cc, normalized);
      return normalized;
    })();

    countrySliceInFlight.set(cc, loader);
    try {
      return await loader;
    } finally {
      countrySliceInFlight.delete(cc);
    }
  }

  async function loadAllShopsDataset() {
    if (allShopsLoaded && Array.isArray(allShopsCache)) return allShopsCache;
    const payload = await loadFirstAvailable(dataUrls);
    const normalized = (Array.isArray(payload) ? payload : []).map(normalizeShop);
    allShopsCache = await mergeWithExtraDataset(normalized);
    allShopsLoaded = true;
    return allShopsCache;
  }

  async function loadExtraMergeDataset() {
    if (extraMergeLoaded && Array.isArray(extraMergeCache)) return extraMergeCache;
    if (!Array.isArray(extraMergeDataUrls) || !extraMergeDataUrls.length) {
      extraMergeCache = [];
      extraMergeLoaded = true;
      return extraMergeCache;
    }

    try {
      const payload = await loadFirstAvailable(extraMergeDataUrls);
      extraMergeCache = (Array.isArray(payload) ? payload : []).map(normalizeShop);
    } catch (_) {
      extraMergeCache = [];
    }
    extraMergeLoaded = true;
    return extraMergeCache;
  }

  async function mergeWithExtraDataset(rows, countryCode = '') {
    const baseRows = Array.isArray(rows) ? rows : [];
    const extras = await loadExtraMergeDataset();
    if (!extras.length) return baseRows;
    if (countryCode) {
      return mergeShopLists(baseRows, extras.filter((shop) => !shop.countryCode || shop.countryCode === countryCode));
    }
    return mergeShopLists(baseRows, extras);
  }

  async function ensureShopScope(countryCode, options = {}) {
    const cc = normalizeCountryCode(countryCode);
    const previewOnly = options?.previewOnly === true;
    if (!cc) {
      shops = await loadAllShopsDataset();
      loadedScopeCountryCode = '';
      loadedScopeIsPreview = false;
      return shops;
    }

    try {
      const scoped = await loadCountrySlice(cc);
      if (scoped.length) {
        const scopedWithExtra = await mergeWithExtraDataset(scoped, cc);
        shops = previewOnly ? buildCountryPreview(scopedWithExtra, initialPreviewLimit()) : scopedWithExtra;
        loadedScopeCountryCode = cc;
        loadedScopeIsPreview = previewOnly;
        return shops;
      }
      shops = await loadAllShopsDataset();
      loadedScopeCountryCode = '';
      loadedScopeIsPreview = false;
      return shops;
    } catch (_) {
      shops = await loadAllShopsDataset();
      loadedScopeCountryCode = '';
      loadedScopeIsPreview = false;
      return shops;
    }
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

  async function fetchNominatimAdmin(countryCode, extraParams = '') {
    const base = `https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&limit=150&dedupe=1&countrycodes=${encodeURIComponent((countryCode || '').toLowerCase())}`;
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 3500);
    let payload = [];
    try {
      const response = await fetch(`${base}${extraParams}`, {
        cache: 'no-cache',
        signal: controller.signal,
      });
      if (!response.ok) return [];
      payload = await response.json();
    } catch (_) {
      return [];
    } finally {
      clearTimeout(timeoutId);
    }

    const items = Array.isArray(payload) ? payload : [];
    const expectedCountry = (countryCode || '').toLowerCase();
    if (!expectedCountry) return items;

    return items.filter((item) => {
      const itemCountry = (item?.address?.country_code || '').toLowerCase();
      if (itemCountry) return itemCountry === expectedCountry;

      const displayName = (item?.display_name || '').toLowerCase();
      const countryName = countryNameByCode(countryCode).toLowerCase();
      return !!countryName && (displayName.endsWith(countryName) || displayName.includes(`, ${countryName}`));
    });
  }

  function collectRegionNames(items) {
    const names = items.flatMap((item) => {
      const address = item?.address || {};
      return [
        address.state,
        address.province,
        address.region,
        address.county,
      ];
    }).filter(Boolean);
    return unique(names);
  }

  function collectMunicipalityNames(items) {
    const names = items.flatMap((item) => {
      const address = item?.address || {};
      return [
        address.municipality,
        address.city,
        address.town,
        address.village,
        address.suburb,
      ];
    }).filter(Boolean);
    return unique(names);
  }

  function normalizeAdminLabel(value) {
    return (value || '')
      .toString()
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .replace(/['’`´.-]/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  function municipalityApiMatchesRegion(item, regionLabel) {
    if (!regionLabel) return true;
    const target = normalizeAdminLabel(regionLabel);
    if (!target) return true;

    const address = item?.address || {};
    const candidates = [
      address.state,
      address.province,
      address.region,
      address.county,
      address.state_district,
    ]
      .map((value) => normalizeAdminLabel(value))
      .filter(Boolean);

    if (!candidates.length) return false;
    return candidates.some((value) =>
      value === target || value.includes(target) || target.includes(value)
    );
  }

  async function fetchCountryRegions(countryCode) {
    if (!countryCode) return [];
    if (regionCache.has(countryCode)) return regionCache.get(countryCode);

    const countryName = countryNameByCode(countryCode);
    const [stateLike, queryLike] = await Promise.all([
      fetchNominatimAdmin(countryCode, '&featuretype=state'),
      fetchNominatimAdmin(countryCode, `&q=${encodeURIComponent(`${countryName} administrative region`)}`),
    ]);

    const fromApi = collectRegionNames([...stateLike, ...queryLike]);
    const fromData = unique(
      shops
        .filter((shop) => shop.countryCode === countryCode)
        .map((shop) => shop.region)
    );

    const fromFallback = COUNTRY_REGIONS_FALLBACK[countryCode] || [];
    const regions = unique([...fromApi, ...fromData, ...fromFallback]);
    regionCache.set(countryCode, regions);
    return regions;
  }

  async function fetchCountryMunicipalities(countryCode, regionLabel) {
    if (!countryCode) return [];
    const key = `${countryCode}|${(regionLabel || '').toLowerCase()}`;
    if (municipalityCache.has(key)) return municipalityCache.get(key);

    const countryName = countryNameByCode(countryCode);
    const regionPart = regionLabel ? `${regionLabel} ` : '';
    const [cityLike, queryLike] = await Promise.all([
      fetchNominatimAdmin(countryCode, '&featuretype=city'),
      fetchNominatimAdmin(countryCode, `&q=${encodeURIComponent(`${regionPart}${countryName} municipality`)}`),
    ]);

    const apiItems = [...cityLike, ...queryLike]
      .filter((item) => municipalityApiMatchesRegion(item, regionLabel));
    const fromApi = collectMunicipalityNames(apiItems);
    const fromData = unique(
      shops
        .filter((shop) => shop.countryCode === countryCode && (!regionLabel || shop.region === regionLabel))
        .map((shop) => shop.municipality)
    );

    const fromRegionFallback = regionFallbackMunicipalities(countryCode, regionLabel);
    const fromFallback = regionLabel
      ? fromRegionFallback
      : (COUNTRY_MUNICIPALITIES_FALLBACK[countryCode] || []);
    const municipalities = unique([...fromApi, ...fromData, ...fromFallback]);
    municipalityCache.set(key, municipalities);
    return municipalities;
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

  function localityToken(value) {
    return municipalityKey((value || '').toString());
  }

  function buildLocalityCacheKey(countryCode, regionText, municipalityText, queryText) {
    const cc = ((countryCode || '').toString().trim().toUpperCase()) || 'ANY';
    const region = localityToken(regionText);
    const municipality = localityToken(municipalityText);
    const query = localityToken(queryText);
    return [cc, region || '-', municipality || '-', query || '-'].join('|');
  }

  function readLocalityCacheMap() {
    try {
      const raw = localStorage.getItem(LOCALITY_CACHE_STORAGE_KEY);
      if (!raw) return new Map();
      const parsed = JSON.parse(raw);
      if (!parsed || typeof parsed !== 'object') return new Map();
      const entries = Object.entries(parsed).filter(([, value]) => value && Array.isArray(value.shops));
      return new Map(entries);
    } catch (_) {
      return new Map();
    }
  }

  function writeLocalityCacheMap(cacheMap) {
    try {
      const rows = [...cacheMap.entries()]
        .sort((left, right) => (right[1]?.updatedAt || 0) - (left[1]?.updatedAt || 0))
        .slice(0, LOCALITY_CACHE_MAX_AREAS);
      localStorage.setItem(LOCALITY_CACHE_STORAGE_KEY, JSON.stringify(Object.fromEntries(rows)));
    } catch (_) {
      // localStorage may be unavailable (private mode/quota); ignore silently.
    }
  }

  function cacheShopSnapshot(shop) {
    return {
      name: shop.name || '',
      countryCode: shop.countryCode || '',
      country: shop.country || '',
      region: shop.region || '',
      municipality: shop.municipality || '',
      address: shop.address || '',
      products: Array.isArray(shop.products) ? shop.products.slice(0, 12) : [],
      website: shop.website || '',
      lat: shop.lat,
      lon: shop.lon,
      category: shop.category || 'Gårdsutsalg',
      phone: shop.phone || '',
      openingHours: shop.openingHours || '',
      mapsUrl: shop.mapsUrl || '',
    };
  }

  function loadSharedLocalityCache(rows) {
    sharedLocalityCache.clear();
    (rows || []).forEach((entry) => {
      const key = (entry?.key || '').toString();
      if (!key) return;
      const normalized = (Array.isArray(entry.shops) ? entry.shops : [])
        .map((shop) => normalizeShop(shop))
        .filter((shop) => shop && shop.name && shop.lat != null && shop.lon != null)
        .slice(0, LOCALITY_CACHE_MAX_ITEMS_PER_AREA);
      if (!normalized.length) return;
      sharedLocalityCache.set(key, normalized);
    });
  }

  function rememberLocalityResult(context, items) {
    const key = buildLocalityCacheKey(context.countryCode, context.regionText, context.municipalityText, context.queryText);
    const normalized = (items || [])
      .filter((shop) => shop && shop.name && shop.lat != null && shop.lon != null)
      .slice(0, LOCALITY_CACHE_MAX_ITEMS_PER_AREA)
      .map(cacheShopSnapshot);
    if (!normalized.length) return;
    const map = readLocalityCacheMap();
    map.set(key, {
      updatedAt: Date.now(),
      countryCode: (context.countryCode || '').toString().toUpperCase(),
      regionText: context.regionText || '',
      municipalityText: context.municipalityText || '',
      queryText: context.queryText || '',
      shops: normalized,
    });
    writeLocalityCacheMap(map);
  }

  function recallLocalityResult(context) {
    const exactKey = buildLocalityCacheKey(context.countryCode, context.regionText, context.municipalityText, context.queryText);
    const fallbackKeys = [
      exactKey,
      buildLocalityCacheKey(context.countryCode, context.regionText, context.municipalityText, ''),
      buildLocalityCacheKey(context.countryCode, '', context.municipalityText, ''),
      buildLocalityCacheKey(context.countryCode, context.regionText, '', context.queryText),
      buildLocalityCacheKey(context.countryCode, '', '', context.queryText),
    ];

    const localMap = readLocalityCacheMap();
    for (const key of fallbackKeys) {
      const row = localMap.get(key);
      if (row && Array.isArray(row.shops) && row.shops.length) {
        return row.shops.map((shop) => normalizeShop(shop));
      }
      const shared = sharedLocalityCache.get(key);
      if (Array.isArray(shared) && shared.length) {
        return shared.map((shop) => normalizeShop(shop));
      }
    }

    return [];
  }

  function findNorwayMunicipalityByQuery(queryText, preferredRegionLabel = '') {
    const key = municipalityKey(queryText);
    if (!key || key.length < 3 || !norwayMunicipalities.length) return null;

    const preferredRegion = regionKey(preferredRegionLabel || '');
    const candidates = norwayMunicipalities
      .filter((municipality) => {
        const nameKey = municipalityKey(municipality.name || '');
        return nameKey === key || nameKey.includes(key) || key.includes(nameKey);
      })
      .sort((left, right) => {
        const leftKey = municipalityKey(left.name || '');
        const rightKey = municipalityKey(right.name || '');

        const leftExact = leftKey === key ? 0 : 1;
        const rightExact = rightKey === key ? 0 : 1;
        if (leftExact !== rightExact) return leftExact - rightExact;

        const leftDelta = Math.abs(leftKey.length - key.length);
        const rightDelta = Math.abs(rightKey.length - key.length);
        if (leftDelta !== rightDelta) return leftDelta - rightDelta;

        if (preferredRegion) {
          const leftCounty = regionKey((norwayCounties.find((county) => county.code === left.countyCode)?.name || '').toString());
          const rightCounty = regionKey((norwayCounties.find((county) => county.code === right.countyCode)?.name || '').toString());
          const leftRegionScore = leftCounty === preferredRegion ? 0 : 1;
          const rightRegionScore = rightCounty === preferredRegion ? 0 : 1;
          if (leftRegionScore !== rightRegionScore) return leftRegionScore - rightRegionScore;
        }

        return (left.name || '').localeCompare((right.name || ''), 'nb');
      });

    const best = candidates[0];
    if (!best) return null;

    const countyName = norwayCounties.find((county) => county.code === best.countyCode)?.name || '';
    return {
      name: best.name || '',
      countyCode: best.countyCode || '',
      countyName,
    };
  }

  function regionKey(value) {
    return (value || '')
      .toString()
      .trim()
      .toLowerCase()
      .replace(/ø/g, 'o')
      .replace(/æ/g, 'ae')
      .replace(/å/g, 'a')
      .replace(/\s+/g, ' ');
  }

  function regionVariants(countryCode, regionLabel) {
    const label = (regionLabel || '').toString().trim();
    if (!label) return [];
    if (countryCode !== 'NO') return [label];
    const key = regionKey(label);
    const aliases = NORWAY_REGION_VARIANTS[key] || [label];
    return [...new Set(aliases.map((item) => regionKey(item)))];
  }

  function regionMatches(shopRegion, regionTerms) {
    if (!regionTerms.length) return true;
    const shopKey = regionKey(shopRegion || '');
    if (!shopKey) return false;
    return regionTerms.some((term) =>
      shopKey === term ||
      shopKey.includes(term) ||
      term.includes(shopKey)
    );
  }

  function strictRegionMatch(shopRegion, selectedRegionLabel) {
    const left = normalizeAdminLabel(shopRegion || '');
    const right = normalizeAdminLabel(selectedRegionLabel || '');
    if (!left || !right) return false;
    return left === right || left.includes(right) || right.includes(left);
  }

  function populateCountries() {
    countrySelect.innerHTML = '<option value="">Velg land</option>' +
      WEST_EUROPE.map((country) => `<option value="${country.code}">${country.name}</option>`).join('');
  }

  async function populateRegions(countryCode) {
    const requestId = ++regionPopulateRequestId;
    const effectiveCountryCode = resolveCountryCode(countryCode);
    if (effectiveCountryCode === 'NO') {
      await ensureNorwayGeoData();
      if (requestId !== regionPopulateRequestId || resolveCountryCode(countrySelect.value) !== effectiveCountryCode) {
        return;
      }
      if (norwayCounties.length) {
        regionSelect.innerHTML = '<option value="">Velg fylke</option>' +
          norwayCounties.map((county) => `<option value="${county.code}">${county.name}</option>`).join('');
      } else {
        regionSelect.innerHTML = '<option value="">Velg fylke/region</option>';
      }
      muniSelect.innerHTML = '<option value="">Velg kommune</option>';
      return;
    }

    const immediateRegions = effectiveCountryCode
      ? unique([
        ...(COUNTRY_REGIONS_FALLBACK[effectiveCountryCode] || []),
        ...shops
          .filter((shop) => shop.countryCode === effectiveCountryCode)
          .map((shop) => shop.region),
      ])
      : [];

    regionSelect.innerHTML = '<option value="">Velg fylke/region</option>' +
      immediateRegions.map((region) => `<option value="${region}">${region}</option>`).join('');
    muniSelect.innerHTML = '<option value="">Velg kommune</option>';

    if (!effectiveCountryCode) {
      return;
    }

    const regions = await fetchCountryRegions(effectiveCountryCode);
    if (requestId !== regionPopulateRequestId || resolveCountryCode(countrySelect.value) !== effectiveCountryCode) {
      return;
    }

    regionSelect.innerHTML = '<option value="">Velg fylke/region</option>' +
      regions.map((region) => `<option value="${region}">${region}</option>`).join('');
    muniSelect.innerHTML = '<option value="">Velg kommune</option>';
  }

  async function populateMunicipalities(countryCode, regionValue) {
    const requestId = ++municipalityPopulateRequestId;
    const effectiveCountryCode = resolveCountryCode(countryCode);
    if (effectiveCountryCode === 'NO') {
      await ensureNorwayGeoData();
      if (requestId !== municipalityPopulateRequestId || resolveCountryCode(countrySelect.value) !== effectiveCountryCode) {
        return;
      }
      let municipalities = norwayMunicipalities.filter((municipality) =>
        !regionValue || municipality.countyCode === regionValue
      );

      if (!municipalities.length) {
        const selectedCountyName = (norwayCounties.find((county) => county.code === regionValue)?.name || selectedText(regionSelect) || '').trim();
        const fallbackMunicipalities = unique([
          ...regionFallbackMunicipalities('NO', selectedCountyName),
          ...getTrustedSeedCandidates('NO', 'Norge', '', selectedCountyName)
            .map((seed) => (seed.municipality || '').toString().trim())
            .filter(Boolean),
        ]);

        muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
          fallbackMunicipalities.map((municipality) => `<option value="${municipality}">${municipality}</option>`).join('');
        return;
      }

      muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
        municipalities.map((municipality) => `<option value="${municipality.code}">${municipality.name}</option>`).join('');
      return;
    }

    const regionLabel = regionValue || selectedText(regionSelect);
    const regionSpecificFallback = regionFallbackMunicipalities(effectiveCountryCode, regionLabel);
    const immediateMunicipalities = effectiveCountryCode
      ? unique([
        ...(regionLabel
          ? regionSpecificFallback
          : (COUNTRY_MUNICIPALITIES_FALLBACK[effectiveCountryCode] || [])),
        ...shops
          .filter((shop) =>
            shop.countryCode === effectiveCountryCode &&
            (!regionLabel || shop.region === regionLabel)
          )
          .map((shop) => shop.municipality),
      ])
      : [];

    muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
      immediateMunicipalities.map((municipality) => `<option value="${municipality}">${municipality}</option>`).join('');

    if (!effectiveCountryCode) {
      return;
    }

    const municipalities = await fetchCountryMunicipalities(effectiveCountryCode, regionLabel);
    if (requestId !== municipalityPopulateRequestId || resolveCountryCode(countrySelect.value) !== effectiveCountryCode) {
      return;
    }

    muniSelect.innerHTML = '<option value="">Velg kommune</option>' +
      municipalities.map((municipality) => `<option value="${municipality}">${municipality}</option>`).join('');
  }

  function sortShops(items) {
    const mode = sortSelect ? sortSelect.value : 'name_asc';
    const sorted = [...items].sort((left, right) => {
      if (mode === 'distance_asc') {
        const leftDistance = Number.isFinite(left?.distanceKm) ? left.distanceKm : Number.POSITIVE_INFINITY;
        const rightDistance = Number.isFinite(right?.distanceKm) ? right.distanceKm : Number.POSITIVE_INFINITY;
        if (leftDistance !== rightDistance) return leftDistance - rightDistance;
      }
      return (left?.name || '').localeCompare((right?.name || ''), 'nb');
    });
    if (mode === 'name_desc') sorted.reverse();
    return sorted;
  }

  function setUserPosition(lat, lon) {
    if (!Number.isFinite(lat) || !Number.isFinite(lon)) return;
    userPosition = { lat, lon };
    // Fire-and-forget: detect country so reset can restore it
    if (!userDetectedCountryCode) {
      reverseGeocodeMunicipality(lat, lon).then((geo) => {
        const code = normalizeCountryCode(geo?.countryCode || '');
        if (code) userDetectedCountryCode = code;
      }).catch(() => {});
    }
  }

  function addDistanceFromUser(items) {
    if (!userPosition || !Number.isFinite(userPosition.lat) || !Number.isFinite(userPosition.lon)) {
      return items;
    }
    const withDistance = (items || []).map((shop) => {
      if (shop.lat == null || shop.lon == null) return shop;
      const lat = Number(shop.lat);
      const lon = Number(shop.lon);
      if (!Number.isFinite(lat) || !Number.isFinite(lon)) return shop;
      const distanceKm = haversineKm(userPosition.lat, userPosition.lon, lat, lon);
      if (!Number.isFinite(distanceKm)) return shop;
      return { ...shop, distanceKm };
    });

    const strictNearFilterActive = sortSelect?.value === 'distance_asc' && Number.isFinite(activeNearRadiusKm) && activeNearRadiusKm > 0;
    if (!strictNearFilterActive) return withDistance;

    return withDistance.filter((shop) => Number.isFinite(shop?.distanceKm) && shop.distanceKm <= activeNearRadiusKm);
  }

  const GOOGLE_MAPS_API_KEY = (document.querySelector('meta[name="google-maps-api-key"]')?.getAttribute('content') || '').trim();
  let mapProvider = 'leaflet';
  let map = null;
  let leafletMarkersLayer = null;
  let googleMarkers = [];
  let markerCoords = [];
  let activeScopeBoundingBox = null;
  let googleInfoWindow = null;
  let googleRoutePolyline = null;
  let leafletBufferLayer = null;
  let googleEmbedIframe = null;
  let pendingSearchCenter = null;

  function setMapStatus(message) {
    if (!mapStatusEl) return;
    mapStatusEl.textContent = message || '';
  }

  function setDebugStats(message) {
    if (!debugStatsEl) return;
    debugStatsEl.textContent = message || '';
  }

  function buildEmbeddedGoogleMapUrl(query) {
    const effectiveQuery = (query || 'gårdsbutikk Norge').trim();
    return `https://www.google.com/maps?q=${encodeURIComponent(effectiveQuery)}&output=embed`;
  }

  function hasFarmKeyword(text) {
    const value = (text || '').toString().toLowerCase();
    return /gårdsbutikk|gardsbutikk|gårdsutsalg|gardsutsalg|farm shop|farmstore|hofladen|ferme/.test(value);
  }

  function buildGoogleMapsSearchApiUrl(query) {
    return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent((query || '').trim())}`;
  }

  function currentMapSearchQuery() {
    const countryCode = resolveCountryCode(countrySelect.value);
    const lexicon = getCountrySearchLexicon(countryCode);
    const country = selectedText(countrySelect);
    const region = selectedText(regionSelect);
    const municipality = selectedText(muniSelect);
    const rawQuery = (searchInput?.value || '').trim();
    const baseTerm = lexicon?.baseTerm || 'farm shop';
    const query = rawQuery
      ? (hasFarmKeyword(rawQuery) ? rawQuery : `${baseTerm} ${rawQuery}`)
      : baseTerm;
    return [query, municipality, region, country].filter(Boolean).join(' ');
  }

  function openGoogleMapsSearchFromFilters() {
    const mapsQuery = currentMapSearchQuery() || 'gårdsbutikk Norge';
    const mapsUrl = buildGoogleMapsSearchApiUrl(mapsQuery);
    window.open(mapsUrl, '_blank', 'noopener');
  }

  function shopKeyForResult(shop) {
    return `${normalizeKey(shop?.name || '')}|${normalizeKey(shop?.address || '')}`;
  }

  function prioritizeShopInResults(shop) {
    if (!shop || !listEl) return;
    const key = shopKeyForResult(shop);
    if (!key) return;

    const cards = [...listEl.querySelectorAll('.item[data-shop-key]')];
    const target = cards.find((card) => card.dataset.shopKey === key);
    if (target && listEl.firstElementChild !== target) {
      listEl.prepend(target);
      listEl.scrollTo({ top: 0, behavior: 'smooth' });
    }

    const idx = activeFiltered.findIndex((entry) => shopKeyForResult(entry) === key);
    if (idx > 0) {
      const selected = activeFiltered[idx];
      activeFiltered = [selected, ...activeFiltered.slice(0, idx), ...activeFiltered.slice(idx + 1)];
    }
  }

  function initGoogleEmbedMap() {
    mapProvider = 'google-embed';
    map = null;
    if (!mapEl) return;

    mapEl.innerHTML = '';
    const iframe = document.createElement('iframe');
    iframe.title = 'Google Maps';
    iframe.loading = 'lazy';
    iframe.referrerPolicy = 'no-referrer-when-downgrade';
    iframe.style.width = '100%';
    iframe.style.height = `${currentMapHeight}px`;
    iframe.style.border = '0';
    iframe.src = buildEmbeddedGoogleMapUrl(currentMapSearchQuery());
    mapEl.appendChild(iframe);
    googleEmbedIframe = iframe;
  }

  function updateEmbeddedMapFromFilters() {
    if (mapProvider !== 'google-embed' || !googleEmbedIframe) return;
    googleEmbedIframe.src = buildEmbeddedGoogleMapUrl(currentMapSearchQuery());
  }

  function loadGoogleMapsScript(apiKey) {
    if (!apiKey) return Promise.reject(new Error('Missing Google Maps API key'));
    if (window.google?.maps) return Promise.resolve();

    return new Promise((resolve, reject) => {
      let settled = false;
      const timeoutId = setTimeout(() => {
        if (settled) return;
        settled = true;
        reject(new Error('Google Maps JS API timed out'));
      }, 4500);

      const existing = document.getElementById('googleMapsJsApi');
      if (existing) {
        existing.addEventListener('load', () => {
          if (settled) return;
          settled = true;
          clearTimeout(timeoutId);
          resolve();
        }, { once: true });
        existing.addEventListener('error', () => {
          if (settled) return;
          settled = true;
          clearTimeout(timeoutId);
          reject(new Error('Failed to load Google Maps JS API'));
        }, { once: true });
        return;
      }

      const script = document.createElement('script');
      script.id = 'googleMapsJsApi';
      script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(apiKey)}&v=weekly`;
      script.async = true;
      script.defer = true;
      script.onload = () => {
        if (settled) return;
        settled = true;
        clearTimeout(timeoutId);
        resolve();
      };
      script.onerror = () => {
        if (settled) return;
        settled = true;
        clearTimeout(timeoutId);
        reject(new Error('Failed to load Google Maps JS API'));
      };
      document.head.appendChild(script);
    });
  }

  function initLeafletMap() {
    mapProvider = 'leaflet';
    map = L.map('map', { minZoom: 4 }).setView([59.9, 10.7], 5);
    window._leafletMap = map;
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 18,
      attribution: '© OpenStreetMap contributors',
    }).addTo(map);
    leafletMarkersLayer = L.layerGroup().addTo(map);
  }

  function initGoogleMap() {
    mapProvider = 'google';
    map = new google.maps.Map(mapEl, {
      center: { lat: 59.9, lng: 10.7 },
      zoom: 5,
      minZoom: 4,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: true,
    });
    googleInfoWindow = new google.maps.InfoWindow();
  }

  async function initMap() {
    setMapStatus('Laster kart...');
    if (GOOGLE_MAPS_API_KEY) {
      try {
        await loadGoogleMapsScript(GOOGLE_MAPS_API_KEY);
        initGoogleMap();
        setMapStatus('Google Maps er aktivert.');
        return;
      } catch (error) {
        console.warn('Google Maps unavailable, falling back to Leaflet.', error);
        setMapStatus('Google Maps JS feilet. Viser innebygd Google Maps.');
      }
    } else {
      setMapStatus('Ingen Google Maps-nøkkel funnet. Viser innebygd Google Maps.');
    }

    try {
      initGoogleEmbedMap();
      return;
    } catch (error) {
      console.warn('Embedded Google Maps unavailable, falling back to Leaflet.', error);
      setMapStatus('Fallback til OpenStreetMap reservekart.');
    }

    initLeafletMap();
  }

  function getCurrentPositionAsync(options) {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        reject(new Error('Geolocation unavailable'));
        return;
      }
      navigator.geolocation.getCurrentPosition(resolve, reject, options);
    });
  }

  async function detectPreferredCountryCode() {
    if (!ENABLE_AUTO_COUNTRY_FROM_POSITION || !navigator.geolocation) {
      return '';
    }
    try {
      const position = await getCurrentPositionAsync({ enableHighAccuracy: false, timeout: 7000, maximumAge: 300000 });
      setUserPosition(position.coords.latitude, position.coords.longitude);
      const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
      const code = normalizeCountryCode(geo?.countryCode || '');
      return code || '';
    } catch (_) {
      return '';
    }
  }

  async function autoSelectCountryFromPosition() {
    if (!navigator.geolocation) return false;
    try {
      const position = await getCurrentPositionAsync({ enableHighAccuracy: false, timeout: 7000, maximumAge: 300000 });
      setUserPosition(position.coords.latitude, position.coords.longitude);
      const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
      const countryCode = normalizeCountryCode(geo?.countryCode || '');
      if (!countryCode) return false;
      if (!userDetectedCountryCode) userDetectedCountryCode = countryCode;

      const hasCountry = [...countrySelect.options].some((option) => option.value === countryCode);
      if (!hasCountry) return false;
      if (countrySelect.value === countryCode) return true;

      countrySelect.value = countryCode;
      await populateRegions(countryCode);
      await populateMunicipalities(countryCode, '');
      filterShops();
      return true;
    } catch (_) {
      return false;
    }
  }

  function clearMapMarkers() {
    markerCoords = [];
    if (mapProvider === 'google-embed') {
      return;
    }
    if (mapProvider === 'google') {
      googleMarkers.forEach((marker) => marker.setMap(null));
      googleMarkers = [];
      return;
    }
    if (leafletMarkersLayer) {
      leafletMarkersLayer.clearLayers();
    }
  }

  function setPendingSearchCenter(lat, lon, zoom = 10) {
    if (!Number.isFinite(lat) || !Number.isFinite(lon)) {
      pendingSearchCenter = null;
      return;
    }
    pendingSearchCenter = { lat, lon, zoom: Number.isFinite(zoom) ? zoom : 10 };
  }

  function applyPendingSearchCenter() {
    if (!pendingSearchCenter) return;
    const { lat, lon, zoom } = pendingSearchCenter;
    pendingSearchCenter = null;

    if (mapProvider === 'google-embed' && googleEmbedIframe) {
      googleEmbedIframe.src = buildEmbeddedGoogleMapUrl(`${lat},${lon}`);
      return;
    }

    if (!map) return;

    if (mapProvider === 'google') {
      map.setCenter({ lat, lng: lon });
      const currentZoom = Number(map.getZoom() || 0);
      map.setZoom(Math.max(currentZoom, zoom));
      return;
    }

    map.setView([lat, lon], Math.max(Number(map.getZoom() || 0), zoom));
  }

  function addMapMarker(shop) {
    if (mapProvider === 'google-embed') {
      return;
    }
    if (!shop.lat || !shop.lon) return;
    const lat = Number(shop.lat);
    const lon = Number(shop.lon);
    if (!Number.isFinite(lat) || !Number.isFinite(lon)) return;

    markerCoords.push({ lat, lon });

    if (mapProvider === 'google') {
      const marker = new google.maps.Marker({
        position: { lat, lng: lon },
        map,
        title: shop.name || 'Gårdsutsalg',
      });
      marker.addListener('click', () => {
        prioritizeShopInResults(shop);
        googleInfoWindow.setContent(buildPopupHtml(shop));
        googleInfoWindow.open({ anchor: marker, map });
      });
      googleMarkers.push(marker);
      return;
    }

    if (leafletMarkersLayer) {
      const marker = L.marker([lat, lon]).bindPopup(buildPopupHtml(shop), { maxWidth: 280 });
      marker.on('click', () => prioritizeShopInResults(shop));
      leafletMarkersLayer.addLayer(marker);
    }
  }

  function buildPopupHtml(shop) {
    const name = escapeHtml(shop.name || 'Gårdsutsalg');
    const addr = shop.address ? `<div class="popup-addr">📍 ${escapeHtml(shop.address)}${shop.municipality ? ', ' + escapeHtml(shop.municipality) : ''}</div>` : '';
    const phone = shop.phone ? `<div class="popup-addr">📞 ${escapeHtml(shop.phone)}</div>` : '';
    const realWebsite = shop.website && !isFallbackWebsite(shop.website) ? normalizeWebsite(shop.website) : null;
    const mapsUrl = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent([shop.name, shop.address, shop.municipality, shop.country].filter(Boolean).join(', '))}`;
    const searchUrl = buildGooglePlaceSearchUrl(shop);
    const websiteBtn = realWebsite
      ? `<a class="popup-btn" href="${realWebsite}" target="_blank" rel="noopener">🌐 Nettside</a>`
      : `<a class="popup-btn" href="${searchUrl}" target="_blank" rel="noopener">🔍 Søk info</a>`;
    const mapsBtn = `<a class="popup-btn" href="${mapsUrl}" target="_blank" rel="noopener">🗺 Veibeskrivelse</a>`;
    return `<div class="popup-card"><strong>${name}</strong>${addr}${phone}<div class="popup-actions">${websiteBtn}${mapsBtn}</div></div>`;
  }

  function fitMapToMarkers() {
    if (!map) return;

    if (activeScopeBoundingBox) {
      const { south, west, north, east } = activeScopeBoundingBox;
      if ([south, west, north, east].every((value) => Number.isFinite(value))) {
        if (mapProvider === 'google') {
          const scopedBounds = new google.maps.LatLngBounds();
          scopedBounds.extend({ lat: south, lng: west });
          scopedBounds.extend({ lat: north, lng: east });
          map.fitBounds(scopedBounds);
          // Cap zoom AFTER fitBounds finishes its async animation
          google.maps.event.addListenerOnce(map, 'idle', () => {
            if (Number(map.getZoom() || 0) > 13) map.setZoom(13);
          });
          return;
        }

        if (leafletMarkersLayer) {
          map.fitBounds([[south, west], [north, east]], { maxZoom: 13 });
          return;
        }
      }
    }

    // No country selected — avoid fitBounds on all global markers (causes world-wrapping).
    // Instead, centre on user position if known, otherwise fall back to Norway.
    if (!countrySelect.value) {
      const fallbackLat = userPosition?.lat ?? 59.9;
      const fallbackLon = userPosition?.lon ?? 10.7;
      const fallbackZoom = userPosition ? 10 : 5;
      if (mapProvider === 'google') {
        map.setCenter({ lat: fallbackLat, lng: fallbackLon });
        map.setZoom(fallbackZoom);
      } else {
        map.setView([fallbackLat, fallbackLon], fallbackZoom);
      }
      return;
    }

    if (mapProvider === 'google') {
      if (!markerCoords.length) return;
      const bounds = new google.maps.LatLngBounds();
      markerCoords.forEach((point) => bounds.extend({ lat: point.lat, lng: point.lon }));
      map.fitBounds(bounds);
      google.maps.event.addListenerOnce(map, 'idle', () => {
        if (Number(map.getZoom() || 0) > 13) map.setZoom(13);
      });
      return;
    }

    if (leafletMarkersLayer && leafletMarkersLayer.getLayers().length) {
      map.fitBounds(leafletMarkersLayer.getBounds(), { maxZoom: 13 });
    }
  }

  function clearRouteVisuals() {
    if (mapProvider === 'google-embed') {
      return;
    }
    if (mapProvider === 'google') {
      if (googleRoutePolyline) {
        googleRoutePolyline.setMap(null);
        googleRoutePolyline = null;
      }
      return;
    }

    if (window._routeLayer) {
      map.removeLayer(window._routeLayer);
      window._routeLayer = null;
    }
    if (leafletBufferLayer) {
      map.removeLayer(leafletBufferLayer);
      leafletBufferLayer = null;
    }
  }

  function drawRouteLine(routeGeom) {
    if (!routeGeom?.coordinates?.length) return;

    if (mapProvider === 'google-embed' && googleEmbedIframe) {
      const start = routeGeom.coordinates[0];
      const end = routeGeom.coordinates[routeGeom.coordinates.length - 1];
      if (start && end) {
        const origin = `${start[1]},${start[0]}`;
        const destination = `${end[1]},${end[0]}`;
        googleEmbedIframe.src = `https://www.google.com/maps?saddr=${encodeURIComponent(origin)}&daddr=${encodeURIComponent(destination)}&output=embed`;
      }
      return;
    }

    if (!map) return;

    if (mapProvider === 'google') {
      const path = routeGeom.coordinates.map((coord) => ({ lat: Number(coord[1]), lng: Number(coord[0]) }));
      googleRoutePolyline = new google.maps.Polyline({
        path,
        geodesic: true,
        strokeColor: '#2563eb',
        strokeOpacity: 0.9,
        strokeWeight: 4,
      });
      googleRoutePolyline.setMap(map);

      const bounds = new google.maps.LatLngBounds();
      path.forEach((point) => bounds.extend(point));
      if (!bounds.isEmpty()) {
        map.fitBounds(bounds);
      }
      return;
    }

    window._routeLayer = L.geoJSON(routeGeom, { style: { color: 'blue', weight: 3 } }).addTo(map);
  }

  function applyMapHeight(nextHeight) {
    const minHeight = isMobile ? 90 : 220;
    const maxHeight = isMobile ? 420 : 900;
    currentMapHeight = Math.max(minHeight, Math.min(maxHeight, Number(nextHeight) || minHeight));
    if (mapEl) {
      mapEl.style.height = `${currentMapHeight}px`;
    }
    setTimeout(() => {
      if (!map) return;
      if (mapProvider === 'google' && window.google?.maps) {
        google.maps.event.trigger(map, 'resize');
      } else if (typeof map.invalidateSize === 'function') {
        map.invalidateSize();
      }
      fitMapToMarkers();
    }, 30);

    if (mapProvider === 'google-embed' && googleEmbedIframe) {
      googleEmbedIframe.style.height = `${currentMapHeight}px`;
    }
  }

  function escapeHtml(value) {
    return (value || '')
      .toString()
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  function haversineKm(lat1, lon1, lat2, lon2) {
    const toRad = (value) => value * (Math.PI / 180);
    const dLat = toRad(lat2 - lat1);
    const dLon = toRad(lon2 - lon1);
    const a = Math.sin(dLat / 2) ** 2 +
      Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
    return 6371 * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)));
  }

  async function loadNearbyRealShopsFromPosition(lat, lon, radiusKm = 50, options = {}) {
    const syncFilters = options?.syncFilters !== false;
    let geo = null;
    try {
      geo = await reverseGeocodeMunicipality(lat, lon);
    } catch (_) {
      geo = null;
    }
    const countryCode = normalizeCountryCode(geo?.countryCode || countrySelect.value);
    const countryLabel = countryCode ? countryNameByCode(countryCode) : (selectedText(countrySelect) || '');
    const regionLabel = geo?.region || selectedText(regionSelect) || '';
    const municipalityLabel = geo?.municipality || selectedText(muniSelect) || '';

    if (syncFilters && geo?.countryCode && [...countrySelect.options].some((option) => option.value === geo.countryCode)) {
      countrySelect.value = geo.countryCode;
      await populateRegions(geo.countryCode);
      if (regionLabel) {
        const regionMatch = [...regionSelect.options].find((option) =>
          (option.value || '').toLowerCase() === regionLabel.toLowerCase()
        );
        if (regionMatch) regionSelect.value = regionMatch.value;
      }
      await populateMunicipalities(countrySelect.value, regionSelect.value);
      if (municipalityLabel) {
        const municipalityMatch = [...muniSelect.options].find((option) =>
          (option.value || '').toLowerCase() === municipalityLabel.toLowerCase()
        );
        if (municipalityMatch) muniSelect.value = municipalityMatch.value;
      }
    }

    const radiusMeters = Math.round(radiusKm * 1000);
    let nearbyElements = [];
    try {
      nearbyElements = await searchOverpassAroundPoint(lat, lon, radiusMeters);
    } catch (_) {
      nearbyElements = [];
    }
    const nearbyLive = nearbyElements
      .map((element) => toOverpassShop(element, municipalityLabel, regionLabel, countryLabel))
      .filter((shop) => keepHighQuality(shop))
      .filter((shop) => shop.lat != null && shop.lon != null)
      .map((shop) => ({
        ...shop,
        distanceKm: haversineKm(lat, lon, Number(shop.lat), Number(shop.lon)),
      }))
      .filter((shop) => shop.distanceKm <= radiusKm);

    const nearbyLocal = shops
      .filter((shop) => shop.lat != null && shop.lon != null)
      .map((shop) => ({
        ...shop,
        distanceKm: haversineKm(lat, lon, Number(shop.lat), Number(shop.lon)),
      }))
      .filter((shop) => shop.distanceKm <= radiusKm);

    const merged = mergeShopLists(nearbyLocal, nearbyLive)
      .sort((left, right) => {
        const leftDistance = Number.isFinite(left.distanceKm) ? left.distanceKm : Number.POSITIVE_INFINITY;
        const rightDistance = Number.isFinite(right.distanceKm) ? right.distanceKm : Number.POSITIVE_INFINITY;
        if (leftDistance !== rightDistance) return leftDistance - rightDistance;
        return candidateScore(right) - candidateScore(left);
      });

    if (sortSelect) sortSelect.value = 'distance_asc';
    activeFiltered = merged;
    renderList(merged);
    if (!merged.length) {
      setMapStatus(`Ingen treff innen ${radiusKm} km. Prøv større radius (25/50/100 km).`);
    }
    if (resultsHeadingEl) {
      resultsHeadingEl.textContent = `${translate('nearbyHeadingPrefix')} (${radiusKm} km)`;
    }
    if (openGoogleMapBtn) {
      openGoogleMapBtn.href = buildGoogleMapsOverviewUrl(merged);
    }
    return merged;
  }

  function buildGoogleMapsOverviewUrl(items) {
    const withCoords = (items || []).filter((shop) => shop.lat != null && shop.lon != null);
    if (!withCoords.length) {
      const q = currentMapSearchQuery() || 'gårdsbutikk Norge';
      return buildGoogleMapsSearchApiUrl(q);
    }
    const first = withCoords[0];
    const destination = `${first.lat},${first.lon}`;
    const waypoints = withCoords
      .slice(1, 10)
      .map((shop) => `${shop.lat},${shop.lon}`)
      .join('|');
    const waypointParam = waypoints ? `&waypoints=${encodeURIComponent(waypoints)}` : '';
    return `https://www.google.com/maps/dir/?api=1&travelmode=driving&destination=${encodeURIComponent(destination)}${waypointParam}`;
  }
  function buildGooglePlaceSearchUrl(shop) {
    const query = [
      shop.name,
      shop.address,
      shop.municipality,
      shop.region,
      shop.country,
    ].filter(Boolean).join(' ');
    return `https://www.google.com/search?q=${encodeURIComponent(query)}`;
  }

  const GITHUB_ISSUE_BASE_URL = 'https://github.com/Einars-Apps/Matsjekk/issues/new';

  function yamlQuoted(value) {
    const text = (value == null ? '' : String(value)).replace(/\\/g, '\\\\').replace(/"/g, '\\"');
    return `"${text}"`;
  }

  function buildIssueUrl(template, title, body) {
    const params = new URLSearchParams({
      template,
      title,
      labels: 'submission',
      body,
    });
    return `${GITHUB_ISSUE_BASE_URL}?${params.toString()}`;
  }

  function openModerationIssue(url) {
    window.open(url, '_blank', 'noopener');
  }

  function createSuggestionIssueUrl(name, municipality, country, address, website) {
    const issueTitle = `[Suggestion] ${name}`;
    const yamlBody = [
      '```yaml',
      `name: ${yamlQuoted(name)}`,
      `country: ${yamlQuoted(country)}`,
      `municipality: ${yamlQuoted(municipality)}`,
      `address: ${yamlQuoted(address || '')}`,
      `website: ${yamlQuoted(website || '')}`,
      'notes: "Submitted from gardsbutikker page"',
      '```',
      '',
      'Verification links (optional):',
      '- '
    ].join('\n');
    return buildIssueUrl('farmshop_suggestion.md', issueTitle, yamlBody);
  }

  function createReportIssueUrl(placeName, reason, selectedCountryCode, address, website) {
    const issueTitle = `[Report] ${placeName}`;
    const yamlBody = [
      '```yaml',
      `name: ${yamlQuoted(placeName)}`,
      `country_code: ${yamlQuoted(selectedCountryCode || '')}`,
      `reason: ${yamlQuoted(reason)}`,
      `address: ${yamlQuoted(address || '')}`,
      `website: ${yamlQuoted(website || '')}`,
      '```',
      '',
      'Please review this listing before any change is merged.',
    ].join('\n');
    return buildIssueUrl('farmshop_report.md', issueTitle, yamlBody);
  }

  function renderList(filtered) {
    const visibleFiltered = (filtered || []).filter((shop) => !isSuppressedShop(shop));
    listEl.innerHTML = '';
    clearMapMarkers();

    if (mapProvider === 'google-embed') {
      updateEmbeddedMapFromFilters();
    }

    if (!visibleFiltered.length) {
      const selectedCountryCode = resolveCountryCode(countrySelect.value) || normalizeCountryCode(selectedText(countrySelect));
      const selectedCountryLabel = selectedText(countrySelect) || countryNameByCode(selectedCountryCode);
      const selectedRegionValue = regionSelect?.value || '';
      const selectedMunicipalityValue = muniSelect?.value || '';
      const selectedRegionLabel = selectedRegionValue ? selectedText(regionSelect) : '';
      const selectedMunicipalityLabel = selectedMunicipalityValue ? selectedText(muniSelect) : '';
      const selectedQuery = (searchInput?.value || '').trim();
      const hasActiveFilters = Boolean(
        selectedCountryCode ||
        selectedQuery ||
        selectedRegionValue ||
        selectedMunicipalityValue
      );
      const hasSpecificAreaFilter = Boolean(selectedQuery || selectedRegionValue || selectedMunicipalityValue);

      if (hasActiveFilters && selectedCountryCode && !hasSpecificAreaFilter) {
        const emergencySeeds = addDistanceFromUser(getTrustedSeedCandidates(selectedCountryCode, selectedCountryLabel, selectedMunicipalityLabel, selectedRegionLabel));
        if (emergencySeeds.length) {
          setMapStatus('Viser kvalitetssikrede nød-fallback treff for valgt land.');
          return renderList(emergencySeeds);
        }
      }

      const empty = document.createElement('div');
      empty.className = 'item';
      empty.textContent = 'Ingen lokale treff i datasettet. Bruk Google Maps-søk for flere resultater.';
      listEl.appendChild(empty);
      // Still zoom map to selected region/municipality bbox even with no results
      fitMapToMarkers();
      return;
    }

    const ordered = sortShops(visibleFiltered);
    ordered.forEach((shop) => {
      const div = document.createElement('div');
      div.className = 'item';
      div.dataset.shopKey = shopKeyForResult(shop);
      const products = (shop.products || []).join(', ');
      const location = [shop.address, shop.municipality, shop.region].filter(Boolean).join(', ');
      const phoneLine = shop.phone ? `<div class="item-sub">📞 ${escapeHtml(shop.phone)}</div>` : '';
      const openingLine = shop.openingHours ? `<div class="item-sub">🕒 ${escapeHtml(shop.openingHours)}</div>` : '';
      const productsLine = products ? `<div class="item-sub">🌾 ${escapeHtml(products)}</div>` : '';
      const realWebsite = shop.website && !isFallbackWebsite(shop.website) ? normalizeWebsite(shop.website) : null;
      const mapsUrl = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent([shop.name, shop.address, shop.municipality, shop.country].filter(Boolean).join(', '))}`;
      const searchUrl = buildGooglePlaceSearchUrl(shop);
      const image = shop.imageUrl ? `<img class="item-thumb" src="${shop.imageUrl}" alt="${escapeHtml(shop.name)}" loading="lazy" />` : '';
      const distanceLine = Number.isFinite(shop.distanceKm)
        ? `<div class="item-sub">📍 ${escapeHtml(shop.distanceKm.toFixed(1))} km unna</div>`
        : '';
      const websiteBtn = realWebsite
        ? `<a class="item-link" href="${realWebsite}" target="_blank" rel="noopener">🌐 Nettside</a>`
        : `<a class="item-link" href="${searchUrl}" target="_blank" rel="noopener">🔍 Søk</a>`;
      div.innerHTML = `
        <div class="item-row">
          ${image}
          <div class="item-content">
            <div class="item-title">${escapeHtml(shop.name)}</div>
            <div class="item-meta">${escapeHtml(shop.category || 'Gårdsutsalg')} · ${escapeHtml(location)}</div>
            ${distanceLine}
            ${phoneLine}
            ${openingLine}
            ${productsLine}
          </div>
        </div>
        <div class="item-actions">
          ${websiteBtn}
          <a class="item-link" href="${mapsUrl}" target="_blank" rel="noopener">🗺 Kart</a>
          <a class="item-link" href="${searchUrl}" target="_blank" rel="noopener">🔍 Google</a>
          <button class="item-link report-entry-btn" type="button" data-shop-name="${escapeHtml(shop.name)}">${escapeHtml(translate('quickReportBtn'))}</button>
        </div>
      `;
      listEl.appendChild(div);

      addMapMarker(shop);
    });

    fitMapToMarkers();
    applyPendingSearchCenter();
    if (openGoogleMapBtn) {
      openGoogleMapBtn.href = buildGoogleMapsOverviewUrl(ordered);
    }
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

  function isSuppressedShop(shop) {
    const rawName = (shop?.name || '').toString().trim().toLowerCase();
    const name = rawName.replace(/\s+/g, ' ');
    const countryCode = normalizeCountryCode(shop?.countryCode || shop?.country);

    if (/^a-k hillestad traktorservice(?: norge)?$/.test(name)) {
      return true;
    }

    if (/^(farm shop|farm store|farmstore|gårdsbutikk|gardsbutikk|gårdsutsalg|gardsutsalg|hofladen|hofladen\s\w+|magasin de la ferme|vente directe|vente à la ferme|farm|farmshop|farm shops)$/.test(name)) {
      return true;
    }
    if (/^farm shop(?: norge| norway)?$/.test(name)) {
      return true;
    }

    return false;
  }

  function keepHighQuality(shop) {
    if (isSuppressedShop(shop)) {
      return false;
    }
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
    const lat = Number.isFinite(Number(seed.lat)) ? Number(seed.lat) : null;
    const lon = Number.isFinite(Number(seed.lon)) ? Number(seed.lon) : null;
    const mapsUrl = (lat != null && lon != null)
      ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(`${lat},${lon}`)}`
      : (seed.address
        ? `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(seed.address)}`
        : '');
    return {
      id: `seed-${municipalityKey(seed.name)}`,
      name: seed.name,
      country: countryLabel,
      region: seed.region,
      municipality: seed.municipality,
      products: seed.products || ['Lokale gårdsprodukter'],
      website,
      lat,
      lon,
      address: seed.address || '',
      phone: '',
      openingHours: '',
      category: 'Gårdsutsalg',
      mapsUrl,
      imageUrl: '',
    };
  }

  function getTrustedSeedCandidates(countryCode, countryLabel, municipalityLabel, regionLabel = '') {
    const countrySeeds = TRUSTED_SEEDS_BY_COUNTRY[countryCode] || [];
    if (!countrySeeds.length) return [];

    const municipalityVariantsKeys = municipalityLabel
      ? municipalityVariants(countryCode, municipalityLabel).map((value) => municipalityKey(value))
      : [];
    const regionVariantKeys = regionLabel
      ? ((countryCode === 'NO' && !municipalityLabel)
        ? [regionKey(regionLabel)]
        : regionVariants(countryCode, regionLabel).map((value) => regionKey(value)))
      : [];

    const seeds = countrySeeds.filter((entry) => {
      const muniKey = municipalityKey(entry.municipality);
      const entryRegionKey = regionKey(entry.region);

      const municipalityMatch = municipalityVariantsKeys.length
        ? (municipalityVariantsKeys.includes(muniKey) || municipalityVariantsKeys.some((value) => muniKey.includes(value) || value.includes(muniKey)))
        : true;

      const regionMatch = regionVariantKeys.length
        ? (regionVariantKeys.includes(entryRegionKey) || regionVariantKeys.some((value) => entryRegionKey.includes(value) || value.includes(entryRegionKey)))
        : true;

      return municipalityMatch && regionMatch;
    });

    return seeds.map((entry) => toSeedShop(entry, countryLabel));
  }

  function buildSeedFallbackDataset() {
    return Object.entries(TRUSTED_SEEDS_BY_COUNTRY)
      .flatMap(([countryCode, seeds]) => (seeds || []).map((entry) => {
        const shop = toSeedShop(entry, countryNameByCode(countryCode));
        return {
          ...shop,
          countryCode,
        };
      }));
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

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), OVERPASS_FETCH_TIMEOUT_MS);
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
        body: overpassQuery,
        signal: controller.signal,
      });
      if (!response.ok) return [];
      const payload = await response.json();
      return Array.isArray(payload?.elements) ? payload.elements : [];
    } catch (_) {
      return [];
    } finally {
      clearTimeout(timeoutId);
    }
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

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), OVERPASS_FETCH_TIMEOUT_MS);
    try {
      const response = await fetch('https://overpass-api.de/api/interpreter', {
        method: 'POST',
        headers: { 'Content-Type': 'text/plain;charset=UTF-8' },
        body: overpassQuery,
        signal: controller.signal,
      });
      if (!response.ok) return [];
      const payload = await response.json();
      return Array.isArray(payload?.elements) ? payload.elements : [];
    } catch (_) {
      return [];
    } finally {
      clearTimeout(timeoutId);
    }
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

  function isWithinBoundingBox(lat, lon, box, padding = 0.08) {
    if (!box || !Number.isFinite(lat) || !Number.isFinite(lon)) return false;
    return (
      lat >= (box.south - padding) &&
      lat <= (box.north + padding) &&
      lon >= (box.west - padding) &&
      lon <= (box.east + padding)
    );
  }

  async function fetchMunicipalityBoundingBoxCached(countryCode, municipalityLabel, regionLabel) {
    if (!countryCode || !municipalityLabel) return null;
    const key = `${countryCode}|${municipalityKey(municipalityLabel)}|${regionKey(regionLabel || '')}`;
    if (municipalityBoundsCache.has(key)) {
      return municipalityBoundsCache.get(key);
    }
    const box = await fetchMunicipalityBoundingBox(countryCode, municipalityLabel, regionLabel);
    municipalityBoundsCache.set(key, box || null);
    return box || null;
  }

  async function fetchRegionBoundingBoxCached(countryCode, regionLabel) {
    if (!countryCode || !regionLabel) return null;
    const key = `${countryCode}|${regionKey(regionLabel)}`;
    if (regionBoundsCache.has(key)) {
      return regionBoundsCache.get(key);
    }
    const box = await fetchRegionBoundingBox(countryCode, regionLabel);
    regionBoundsCache.set(key, box || null);
    return box || null;
  }

  async function fetchRegionBoundingBox(countryCode, regionLabel) {
    if (!regionLabel) return null;
    const regionVariantsList = [regionLabel]
      .map((value) => (value || '').toString().trim())
      .filter(Boolean);
    const countryLabel = countryNameByCode(countryCode);
    const collectedBoxes = [];

    for (const regionName of (regionVariantsList.length ? regionVariantsList : [regionLabel])) {
      const hits = await searchNominatim(`${regionName} ${countryLabel}`, countryCode);
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

      const adminCandidate = candidates.find((box) => /boundary|administrative|county|state|region/.test(box.classType));
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
    const seedCandidates = getTrustedSeedCandidates(countryCode, country, muni, region);

    if (webCandidateCache.has(cacheKey)) {
      return webCandidateCache.get(cacheKey);
    }

    const municipalityTerms = municipalityVariants(countryCode, muni);
    const locationTerms = municipalityTerms.length ? municipalityTerms : [muni];
    const lexicon = getCountrySearchLexicon(countryCode);
    const baseTerm = query || lexicon.baseTerm || 'farm shop';
    const countryTerms = countryQueryVariants(countryCode, country);
    const fallbackCountryTerms = countryTerms.length ? countryTerms : [country || countryCode || ''];

    const terms = [
      ...fallbackCountryTerms.map((countryTerm) => `${baseTerm} ${muni} ${region} ${countryTerm}`),
      ...fallbackCountryTerms.map((countryTerm) => `farm shop ${muni} ${countryTerm}`),
      ...fallbackCountryTerms.map((countryTerm) => `local farm store ${muni} ${countryTerm}`),
      ...locationTerms.flatMap((name) => fallbackCountryTerms.map((countryTerm) => `${baseTerm} ${name} ${region} ${countryTerm}`)),
      ...locationTerms.flatMap((name) => fallbackCountryTerms.map((countryTerm) => `farm shop ${name} ${countryTerm}`)),
    ].filter((term) => (term || '').trim().length >= 3);

    let results = [];
    let overpassCandidates = [];
    try {
      [results, overpassCandidates] = await Promise.all([
        Promise.all(terms.map((term) => searchNominatim(term, countryCode))),
        fetchOverpassMunicipalityCandidates({
          countryCode,
          countryLabel: country,
          regionLabel: region,
          municipalityLabel: muni,
        }),
      ]);
    } catch (error) {
      console.warn('Live candidate lookups failed; falling back to trusted seeds only.', error);
      results = [];
      overpassCandidates = [];
    }
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

  async function filterShops() {
    const runId = ++filterRunId;
    setMapStatus('');
    setPendingSearchCenter(null, null);
    const countryCode = resolveCountryCode(countrySelect.value);
    const regionValue = regionSelect.value;
    const municipalityValue = muniSelect.value;
    const regionText = regionValue ? selectedText(regionSelect) : '';
    const municipalityText = municipalityValue ? selectedText(muniSelect) : '';
    const countryText = selectedText(countrySelect);
    const query = searchInput.value.trim().toLowerCase();

    const needsFullCountryScope = Boolean(countryCode && (query || regionValue || municipalityValue));
    const scopeMismatch = countryCode && loadedScopeCountryCode !== countryCode;
    const shouldPromoteScope = Boolean(needsFullCountryScope && (loadedScopeIsPreview || scopeMismatch));
    if (shouldPromoteScope) {
      await ensureShopScope(countryCode, { previewOnly: false });
      if (runId !== filterRunId) return activeFiltered;
    }

    if (query.length >= 3) {
      try {
        const searchHint = [
          query,
          municipalityText,
          regionText,
          countryText || countryNameByCode(countryCode),
        ].filter(Boolean).join(', ');
        const searchGeo = await geocodeWithFallback(searchHint);
        if (runId !== filterRunId) return activeFiltered;
        if (searchGeo?.lat != null && searchGeo?.lon != null) {
          setPendingSearchCenter(Number(searchGeo.lat), Number(searchGeo.lon), 10);
        }
      } catch (_) {
        // Ignore geocode failures; list/map filtering continues.
      }
    }

    let localityCountryCode = countryCode;
    let localityRegionText = regionText;
    let localityMunicipalityText = municipalityText;

    if ((!countryCode || countryCode === 'NO') && !municipalityText && query.length >= 3) {
      await ensureNorwayGeoData();
      const municipalityHint = findNorwayMunicipalityByQuery(query, regionText);
      if (municipalityHint) {
        localityCountryCode = 'NO';
        localityMunicipalityText = municipalityHint.name;
        if (!localityRegionText && municipalityHint.countyName) {
          localityRegionText = municipalityHint.countyName;
        }
      }
    }

    const countryRows = (countryCode
      ? shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode))
      : shops).filter((shop) => !isSuppressedShop(shop));
    const hasRegionDataForCountry = countryRows.some((shop) => (shop.region || '').toString().trim());
    const hasMunicipalityDataForCountry = countryRows.some((shop) => (shop.municipality || '').toString().trim());

    const municipalityTerms = municipalityVariants(countryCode, municipalityText)
      .map((name) => municipalityKey(name));
    const regionTerms = regionVariants(countryCode, regionText);
    const queryMunicipalityTerms = municipalityVariants(countryCode, query)
      .map((name) => municipalityKey(name));

    let municipalityBoundingBox = null;
    if (countryCode && municipalityText) {
      municipalityBoundingBox = await fetchMunicipalityBoundingBoxCached(countryCode, municipalityText, regionText);
      if (runId !== filterRunId) return [];
    }

    let regionBoundingBox = null;
    if (countryCode && regionText && !municipalityText) {
      regionBoundingBox = await fetchRegionBoundingBoxCached(countryCode, regionText);
      if (runId !== filterRunId) return [];
    }

    activeScopeBoundingBox = municipalityBoundingBox || regionBoundingBox;

    const applyMunicipalityScope = (items) => {
      const source = (items || []).filter((shop) => !isSuppressedShop(shop));
      const hasMunicipalityScope = Boolean(municipalityText);
      const hasRegionScope = Boolean(regionText && !municipalityText);
      if (!hasMunicipalityScope && !hasRegionScope) return source;

      return source.filter((shop) => {
        const lat = Number(shop?.lat);
        const lon = Number(shop?.lon);

        if (hasMunicipalityScope) {
          const municipalityTextMatch = countryCode === 'NO'
            ? municipalityMatches(shop.municipality || '', municipalityTerms)
            : normalizeAdminLabel(shop.municipality || '') === normalizeAdminLabel(municipalityText);

          if (municipalityTextMatch) {
            return true;
          }
          if (municipalityBoundingBox && Number.isFinite(lat) && Number.isFinite(lon)) {
            return isWithinBoundingBox(lat, lon, municipalityBoundingBox, 0.12);
          }
          return false;
        }

        const regionTextMatch = countryCode === 'NO'
          ? regionMatches(shop.region || '', regionTerms)
          : normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionText);

        if (regionTextMatch) {
          return true;
        }
        if (regionBoundingBox && Number.isFinite(lat) && Number.isFinite(lon)) {
          return isWithinBoundingBox(lat, lon, regionBoundingBox, 0.2);
        }
        return false;
      });
    };

    let filtered = [...countryRows];

    if (regionValue || municipalityValue) {
      filtered = filtered.filter((shop) => {
        const regionMatch = !regionValue || (countryCode === 'NO'
          ? regionMatches(shop.region || '', regionTerms)
          : normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionValue || regionText));
        // For non-Norway, skip strict municipality equality here — applyMunicipalityScope
        // uses bounding box to capture all sub-localities within the selected comune/commune.
        const municipalityMatch = !municipalityValue || (countryCode === 'NO'
          ? municipalityMatches(shop.municipality || '', municipalityTerms)
          : true);
        return regionMatch && municipalityMatch;
      });
    }

    if (countryCode === 'NO' && (regionValue || municipalityValue) && (!hasRegionDataForCountry || !hasMunicipalityDataForCountry)) {
      setMapStatus('Datagrunnlaget mangler fylke/kommune på mange treff; bruker kun verifiserte treff for valgt område.');
    }

    if (countryCode && !filtered.length) {
      const countrySeeds = getTrustedSeedCandidates(
        countryCode,
        countryText || countryNameByCode(countryCode),
        municipalityText,
        regionText,
      );
      if (countrySeeds.length) {
        filtered = mergeShopLists(filtered, countrySeeds);
        setMapStatus('Viser kvalitetssikrede, verifiserte treff for valgt område (seed-fallback).');
      }
    }

    if (query) {
      filtered = filtered.filter((shop) =>
        (shop.name || '').toLowerCase().includes(query) ||
        (shop.products || []).join(' ').toLowerCase().includes(query) ||
        (shop.address || '').toLowerCase().includes(query) ||
        (shop.municipality || '').toLowerCase().includes(query) ||
        (queryMunicipalityTerms.length > 1 && municipalityMatches(shop.municipality || '', queryMunicipalityTerms))
      );
    }

    filtered = applyMunicipalityScope(filtered);

    if (countryCode && !regionValue && !municipalityValue && !query && !filtered.length) {
      const relaxedCountryOnly = shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode));
      if (relaxedCountryOnly.length) {
        filtered = relaxedCountryOnly;
        setMapStatus('Viser treff med tolerant landmatch (fallback).');
      }
    }

    if (countryCode && !query && !regionValue && !municipalityValue && !filtered.length) {
      const countryOnly = shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode));
      if (countryOnly.length) {
        filtered = countryOnly;
        setMapStatus('Viser landtreff via hard fallback.');
      } else {
        setMapStatus('Fant ingen treff i valgt land enda. Prøv nær-søk eller velg et annet land mens datagrunnlaget oppdateres.');
      }
    }

    if (sortSelect?.value === 'distance_asc') {
      filtered = addDistanceFromUser(filtered);
    }

    const countryOnlyCount = countryCode
      ? shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode)).length
      : shops.length;
    setDebugStats(`Debug: value=${countrySelect.value || '-'}, text=${countryText || '-'}, land=${countryCode || '-'}, lastet=${shops.length}, landtreff=${countryOnlyCount}, vises=${filtered.length}`);

    if (countryCode && loadedScopeIsPreview && !query && !regionValue && !municipalityValue) {
      const previewLimit = initialPreviewLimit();
      setMapStatus(`Viser et utvalg (${Math.min(previewLimit, filtered.length)} av ${countryOnlyCount}) for valgt land. Søk eller velg område for full liste.`);
    }

    filtered = applyMunicipalityScope(filtered);
    activeFiltered = filtered;
    renderList(filtered);

    const isCountyOnlySelection = Boolean(regionText && !municipalityText && !query);
    const shouldUseLocalityFallback = Boolean(
      municipalityText ||
      (query && query.length >= 2) ||
      isCountyOnlySelection
    );

    const localityContext = {
      countryCode: localityCountryCode || countryCode,
      regionText: localityRegionText || regionText,
      municipalityText: localityMunicipalityText || municipalityText,
      queryText: query,
    };

    if (!filtered.length && shouldUseLocalityFallback) {
      const cachedLocality = recallLocalityResult(localityContext);
      if (cachedLocality.length) {
        filtered = applyMunicipalityScope(addDistanceFromUser(cachedLocality));
        activeFiltered = filtered;
        renderList(filtered);
        setMapStatus('Viser lagrede områdetreff (cache).');
        return filtered;
      }
    }

    if (!filtered.length && shouldUseLocalityFallback) {
      try {
        if (isCountyOnlySelection) {
          const regionBox = await fetchRegionBoundingBox(countryCode, regionText);
          if (runId !== filterRunId) return filtered;
          if (regionBox) {
            const liveCountyElements = await searchOverpassInBoundingBox(regionBox);
            const liveCounty = liveCountyElements
              .map((element) => toOverpassShop(element, municipalityText || query, regionText, countryText || countryNameByCode(countryCode)))
              .filter((shop) => keepHighQuality(shop));

            const countyLocal = shops
              .filter((shop) => shop.countryCode === countryCode)
              .filter((shop) => {
                if (countryCode === 'NO') return strictRegionMatch(shop.region || '', regionText);
                return normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionText);
              });

            const countyCombined = mergeShopLists(countyLocal, liveCounty)
              .slice(0, 120);
            const scopedCounty = applyMunicipalityScope(countyCombined);

            if (scopedCounty.length) {
              filtered = scopedCounty;
              activeFiltered = scopedCounty;
              renderList(scopedCounty);
              setMapStatus('Viser treff innen valgt fylke/region (fallback).');
            }
          }
        } else {
          const effectiveCountryLabel = countryText || countryNameByCode(localityCountryCode || countryCode);
          const localityHint = [localityMunicipalityText || query, localityRegionText, effectiveCountryLabel]
            .filter(Boolean)
            .join(', ');
          let nearLat = null;
          let nearLon = null;

          if ((localityCountryCode || countryCode) === 'NO' && localityMunicipalityText) {
            const center = await fetchMunicipalityCenter('NO', localityMunicipalityText, localityRegionText);
            if (center && Number.isFinite(center.lat) && Number.isFinite(center.lon)) {
              nearLat = Number(center.lat);
              nearLon = Number(center.lon);
            }
          }

          if (!Number.isFinite(nearLat) || !Number.isFinite(nearLon)) {
            const geo = await geocodeWithFallback(localityHint);
            nearLat = geo?.lat != null ? Number(geo.lat) : null;
            nearLon = geo?.lon != null ? Number(geo.lon) : null;
          }

          if (runId !== filterRunId) return filtered;
          if (Number.isFinite(nearLat) && Number.isFinite(nearLon)) {
            const localityRadiusKm = municipalityText ? 50 : (localityMunicipalityText ? 45 : 35);
            const liveNearbyElements = await searchOverpassAroundPoint(nearLat, nearLon, localityRadiusKm * 1000);
            const liveNearby = liveNearbyElements
              .map((element) => toOverpassShop(
                element,
                localityMunicipalityText || municipalityText || query,
                localityRegionText || regionText,
                effectiveCountryLabel,
              ))
              .filter((shop) => keepHighQuality(shop))
              .filter((shop) => shop.lat != null && shop.lon != null)
              .map((shop) => ({
                ...shop,
                distanceKm: haversineKm(nearLat, nearLon, Number(shop.lat), Number(shop.lon)),
              }))
              .filter((shop) => Number.isFinite(shop.distanceKm) && shop.distanceKm <= localityRadiusKm);

            const nearbyLocal = shops
              .filter((shop) => (!(localityCountryCode || countryCode) || shopMatchesCountryRelaxed(shop, localityCountryCode || countryCode)) && shop.lat != null && shop.lon != null)
              .map((shop) => ({
                ...shop,
                distanceKm: haversineKm(nearLat, nearLon, Number(shop.lat), Number(shop.lon)),
              }))
              .filter((shop) => Number.isFinite(shop.distanceKm) && shop.distanceKm <= localityRadiusKm)
              .sort((left, right) => left.distanceKm - right.distanceKm);

            const nearbyCombined = mergeShopLists(nearbyLocal, liveNearby)
              .sort((left, right) => {
                const leftDistance = Number.isFinite(left.distanceKm) ? left.distanceKm : Number.POSITIVE_INFINITY;
                const rightDistance = Number.isFinite(right.distanceKm) ? right.distanceKm : Number.POSITIVE_INFINITY;
                return leftDistance - rightDistance;
              })
              .slice(0, 120);

            let scopedNearby = nearbyCombined;
            if (regionValue || municipalityValue) {
              scopedNearby = nearbyCombined.filter((shop) => {
                const regionMatch = !regionValue || (countryCode === 'NO'
                  ? regionMatches(shop.region || '', regionTerms)
                  : normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionValue || regionText));
                // For non-Norway, skip strict equality — applyMunicipalityScope uses bounding box
                const municipalityMatch = !municipalityValue || (countryCode === 'NO'
                  ? municipalityMatches(shop.municipality || '', municipalityTerms)
                  : true);
                return regionMatch && municipalityMatch;
              });
            }

            if (scopedNearby.length) {
              scopedNearby = applyMunicipalityScope(scopedNearby);
            }

            if (scopedNearby.length) {
              filtered = scopedNearby;
              activeFiltered = scopedNearby;
              renderList(scopedNearby);
              setMapStatus('Viser nærmeste treff basert på kommune-sentrum (strammere lokalitetsfallback).');
              rememberLocalityResult(localityContext, scopedNearby);
            } else if (nearbyCombined.length && (regionValue || municipalityValue)) {
              setMapStatus('Fant treff nær valgt sted, men ingen innen valgt fylke/kommune.');
            }
          }
        }
      } catch (_) {
        // Ignore fallback failures and continue with web enrichment below.
      }
    }

    if (!ENABLE_LIVE_ENRICHMENT) {
      if (!filtered.length && countryCode) {
        setMapStatus('Ingen verifiserte treff i datasett/seed for valgt filter. Bruk Google Maps-søk for utvidet søk.');
      }
      return filtered;
    }

    const shouldEnrich = Boolean(
      regionText ||
      municipalityText ||
      (query && query.length >= 2) ||
      (countryCode && !filtered.length)
    );
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
      const merged = applyMunicipalityScope(addDistanceFromUser(mergeShopLists(filtered, liveCandidates)));
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
        const mergedRegionWide = applyMunicipalityScope(addDistanceFromUser(mergeShopLists(merged, regionWideCandidates)));
        activeFiltered = mergedRegionWide;
        renderList(mergedRegionWide);
        return mergedRegionWide;
      }

      return merged;
    } catch (error) {
      console.warn('Could not enrich farmshop list with live web candidates.', error);
      if (countryCode === 'NO' && municipalityText) {
        const trustedFallback = getTrustedSeedCandidates(countryCode, countryText, municipalityText, regionText);
        const mergedFallback = applyMunicipalityScope(addDistanceFromUser(mergeShopLists(filtered, trustedFallback)));
        activeFiltered = mergedFallback;
        renderList(mergedFallback);
        return mergedFallback;
      }
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

  async function geocode(query) {
    const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}`;
    try {
      const response = await fetch(url, { cache: 'no-cache' });
      if (!response.ok) return null;
      const payload = await response.json();
      return payload[0] || null;
    } catch (_) {
      return null;
    }
  }

  async function geocodeWithFallback(query) {
    const first = await geocode(query);
    if (first) return first;

    const selectedCountryCode = resolveCountryCode(countrySelect.value);
    const selectedCountry = selectedText(countrySelect) || countryNameByCode(selectedCountryCode) || 'Norge';
    const fallback = await geocode(`${query}, ${selectedCountry}`);
    if (fallback) return fallback;

    if (!/norge|norway/i.test(query)) {
      return geocode(`${query}, Norge`);
    }
    return null;
  }

  async function findAlongRoute(from, to) {
    if (!from || !to) {
      alert('Skriv inn både fra- og til-sted.');
      return;
    }

    const fromPoint = await geocodeWithFallback(from);
    const toPoint = await geocodeWithFallback(to);
    if (!fromPoint || !toPoint) {
      const fallbackUrl = `https://www.google.com/maps/dir/?api=1&origin=${encodeURIComponent(from)}&destination=${encodeURIComponent(to)}&travelmode=driving`;
      window.open(fallbackUrl, '_blank', 'noopener');
      alert('Kunne ikke geokode hele ruten lokalt. Åpnet Google Maps rute i ny fane.');
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
    clearRouteVisuals();
    drawRouteLine(routeGeom);

    if (mapProvider === 'leaflet') {
      leafletBufferLayer = L.geoJSON(buffer, { style: { color: '#00f', weight: 1, opacity: 0.15 } }).addTo(map);
      setTimeout(() => {
        if (leafletBufferLayer) {
          map.removeLayer(leafletBufferLayer);
          leafletBufferLayer = null;
        }
      }, 10000);
    }

    fitMapToMarkers();
  }

  countrySelect.addEventListener('change', async () => {
    activeNearRadiusKm = null;
    const selectedCountryCode = resolveCountryCode(countrySelect.value);
    await ensureShopScope(selectedCountryCode, { previewOnly: Boolean(selectedCountryCode) });
    await populateRegions(selectedCountryCode);
    await populateMunicipalities(selectedCountryCode, '');
    filterShops();
  });

  regionSelect.addEventListener('change', async () => {
    activeNearRadiusKm = null;
    const selectedCountryCode = resolveCountryCode(countrySelect.value);
    await populateMunicipalities(selectedCountryCode, regionSelect.value);
    filterShops();
  });

  muniSelect.addEventListener('change', () => {
    activeNearRadiusKm = null;
    filterShops();
  });
  if (sortSelect) {
    sortSelect.addEventListener('change', () => {
      renderList(activeFiltered);
    });
  }
  if (applyFiltersBtn) {
    applyFiltersBtn.addEventListener('click', () => {
      activeNearRadiusKm = null;
      filterShops();
    });
  }
  let searchDebounce = null;
  searchInput.addEventListener('input', () => {
    activeNearRadiusKm = null;
    if (searchDebounce) clearTimeout(searchDebounce);
    searchDebounce = setTimeout(() => {
      filterShops();
    }, 300);
  });

  if (listEl) {
    listEl.addEventListener('click', (event) => {
      const target = event.target;
      if (!(target instanceof HTMLElement)) return;
      if (!target.classList.contains('report-entry-btn')) return;
      const placeName = target.dataset.shopName || '';
      if (reportNameEl) reportNameEl.value = placeName;
      if (reportReasonEl && !reportReasonEl.value.trim()) {
        reportReasonEl.value = translate('quickReportDefaultReason');
      }
      if (reportStatusEl) reportStatusEl.textContent = '';
      reportNameEl?.focus();
      reportNameEl?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    });
  }

  if (submitSuggestionBtn) {
    submitSuggestionBtn.addEventListener('click', () => {
      const name = (suggestNameEl?.value || '').trim();
      const municipality = (suggestMunicipalityEl?.value || '').trim();
      const country = (suggestCountryEl?.value || '').trim();
      const address = (suggestAddressEl?.value || '').trim();
      const website = (suggestWebsiteEl?.value || '').trim();
      if (!name || !municipality || !country) {
        if (suggestionStatusEl) suggestionStatusEl.textContent = translate('suggestionMissingFields');
        return;
      }
      if (suggestionStatusEl) suggestionStatusEl.textContent = translate('suggestionOpeningIssue');
      const url = createSuggestionIssueUrl(name, municipality, country, address, website);
      openModerationIssue(url);
    });
  }

  if (submitReportBtn) {
    submitReportBtn.addEventListener('click', () => {
      const placeName = (reportNameEl?.value || '').trim();
      const reason = (reportReasonEl?.value || '').trim();
      const address = (reportAddressEl?.value || '').trim();
      const website = (reportWebsiteEl?.value || '').trim();
      if (!placeName || !reason) {
        if (reportStatusEl) reportStatusEl.textContent = translate('reportMissingFields');
        return;
      }
      if (reportStatusEl) reportStatusEl.textContent = translate('reportOpeningIssue');
      const countryCode = resolveCountryCode(countrySelect?.value || '');
      const url = createReportIssueUrl(placeName, reason, countryCode, address, website);
      openModerationIssue(url);
    });
  }

  document.getElementById('resetBtn').addEventListener('click', async () => {
    activeNearRadiusKm = null;
    regionSelect.value = '';
    muniSelect.value = '';
    searchInput.value = '';
    if (sortSelect) sortSelect.value = 'name_asc';
    if (nearRadiusSelect) nearRadiusSelect.value = '50';

    // Restore to the country the device is physically in (if known), else keep current.
    const restoreCode = userDetectedCountryCode || countrySelect.value || '';
    countrySelect.value = restoreCode;
    await ensureShopScope(restoreCode);
    await populateRegions(restoreCode);
    await populateMunicipalities(restoreCode, '');
    // filterShops → fitMapToMarkers will fitBounds to the country's markers automatically.
    filterShops();
  });

  document.getElementById('routeBtn').addEventListener('click', () => {
    const from = document.getElementById('routeFrom').value;
    const to = document.getElementById('routeTo').value;
    findAlongRoute(from, to);
  });

  if (myMunicipalityBtn && navigator.geolocation) {
    myMunicipalityBtn.addEventListener('click', () => {
      activeNearRadiusKm = null;
      filterShops();
      if ((searchInput?.value || '').trim()) {
        openGoogleMapsSearchFromFilters();
      }
    });
  } else if (myMunicipalityBtn) {
    myMunicipalityBtn.addEventListener('click', () => {
      activeNearRadiusKm = null;
      filterShops();
      if ((searchInput?.value || '').trim()) {
        openGoogleMapsSearchFromFilters();
      }
    });
  }

  if (nearMeBtn && navigator.geolocation) {
    nearMeBtn.addEventListener('click', () => {
      navigator.geolocation.getCurrentPosition(async (position) => {
        const radiusKm = selectedNearRadiusKm();
        activeNearRadiusKm = radiusKm;
        try {
          if (sortSelect) sortSelect.value = 'distance_asc';
          setUserPosition(position.coords.latitude, position.coords.longitude);
          await loadNearbyRealShopsFromPosition(position.coords.latitude, position.coords.longitude, radiusKm, { syncFilters: false });
        } catch (_) {
          const localNearby = addDistanceFromUser(shops)
            .filter((shop) => Number.isFinite(shop?.distanceKm) && shop.distanceKm <= radiusKm)
            .sort((left, right) => left.distanceKm - right.distanceKm)
            .slice(0, 120);

          if (localNearby.length) {
            activeFiltered = localNearby;
            renderList(localNearby);
            if (resultsHeadingEl) {
              resultsHeadingEl.textContent = `${translate('nearbyHeadingPrefix')} (${radiusKm} km)`;
            }
            setMapStatus('Viser nærmeste treff fra lokalt datasett (fallback).');
            return;
          }

          setMapStatus(`Fant ingen sikre treff innen ${radiusKm} km. Prøv større radius.`);
          const nearbyUrl = `https://www.google.com/maps/search/${encodeURIComponent(`gårdsbutikk ${position.coords.latitude},${position.coords.longitude}`)}`;
          window.open(nearbyUrl, '_blank', 'noopener');
        }
      }, () => {
        alert('Kunne ikke hente posisjon. Sjekk stedstjenester i nettleseren.');
      }, { enableHighAccuracy: true, timeout: 10000 });
    });
  } else if (nearMeBtn) {
    nearMeBtn.addEventListener('click', () => {
      alert('Stedstjenester er ikke tilgjengelig i denne nettleseren. Åpner Google Maps-søk for valgt område.');
      openGoogleMapsSearchFromFilters();
    });
  }

  if (openGoogleMapBtn) {
    openGoogleMapBtn.addEventListener('click', (event) => {
      if (!openGoogleMapBtn.href || openGoogleMapBtn.href === '#') {
        event.preventDefault();
        openGoogleMapBtn.href = buildGoogleMapsOverviewUrl(activeFiltered);
      }
    });
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

  const mapInitPromise = initMap();
  initLanguageSelector();

  populateCountries();

  const preferredCountryCode = await detectPreferredCountryCode();
  if (preferredCountryCode && [...countrySelect.options].some((option) => option.value === preferredCountryCode)) {
    countrySelect.value = preferredCountryCode;
  } else {
    countrySelect.value = 'NO';
  }

  try {
    const initialCountryCode = resolveCountryCode(countrySelect.value);
    await ensureShopScope(initialCountryCode, { previewOnly: Boolean(initialCountryCode) });
    if (shops.length === 0) {
      shops = (await loadFirstAvailable(fallbackUrls)).map(normalizeShop);
      loadedScopeCountryCode = '';
      loadedScopeIsPreview = false;
    }
  } catch (error) {
    console.error('Failed to load scoped farmshops dataset, falling back to example', error);
    try {
      shops = (await loadFirstAvailable(fallbackUrls)).map(normalizeShop);
      loadedScopeCountryCode = '';
      loadedScopeIsPreview = false;
    } catch (_) {
      shops = [];
    }
  }

  if (!shops.length) {
    shops = buildSeedFallbackDataset();
    loadedScopeCountryCode = '';
    loadedScopeIsPreview = false;
    setMapStatus('Datakilde utilgjengelig. Viser kvalitetssikrede fallback-treff.');
  }

  try {
    const areaCacheRows = await loadFirstAvailableAreaCache(areaCacheUrls);
    loadSharedLocalityCache(areaCacheRows);
  } catch (_) {
    sharedLocalityCache.clear();
  }

  const norwayLoadedCount = shops.filter((shop) => shopMatchesCountryRelaxed(shop, 'NO')).length;
  setDebugStats(`Init: lastet=${shops.length}, NO=${norwayLoadedCount}`);

  await mapInitPromise;
  applyMapHeight(currentMapHeight);

  await populateRegions(resolveCountryCode(countrySelect.value));
  await populateMunicipalities(resolveCountryCode(countrySelect.value), '');
  applyPageLanguage(currentPageLanguage);
  activeFiltered = addDistanceFromUser(shops);
  renderList(activeFiltered);
  filterShops();
})();
