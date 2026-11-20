import 'factory_customer_relations.dart';

/// Owner-confirmed Bovaer status for TINE and TINE products (Jarlsberg, Norvegia,
/// and the other Norwegian sub-brands). Stays yellow: the risk applies only to
/// products made before TINE stopped using milk from Bovaer-fed cows on
/// 22 January 2026. Users should check the production or packing date.
const String tineBovaerYellowReasonNb =
    'TINE sluttet å bruke melk fra kyr fôret med Bovaer 22. januar 2026. Risikoen gjelder bare produkter laget før denne datoen – sjekk produksjons-/pakkedato. Eldre produkter (f.eks. ost) kan fortsatt finnes i butikk.';

const String tineBovaerYellowReasonEn =
    'TINE stopped using milk from cows fed with Bovaer on 22 January 2026. The risk applies only to products made before this date – check the production/packing date. Older products (for example cheese) may still be found in stores.';

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
// CLASSIFICATION (weekly review 2026-11-16):
//   RED    = Source-backed current use. Never red without a public source.
//   YELLOW = Source-backed partial/possible use, or products made before a
//            source-backed stop date.
//            Norwegian model: TINE (yellow) → Synnøve / Fjordland / Q-meieriene / Kavli
//   UNKNOWN = No reliable source. Not listed. "Plausible exposure" without a
//            source was removed 2026-11-16.
//   GREEN note: Certified organic (Demeter, KRAV, EU Organic, Debio, Bio Suisse)
//            products are captured by organic_keywords. Bovaer is incompatible with
//            EU organic certification, so organic labels are a reliable green signal.

final Map<String, Map<String, List<String>>> riskBrandsByCountry = {
  // ─────────────────────────────────────────────────────────────────────────
  'NO': {
    // NORGE — Last verified: 2026-11-16
    // RED:  Lurpak follows sourced Danish Arla (dk_lurpak). Generic Arla stays
    //       red here because milk origin is unknown and the strictest sourced
    //       Arla status is Danish conventional milk.
    // YELLOW: Castello/Puck (dk_castello) and Apetina: Arla brands, milk origin
    //       not documented. TINE sluttet å bruke melk fra kyr fôret med Bovaer 22. januar 2026.
    //   Risikoen gjelder bare produkter laget før denne datoen – sjekk produksjons-/pakkedato.
    //   Eldre produkter (f.eks. ost) kan fortsatt finnes i butikk.
    //   TINE supplies milk/ingredients to Synnøve, Fjordland (TINE subsidiary),
    //   Q-meieriene, Kavli and OsteCompagniet — whole downstream chain flagged.
    'bovaer_red': [
      'arla',
      'lurpak', // dk_lurpak — sourced red
    ],
    'bovaer_yellow': [
      'tine', 'synnøve', 'synnøve finden', 'fjordland',
      'ostecompagniet', 'q-meieriene', 'q meieriene', 'kavli',
      // TINE sub-brands — appear on packaging without "TINE"
      'jarlsberg', 'norvegia', 'biola', 'litago',
      'snøfrisk', 'gudbrandsdalsost', 'ski queen',
      // Arla brands; milk origin not documented (dk_castello / Apetina note).
      'castello', 'puck',
      'apetina', 'aptina',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['økologisk', 'organic', 'biodynamisk', 'debio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SE': {
    // SVERIGE — Last verified: 2026-11-16
    // YELLOW: se_arla is only the 2022 pilot (dsm-firmenich 20.04.2022).
    //       Current Swedish use is not documented. Yoggi, Bregott, Keso,
    //       Finello and Arla Ko follow that yellow rating.
    // RED:  Lurpak stays red (dk_lurpak, Danish milk).
    // REMOVED 2026-11-02: Skånemejerier and Lindahls -> unknown.
    // REMOVED 2026-11-16: Norrmejerier (no public source) -> unknown.
    'bovaer_red': [
      'lurpak', // dk_lurpak — sourced red
    ],
    'bovaer_yellow': [
      'arla', 'bregott', 'arla ko', 'keso', 'finello',
      'yoggi', // Arla SE (arla.se/produkter/yoggi/)
      'castello', 'puck',
      'apetina',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['ekologisk', 'organic', 'biodynamisk', 'krav'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'DK': {
    // DANMARK — Last verified: 2026-11-16
    // RED:  Conventional Danish Arla milk (80-day 3-NOP requirement, continues
    //       in 2027; SGAV 08.10.2026). Lurpak is sourced to Holstebro.
    //       Kærgården, Karolines Køkken and Dofino stay on this list as Danish
    //       Arla brands under that requirement; no separate product source.
    // YELLOW: Castello/Puck (origin per product not documented). Apetina same.
    //       Finello follows se_arla (2022 pilot only), not a DK product source.
    // REMOVED 2026-11-16: Diplom-Is (no product source; was red here and yellow
    //       in risk.json) -> unknown. Naturmælk (no source) -> unknown.
    'bovaer_red': [
      'arla', 'lurpak', 'kærgården',
      'karolines køkken',
      'dofino',
    ],
    'bovaer_yellow': [
      'castello', 'puck',
      'apetina',
      'finello',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['økologisk', 'organic', 'demeter', 'ø-certificeret', 'øko'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'DE': {
    // DEUTSCHLAND — Last verified: 2026-11-16
    // YELLOW: de_arla is the 2022 pilot only. Buko follows that.
    //       Landliebe, Campina and Friesche Vlag follow nl_frieslandcampina
    //       (partial, about 600 farms) — yellow, not red.
    // RED:  Lurpak stays red (dk_lurpak).
    // REMOVED: Müller (2026-10-31), Zott, Ehrmann, Weihenstephan, Hochland,
    //          Lactalis, Président (no public source) -> unknown.
    'bovaer_red': [
      'lurpak',
    ],
    'bovaer_yellow': [
      'arla', 'buko',
      'castello', 'puck',
      'landliebe', 'campina', 'friesche vlag',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'demeter', 'bioland', 'naturland', 'ökologisch'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'NL': {
    // NEDERLAND — Last verified: 2026-11-16
    // YELLOW: FrieslandCampina is partial (about 600 farms, no separate milk
    //       stream). Chocomel, Mona, Milner, Valess, Vifit, Optimel, Fristi,
    //       Campina and Friesche Vlag follow nl_frieslandcampina. Not red.
    // REMOVED 2026-10-31: DOC Kaas, A-ware -> unknown.
    // REMOVED 2026-11-16: CONO, Melkunie (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'frieslandcampina', 'campina', 'friesche vlag',
      'chocomel', 'mona', 'milner', 'valess',
      'vifit', 'optimel', 'fristi',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['biologisch', 'organic', 'demeter', 'eko'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BE': {
    // BELGIË / BELGIQUE — Last verified: 2026-11-16
    // YELLOW: Campina and Friesche Vlag follow nl_frieslandcampina (partial).
    //       Bel, Babybel, Boursin and Kiri follow fr_bel (Bel 26.10.2023).
    // REMOVED 2026-11-16: Milcobel, Passendale, Wynendale, Père Joseph, Inex,
    //       Président (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'campina', 'friesche vlag',
      'bel', 'babybel', 'boursin', 'kiri',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['biologisch', 'biologique', 'organic', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'FR': {
    // FRANCE — Last verified: 2026-11-16
    // YELLOW: Bel, Babybel, Boursin and Kiri (fr_bel, Bel 26.10.2023).
    //       Savencia stays yellow via the processor-status entry, not this list.
    // REMOVED 2026-11-16: Lactalis, Président, Bridel, Lactel, Sodiaal, Candia,
    //       Yoplait, Danone, Elle & Vire, Isigny Sainte-Mère, Entremont,
    //       Riches Monts (no public source for current use) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'bel', 'babybel', 'boursin', 'kiri',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'demeter', 'agriculture biologique', 'ab'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GB': {
    // UNITED KINGDOM — Last verified: 2026-11-16
    // YELLOW: gb_arla trial ended (FarmingUK 09.11.2025). Cravendale and
    //       Tickler follow that rule: products made before 09.11.2025.
    //       Castello/Puck follow dk_castello (origin not documented).
    // RED:  Lurpak stays red (dk_lurpak).
    // REMOVED 2026-10-31: Müller, Anchor -> unknown.
    // REMOVED 2026-11-16: Saputo, Cathedral City, Davidstow, Clover,
    //       Kerrygold, Pilgrims Choice, Country Life, Lakeland (no source
    //       for use; Ornua/Kerrygold is unknown in the status file).
    'bovaer_red': [
      'lurpak',
    ],
    'bovaer_yellow': [
      'arla', 'cravendale', 'tickler',
      'castello', 'puck',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['organic', 'biodynamic', 'soil association', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IE': {
    // IRELAND — Last verified: 2026-11-16
    // Ornua/Kerrygold is unknown in the status file (no documented use).
    // REMOVED 2026-11-16: Ornua, Kerrygold, Pilgrims Choice, Glanbia, Tirlán,
    //       Avonmore, Kerry, Lakeland, Dairygold, Carbery, Dubliner, Kerrymaid,
    //       Connacht Gold (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['organic', 'biodynamic', 'demeter', 'iofga'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IT': {
    // ITALIA — Last verified: 2026-11-16
    // YELLOW: Parmalat trial at Università Cattolica CERZOO (dsm-firmenich
    //       04.09.2023). Bel brands follow fr_bel.
    // REMOVED 2026-11-16: Granarolo, Lactalis, Galbani, Fattorie Osella, Nestlé
    //       (no source beyond the Parmalat trial) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'parmalat',
      'bel', 'babybel', 'boursin', 'kiri',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['biologico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'ES': {
    // ESPAÑA — Last verified: 2026-11-16
    // REMOVED 2026-11-16: Danone, Puleva, Lactalis, Président, Central Lechera
    //       Asturiana, Larsa, El Castillo, Pascual, Kaiku, Nestlé
    //       (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['ecológico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PT': {
    // PORTUGAL — Last verified: 2026-11-16
    // REMOVED 2026-11-16: Lactogal, Mimosa, Agros, Vigor, Matinal, Gresso,
    //       Lactalis, Nestlé (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['biológico', 'organic', 'demeter', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'FI': {
    // FINLAND — Last verified: 2026-11-16
    // YELLOW: Valio stopped its pilot 09.02.2026 (valio.fi). Oltermanni and
    //       Gefilus stay as Valio brands named in that earlier sourced update.
    // REMOVED 2026-11-16: Juustoportti (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'valio', 'oltermanni', 'gefilus',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['luomu', 'organic', 'demeter'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CH': {
    // SCHWEIZ / SUISSE / SVIZZERA — Last verified: 2026-11-16
    // YELLOW: Landliebe and Campina follow nl_frieslandcampina (partial).
    // REMOVED 2026-11-16: Emmi, Kaltbach, Cremo, Elsa, Hochdorf
    //       (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'landliebe', 'campina',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'demeter', 'knospe', 'bio suisse'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AT': {
    // ÖSTERREICH — Last verified: 2026-11-16
    // YELLOW: Landliebe follows nl_frieslandcampina (partial).
    // REMOVED 2026-11-16: Berglandmilch, Schärdinger, NÖM, Tirol Milch,
    //       Salzburg Milch, Stainzer, Lattella (no public source) -> unknown.
    'bovaer_red': [
      'arla',
    ],
    'bovaer_yellow': [
      'landliebe',
    ],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'demeter', 'aus österreich bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'IS': {
    // ÍSLAND — Last verified: March 2026
    // MS (Mjólkursamsalan) = Iceland's only large-scale dairy co-op.
    // No confirmed Bovaer use in Iceland as of March 2026.
    // Royal Greenland and Icelandic fishing companies sell GMO-feed salmon.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['lífrænn', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GL': {
    // GRØNLAND — Last verified: March 2026
    // Dairy market is minimal — primarily imports from Denmark/Arla.
    // Royal Greenland = major seafood exporter, uses GMO fish feed.
    'bovaer_red': ['arla', 'lurpak'],
    'bovaer_yellow': ['castello', 'puck'],
    'gmo_fish_red': [],
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
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekologiczny', 'ekologiczne', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CZ': {
    // ČESKÁ REPUBLIKA — Last verified: March 2026
    // Madeta = Czech's largest dairy (Jihočeská Madeta, South Bohemia).
    // Olma = second largest, acquired by Lactalis → yellow via parent.
    // Lacina = regional co-op.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekologický', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SK': {
    // SLOVENSKO — Last verified: March 2026
    // Rajo = Slovakia's largest dairy, acquired by Müller then Lactalis → yellow.
    // Tatra = well-known Slovak dairy brand.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekologický', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'HU': {
    // MAGYARORSZÁG — Last verified: 2026-11-16
    // FrieslandCampina, Campina, Sole-Mizo, Danone and Nestlé: no source for
    // use in Hungary -> unknown (not listed).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ökológiai', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'RO': {
    // ROMÂNIA — Last verified: 2026-11-16
    // FrieslandCampina, Napolact, Zuzu, Dorna and Lactalis: no source for use
    // in Romania -> unknown (not listed).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ecologic', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BG': {
    // БЪЛГАРИЯ — Last verified: March 2026
    // Danone BG = major producer (Activia, Actimel, Serdika brands).
    // Lactalis BG operations via imported products.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
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
      // Valio moved to sourced status (stopped 09.02.2026, yellow).
    ],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['mahe', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'LV': {
    // LATVIJA — Last verified: March 2026
    // Rīgas piens = major Latvian dairy.
    // Latvijas piens = second cooperative.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekologisks', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'LT': {
    // LIETUVA — Last verified: March 2026
    // Rokiškio sūris = Lithuania's largest cheese producer — market sourcing.
    // Žemaitijos pienas = second largest dairy co-op.
    // Valio distributes in LT.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['ekologiškas', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'HR': {
    // HRVATSKA — Last verified: March 2026
    // Vindija = Croatia's largest dairy (owns Sirela, Zdenka cheese, Vindija yogurt).
    // Dukat = Lactalis Croatia acquisition → yellow via parent.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'SI': {
    // SLOVENIJA — Last verified: March 2026
    // Ljubljanske mlekarne = Slovenia's largest dairy co-op.
    // Mlekarna Celeia = major regional dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'RS': {
    // SRBIJA — Last verified: March 2026
    // Imlek = Serbia's largest dairy (Danube Foods Group).
    // Mlekara Šabac = second major.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organsko', 'organic', 'ekološki'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BA': {
    // BOSNA I HERCEGOVINA — Last verified: March 2026
    // Mlijekoprodukt = major BiH dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'ekološki', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'ME': {
    // CRNA GORA — Last verified: March 2026
    // Small domestic dairy market; mostly imported products.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'ekološki'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'MK': {
    // СЕВЕРНА МАКЕДОНИЈА — Last verified: March 2026
    // Bimilk = major Macedonian dairy (Bitola dairy region).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organic', 'органски'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AL': {
    // SHQIPËRI — Last verified: March 2026
    // Small dairy market with local producers.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['bio', 'organik', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'GR': {
    // ΕΛΛΆΔΑ — Last verified: March 2026
    // FAGE = Greece's largest/most international dairy (yogurt, cheese). Market milk.
    // Delta = Vivartia group dairy brand (major Greek conglomerate).
    // Olympos = major Greek dairy (part of Friesland — FC connection → yellow).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['βιολογικό', 'bio', 'organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CY': {
    // ΚΥΠΡΟΣ — Last verified: March 2026
    // Charalambides Christis = Cyprus's dominant dairy (Halloumi, yogurt, butter).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
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
    'bovaer_red': ['arla', 'lurpak'],
    'bovaer_yellow': ['castello', 'puck', 'apetina'],
    'gmo_fish_red': [],
    'organic_keywords': ['organic', 'usda organic', 'certified organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CA': {
    // CANADA — Last verified: March 2026
    // Agropur = Canada's largest dairy co-op (iGO, Natrel, OKA brands).
    // Saputo = world's third largest dairy, headquartered in Montreal.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['organic', 'certifié biologique', 'bio', 'canada organic'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AU': {
    // AUSTRALIA — Last verified: March 2026
    // Lion Dairy & Drinks = major (owns Dairy Farmers, Pura, Masters, Yoplait AU).
    // Bega Cheese = publicly listed AU dairy.
    // Fonterra AU operations (anchor, mainland sold in AU).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
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
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['organic', 'certified organic', 'bio-gro', 'biogro'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BR': {
    // BRASIL — Last verified: March 2026
    // Lactalis, Elegê and Batavo removed 2026-11-16: no source beyond the
    // Italian Parmalat trial -> unknown.
    // Itambé = major Brazilian dairy co-op (CCPR).
    // Piracanjuba = major co-op (Centro-oeste Brazil).
    // Nestlé Brazil dairy (Molico brand) and Danone Brazil.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgânico', 'organic', 'bio', 'produto orgânico'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'AR': {
    // ARGENTINA — Last verified: March 2026
    // La Serenísima = Argentina's leading dairy brand (Mastellone Hermanos).
    // SanCor = major Argentine dairy co-op.
    // Danone Argentina and Nestlé Argentina have market milk exposure.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CL': {
    // CHILE — Last verified: March 2026
    // Colún = Chile's largest dairy co-op (La Unión, Los Ríos).
    // Soprole = major, acquired by Lactalis/Froneri → yellow via parent.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'CO': {
    // COLOMBIA — Last verified: March 2026
    // Alpina = Colombia's largest dairy and food company.
    // Colanta = major Colombian dairy co-op.
    // Nestlé and Danone have Colombian market milk exposure.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PE': {
    // PERÚ — Last verified: March 2026
    // Gloria = Peru's dominant dairy (Gloria SA, also owns PIL Andina in Bolivia).
    // Laive = major Peruvian dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'UY': {
    // URUGUAY — Last verified: March 2026
    // CONAPROLE = Uruguay's national dairy co-op (~95% of milk production).
    //   One of the most dominant single co-ops in the world.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'PY': {
    // PARAGUAY — Last verified: March 2026
    // Small dairy market; local brands and imports from Argentina/Brazil.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'VE': {
    // VENEZUELA — Last verified: March 2026
    // Lactalis Venezuela (Parmalat VE) → yellow via parent company.
    // Indulac = state-owned dairy.
    'bovaer_red': ['arla'],
    'bovaer_yellow': ['parmalat'],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'EC': {
    // ECUADOR — Last verified: March 2026
    // Gloria Group (Peru) has operations in Ecuador via Rey Leche/Floralp.
    // Nestlé and Danone distributed in Ecuador.
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },

  // ─────────────────────────────────────────────────────────────────────────
  'BO': {
    // BOLIVIA — Last verified: March 2026
    // PIL Andina = Bolivia's largest dairy (controlled by Gloria SA, Peru).
    'bovaer_red': ['arla'],
    'bovaer_yellow': [],
    'gmo_fish_red': [],
    'organic_keywords': ['orgánico', 'organic', 'bio'],
  },
};

// Country-specific yellow/watch lists for newer risk dimensions.
// These are merged into each country response to keep legacy country blocks compact.
const Map<String, List<String>> gmoSupplyChainYellowByCountry = {
  // 2026-11-16: Mowi, Lerøy, SalMar, Nordic Seafood, Royal Greenland, Iglo,
  // followfish, Labeyrie, Bakkafrost, Young's, Pescanova and Icelandic Salmon
  // moved to unknown (no source in the repo). ICA, Coop, Edeka, Rewe and
  // Findus likewise. Other names below were outside that list and are unchanged.
  'NO': [
    'fiskemannen',
  ],
  'SE': [],
  'DK': ['frozen at sea'],
  'DE': ['deutsche see'],
  'NL': ['ah', 'albert heijn', 'plus', 'jumbo'],
  'BE': ['delhaize', 'colruyt', 'carrefour'],
  'FR': ['picard', 'carrefour', 'auchan'],
  'GB': ['tesco', 'sainsbury', 'waitrose', 'asda'],
  'IE': ['tesco ireland', 'supervalu', 'dunnes'],
  'ES': ['carrefour', 'mercadona'],
  'IT': ['esselunga', 'coop italia', 'conad'],
  'PL': ['lisner', 'biedronka', 'carrefour', 'auchan'],
  'FI': ['kalaneuvos', 'kesko', 's-group'],
};

const Map<String, List<String>> insectSupplyChainYellowByCountry = {
  'NO': ['protix', 'ynsect', 'nextprotein', 'agronutris', 'entocube'],
  'SE': ['protix', 'ynsect', 'nextprotein', 'agronutris'],
  'DK': ['protix', 'enorm biofactory', 'ynsect', 'nextprotein'],
  'DE': ['nextprotein', 'ynsect', 'protix', 'bugfoundation'],
  'NL': ['protix', 'kreca', 'ynsect', 'nextprotein'],
  'BE': ['nextprotein', 'protix', 'ynsect', 'nusect'],
  'FR': ['ynsect', 'nextprotein', 'agronutris', 'micronutris'],
  'GB': ['yora', 'small giants', 'nextprotein', 'protix'],
  'IE': ['nextprotein', 'protix', 'ynsect'],
  'ES': ['proteinsecta', 'nextprotein', 'protix'],
  'IT': ['italbugs', 'nextprotein', 'protix'],
  'PL': ['hi-pro-mine', 'nextprotein', 'protix'],
  'FI': ['entocube', 'nextprotein', 'protix'],
};

const Map<String, List<String>> insectEuWatchByCountry = {
  'NO': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'SE': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'DK': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'DE': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'NL': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'BE': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'FR': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'GB': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'IE': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'ES': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'IT': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'PL': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
  'FI': [
    'acheta domesticus',
    'tenebrio molitor',
    'alphitobius diaperinus',
    'locusta migratoria',
    'hermetia illucens',
  ],
};

// Get risk brands for a specific country
Map<String, List<String>> getRiskBrandsForCountry(String countryCode) {
  final normalizedCountryCode = countryCode.toUpperCase();
  final base = riskBrandsByCountry[normalizedCountryCode] ??
      riskBrandsByCountry['NO']!; // Default to NO
  final merged = Map<String, List<String>>.from(base);

  merged['gmo_supply_chain_yellow'] =
      gmoSupplyChainYellowByCountry[normalizedCountryCode] ??
          gmoSupplyChainYellowByCountry['NO'] ??
          const [];

  merged['insect_supply_chain_yellow'] =
      insectSupplyChainYellowByCountry[normalizedCountryCode] ??
          insectSupplyChainYellowByCountry['NO'] ??
          const [];

  merged['insect_eu_watch'] =
      insectEuWatchByCountry[normalizedCountryCode] ??
          insectEuWatchByCountry['NO'] ??
          const [];

  merged['factory_customer_yellow'] =
      getFactoryCustomerYellowSignals(normalizedCountryCode);

  return merged;
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
