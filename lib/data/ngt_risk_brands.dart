/// Curated NGT / "skjult GMO" precaution data.
///
/// LEGAL FRAMING (read before editing):
/// The app NEVER claims that a specific product *contains* gene-edited (NGT)
/// ingredients. It presents a YELLOW, precautionary "MULIG RISIKO" signal
/// ("risk of") that is grounded in two publicly verifiable facts:
///   1. EU regulation now allows certain gene-edited (NGT) ingredients to be
///      placed on the market without GMO labelling.
///   2. The product contains industrial crops that are commonly gene-edited.
///
/// This is general, regulation-based consumer information — not an assertion
/// about any single product. Keep all wording in the "risiko for"/"kan"
/// (possibility) register, never the "inneholder"/"is" (assertion) register.
library;

/// A documented reason for flagging a brand/chain. Each entry MUST have a
/// publicly verifiable basis (a public statement, supplier relationship, or
/// other source you can point to). When in doubt, leave it out.
class NgtRiskEntry {
  final String reasonNb;
  final String reasonEn;
  const NgtRiskEntry({required this.reasonNb, required this.reasonEn});
}

/// Brand/chain → documented reason.
///
/// Keys are lowercase substrings matched against the product brand name.
/// Keep this map conservative. Only add an entry when you have a verifiable
/// public source, and keep the reason text in the precautionary register.
const Map<String, NgtRiskEntry> ngtRiskBrands = {
  // Example (disabled — enable only with a verifiable public source):
  // 'eksempelmerke': NgtRiskEntry(
  //   reasonNb:
  //       'MULIG RISIKO: Produsenten bruker industrielle råvarer som under nytt '
  //       'EU-regelverk kan være genredigert (NGT) uten GMO-merking.',
  //   reasonEn:
  //       'POSSIBLE RISK: The producer uses industrial crops that, under the new '
  //       'EU rules, may be gene-edited (NGT) without GMO labelling.',
  // ),
};

/// Industrially processed crops that are commonly gene-edited / GMO-prone.
/// Presence in a processed food is the basis for a GENERAL regulatory
/// precaution — it is not, and must not be presented as, proof that the
/// product contains NGT ingredients.
const List<String> ngtProneCrops = [
  'soya',
  'soja',
  'soy',
  'soybean',
  'soyaprotein',
  'soyaproteinisolat',
  'soyalecitin',
  'soyalecithin',
  'mais',
  'maize',
  'corn',
  'maisstivelse',
  'maissirup',
  'maisstrk',
  'raps',
  'rapsolje',
  'rapeseed',
  'canola',
  'sukkerbete',
  'sukkerroe',
  'sugar beet',
];

/// Known large-scale producers / retail groups that demonstrably trade in
/// mass-produced, processed industrial goods sourced from global commodity
/// markets (where gene-edited / NGT crops are common).
///
/// STRICT RULE: A YELLOW precaution is ONLY shown when the product brand
/// matches one of these KNOWN actors AND the product contains a GMO/NGT-prone
/// commodity crop. Every other product is treated as GREEN (benefit of the
/// doubt) unless proven otherwise. This guarantees that a traditional farmer,
/// farm shop or small-scale producer is never flagged.
///
/// Keys are lowercase substrings matched against the product brand name.
/// Only add genuinely large, well-known producers / retail groups and their
/// private labels — actors where it is publicly known that they trade such
/// commodity goods.
const List<String> ngtIndustrialBrands = [
  // NorgesGruppen (retail group + private labels):
  'norgesgruppen',
  'first price',
  'eldorado',
  'folkets',
  'jacobs utvalgte',
  'unik',
  'kiwi',
  'meny',
  'spar',
  'joker',
  // Coop (retail group + private labels):
  'coop',
  'x-tra',
  'xtra',
  'coop smak',
  // Rema 1000 (retail group + private labels):
  'rema 1000',
  'rema1000',
  'prima',
  'kvardag',
  'solvinge',
  // Bunnpris:
  'bunnpris',
  // International retailers:
  'walmart',
  'lidl',
  'aldi',
  'tesco',
  'carrefour',
  // Large international food producers:
  'orkla',
  'nestlé',
  'nestle',
  'unilever',
  'mondelez',
  'mars',
  'kelloggs',
  "kellogg's",
  'general mills',
  'cargill',
];

/// Traditional / small-scale producers that must NEVER be flagged, even if the
/// brand otherwise matches. Matched as lowercase substrings against the brand.
/// This protects local farmers, farm shops and artisanal producers.
const List<String> ngtTraditionalExclusions = [
  'gård',
  'gard',
  'gårdsbutikk',
  'gardsbutikk',
  'bonde',
  'småbruk',
  'smabruk',
  'andelslandbruk',
  'bygdø',
  'seter',
  'farm shop',
  'family farm',
  'håndverk',
  'handverk',
  'artisan',
];

