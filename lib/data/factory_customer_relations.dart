class FactoryCustomerRelation {
  final String factory;
  final String customer;
  final String source;

  const FactoryCustomerRelation({
    required this.factory,
    required this.customer,
    required this.source,
  });
}

// Curated factory -> customer/brand-chain relations with source references.
// Used as a yellow risk signal in Bovaer/GMO/Insect assessments.
const Map<String, List<FactoryCustomerRelation>> factoryCustomerRelationsByCountry = {
  'NO': [
    FactoryCustomerRelation(
      factory: 'tine',
      customer: 'fjordland',
      source: 'https://www.fjordland.no/om-fjordland',
    ),
    FactoryCustomerRelation(
      factory: 'tine',
      customer: 'q-meieriene',
      source: 'https://www.tine.no/om-tine',
    ),
    FactoryCustomerRelation(
      factory: 'tine',
      customer: 'synnove',
      source: 'https://www.tine.no/merkevarer',
    ),
    FactoryCustomerRelation(
      factory: 'tine',
      customer: 'kavli',
      source: 'https://www.tine.no/merkevarer',
    ),
  ],
  'SE': [
    FactoryCustomerRelation(
      factory: 'arla',
      customer: 'ica',
      source: 'https://www.arla.com/company/',
    ),
    FactoryCustomerRelation(
      factory: 'arla',
      customer: 'coop',
      source: 'https://www.arla.com/company/',
    ),
  ],
  'DK': [
    FactoryCustomerRelation(
      factory: 'arla',
      customer: 'foetex',
      source: 'https://www.arla.com/company/',
    ),
    FactoryCustomerRelation(
      factory: 'arla',
      customer: 'netto',
      source: 'https://www.arla.com/company/',
    ),
  ],
  'DE': [
    FactoryCustomerRelation(
      factory: 'arla',
      customer: 'edeka',
      source: 'https://www.arla.com/company/',
    ),
    FactoryCustomerRelation(
      factory: 'mueller',
      customer: 'rewe',
      source: 'https://www.muellergroup.com/',
    ),
  ],
  'NL': [
    FactoryCustomerRelation(
      factory: 'frieslandcampina',
      customer: 'albert heijn',
      source: 'https://www.frieslandcampina.com/',
    ),
  ],
  'FR': [
    FactoryCustomerRelation(
      factory: 'lactalis',
      customer: 'carrefour',
      source: 'https://www.lactalis.fr/',
    ),
    FactoryCustomerRelation(
      factory: 'lactalis',
      customer: 'auchan',
      source: 'https://www.lactalis.fr/',
    ),
  ],
  'GB': [
    FactoryCustomerRelation(
      factory: 'youngs seafood',
      customer: 'tesco',
      source: 'https://www.youngsseafood.co.uk/',
    ),
    FactoryCustomerRelation(
      factory: 'youngs seafood',
      customer: 'sainsbury',
      source: 'https://www.youngsseafood.co.uk/',
    ),
  ],
  'FI': [
    FactoryCustomerRelation(
      factory: 'valio',
      customer: 'kesko',
      source: 'https://www.valio.com/',
    ),
    FactoryCustomerRelation(
      factory: 'valio',
      customer: 's-group',
      source: 'https://www.valio.com/',
    ),
  ],
};

List<FactoryCustomerRelation> getFactoryCustomerRelationsForCountry(
  String countryCode,
) {
  final normalizedCountryCode = countryCode.toUpperCase();
  return factoryCustomerRelationsByCountry[normalizedCountryCode] ??
      factoryCustomerRelationsByCountry['NO'] ??
      const [];
}

List<String> getFactoryCustomerYellowSignals(String countryCode) {
  final relations = getFactoryCustomerRelationsForCountry(countryCode);
  final signals = <String>{};

  for (final relation in relations) {
    final factory = relation.factory.trim().toLowerCase();
    final customer = relation.customer.trim().toLowerCase();
    if (factory.isNotEmpty) signals.add(factory);
    if (customer.isNotEmpty) signals.add(customer);
  }

  return signals.toList();
}

List<String> getFactoryCustomerSources(String countryCode) {
  final relations = getFactoryCustomerRelationsForCountry(countryCode);
  final sources = <String>{};

  for (final relation in relations) {
    final source = relation.source.trim();
    if (source.isNotEmpty) sources.add(source);
  }

  return sources.toList();
}
