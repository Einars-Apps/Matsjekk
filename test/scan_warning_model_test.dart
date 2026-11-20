import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/bovaer_processor_status.dart';
import 'package:mat_sjekk/data/scan_warning_catalog.dart';
import 'package:mat_sjekk/data/warning_research.dart';
import 'package:mat_sjekk/models/scan_warning.dart';
import 'package:mat_sjekk/services/remote_ngt_suppliers_service.dart';

void main() {
  test('research JSON matches the embedded copy and the disclaimer', () {
    final file = json.decode(
      File('docs/data/warning_research.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final embedded =
        json.decode(kWarningResearchJson) as Map<String, dynamic>;
    expect(embedded['disclaimer_nb'], kResearchDisclaimerNb);
    expect(embedded['disclaimer_en'], kResearchDisclaimerEn);
    expect(file['entries'], embedded['entries']);
    expect(warningResearchDisclaimer(norwegian: true), kResearchDisclaimerNb);
    for (final entry in warningResearchEntries) {
      expect(entry.citation.url.startsWith('https://'), isTrue, reason: entry.id);
      expect(entry.citation.quoteOrNote.trim(), isNotEmpty, reason: entry.id);
      expect(entry.citation.lastChecked, '2026-11-14', reason: entry.id);
    }
  });

  test('bovaer check date matches the sourced file', () {
    final decoded = json.decode(
      File('docs/data/bovaer_processor_status.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    expect(decoded['updated_at'], kBovaerCatalogCheckedOn);
  });

  test('a warning without a source is hidden, and red requires documented use', () {
    const hidden = ScanWarning(
      id: 'no-source',
      topic: WarningTopic.bovaer,
      whatNb: 'Mangler kilde',
      whatEn: 'Missing source',
      who: 'Ukjent',
      howNb: 'Ingen.',
      howEn: 'None.',
      level: WarningLevel.red,
      documentedUse: true,
    );
    expect(hidden.showInPopup, isFalse);
    expect(hidden.popupLevel, isNull);

    const lowered = ScanWarning(
      id: 'red-without-use',
      topic: WarningTopic.gmo,
      whatNb: 'Bakgrunn',
      whatEn: 'Background',
      who: 'Ukjent',
      howNb: 'Sjekk pakken.',
      howEn: 'Check the pack.',
      level: WarningLevel.red,
      documentedUse: false,
      sources: [
        WarningCitation(
          url: 'https://publications.europa.eu/resource/celex/32003R1829',
          date: '2003-09-22',
          publisher: 'EUR-Lex',
          quoteOrNote: 'Regulation (EC) No 1829/2003',
          lastChecked: '2026-11-14',
        ),
      ],
    );
    expect(lowered.showInPopup, isTrue);
    expect(lowered.popupLevel, WarningLevel.yellow);
    expect(lowered.popupLevel, isNot(WarningLevel.red));
  });

  test('sourced Bovaer colours: red only for documented use, none is omitted', () {
    for (final entry in bovaerProcessorStatuses) {
      final warning = scanWarningFromBovaer(entry, shopCountry: 'NO');
      if (entry.appColor == 'none') {
        expect(warning, isNull, reason: entry.id);
        continue;
      }
      expect(warning, isNotNull, reason: entry.id);
      expect(warning!.showInPopup, isTrue, reason: entry.id);
      expect(warning.sources, isNotEmpty, reason: entry.id);
      if (entry.appColor == 'red') {
        expect(entry.status, 'bruker', reason: entry.id);
        expect(warning.documentedUse, isTrue, reason: entry.id);
        expect(warning.popupLevel, WarningLevel.red, reason: entry.id);
      } else {
        expect(warning.popupLevel, isNot(WarningLevel.red), reason: entry.id);
      }
      _expectNoHealthClaim(warning.whatNb, entry.id);
      _expectNoHealthClaim(warning.whatEn, entry.id);
      _expectNoHealthClaim(warning.howNb, entry.id);
      _expectNoHealthClaim(warning.howEn, entry.id);
    }
  });

  test('TINE popup names the company, the date rule and the oval stamp', () {
    final view = resolveScanWarnings(
      brand: 'TINE Lettmelk',
      productText: 'TINE Lettmelk',
      shopCountry: 'NO',
      bovaerLevel: 'yellow',
    );
    expect(view.unsourcedTopics, isEmpty);
    final warning = view.popupWarnings.single;
    expect(warning.id, 'no_tine');
    expect(warning.popupLevel, WarningLevel.yellow);
    expect(warning.who, 'TINE SA');
    expect(warning.whatNb, contains('TINE SA'));
    expect(warning.whatNb, contains('TINE'));
    expect(warning.howNb, contains('ovale stempelet'));
    expect(warning.howNb, contains('22.01.2026'));
    expect(warning.sources.first.publisher, 'TINE');
    expect(warning.sources.first.lastChecked, kBovaerCatalogCheckedOn);
    expect(warning.research, isNotEmpty);
    expect(
      warning.research.map((e) => e.url),
      contains('https://publications.europa.eu/resource/celex/32022R0565'),
    );
  });

  test('Danish Arla stays red only because use is documented', () {
    final view = resolveScanWarnings(
      brand: 'Arla',
      productText: 'Arla lettmelk',
      shopCountry: 'NO',
      bovaerLevel: 'red',
    );
    final warning = view.popupWarnings.single;
    expect(warning.id, 'dk_arla');
    expect(warning.documentedUse, isTrue);
    expect(warning.popupLevel, WarningLevel.red);
  });

  test('organic Arla is green and not a red popup', () {
    final view = resolveScanWarnings(
      brand: 'Arla økologisk',
      productText: 'Arla økologisk melk',
      shopCountry: 'DK',
      bovaerLevel: 'green',
    );
    final warning = view.popupWarnings.single;
    expect(warning.id, 'dk_arla_okologisk');
    expect(warning.popupLevel, WarningLevel.green);
  });

  test('a yellow stamp without a sourced brand is not a popup', () {
    final view = resolveScanWarnings(
      brand: 'Apetina',
      productText: 'Apetina',
      shopCountry: 'NO',
      bovaerLevel: 'yellow',
    );
    expect(view.popupWarnings, isEmpty);
    expect(view.unsourcedTopics, contains(WarningTopic.bovaer));
  });

  test('insect species warning is yellow and cites 2021/882, not the brand', () {
    final view = resolveScanWarnings(
      brand: 'Eksempel',
      productText: 'protein fra tørket Tenebrio molitor',
      insectLevel: 'red',
    );
    final warning = view.popupWarnings.single;
    expect(warning.topic, WarningTopic.insekter);
    expect(warning.popupLevel, WarningLevel.yellow);
    expect(warning.documentedUse, isFalse);
    expect(warning.brandSpecific, isFalse);
    expect(warning.who, kUnsourcedWhoNb);
    expect(warning.whatNb, contains('2021/882'));
    expect(warning.whatNb, contains('Tenebrio molitor'));
    expect(
      warning.sources.map((s) => s.url),
      contains('https://publications.europa.eu/resource/celex/32021R0882'),
    );
    expect(
      warning.research.map((s) => s.url),
      contains('https://pmc.ncbi.nlm.nih.gov/articles/PMC7805300/'),
    );
    expect(warning.research.map((s) => s.url),
        isNot(contains('https://publications.europa.eu/resource/celex/32021R1975')));
  });

  test('supply-chain insect flag without an insect word has no popup', () {
    final view = resolveScanWarnings(
      brand: 'Importor AS',
      productText: 'importert av leverandør',
      insectLevel: 'yellow',
    );
    expect(view.popupWarnings, isEmpty);
    expect(view.unsourcedTopics, contains(WarningTopic.insekter));
  });

  test('explicit GMO text uses the EU act, never red without brand use', () {
    final view = resolveScanWarnings(
      brand: 'Eksempel',
      productText: 'inneholder genmodifisert soya',
      gmoLevel: 'red',
    );
    final warning = view.popupWarnings.single;
    expect(warning.popupLevel, WarningLevel.yellow);
    expect(warning.who, kUnsourcedWhoNb);
    expect(
      warning.sources.map((s) => s.url),
      contains('https://publications.europa.eu/resource/celex/32003R1829'),
    );
    expect(
      warning.research.map((s) => s.url),
      contains('https://publications.europa.eu/resource/celex/32026R1388'),
    );
  });

  test('NGT supplier without a URL is hidden; with a URL it stays yellow', () {
    final hidden = resolveScanWarnings(
      brand: 'Eksempelmerke',
      productText: 'Eksempelmerke',
      ngtLevel: 'yellow',
      ngtSuppliers: const [
        NgtSupplierEntry(
          brandAliases: ['eksempelmerke'],
          reasonNb: 'Leveranse er omtalt.',
          reasonEn: 'A delivery is mentioned.',
          sourceUrl: '',
        ),
      ],
    );
    expect(hidden.popupWarnings, isEmpty);
    expect(hidden.unsourcedTopics, contains(WarningTopic.ngt));

    final shown = resolveScanWarnings(
      brand: 'Eksempelmerke',
      productText: 'Eksempelmerke',
      ngtLevel: 'yellow',
      ngtSuppliers: const [
        NgtSupplierEntry(
          brandAliases: ['eksempelmerke'],
          reasonNb: 'Leveranse er omtalt i kilden.',
          reasonEn: 'A delivery is mentioned in the source.',
          sourceUrl: 'https://publications.europa.eu/resource/celex/32026R1388',
        ),
      ],
    );
    final warning = shown.popupWarnings.single;
    expect(warning.popupLevel, WarningLevel.yellow);
    expect(warning.popupLevel, isNot(WarningLevel.red));
    expect(warning.sources.single.url,
        'https://publications.europa.eu/resource/celex/32026R1388');
  });
}

void _expectNoHealthClaim(String text, String reason) {
  final lower = text.toLowerCase();
  for (final banned in [
    'trygt',
    'trygg',
    'farlig',
    'skadelig',
    'giftig',
    'helse',
    'dangerous',
    'healthy',
  ]) {
    expect(lower.contains(banned), isFalse, reason: '$reason contains $banned');
  }
  expect(RegExp(r'\bsafe\b').hasMatch(lower), isFalse, reason: reason);
}
