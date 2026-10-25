const String kSupplierStatusUrl = 'https://matsjekk.com/index.html#news';
const String kEditorialMethodUrl = 'https://matsjekk.com/editorial-method.html';
const String kNgtSuppliersUrl = 'https://matsjekk.com/data/ngt_suppliers.json';
const String kSupplierRulesUrl =
    'https://matsjekk.com/supplier_rules_v2.json?v=20261019a';
const String kPublicAppUrl = 'https://matsjekk.com/app.html';
const String kPublicPrivacyPolicyBaseUrl = 'https://matsjekk.com/privacy.html';
const String kEuGmoDecisionUrl =
	'https://food.ec.europa.eu/plants/genetically-modified-organisms/new-techniques-biotechnology_en';
const String kEuNovelFoodInsectsUrl =
	'https://food.ec.europa.eu/safety/novel-food/authorisations/summary-applications-and-notifications_en';

// Farm shops (gårdsbutikker) – same data as docs/gardsbutikker.html.
// Bump kFarmShopsDataVersion (YYYYMMDD) to bust caches after data updates.
const String kFarmShopsDataVersion = '20261025';
const String kFarmShopsByCountryBaseUrl =
    'https://matsjekk.com/data/farmshops_by_country';
const String kOrganicFarmShopsUrl =
    'https://matsjekk.com/data/organic_farmshops.json?v=$kFarmShopsDataVersion';
const String kFarmShopsWebUrl = 'https://matsjekk.com/gardsbutikker.html';
const String kOsmCopyrightUrl = 'https://www.openstreetmap.org/copyright';

String farmShopsCountryUrl(String countryCode) =>
    '$kFarmShopsByCountryBaseUrl/${countryCode.toLowerCase()}.json?v=$kFarmShopsDataVersion';
