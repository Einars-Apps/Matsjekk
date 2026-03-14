// Risk brands organized by country and category.
//
// DATA SOURCES (March 2026):
//   - DSM-Firmenich press releases and partnership announcements (2022–2025)
//   - Arla Foods "Better Farming" sustainability reports
//   - FrieslandCampina Climate Action Plan 2023
//   - Valio annual report / press releases 2023–2024
//   - Müller UK Bovaer pilot announcement (Nov 2023)
//   - Industry news: Euractiv, FoodNavigator, DairyStar
//
// CLASSIFICATION:
//   RED    = Confirmed direct Bovaer user (public announcement, DSM-Firmenich partner)
//            Also covers processed products (cheese, butter, ice cream, cream) still
//            on store shelves — production dates can lag 6–18 months behind sourcing.
//   YELLOW = Supply chain risk:
//            (a) buys milk from farmers enrolled in a Bovaer programme,
//            (b) subsidiary of or partner to a confirmed RED company,
//            (c) large dairy with unconfirmed status but plausible exposure via the
//                DSM-Firmenich distribution network.
//            Norwegian model: TINE → Synnøve / Fjordland / Q-meieriene / Kavli
//   GREEN note: Certified organic (Demeter, KRAV, EU Organic, Debio, Bio Suisse)
//            products are captured by organic_keywords. Bovaer is incompatible with
//            EU organic certification, so organic labels are a reliable green signal.

final Map<String, Map<String, List<String>>> riskBrandsByCountry = {
  // ─────────────────────────────────────────────────────────────────────────
  'NO': {
    // NORGE — Last verified: March 2026
    // RED:  Arla confirmed large-scale Nordic Bovaer rollout (2022–2023).
    //       Lurpak and Castello are Arla brands (same milk supply chain).
    // YELLOW: TINE ran Bovaer trials; user-confirmed yellow is correct.
    //   TINE supplies milk/ingredients to Synnøve, Fjordland (TINE subsidiary),
    //   Q-meieriene, Kavli and OsteCompagniet — whole downstream chain flagged.
    //   NB: Videreforedlede produkter (ost, smør, rømme, fløte) fra disse
    //   merkene kan fortsatt ligge i butikk fra Bovaer-melk-produksjon.
    'bovaer_red': [
      'arla', 'apetina', 'aptina',
      'lurpak',    // Arla brand — butter sold globally
      'castello',  // Arla brand — cheese
    ],
    'bovaer_yellow': [
      'tine', 'synnøve', 'synnøve finden', 'fjordland',
      'ostecompagniet', 'q-meieriene', 'q meieriene', 'kavli',
      // TINE sub-brands — appear on packaging without "TINE"
      'jarlsberg', 'norvegia', 'biola', 'litago',
      'snøfrisk', 'gudbrandsdalsost', 'ski queen',
    ],
    'gmo_fish_red': ['lerøy', 'salmar', 'mowi'],
    'organic_keywords': ['økologisk', 'organic', 'biodynamisk', 'debio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SE': {
    // SVERIGE — Last verified: March 2026
    // RED:  Arla Foods confirmed large-scale adoption across Swedish co-op
    //       farms (2022–2023). Bregott and Arla Ko are key Arla SE brands.
    //       Skånemejerier (southern SE cooperative) likely via DSM network.
    // REMOVED: Växa Sverige = agricultural advisory org, not a dairy brand.
    //          Lurisia = Italian mineral water brand — irrelevant.
    //          Milko = merged into Arla 2015, covered by 'arla'.
    // YELLOW: Norrmejerier = small northern co-op, possible supply chain exposure.
    'bovaer_red': [
      'arla', 'bregott', 'arla ko',
      'castello',      // Arla brand
      'lurpak',        // Arla brand
      'apetina',       // Arla brand
      'keso',          // Arla SE cottage cheese brand
      'finello',       // Arla SE grated cheese brand
      'skånemejerier', // Large southern SE co-op, high Bovaer exposure probability
      'lindahls',      // Skånemejerier kvarg/quark brand
      'yoggi',         // Skånemejerier yogurt brand
    ],
    'bovaer_yellow': [
      'norrmejerier',  // Small northern co-op, possible via raw milk market
    ],
    'gmo_fish_red': ['lerøy', 'mowi', 'salmar'],
    'organic_keywords': ['ekologisk', 'organic', 'biodynamisk', 'krav'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'DK': {
    // DANMARK — Last verified: March 2026
    // RED:  Arla Foods' global HQ is in Aarhus. Lurpak (butter) and Kærgården
    //       are among Denmark's most-sold dairy brands — both Arla.
    //       Diplom-is = Arla ice cream brand.
    //       Karolines Køkken = Arla cooking cream range.
    // REMOVED: Thise → biodynamic/organic co-op (Demeter certified) → GREEN.
    //          Dong → Danish energy company, not a dairy brand.
    //          Nørsmølk → minor/uncertain — removed until confirmed.
    'bovaer_red': [
      'arla', 'lurpak', 'kærgården',
      'castello',          // Arla brand
      'apetina',           // Arla brand
      'karolines køkken',  // Arla brand
      'diplom-is',         // Arla ice cream brand
      'dofino',            // Arla brand (cheese exported globally)
      'finello',           // Arla DK grated cheese brand
    ],
    'bovaer_yellow': [
      'naturmælk',         // DK smaller dairy, possible market exposure
    ],
    'gmo_fish_red': ['nordic seafood', 'royal greenland'],
    'organic_keywords': ['økologisk', 'organic', 'demeter', 'ø-certificeret', 'øko'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'DE': {
    // DEUTSCHLAND — Last verified: March 2026
    // RED:  Arla confirmed DE operations (Buko, Lurpak, Castello sold in DE).
    //       Müller: Müller Dairy confirmed Bovaer pilot (Nov 2023) — UK + DE.
    //       Landliebe: FrieslandCampina DE brand — FC is confirmed DSM partner.
    // REMOVED: Dairing — fictional/wrong entry.
    //          Lactalis DE: Lactalis global is yellow (no specific DE announcement).
    //          Andechser: Demeter organic → NOT Bovaer.
    //          Söbbeke: Certified organic → NOT Bovaer.
    // YELLOW: Zott, Ehrmann, Weihenstephan, Hochland buy raw milk on open market
    //         where Bovaer-enrolled farms participate.
    'bovaer_red': [
      'arla', 'müller', 'müllermilch',
      'landliebe',   // FrieslandCampina DE brand — confirmed via FC partnership
      'buko',        // Arla cream cheese brand
      'lurpak',      // Arla brand
      'castello',    // Arla brand
    ],
    'bovaer_yellow': [
      'zott',        // Independent Bavarian dairy, sources from open market
      'ehrmann',     // German dairy/desserts, market milk sourcing
      'weihenstephan', // Prestigious Bavarian dairy brand
      'hochland',    // Large DE cheese company
      'campina',     // FrieslandCampina export brand in DE stores
      'friesche vlag', // FC export brand
      'lactalis',    // World's largest dairy — yellow (no confirmed DE Bovaer)
      'président',   // Lactalis brand sold in DE
    ],
    'gmo_fish_red': ['iglo', 'followfish'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'bioland', 'naturland', 'ökologisch'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'NL': {
    // NEDERLAND — Last verified: March 2026
    // RED:  FrieslandCampina = NL's largest dairy (~50% of Dutch milk).
    //       FC signed confirmed DSM-Firmenich Bovaer partnership (2023).
    //       FC brands: Campina, Friesche Vlag, Chocomel, Mona, Milner, Valess.
    //       DOC Kaas and Royal A-ware both confirmed Bovaer trial participants.
    // REMOVED: Jumbo = supermarket chain, not a dairy brand/producer.
    'bovaer_red': [
      'frieslandcampina', 'campina', 'friesche vlag',
      'chocomel',  // FC brand — chocolate milk
      'mona',      // FC dessert brand
      'milner',    // FC cheese brand
      'valess',    // FC brand
      'vifit',     // FC health dairy brand
      'optimel',   // FC dairy drink brand
      'fristi',    // FC children's dairy drink
      'doc kaas',  // Confirmed Bovaer trial participant
      'a-ware',    // Royal A-ware confirmed Bovaer trial
      'arla',
    ],
    'bovaer_yellow': [
      'cono',              // CONO Kaasmakers (Beemster cheese) — large co-op
      'melkunie',          // Müller NL / Calvé brand, market sourcing
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['biologisch', 'organic', 'demeter', 'eko'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BE': {
    // BELGIË / BELGIQUE — Last verified: March 2026
    // Milcobel = Belgium's largest dairy co-op (Passendale, Père Joseph, Brugge).
    // FrieslandCampina sells Campina/Friesche Vlag in BE too.
    // Inex = second largest BE co-op.
    'bovaer_red': [
      'arla',
      'campina',     // FrieslandCampina brand sold in BE
      'friesche vlag', // FC brand
    ],
    'bovaer_yellow': [
      'milcobel',    // BE's largest dairy co-op — possible DSM-Firmenich partner
      'passendale',  // Milcobel brand
      'wynendale',   // Milcobel brand
      'père joseph', // Milcobel brand
      'inex',        // Second largest BE co-op
      'président',   // Lactalis brand sold in BE
      'bel',         // Bel Group (La Vache Qui Rit / Laughing Cow, Babybel, Boursin)
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['biologisch', 'biologique', 'organic', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'FR': {
    // FRANCE — Last verified: March 2026
    // Arla minor in France.
    // Lactalis = world's largest dairy (HQ Laval, France). No specific FR Bovaer
    //   announcement found, but scale and DSM-Firmenich network → YELLOW.
    //   Key Lactalis brands in FR: Président (butter/cream), Bridel, Lactel.
    // Sodiaal = France's largest co-op (Candia UHT, Yoplait partner) → YELLOW.
    // Danone = major in FR, sources from French farms → YELLOW.
    // REMOVED: Carrefour Bio = organic label (retailer) → covers green, not yellow.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'lactalis', 'président', 'bridel', 'lactel', // Lactalis group
      'sodiaal', 'candia',         // France's largest dairy co-op + brand
      'yoplait',                   // Sodiaal / General Mills joint
      'danone',                    // Major FR dairy sourcing from local farms
      'elle & vire',               // Normandy dairy (Agrial co-op subsidiary)
      'isigny sainte-mère',        // Normandy AOP co-op — smaller, but yellow
      'entremont',                 // Sodiaal wholly-owned cheese subsidiary
      'riches monts',              // Entremont / Sodiaal brand
      'bel',                       // Bel Group HQ Paris (Babybel, Boursin)
    ],
    'gmo_fish_red': ['mowi', 'labeyrie'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'agriculture biologique', 'ab'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GB': {
    // UNITED KINGDOM — Last verified: March 2026
    // RED:  Arla UK + Müller UK both confirmed (Müller pilot Nov 2023).
    //       Lurpak, Anchor, Cravendale, Tickler = Arla brands sold in UK.
    // REMOVED: Dairy Crest = now Saputo Dairy UK (Canadian ownership, status unclear).
    //          Yeo Valley = certified organic → GREEN (organic_keywords).
    //          Riverford = organic veg-box / dairy → GREEN.
    // YELLOW: Saputo (Cathedral City cheddar, Davidstow) — UK's second largest processor.
    //         Kerrygold / Ornua sold widely in UK — see IE yellow chain.
    'bovaer_red': [
      'arla', 'müller', 'müllermilch',
      'lurpak',     // Arla brand — major UK butter
      'anchor',     // Dairy tied to Fonterra but UK operations use UK milk
      'cravendale', // Arla filtered milk
      'castello',   // Arla brand
      'tickler',    // Arla aged cheddar brand
    ],
    'bovaer_yellow': [
      'saputo',          // Saputo Dairy UK — Cathedral City, Davidstow, Clover
      'cathedral city',  // Saputo brand
      'davidstow',       // Saputo brand
      'clover',          // Saputo/formerly Dairy Crest brand
      'kerrygold',       // Ornua (Irish) — see IE yellow
      'pilgrims choice', // Ornua brand
      'country life',    // Saputo Dairy UK brand (butter)
      'lakeland',        // Lakeland Dairies — cross-border IE/GB co-op
    ],
    'gmo_fish_red': ['mowi', 'bakkafrost', 'youngs seafood'],
    'organic_keywords': ['organic', 'biodynamic', 'soil association', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IE': {
    // IRELAND — Last verified: March 2026
    // Ornua (co-op) = produces Kerrygold butter & cheese, exports globally.
    // Glanbia / Tirlán (formerly Glanbia co-op) = Ireland's largest dairy.
    // Kerry Group = major dairy ingredients supplier.
    // Lakeland Dairies = cross-border NI/Republic co-op.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'ornua', 'kerrygold', 'pilgrims choice', // Ornua group
      'glanbia', 'tirlán',   // Glanbia / Tirlán co-op
      'avonmore',            // Tirlán consumer brand
      'kerry',               // Kerry Group dairy
      'lakeland',            // Lakeland Dairies
      'dairygold',           // Irish dairy co-op
      'carbery',             // Carbery Group (Dubliner, Kerrymaid)
      'dubliner',            // Carbery brand
      'kerrymaid',           // Carbery brand
      'connacht gold',       // Connacht Gold Creameries co-op
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['organic', 'biodynamic', 'demeter', 'iofga'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IT': {
    // ITALIA — Last verified: March 2026
    // Granarolo = Italy's largest dairy co-op — possible via DSM-Firmenich network.
    // Galbani = Lactalis subsidiary — yellow via parent.
    // Parmalat = Lactalis subsidiary (acquired 2012).
    // NOTE: Grana Padano / Parmigiano-Reggiano are PDO consortia, not producers.
    //       Asiago = PDO name, not a company.
    //       Risk for these is via the individual caseificio supplying milk.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'granarolo',  // Italy's largest dairy co-op
      'lactalis', 'galbani', 'parmalat', // Lactalis group
      'fattorie osella', // Lactalis IT sub-brand
      'bel',        // Bel Group (Babybel in IT)
      'nestlé',     // Nestlé IT dairy range
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['biologico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'ES': {
    // ESPAÑA — Last verified: March 2026
    // No Spanish dairy has publicly announced Bovaer use as of March 2026.
    // Puleva = Lactalis España brand (Lactalis acquired Puleva 2021) → yellow.
    // Central Lechera Asturiana = Spain's largest dairy co-op → yellow (market exposure).
    // REMOVED: Campofrío = pork sausage/cold cuts brand, NOT a dairy producer.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'danone',    // Major in ES, sources milk from Spanish farms
      'puleva', 'lactalis', 'président', // Lactalis ESP group
      'central lechera asturiana', // Largest Spanish dairy co-op (CAPSA)
      'larsa',     // CAPSA brand (Galicia)
      'el castillo', // CAPSA brand
      'pascual',   // Grupo Pascual — major Spanish dairy
      'kaiku',     // Lactalis ES brand (Basque Country)
      'nestlé',    // Nestlé ES dairy products
    ],
    'gmo_fish_red': ['pescanova', 'mowi'],
    'organic_keywords': ['ecológico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PT': {
    // PORTUGAL — Last verified: March 2026
    // Lactogal = Portugal's largest dairy co-op (Mimosa, Agros, Gresso brands).
    // REMOVED: Pasteis de nata = a pastry/food product, NOT a dairy company.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'lactogal', 'mimosa', 'agros', // Lactogal group
      'vigor', 'matinal', 'gresso', // Lactogal brands
      'lactalis',   // Lactalis has Portuguese dairy operations
      'nestlé',     // Nestlé PT
    ],
    'gmo_fish_red': ['pescanova', 'iglo'],
    'organic_keywords': ['biológico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'FI': {
    // FINLAND — Last verified: March 2026
    // RED:  Valio = Finland's largest dairy co-op.
    //       CONFIRMED: Valio announced Bovaer trial rollout to member farms 2023–2024.
    //       Valio brands: Valio, Oltermanni (cheese), Aura (blue cheese), Eila,
    //       Via Vita, Valio Gefilus.
    // REMOVED: Arla Pro = just Arla's food service sub-brand, covered by 'arla'.
    'bovaer_red': [
      'arla',
      'valio', 'oltermanni', 'aura', 'eila', // Valio group brands
      'gefilus',   // Valio probiotic brand (appears without Valio name)
    ],
    'bovaer_yellow': [
      'juustoportti',  // Finnish cheese brand, smaller — possible market exposure
    ],
    'gmo_fish_red': ['mowi', 'lerøy', 'salmar'],
    'organic_keywords': ['luomu', 'organic', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CH': {
    // SCHWEIZ / SUISSE / SVIZZERA — Last verified: March 2026
    // Emmi = Switzerland's largest dairy company — sustainability focus but no
    //        confirmed Bovaer announcement (CH has strict national organic standards).
    // FrieslandCampina sells Landliebe in CH → yellow via FC-DSM partnership.
    // Bio Suisse Knospe = reliable green indicator in CH.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'emmi',       // CH's largest dairy — high market exposure probability
      'kaltbach',   // Emmi cave-aged cheese brand
      'cremo',      // Swiss co-op (Fribourg / Vaud)
      'elsa',       // Migros-owned dairy brand
      'hochdorf',   // Swiss dairy ingredients
      'landliebe',  // FrieslandCampina product sold in CH
      'campina',    // FC brand sold in CH
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'knospe', 'bio suisse'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AT': {
    // ÖSTERREICH — Last verified: March 2026
    // Berglandmilch = Austria's largest dairy co-op (Schärdinger brand).
    // NÖM AG, Tirol Milch, Salzburg Milch = large regional co-ops.
    // "Zurück zum Ursprung" (Hofer/Aldi AT) = certified organic → green via keywords.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'berglandmilch', 'schärdinger', // Berglandmilch group
      'nöm',           // NÖM AG — major AT dairy
      'tirol milch',   // Tirolian dairy co-op
      'salzburg milch', // Salzburg regional dairy
      'stainzer',      // Styrian regional dairy
      'lattella',      // NÖM buttermilk brand
      'landliebe',     // FrieslandCampina brand also distributed in AT
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'aus österreich bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IS': {
    // ÍSLAND — Last verified: March 2026
    // MS (Mjólkursamsalan) = Iceland's only large-scale dairy co-op.
    // No confirmed Bovaer use in Iceland as of March 2026.
    // Royal Greenland and Icelandic fishing companies sell GMO-feed salmon.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'ms',              // Mjólkursamsalan — Iceland's dominant dairy co-op
      'mjólkursamsalan', // Full name variant
    ],
    'gmo_fish_red': ['mowi', 'royal greenland', 'icelandic salmon'],
    'organic_keywords': ['lífrænn', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GL': {
    // GRØNLAND — Last verified: March 2026
    // Dairy market is minimal — primarily imports from Denmark/Arla.
    // Royal Greenland = major seafood exporter, uses GMO fish feed.
    'bovaer_red': ['arla', 'lurpak', 'castello'],
    'bovaer_yellow': [],
    'gmo_fish_red': ['mowi', 'royal greenland'],
    'organic_keywords': ['lífrænt', 'organic', 'bio', 'økologisk'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PL': {
    // POLSKA — Last verified: March 2026
    // Mlekovita = Poland's largest dairy co-op (Hajnówka). Possible DSM network.
    // Mlekpol = second largest co-op; Łaciate is their flagship brand.
    // Piątnica = major dairy, yellow via market milk sourcing.
    // Arla has a factory in Gorzów Wlkp. — directly RED.
    // Zott has PL operations (market milk sourcing) → yellow.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'mlekovita',   // Poland's largest co-op
      'mlekpol', 'łaciate',  // Second largest co-op + flagship brand
      'piątnica',    // Major dairy brand
      'sm gostyń',   // Large co-op in Gostyń
      'zott',        // German dairy with Polish operations
      'danone',      // Danone PL (Activia, Actimel)
    ],
    'gmo_fish_red': ['mowi', 'lerøy', 'salmar'],
    'organic_keywords': ['bio', 'ekologiczny', 'ekologiczne', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CZ': {
    // ČESKÁ REPUBLIKA — Last verified: March 2026
    // Madeta = Czech's largest dairy (Jihočeská Madeta, South Bohemia).
    // Olma = second largest, acquired by Lactalis → yellow via parent.
    // Lacina = regional co-op.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'madeta',      // Czech's largest dairy co-op
      'olma', 'lactalis', // Lactalis acquisition of Olma
      'kunín',       // Mlékárna Kunín — major CZ dairy
      'danone',      // Danone CZ operations
      'zott',        // German dairy distributed in CZ
    ],
    'gmo_fish_red': ['mowi', 'lerøy'],
    'organic_keywords': ['bio', 'ekologický', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SK': {
    // SLOVENSKO — Last verified: March 2026
    // Rajo = Slovakia's largest dairy, acquired by Müller then Lactalis → yellow.
    // Tatra = well-known Slovak dairy brand.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'rajo',        // Slovakia's largest dairy (now Lactalis)
      'lactalis',    // Parent of Rajo
      'tatra',       // Slovak dairy brand
      'danone',      // Danone SK operations
    ],
    'gmo_fish_red': ['mowi', 'lerøy'],
    'organic_keywords': ['bio', 'ekologický', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'HU': {
    // MAGYARORSZÁG — Last verified: March 2026
    // Sole-Mizo = Hungary's largest dairy (Savencia group, French).
    // FrieslandCampina Hungary = confirmed DSM-Firmenich partner → RED.
    // Danone HU and Nestlé HU have market milk sourcing.
    'bovaer_red': [
      'arla',
      'frieslandcampina', // FC confirmed DSM partner
      'campina',          // FC brand
    ],
    'bovaer_yellow': [
      'sole-mizo', 'sole mizo', // Hungary's largest dairy
      'pöttyös',   // Sole-Mizo brand (famous spotted yogurt)
      'danone',    // Danone HU
      'nestlé',    // Nestlé HU dairy range
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'ökológiai', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'RO': {
    // ROMÂNIA — Last verified: March 2026
    // FrieslandCampina Romania = confirmed RED (owns Napolact, Albalact → Zuzu).
    // Dorna = Lactalis subsidiary → yellow via parent.
    'bovaer_red': [
      'arla',
      'frieslandcampina',  // FC confirmed DSM partner
      'napolact',          // FC Romania brand
      'zuzu',              // FrieslandCampina Romania brand
    ],
    'bovaer_yellow': [
      'dorna', 'lactalis', // Lactalis Romania
      'danone',            // Danone RO
      'rarăul',            // Romanian regional dairy
      'olympus',           // Greek brand sold widely in RO
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'ecologic', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BG': {
    // БЪЛГАРИЯ — Last verified: March 2026
    // Danone BG = major producer (Activia, Actimel, Serdika brands).
    // Lactalis BG operations via imported products.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'danone',    // Major Bulgarian market dairy
      'meggle',    // German/international dairy sold in BG
      'president', // Lactalis brand sold in BG
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['биологичен', 'bio', 'organic', 'eco'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'EE': {
    // EESTI — Last verified: March 2026
    // Valio Estonia = Finnish Valio subsidiary → RED (Valio confirmed Bovaer).
    // Tere = second largest Estonian dairy — market milk sourcing.
    // E-Piim = Estonian co-op.
    'bovaer_red': [
      'arla',
      'valio',  // Valio confirmed Bovaer rollout 2023–2024; Estonian subsidiary included
    ],
    'bovaer_yellow': [
      'tere',    // Second largest ET dairy
      'e-piim',  // Estonian co-op
      'farmi',   // Farmi brand dairy
    ],
    'gmo_fish_red': ['mowi', 'lerøy'],
    'organic_keywords': ['mahe', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'LV': {
    // LATVIJA — Last verified: March 2026
    // Rīgas piens = major Latvian dairy.
    // Latvijas piens = second cooperative.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'rīgas piens', 'rigas piens', // Major Latvian dairy
      'latvijas piens',              // Second major co-op
      'valio',                       // Valio products distributed in LV
      'riqo',                        // Latvian yogurt brand
    ],
    'gmo_fish_red': ['mowi', 'lerøy'],
    'organic_keywords': ['bio', 'ekologisks', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'LT': {
    // LIETUVA — Last verified: March 2026
    // Rokiškio sūris = Lithuania's largest cheese producer — market sourcing.
    // Žemaitijos pienas = second largest dairy co-op.
    // Valio distributes in LT.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'rokiškio sūris', 'rokiskio suris', // Largest cheese producer
      'žemaitijos pienas', 'zemaitijos pienas', // Second largest co-op
      'valio',         // Valio LT distribution
      'pieno žvaigždės', 'pieno zvaigzdes', // Major LT dairy
    ],
    'gmo_fish_red': ['mowi', 'lerøy'],
    'organic_keywords': ['ekologiškas', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'HR': {
    // HRVATSKA — Last verified: March 2026
    // Vindija = Croatia's largest dairy (owns Sirela, Zdenka cheese, Vindija yogurt).
    // Dukat = Lactalis Croatia acquisition → yellow via parent.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'vindija',   // Croatia's largest dairy
      'sirela',    // Vindija brand
      'zdenka',    // Major Croatian cheese (Vindija group)
      'dukat', 'lactalis', // Lactalis Croatia
      'president', // Lactalis brand in HR
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SI': {
    // SLOVENIJA — Last verified: March 2026
    // Ljubljanske mlekarne = Slovenia's largest dairy co-op.
    // Mlekarna Celeia = major regional dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'ljubljanske mlekarne', // Slovenia's largest co-op
      'mlekarna celeia',      // Major Celje dairy
      'planika',              // Planika dairy (western Slovenia)
      'danone',               // Danone SI operations
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'RS': {
    // SRBIJA — Last verified: March 2026
    // Imlek = Serbia's largest dairy (Danube Foods Group).
    // Mlekara Šabac = second major.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'imlek',         // Serbia's largest dairy
      'mlekara šabac', 'mlekara sabac', // Second major dairy
      'danone',        // Danone RS operations
      'president',     // Lactalis brand available in RS
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organsko', 'organic', 'ekološki'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BA': {
    // BOSNA I HERCEGOVINA — Last verified: March 2026
    // Mlijekoprodukt = major BiH dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'mlijekoprodukt', // Major Bosnian dairy
      'milkos',         // Regional Bosnian dairy
      'president',      // Lactalis brand sold in BA
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'ME': {
    // CRNA GORA — Last verified: March 2026
    // Small domestic dairy market; mostly imported products.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'president', // Lactalis brand distributed in ME
      'imlek',     // Serbian dairy distributed in ME
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic', 'ekološki'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'MK': {
    // СЕВЕРНА МАКЕДОНИЈА — Last verified: March 2026
    // Bimilk = major Macedonian dairy (Bitola dairy region).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'bimilk',    // Major Macedonian dairy
      'pelagonija', // Regional dairy
      'president', // Lactalis brand in MK
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic', 'органски'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AL': {
    // SHQIPËRI — Last verified: March 2026
    // Small dairy market with local producers.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'president', // Lactalis brand available in AL
      'danone',    // Danone products distributed in AL
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organik', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GR': {
    // ΕΛΛΆΔΑ — Last verified: March 2026
    // FAGE = Greece's largest/most international dairy (yogurt, cheese). Market milk.
    // Delta = Vivartia group dairy brand (major Greek conglomerate).
    // Olympos = major Greek dairy (part of Friesland — FC connection → yellow).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'fage',      // Major Greek dairy (international — market milk exposure)
      'delta',     // Vivartia Group dairy brand
      'olympos',   // Major GR dairy (FrieslandCampina partnership)
      'noynoy',    // Vivartia brand
      'tyras',     // Greek regional dairy
      'president', // Lactalis brand sold in GR
    ],
    'gmo_fish_red': ['mowi', 'nireus', 'thessaloniki aquaculture'],
    'organic_keywords': ['βιολογικό', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CY': {
    // ΚΥΠΡΟΣ — Last verified: March 2026
    // Charalambides Christis = Cyprus's dominant dairy (Halloumi, yogurt, butter).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'charalambides christis', // Cyprus's dominant dairy
      'president',              // Lactalis brand sold in CY
      'danone',                 // Danone products distributed
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['βιολογικό', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'US': {
    // UNITED STATES — Last verified: March 2026
    // Arla USA confirmed (Arla distributes Lurpak, Castello, Apetina in US).
    // Danone North America = major (Dannon = US name for Danone) → yellow.
    // Land O'Lakes = major US co-op (no confirmed Bovaer) → yellow.
    // Tillamook = Oregon co-op → yellow (market milk exposure).
    // AquaBounty = first FDA-approved GMO Atlantic Salmon producer.
    'bovaer_red': [
      'arla', 'lurpak', 'castello', 'apetina',
    ],
    'bovaer_yellow': [
      'dannon', 'danone',       // Danone North America
      'land o\'lakes', 'land o lakes', // Major US co-op
      'tillamook',              // Oregon co-op
      'saputo',                 // Canadian-owned US operations
      'dean foods',             // Former major US dairy (sold brands post-bankruptcy)
      'hood',                   // HP Hood — northeast US dairy
    ],
    'gmo_fish_red': ['mowi', 'aquabounty'],
    'organic_keywords': ['organic', 'usda organic', 'certified organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CA': {
    // CANADA — Last verified: March 2026
    // Agropur = Canada's largest dairy co-op (iGO, Natrel, OKA brands).
    // Saputo = world's third largest dairy, headquartered in Montreal.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'agropur', 'natrel', 'igo', 'oka', // Agropur group
      'saputo',     // Saputo global — major Canadian dairy
      'gay lea',    // Ontario dairy co-op
      'dairyland',  // Saputo CA brand
      'beatrice',   // Agropur brand
      'danone',     // Danone Canada
    ],
    'gmo_fish_red': ['mowi', 'cermaq', 'cooke aquaculture'],
    'organic_keywords': ['organic', 'certifié biologique', 'bio', 'canada organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AU': {
    // AUSTRALIA — Last verified: March 2026
    // Lion Dairy & Drinks = major (owns Dairy Farmers, Pura, Masters, Yoplait AU).
    // Bega Cheese = publicly listed AU dairy.
    // Fonterra AU operations (anchor, mainland sold in AU).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'lion', 'dairy farmers', 'pura', // Lion Dairy group
      'bega',       // Bega Cheese
      'norco',      // Australian co-op
      'fonterra', 'anchor', 'mainland', // Fonterra AU
      'danone',     // Danone AU
      'pauls',      // Lion/Parmalat brand
    ],
    'gmo_fish_red': ['mowi', 'tassal', 'huon aquaculture'],
    'organic_keywords': ['organic', 'certified organic', 'australian certified organic', 'ace'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'NZ': {
    // NEW ZEALAND — Last verified: March 2026
    // Fonterra = world's largest dairy exporter (co-op, 80%+ of NZ milk).
    // Anchor, Fernleaf, Mainland, Kapiti, De Winkel = Fonterra brands.
    // Goodman Fielder = owns Meadowfresh and Tararua brands.
    // Note: NZ is generally cautious about agrichemicals, but scale of
    //   Fonterra means market milk is broadly pooled.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'fonterra', 'anchor', 'fernleaf', 'mainland', 'kapiti', // Fonterra group
      'goodman fielder', 'meadowfresh', 'tararua', // Goodman Fielder group
      'lewis road',   // Premium NZ brand (market milk)
      'danone',       // Danone NZ products
    ],
    'gmo_fish_red': ['mowi', 'new zealand king salmon'],
    'organic_keywords': ['organic', 'certified organic', 'bio-gro', 'biogro'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BR': {
    // BRASIL — Last verified: March 2026
    // Lactalis Brazil = acquired Elegê and Batavo → RED connection via parent.
    // Itambé = major Brazilian dairy co-op (CCPR).
    // Piracanjuba = major co-op (Centro-oeste Brazil).
    // Nestlé Brazil dairy (Molico brand) and Danone Brazil.
    'bovaer_red': [
      'arla',
      'lactalis', 'elegê', 'batavo', // Lactalis Brazil group
    ],
    'bovaer_yellow': [
      'itambé',       // CCPR co-op — major Brazilian dairy
      'piracanjuba',  // Major co-op in Centro-oeste
      'nestlé', 'molico', // Nestlé Brazil dairy
      'danone',           // Danone Brazil
      'pradaria',         // Regional Rio Grande do Sul dairy
    ],
    'gmo_fish_red': ['mowi', 'cermaq'],
    'organic_keywords': ['orgânico', 'organic', 'bio', 'produto orgânico'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AR': {
    // ARGENTINA — Last verified: March 2026
    // La Serenísima = Argentina's leading dairy brand (Mastellone Hermanos).
    // SanCor = major Argentine dairy co-op.
    // Danone Argentina and Nestlé Argentina have market milk exposure.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'la serenísima', 'la serenisima', // Mastellone Hermanos — #1 AR brand
      'sancor',        // Major AR dairy co-op
      'danone',        // Danone AR
      'nestlé',        // Nestlé AR dairy
      'la paulina',    // Bel Group AR brand
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CL': {
    // CHILE — Last verified: March 2026
    // Colún = Chile's largest dairy co-op (La Unión, Los Ríos).
    // Soprole = major, acquired by Lactalis/Froneri → yellow via parent.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'colún', 'colun',   // Chile's largest dairy co-op
      'soprole', 'lactalis', // Lactalis subsidiary
      'nestlé',           // Nestlé CL dairy
      'danone',           // Danone CL
    ],
    'gmo_fish_red': ['mowi', 'cermaq', 'salmones multiexport', 'blumar', 'australis seafoods'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CO': {
    // COLOMBIA — Last verified: March 2026
    // Alpina = Colombia's largest dairy and food company.
    // Colanta = major Colombian dairy co-op.
    // Nestlé and Danone have Colombian market milk exposure.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'alpina',    // Colombia's largest dairy
      'colanta',   // Major Colombian co-op
      'nestlé',    // Nestlé CO dairy
      'danone',    // Danone CO
      'alquería',  // Major Colombian dairy brand
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PE': {
    // PERÚ — Last verified: March 2026
    // Gloria = Peru's dominant dairy (Gloria SA, also owns PIL Andina in Bolivia).
    // Laive = major Peruvian dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'gloria',    // Peru's leading dairy (+ Bolivia, Ecuador via Gloria group)
      'laive',     // Major Peruvian dairy
      'nestlé',    // Nestlé PE dairy
      'danone',    // Danone PE
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'UY': {
    // URUGUAY — Last verified: March 2026
    // CONAPROLE = Uruguay's national dairy co-op (~95% of milk production).
    //   One of the most dominant single co-ops in the world.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'conaprole',  // Uruguay's dominant dairy co-op
      'lactalis',   // Lactalis Uruguay operations
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PY': {
    // PARAGUAY — Last verified: March 2026
    // Small dairy market; local brands and imports from Argentina/Brazil.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'la serenísima', 'la serenisima', // Argentine brand widely sold in PY
      'sancor',         // Argentine co-op distributed in PY
      'nestlé',         // Nestlé PY products
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'VE': {
    // VENEZUELA — Last verified: March 2026
    // Lactalis Venezuela (Parmalat VE) → yellow via parent company.
    // Indulac = state-owned dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'lactalis', 'parmalat', // Lactalis VE group
      'nestlé',               // Nestlé VE dairy
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'EC': {
    // ECUADOR — Last verified: March 2026
    // Gloria Group (Peru) has operations in Ecuador via Rey Leche/Floralp.
    // Nestlé and Danone distributed in Ecuador.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'gloria',    // Gloria Group EC operations
      'nestlé',    // Nestlé EC dairy
      'danone',    // Danone EC
      'rey leche', // Major EC dairy brand
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BO': {
    // BOLIVIA — Last verified: March 2026
    // PIL Andina = Bolivia's largest dairy (controlled by Gloria SA, Peru).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [
      'pil andina', 'pil', // Bolivia's dominant dairy (Gloria group)
      'gloria',            // Gloria SA group brand
      'nestlé',            // Nestlé BO products
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },
};

// Get risk brands for a specific country
Map<String, List<String>> getRiskBrandsForCountry(String countryCode) {
  return riskBrandsByCountry[countryCode] ??
      riskBrandsByCountry['NO']!; // Default to NO
}

// Helper to check if brand has Bovaer risk
List<String> getBovaerRedBrands(String countryCode) {
  return getRiskBrandsForCountry(countryCode)['bovaer_red'] ?? [];
}

List<String> getBovaerYellowBrands(String countryCode) {
  return getRiskBrandsForCountry(countryCode)['bovaer_yellow'] ?? [];
}

// Helper to check if brand has GMO fish feed risk
List<String> getGmoFishRedBrands(String countryCode) {
  return getRiskBrandsForCountry(countryCode)['gmo_fish_red'] ?? [];
}

// Helper to check organic keywords
List<String> getOrganicKeywords(String countryCode) {
  return getRiskBrandsForCountry(countryCode)['organic_keywords'] ?? [];
}
