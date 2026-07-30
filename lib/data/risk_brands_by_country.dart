// Risk brands organized by country and category
// Mainly from Arla Foods (present in all Nordic countries)

final Map<String, Map<String, List<String>>> riskBrandsByCountry = {
  'NO': { // NORGE
    'bovaer_red': ['tine', 'arla', 'aptina', 'lerøy', 'mowi', 'salmar'],
    'bovaer_yellow': ['synnøve', 'fjordland', 'ostecompagniet', 'q-meieriene', 'kavli'],
    'gmo_fish_red': ['lerøy', 'salmar', 'mowi'],
    'organic_keywords': ['økologisk', 'organic', 'biodynamisk', 'debio'],
  },
  'SE': { // SVERIGE
    'bovaer_red': ['arla', 'arla foods', 'växa', 'lurisia'],
    'bovaer_yellow': ['milko', 'norrmejerier', 'gårdsyssan'],
    'gmo_fish_red': ['lerøy', 'mowi', 'salmar'],
    'organic_keywords': ['ekologisk', 'organic', 'biodynamisk', 'krav'],
  },
  'DK': { // DANMARK
    'bovaer_red': ['arla', 'arla foods', 'nørsmølk', 'thise', 'dong'],
    'bovaer_yellow': ['meka', 'landet', 'diplom-is'],
    'gmo_fish_red': ['grønnland', 'nordic seafood'],
    'organic_keywords': ['økologisk', 'organic', 'demeter', 'økocertificeret'],
  },
  'DE': { // DEUTSCHLAND
    'bovaer_red': ['arla', 'lactalis', 'dairing', 'müller'],
    'bovaer_yellow': ['zott', 'söbbeke', 'andechser'],
    'gmo_fish_red': ['dirk fruithandel'],
    'organic_keywords': ['bio', 'organic', 'demeter', 'bioland'],
  },
  'IT': { // ITALIA
    'bovaer_red': ['arla', 'lactalis', 'galbani', 'grana padano'],
    'bovaer_yellow': ['asiago', 'italcaseifici'],
    'gmo_fish_red': ['acqua del danubio'],
    'organic_keywords': ['biologico', 'organic', 'demeter'],
  },
  'ES': { // ESPAÑA
    'bovaer_red': ['arla', 'lactalis', 'campofrío', 'danone'],
    'bovaer_yellow': ['mercadona', 'puleva'],
    'gmo_fish_red': ['pescanova'],
    'organic_keywords': ['ecológico', 'organic', 'demeter'],
  },
  'PT': { // PORTUGAL
    'bovaer_red': ['arla', 'lactalis', 'mimosa', 'pasteis de nata'],
    'bovaer_yellow': ['central leite'],
    'gmo_fish_red': ['pescanova'],
    'organic_keywords': ['biológico', 'organic', 'demeter'],
  },
  'FI': { // FINLAND
    'bovaer_red': ['arla', 'valio'],
    'bovaer_yellow': ['arla pro'],
    'gmo_fish_red': ['mowi', 'lerøy', 'salmar'],
    'organic_keywords': ['luomu', 'organic'],
  },
  'NL': { // NEDERLAND
    'bovaer_red': ['arla', 'campina'],
    'bovaer_yellow': ['jumbo'],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['biologisch', 'organic'],
  },
  'FR': { // FRANCE
    'bovaer_red': ['arla', 'lactalis', 'danone'],
    'bovaer_yellow': ['carrefour bio'],
    'gmo_fish_red': ['mowi'],
    'organic_keywords': ['bio', 'organic'],
  },
  'GB': { // UNITED KINGDOM (for future expansion)
    'bovaer_red': ['arla', 'lactalis', 'dairy crest', 'müller'],
    'bovaer_yellow': ['yeo valley', 'riverford'],
    'gmo_fish_red': ['mowi', 'bakkafrost'],
    'organic_keywords': ['organic', 'biodynamic', 'soil association'],
  },
};

// Get risk brands for a specific country
Map<String, List<String>> getRiskBrandsForCountry(String countryCode) {
  return riskBrandsByCountry[countryCode] ?? riskBrandsByCountry['NO']!; // Default to NO
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
