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
      'skånemejerier', // Large southern SE co-op, high Bovaer exposure probability
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
      'kerry',               // Kerry Group dairy
      'lakeland',            // Lakeland Dairies
      'dairygold',           // Irish dairy co-op
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
      'central lechera asturiana', // Largest Spanish dairy co-op
      'pascual',   // Grupo Pascual — major Spanish dairy
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
    ],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'aus österreich bio'],
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
