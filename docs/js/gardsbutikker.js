// Farmshops client: filters, map, route search and Google Maps area search
(async function () {
  const dataUrls = [
    'data/farmshops.json',
    '/data/farmshops.json',
    '../../docs/data/farmshops.json',
  ];
  const fallbackUrls = [
    'data/farmshops.example.json',
    '/data/farmshops.example.json',
    '../../docs/data/farmshops.example.json',
  ];
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
    IT: ['Lombardia', 'Piemonte', 'Veneto', 'Emilia-Romagna', 'Toscana', 'Lazio', 'Sicilia'],
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
  const openGoogleMapBtn = document.getElementById('openGoogleMapBtn');
  const backBtn = document.getElementById('backBtn');

  const isMobile = window.matchMedia('(max-width: 768px)').matches;
  let currentMapHeight = isMobile ? 110 : 400;
  let regionPopulateRequestId = 0;
  let municipalityPopulateRequestId = 0;
  let userPosition = null;
  const ENABLE_AUTO_COUNTRY_FROM_POSITION = false;
  const ENABLE_LIVE_ENRICHMENT = false;
  const OVERPASS_FETCH_TIMEOUT_MS = 5500;

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
  }

  function addDistanceFromUser(items) {
    if (!userPosition || !Number.isFinite(userPosition.lat) || !Number.isFinite(userPosition.lon)) {
      return items;
    }
    return (items || []).map((shop) => {
      if (shop.lat == null || shop.lon == null) return shop;
      const lat = Number(shop.lat);
      const lon = Number(shop.lon);
      if (!Number.isFinite(lat) || !Number.isFinite(lon)) return shop;
      const distanceKm = haversineKm(userPosition.lat, userPosition.lon, lat, lon);
      if (!Number.isFinite(distanceKm)) return shop;
      return { ...shop, distanceKm };
    });
  }

  const GOOGLE_MAPS_API_KEY = (document.querySelector('meta[name="google-maps-api-key"]')?.getAttribute('content') || '').trim();
  let mapProvider = 'leaflet';
  let map = null;
  let leafletMarkersLayer = null;
  let googleMarkers = [];
  let markerCoords = [];
  let googleInfoWindow = null;
  let googleRoutePolyline = null;
  let leafletBufferLayer = null;
  let googleEmbedIframe = null;

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
    map = L.map('map').setView([59.9, 10.7], 5);
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

  async function autoSelectCountryFromPosition() {
    if (!navigator.geolocation) return false;
    try {
      const position = await getCurrentPositionAsync({ enableHighAccuracy: false, timeout: 7000, maximumAge: 300000 });
      setUserPosition(position.coords.latitude, position.coords.longitude);
      const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
      const countryCode = normalizeCountryCode(geo?.countryCode || '');
      if (!countryCode) return false;

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
        googleInfoWindow.setContent(`<strong>${escapeHtml(shop.name || 'Gårdsutsalg')}</strong><br>${escapeHtml(shop.address || '')}`);
        googleInfoWindow.open({ anchor: marker, map });
      });
      googleMarkers.push(marker);
      return;
    }

    if (leafletMarkersLayer) {
      const marker = L.marker([lat, lon]).bindPopup(`<strong>${shop.name}</strong><br>${shop.address || ''}`);
      marker.on('click', () => prioritizeShopInResults(shop));
      leafletMarkersLayer.addLayer(marker);
    }
  }

  function fitMapToMarkers() {
    if (!map) return;

    if (mapProvider === 'google') {
      if (!markerCoords.length) return;
      const bounds = new google.maps.LatLngBounds();
      markerCoords.forEach((point) => bounds.extend({ lat: point.lat, lng: point.lon }));
      map.fitBounds(bounds);
      return;
    }

    if (leafletMarkersLayer && leafletMarkersLayer.getLayers().length) {
      map.fitBounds(leafletMarkersLayer.getBounds(), { maxZoom: 12 });
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

  async function loadNearbyRealShopsFromPosition(lat, lon, radiusKm = 50) {
    const geo = await reverseGeocodeMunicipality(lat, lon);
    const countryCode = normalizeCountryCode(geo?.countryCode || countrySelect.value);
    const countryLabel = countryCode ? countryNameByCode(countryCode) : (selectedText(countrySelect) || '');
    const regionLabel = geo?.region || selectedText(regionSelect) || '';
    const municipalityLabel = geo?.municipality || selectedText(muniSelect) || '';

    if (geo?.countryCode && [...countrySelect.options].some((option) => option.value === geo.countryCode)) {
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
    const nearbyElements = await searchOverpassAroundPoint(lat, lon, radiusMeters);
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

    activeFiltered = merged;
    renderList(merged);
    if (resultsHeadingEl) {
      resultsHeadingEl.textContent = `Gårdsbutikker nær deg (${radiusKm} km)`;
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

  function renderList(filtered) {
    listEl.innerHTML = '';
    clearMapMarkers();

    if (mapProvider === 'google-embed') {
      updateEmbeddedMapFromFilters();
    }

    if (!filtered.length) {
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
      return;
    }

    const ordered = sortShops(filtered);
    ordered.forEach((shop) => {
      const div = document.createElement('div');
      div.className = 'item';
      div.dataset.shopKey = shopKeyForResult(shop);
      const products = (shop.products || []).join(', ');
      const location = [shop.address, shop.municipality, shop.region].filter(Boolean).join(', ');
      const phoneLine = shop.phone ? `<div class="item-sub">📞 ${escapeHtml(shop.phone)}</div>` : '';
      const openingLine = shop.openingHours ? `<div class="item-sub">🕒 ${escapeHtml(shop.openingHours)}</div>` : '';
      const productsLine = products ? `<div class="item-sub">🌾 ${escapeHtml(products)}</div>` : '';
      const websiteSearchUrl = buildGooglePlaceSearchUrl(shop);
      const image = shop.imageUrl ? `<img class="item-thumb" src="${shop.imageUrl}" alt="${escapeHtml(shop.name)}" loading="lazy" />` : '';
      const distanceLine = Number.isFinite(shop.distanceKm)
        ? `<div class="item-sub">📍 ${escapeHtml(shop.distanceKm.toFixed(1))} km unna</div>`
        : '';
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
          <a class="item-link" href="${websiteSearchUrl}" target="_blank" rel="noopener">Nettside</a>
        </div>
      `;
      listEl.appendChild(div);

      addMapMarker(shop);
    });

    fitMapToMarkers();
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
      ? regionVariants(countryCode, regionLabel).map((value) => regionKey(value))
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

  async function fetchRegionBoundingBox(countryCode, regionLabel) {
    if (!regionLabel) return null;
    const regionVariantsList = regionVariants(countryCode, regionLabel)
      .map((value) => value.toString().trim())
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
    const countryCode = resolveCountryCode(countrySelect.value);
    const regionValue = regionSelect.value;
    const municipalityValue = muniSelect.value;
    const regionText = regionValue ? selectedText(regionSelect) : '';
    const municipalityText = municipalityValue ? selectedText(muniSelect) : '';
    const countryText = selectedText(countrySelect);
    const query = searchInput.value.trim().toLowerCase();

    const countryRows = countryCode
      ? shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode))
      : shops;
    const hasRegionDataForCountry = countryRows.some((shop) => (shop.region || '').toString().trim());
    const hasMunicipalityDataForCountry = countryRows.some((shop) => (shop.municipality || '').toString().trim());

    const municipalityTerms = municipalityVariants(countryCode, municipalityText)
      .map((name) => municipalityKey(name));
    const regionTerms = regionVariants(countryCode, regionText);
    const queryMunicipalityTerms = municipalityVariants(countryCode, query)
      .map((name) => municipalityKey(name));

    let filtered = [...countryRows];

    if (regionValue || municipalityValue) {
      filtered = filtered.filter((shop) => {
        const regionMatch = !regionValue || (countryCode === 'NO'
          ? regionMatches(shop.region || '', regionTerms)
          : normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionValue || regionText));
        const municipalityMatch = !municipalityValue || (countryCode === 'NO'
          ? municipalityMatches(shop.municipality || '', municipalityTerms)
          : shop.municipality === municipalityValue);
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
      } else if (shops.length) {
        filtered = shops.slice(0, 250);
        setMapStatus('Landtreff manglet; viser midlertidig globale treff (hard fallback).');
      }
    }

    if (sortSelect?.value === 'distance_asc') {
      filtered = addDistanceFromUser(filtered);
    }

    const countryOnlyCount = countryCode
      ? shops.filter((shop) => shopMatchesCountryRelaxed(shop, countryCode)).length
      : shops.length;
    setDebugStats(`Debug: value=${countrySelect.value || '-'}, text=${countryText || '-'}, land=${countryCode || '-'}, lastet=${shops.length}, landtreff=${countryOnlyCount}, vises=${filtered.length}`);

    activeFiltered = filtered;
    renderList(filtered);

    const isCountyOnlySelection = Boolean(regionText && !municipalityText && !query);
    const shouldUseLocalityFallback = Boolean(
      municipalityText ||
      (query && query.length >= 2) ||
      isCountyOnlySelection
    );

    if (!filtered.length && countryCode && shouldUseLocalityFallback) {
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
                if (countryCode === 'NO') return regionMatches(shop.region || '', regionTerms);
                return normalizeAdminLabel(shop.region || '') === normalizeAdminLabel(regionText);
              });

            const countyCombined = mergeShopLists(countyLocal, liveCounty)
              .slice(0, 120);

            if (countyCombined.length) {
              filtered = countyCombined;
              activeFiltered = countyCombined;
              renderList(countyCombined);
              setMapStatus('Viser treff innen valgt fylke/region (fallback).');
            }
          }
        } else {
          const localityHint = [query, municipalityText, regionText, countryText]
            .filter(Boolean)
            .join(', ');
          const geo = await geocodeWithFallback(localityHint);
          if (runId !== filterRunId) return filtered;
          const nearLat = geo?.lat != null ? Number(geo.lat) : null;
          const nearLon = geo?.lon != null ? Number(geo.lon) : null;
          if (Number.isFinite(nearLat) && Number.isFinite(nearLon)) {
            const liveNearbyElements = await searchOverpassAroundPoint(nearLat, nearLon, 120000);
            const liveNearby = liveNearbyElements
              .map((element) => toOverpassShop(element, municipalityText || query, regionText, countryText || countryNameByCode(countryCode)))
              .filter((shop) => keepHighQuality(shop))
              .filter((shop) => shop.lat != null && shop.lon != null)
              .map((shop) => ({
                ...shop,
                distanceKm: haversineKm(nearLat, nearLon, Number(shop.lat), Number(shop.lon)),
              }))
              .filter((shop) => Number.isFinite(shop.distanceKm) && shop.distanceKm <= 120);

            const nearbyLocal = shops
              .filter((shop) => shop.countryCode === countryCode && shop.lat != null && shop.lon != null)
              .map((shop) => ({
                ...shop,
                distanceKm: haversineKm(nearLat, nearLon, Number(shop.lat), Number(shop.lon)),
              }))
              .filter((shop) => Number.isFinite(shop.distanceKm) && shop.distanceKm <= 120)
              .sort((left, right) => left.distanceKm - right.distanceKm);

            const nearbyCombined = mergeShopLists(nearbyLocal, liveNearby)
              .sort((left, right) => {
                const leftDistance = Number.isFinite(left.distanceKm) ? left.distanceKm : Number.POSITIVE_INFINITY;
                const rightDistance = Number.isFinite(right.distanceKm) ? right.distanceKm : Number.POSITIVE_INFINITY;
                return leftDistance - rightDistance;
              })
              .slice(0, 120);

            if (nearbyCombined.length) {
              filtered = nearbyCombined;
              activeFiltered = nearbyCombined;
              renderList(nearbyCombined);
              setMapStatus('Viser nærmeste treff basert på område (fallback når kommune/fylke mangler i datagrunnlaget).');
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
      const merged = addDistanceFromUser(mergeShopLists(filtered, liveCandidates));
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
        const mergedRegionWide = addDistanceFromUser(mergeShopLists(merged, regionWideCandidates));
        activeFiltered = mergedRegionWide;
        renderList(mergedRegionWide);
        return mergedRegionWide;
      }

      return merged;
    } catch (error) {
      console.warn('Could not enrich farmshop list with live web candidates.', error);
      if (countryCode === 'NO' && municipalityText) {
        const trustedFallback = getTrustedSeedCandidates(countryCode, countryText, municipalityText, regionText);
        const mergedFallback = addDistanceFromUser(mergeShopLists(filtered, trustedFallback));
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

    const selectedCountry = selectedText(countrySelect) || 'Norge';
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
    const selectedCountryCode = resolveCountryCode(countrySelect.value);
    await populateRegions(selectedCountryCode);
    await populateMunicipalities(selectedCountryCode, '');
    filterShops();
  });

  regionSelect.addEventListener('change', async () => {
    const selectedCountryCode = resolveCountryCode(countrySelect.value);
    await populateMunicipalities(selectedCountryCode, regionSelect.value);
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
  if (applyFiltersBtn) {
    applyFiltersBtn.addEventListener('click', () => {
      filterShops();
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
      filterShops();
      if ((searchInput?.value || '').trim()) {
        openGoogleMapsSearchFromFilters();
      }
    });
  } else if (myMunicipalityBtn) {
    myMunicipalityBtn.addEventListener('click', () => {
      filterShops();
      if ((searchInput?.value || '').trim()) {
        openGoogleMapsSearchFromFilters();
      }
    });
  }

  if (nearMeBtn && navigator.geolocation) {
    nearMeBtn.addEventListener('click', () => {
      navigator.geolocation.getCurrentPosition(async (position) => {
        try {
          setUserPosition(position.coords.latitude, position.coords.longitude);
          await loadNearbyRealShopsFromPosition(position.coords.latitude, position.coords.longitude, 50);
        } catch (_) {
          try {
            const geo = await reverseGeocodeMunicipality(position.coords.latitude, position.coords.longitude);
            await chooseBestMunicipality(geo);
            openGoogleMapsSearchFromFilters();
          } catch (__) {
            const nearbyUrl = `https://www.google.com/maps/search/${encodeURIComponent(`gårdsbutikk ${position.coords.latitude},${position.coords.longitude}`)}`;
            window.open(nearbyUrl, '_blank', 'noopener');
          }
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

  try {
    shops = (await loadFirstAvailable(dataUrls)).map(normalizeShop);
    if (shops.length === 0) {
      shops = (await loadFirstAvailable(fallbackUrls)).map(normalizeShop);
    }
  } catch (error) {
    console.error('Failed to load farmshops dataset, falling back to example', error);
    try {
      shops = (await loadFirstAvailable(fallbackUrls)).map(normalizeShop);
    } catch (_) {
      shops = [];
    }
  }

  if (!shops.length) {
    shops = buildSeedFallbackDataset();
    setMapStatus('Datakilde utilgjengelig. Viser kvalitetssikrede fallback-treff.');
  }

  const norwayLoadedCount = shops.filter((shop) => shopMatchesCountryRelaxed(shop, 'NO')).length;
  setDebugStats(`Init: lastet=${shops.length}, NO=${norwayLoadedCount}`);

  await mapInitPromise;
  applyMapHeight(currentMapHeight);

  populateCountries();
  await populateRegions('');
  await populateMunicipalities('', '');
  if (resultsHeadingEl) {
    resultsHeadingEl.textContent = 'Gårdsbutikker nær deg';
  }
  activeFiltered = shops;
  activeFiltered = addDistanceFromUser(shops);
  renderList(activeFiltered);

  if (ENABLE_AUTO_COUNTRY_FROM_POSITION) {
    autoSelectCountryFromPosition();
  }
})();
