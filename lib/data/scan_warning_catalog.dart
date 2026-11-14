import '../models/scan_warning.dart';
import 'bovaer_processor_status.dart';
import 'warning_research.dart';
import '../services/remote_ngt_suppliers_service.dart';

/// Matches `updated_at` in docs/data/bovaer_processor_status.json.
/// Shown as "sist kontrollert" for those source notes. The weekly risk
/// routine owns the colours; this date is only the check stamp.
const String kBovaerCatalogCheckedOn = '2026-11-02';

class ScanWarningResolution {
  final List<ScanWarning> popupWarnings;
  final Set<WarningTopic> unsourcedTopics;

  const ScanWarningResolution({
    required this.popupWarnings,
    required this.unsourcedTopics,
  });
}

String publisherFromUrl(String url) {
  final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
  const known = <String, String>{
    'www.tine.no': 'TINE',
    'medlem.tine.no': 'TINE',
    'www.q-meieriene.no': 'Q-Meieriene',
    'www.bondebladet.no': 'Bondebladet',
    'borsen.dagbladet.no': 'Dagbladet Børsen',
    'www.synnove.no': 'Synnøve Finden',
    'kommunikasjon.ntb.no': 'NTB',
    'publications.europa.eu': 'Publications Office of the European Union',
    'eur-lex.europa.eu': 'EUR-Lex',
    'pmc.ncbi.nlm.nih.gov': 'PubMed Central',
    'food.ec.europa.eu': 'European Commission',
    'www.efsa.europa.eu': 'EFSA',
    'europepmc.org': 'Europe PMC',
    'pubmed.ncbi.nlm.nih.gov': 'PubMed',
  };
  final named = known[host];
  if (named != null) return named;
  if (host.startsWith('www.')) return host.substring(4);
  return host.isEmpty ? 'Ukjent utgiver' : host;
}

String formatWarningDate(String raw) {
  final p = raw.split('-');
  if (p.length == 3 && p[0].length == 4 && int.tryParse(p[0]) != null) {
    return '${p[2]}.${p[1]}.${p[0]}';
  }
  return raw;
}

List<WarningCitation> researchCitationsFor(WarningTopic topic) {
  return warningResearchEntries
      .where((e) => e.topic == topic)
      .map((e) => e.citation)
      .toList();
}

ScanWarning? scanWarningFromBovaer(
  BovaerProcessorStatus entry, {
  String? shopCountry,
}) {
  if (entry.appColor != 'red' &&
      entry.appColor != 'yellow' &&
      entry.appColor != 'green') {
    return null;
  }
  final sources = entry.sources
      .map(
        (s) => WarningCitation(
          url: s.url,
          date: s.date,
          publisher: publisherFromUrl(s.url),
          quoteOrNote: s.note,
          lastChecked: kBovaerCatalogCheckedOn,
        ),
      )
      .toList();
  final first = sources.isEmpty
      ? const WarningCitation(
          url: '',
          date: '',
          publisher: '',
          quoteOrNote: '',
          lastChecked: '',
        )
      : sources.first;
  final level = switch (entry.appColor) {
    'red' => WarningLevel.red,
    'green' => WarningLevel.green,
    _ => WarningLevel.yellow,
  };
  return ScanWarning(
    id: entry.id,
    topic: WarningTopic.bovaer,
    whatNb: _bovaerWhatNb(entry, first),
    whatEn: _bovaerWhatEn(entry, first),
    who: entry.company,
    howNb: _bovaerHowNb(entry, shopCountry),
    howEn: _bovaerHowEn(entry, shopCountry),
    level: level,
    documentedUse: entry.status == 'bruker',
    sources: sources,
    research: researchCitationsFor(WarningTopic.bovaer),
  );
}

ScanWarning? scanWarningFromNgtSupplier(NgtSupplierEntry entry) {
  final url = entry.sourceUrl.trim();
  if (!url.startsWith('https://')) return null;
  final note = entry.reasonNb.trim().isNotEmpty
      ? entry.reasonNb.trim()
      : entry.reasonEn.trim();
  final citation = WarningCitation(
    url: url,
    date: 'udatert',
    publisher: publisherFromUrl(url),
    quoteOrNote: note,
    lastChecked: 'ikke oppgitt',
  );
  final who = entry.brandAliases.where((a) => a.trim().isNotEmpty).join(', ');
  final whoNb = who.isEmpty ? 'Merke i leverandørlisten' : who;
  return ScanWarning(
    id: 'ngt-${whoNb.toLowerCase()}',
    topic: WarningTopic.ngt,
    whatNb:
        'Kilden oppgir en leverandørkobling for $whoNb. ${_attrNb(citation)} '
        'Det er ikke dokumentasjon for genredigert innhold i ett bestemt produkt. '
        'Informasjonen kan være ufullstendig.',
    whatEn:
        'The source records a supplier link for $whoNb. ${_attrEn(citation)} '
        'It does not document gene-edited content in one specific product. '
        'The information may be incomplete.',
    who: whoNb,
    howNb:
        'Sjekk ingrediensliste og merking på pakken. Kilden dokumenterer en leverandørkobling, ikke innholdet i denne pakken. Informasjonen kan være ufullstendig.',
    howEn:
        'Check the ingredient list and the label. The source documents a supplier link, not the contents of this pack. The information may be incomplete.',
    level: WarningLevel.yellow,
    documentedUse: false,
    sources: [citation],
    research: researchCitationsFor(WarningTopic.ngt),
  );
}

/// EU novel-food acts for species named in the product text.
/// [species] empty means every insect act in the research file.
ScanWarning? insectTopicWarning(Set<String> species) {
  final acts = warningResearchEntries.where((e) {
    if (e.topic != WarningTopic.insekter || e.kind != 'act') return false;
    if (species.isEmpty) return true;
    return e.species != null && species.contains(e.species);
  }).toList();
  if (acts.isEmpty) return null;
  final opinions = warningResearchEntries.where((e) {
    if (e.topic != WarningTopic.insekter) return false;
    if (e.kind == 'framework') return true;
    if (e.kind != 'opinion') return false;
    if (species.isEmpty) return true;
    return e.species != null && species.contains(e.species);
  }).map((e) => e.citation);
  final named = species.isEmpty
      ? 'Produktteksten nevner insekt eller insektsmel uten at én art er pekt ut her.'
      : 'Produktteksten peker mot: ${species.join(', ')}.';
  final namedEn = species.isEmpty
      ? 'The product text mentions insect or insect meal without naming one species here.'
      : 'The product text points to: ${species.join(', ')}.';
  final actLinesNb = acts.map(_actLineNb).join(' ');
  final actLinesEn = acts.map(_actLineEn).join(' ');
  return ScanWarning(
    id: species.isEmpty ? 'topic-insekter' : 'topic-insekter-${species.join('-')}',
    topic: WarningTopic.insekter,
    whatNb:
        '$named $actLinesNb Vedtakene gjelder art og form. De dokumenterer ikke dette merket. Informasjonen kan være ufullstendig.',
    whatEn:
        '$namedEn $actLinesEn The acts cover a species and a form. They do not document this brand. The information may be incomplete.',
    who: kUnsourcedWhoNb,
    whoEn: kUnsourcedWhoEn,
    howNb:
        'Sjekk ingredienslisten på pakken. En EU-tillatelse gjelder en art og en form, ikke ett merke. Informasjonen kan være ufullstendig.',
    howEn:
        'Check the ingredient list on the pack. An EU authorisation covers a species and a form, not one brand. The information may be incomplete.',
    level: WarningLevel.yellow,
    documentedUse: false,
    brandSpecific: false,
    sources: acts.map((e) => e.citation).toList(),
    research: opinions.toList(),
  );
}

ScanWarning gmoTopicWarning() {
  final sources = warningResearchEntries
      .where((e) =>
          e.topic == WarningTopic.gmo &&
          (e.kind == 'act' || e.kind == 'register'))
      .map((e) => e.citation)
      .toList();
  return ScanWarning(
    id: 'topic-gmo',
    topic: WarningTopic.gmo,
    whatNb:
        'EUR-Lex har forordning (EF) nr. 1829/2003 av 22. september 2003 om genmodifisert mat og fôr. European Commission har et søk i registeret over slik mat og fôr, inkludert produkter som er trukket fra markedet. Ingen av kildene sier at dette merket bruker et bestemt GMO. Informasjonen kan være ufullstendig.',
    whatEn:
        'EUR-Lex has Regulation (EC) No 1829/2003 of 22 September 2003 on genetically modified food and feed. The European Commission page searches the register of such food and feed, including products withdrawn from the market. Neither source says that this brand uses a specific GMO. The information may be incomplete.',
    who: kUnsourcedWhoNb,
    whoEn: kUnsourcedWhoEn,
    howNb:
        'Sjekk merkingen på pakken. Kildene er generelle EU-regler, ikke dokumentasjon for dette merket. Informasjonen kan være ufullstendig.',
    howEn:
        'Check the label on the pack. The sources are general EU rules, not documentation for this brand. The information may be incomplete.',
    level: WarningLevel.yellow,
    documentedUse: false,
    brandSpecific: false,
    sources: sources,
    research: researchCitationsFor(WarningTopic.ngt),
  );
}

ScanWarningResolution resolveScanWarnings({
  required String brand,
  required String productText,
  String? shopCountry,
  String? bovaerLevel,
  String? gmoLevel,
  String? insectLevel,
  String? ngtLevel,
  List<NgtSupplierEntry> ngtSuppliers = const [],
}) {
  final popup = <ScanWarning>[];
  final unsourced = <WarningTopic>{};
  final text = productText.toLowerCase();

  if (_stamped(bovaerLevel)) {
    final entry = resolveBovaerProcessorStatus(
      '$brand $productText',
      country: shopCountry,
    );
    final warning = entry == null
        ? null
        : scanWarningFromBovaer(entry, shopCountry: shopCountry);
    if (warning != null && warning.showInPopup) {
      popup.add(warning);
    } else if (_warned(bovaerLevel)) {
      unsourced.add(WarningTopic.bovaer);
    }
  }

  if (_warned(gmoLevel)) {
    if (_explicitGmo(text)) {
      final warning = gmoTopicWarning();
      if (warning.showInPopup) {
        popup.add(warning);
      } else {
        unsourced.add(WarningTopic.gmo);
      }
    } else {
      unsourced.add(WarningTopic.gmo);
    }
  }

  if (_warned(insectLevel)) {
    final species = insectSpeciesIn(text);
    if (species.isNotEmpty || _genericInsect(text)) {
      final warning = insectTopicWarning(species);
      if (warning != null && warning.showInPopup) {
        popup.add(warning);
      } else {
        unsourced.add(WarningTopic.insekter);
      }
    } else {
      unsourced.add(WarningTopic.insekter);
    }
  }

  if (_warned(ngtLevel)) {
    final lowerBrand = brand.toLowerCase();
    NgtSupplierEntry? hit;
    for (final entry in ngtSuppliers) {
      if (entry.brandAliases.any((a) => a.isNotEmpty && lowerBrand.contains(a))) {
        hit = entry;
        break;
      }
    }
    final warning = hit == null ? null : scanWarningFromNgtSupplier(hit);
    if (warning != null && warning.showInPopup) {
      popup.add(warning);
    } else {
      unsourced.add(WarningTopic.ngt);
    }
  }

  return ScanWarningResolution(
    popupWarnings: popup,
    unsourcedTopics: unsourced,
  );
}

Set<String> insectSpeciesIn(String lowerText) {
  final found = <String>{};
  if (lowerText.contains('tenebrio') ||
      lowerText.contains('melorm') ||
      lowerText.contains('melbille')) {
    found.add('tenebrio');
  }
  if (lowerText.contains('mealworm') && !lowerText.contains('lesser mealworm')) {
    found.add('tenebrio');
  }
  if (lowerText.contains('locusta') || lowerText.contains('gresshoppe')) {
    found.add('locusta');
  }
  if (lowerText.contains('acheta') ||
      lowerText.contains('cricket flour') ||
      lowerText.contains('husiriss')) {
    found.add('acheta');
  }
  if (lowerText.contains('alphitobius') ||
      lowerText.contains('lesser mealworm') ||
      lowerText.contains('buffaloworm') ||
      lowerText.contains('buffaloorm')) {
    found.add('alphitobius');
  }
  return found;
}

bool _genericInsect(String text) {
  const keys = [
    'insektsmel',
    'insektsprotein',
    'insektprotein',
    'insect meal',
    'insect protein',
    'insect flour',
    'insekt',
  ];
  return keys.any(text.contains);
}

bool _explicitGmo(String text) {
  const keys = [
    'genmodifisert',
    'genetisk modifisert',
    'genetically modified',
    'genetically engineered',
    'contains gmo',
    'contains genetically modified',
  ];
  return keys.any(text.contains);
}

bool _warned(String? level) => level == 'red' || level == 'yellow';

bool _stamped(String? level) =>
    level == 'red' || level == 'yellow' || level == 'green';

String _attrNb(WarningCitation source) {
  return '${source.publisher}, datert ${source.date}, er notert slik: «${source.quoteOrNote}»';
}

String _attrEn(WarningCitation source) {
  return '${source.publisher}, dated ${source.date}, is noted as: «${source.quoteOrNote}»';
}

String _bovaerWhatNb(BovaerProcessorStatus entry, WarningCitation first) {
  final lead = switch (entry.status) {
    'bruker' =>
      'Kildene beskriver bruk av Bovaer (3-nitrooksypropanol, 3-NOP) knyttet til ${entry.company}. De sier ikke at hvert enkelt produkt er berørt.',
    'har_brukt' =>
      'Kildene beskriver tidligere bruk av Bovaer (3-NOP) knyttet til ${entry.company}. De sier ikke at bruken pågår nå.',
    'stoppet' =>
      'Kildene beskriver at ${entry.company} har stanset bruk av melk fra kyr fôret med Bovaer (3-NOP).',
    'forsok' =>
      'Kildene beskriver forsøk med Bovaer (3-NOP) knyttet til ${entry.company}. Omfanget for vanlige produkter er ikke fullstendig dokumentert.',
    'ukjent' =>
      'Vi har ikke en kilde som dokumenterer at ${entry.company} selv bruker Bovaer (3-NOP) nå. Varslet bygger på leverandør- eller råmelkkoblingen i kildene.',
    'ikke_tillatt' =>
      'Kildene sier at Bovaer (3-NOP) ikke er tillatt i denne produksjonen hos ${entry.company}.',
    _ =>
      'Kildene om ${entry.company} og Bovaer (3-NOP) er ufullstendige.',
  };
  if (first.url.isEmpty) {
    return '$lead Informasjonen kan være ufullstendig.';
  }
  return '$lead Første kilde: ${first.publisher}, datert ${first.date}. Notatet står under Se kilder. Informasjonen kan være ufullstendig.';
}

String _bovaerWhatEn(BovaerProcessorStatus entry, WarningCitation first) {
  final lead = switch (entry.status) {
    'bruker' =>
      'The sources describe use of Bovaer (3-nitrooxypropanol, 3-NOP) linked to ${entry.company}. They do not say that every single product is affected.',
    'har_brukt' =>
      'The sources describe earlier use of Bovaer (3-NOP) linked to ${entry.company}. They do not say that use is ongoing.',
    'stoppet' =>
      'The sources describe that ${entry.company} has stopped using milk from cows fed Bovaer (3-NOP).',
    'forsok' =>
      'The sources describe trials with Bovaer (3-NOP) linked to ${entry.company}. The extent for ordinary products is not fully documented.',
    'ukjent' =>
      'We do not have a source documenting that ${entry.company} itself uses Bovaer (3-NOP) now. The warning rests on a supplier or raw-milk link in the sources.',
    'ikke_tillatt' =>
      'The sources say that Bovaer (3-NOP) is not permitted in this production at ${entry.company}.',
    _ => 'The sources on ${entry.company} and Bovaer (3-NOP) are incomplete.',
  };
  if (first.url.isEmpty) {
    return '$lead The information may be incomplete.';
  }
  return '$lead First source: ${first.publisher}, dated ${first.date}. The note is under See sources. The information may be incomplete.';
}

String _bovaerHowNb(BovaerProcessorStatus entry, String? shopCountry) {
  final b = StringBuffer(
    'Sjekk produksjons- eller pakkedato på emballasjen. '
    'For import: sjekk landkoden i det ovale stempelet (for eksempel DK, NO eller FI). '
    'Varer med lang holdbarhet kan ligge i butikk etter en stoppdato. ',
  );
  if (entry.producedBefore != null && entry.appColor == 'yellow') {
    b.write(
      'Datagrunnlaget bruker ${formatWarningDate(entry.producedBefore!)}: det gjelder produkter produsert før den datoen. ',
    );
  }
  if (shopCountry != null &&
      shopCountry.isNotEmpty &&
      shopCountry.toUpperCase() != entry.country) {
    b.write('Opplysningen gjelder ${entry.country}. ');
  }
  b.write('Informasjonen kan være ufullstendig.');
  return b.toString();
}

String _bovaerHowEn(BovaerProcessorStatus entry, String? shopCountry) {
  final b = StringBuffer(
    'Check the production or packing date on the pack. '
    'For imports, check the country code in the oval stamp (for example DK, NO or FI). '
    'Long-shelf-life goods can remain in shops after a stop date. ',
  );
  if (entry.producedBefore != null && entry.appColor == 'yellow') {
    b.write(
      'The sourced data uses ${formatWarningDate(entry.producedBefore!)}: it applies to products made before that date. ',
    );
  }
  if (shopCountry != null &&
      shopCountry.isNotEmpty &&
      shopCountry.toUpperCase() != entry.country) {
    b.write('This concerns ${entry.country}. ');
  }
  b.write('The information may be incomplete.');
  return b.toString();
}

String _actLineNb(WarningResearchEntry entry) {
  final fact = switch (entry.id) {
    'eu-2021-882' =>
      'gjennomføringsforordning (EU) 2021/882 av 1. juni 2021 om tørket larve av Tenebrio molitor som ny mat',
    'eu-2021-1975' =>
      'gjennomføringsforordning (EU) 2021/1975 av 12. november 2021 om fryst, tørket og pulverform av Locusta migratoria som ny mat',
    'eu-2022-188' =>
      'gjennomføringsforordning (EU) 2022/188 av 10. februar 2022 om fryst, tørket og pulverform av Acheta domesticus som ny mat',
    'eu-2023-5' =>
      'gjennomføringsforordning (EU) 2023/5 av 3. januar 2023 om delvis avfettet pulver av Acheta domesticus som ny mat',
    'eu-2023-58' =>
      'gjennomføringsforordning (EU) 2023/58 av 5. januar 2023 om fryst form, paste, tørket form og pulver av Alphitobius diaperinus-larver som ny mat',
    _ => entry.citation.quoteOrNote,
  };
  return '${entry.citation.publisher} (${formatWarningDate(entry.citation.date)}): $fact.';
}

String _actLineEn(WarningResearchEntry entry) {
  final fact = switch (entry.id) {
    'eu-2021-882' =>
      'Implementing Regulation (EU) 2021/882 of 1 June 2021 on dried Tenebrio molitor larva as a novel food',
    'eu-2021-1975' =>
      'Implementing Regulation (EU) 2021/1975 of 12 November 2021 on frozen, dried and powder forms of Locusta migratoria as a novel food',
    'eu-2022-188' =>
      'Implementing Regulation (EU) 2022/188 of 10 February 2022 on frozen, dried and powder forms of Acheta domesticus as a novel food',
    'eu-2023-5' =>
      'Implementing Regulation (EU) 2023/5 of 3 January 2023 on partially defatted Acheta domesticus powder as a novel food',
    'eu-2023-58' =>
      'Implementing Regulation (EU) 2023/58 of 5 January 2023 on frozen, paste, dried and powder forms of Alphitobius diaperinus larvae as a novel food',
    _ => entry.citation.quoteOrNote,
  };
  return '${entry.citation.publisher} (${formatWarningDate(entry.citation.date)}): $fact.';
}
