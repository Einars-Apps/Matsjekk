import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/data/bovaer_processor_status.dart';

void main() {
  test('bovaer_processor_status.dart is synced with docs JSON', () {
    final decoded = json.decode(
      File('docs/data/bovaer_processor_status.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final entries = decoded['entries'] as List<dynamic>;
    final jsonIds = entries.map((e) => (e as Map<String, dynamic>)['id']).toSet();
    final dartIds = bovaerProcessorStatuses.map((e) => e.id).toSet();
    expect(dartIds, jsonIds);
  });

  test('every entry has at least one https source with a date', () {
    for (final e in bovaerProcessorStatuses) {
      expect(e.sources, isNotEmpty, reason: e.id);
      for (final s in e.sources) {
        expect(s.url.startsWith('https://'), isTrue, reason: e.id);
        expect(s.date.trim(), isNotEmpty, reason: e.id);
      }
    }
  });

  test('unknown status is never red', () {
    for (final e in bovaerProcessorStatuses) {
      if (e.status == 'ukjent') {
        expect(e.appColor, isNot('red'), reason: e.id);
      }
    }
  });

  test('TINE stays yellow with produced-before 2026-01-22', () {
    final tine = bovaerProcessorStatuses.firstWhere((e) => e.id == 'no_tine');
    expect(tine.appColor, 'yellow');
    expect(tine.producedBefore, '2026-01-22');
    expect(bovaerProducedBeforeTextNb(tine), contains('22.01.2026'));
  });

  test('whole-word matching avoids false hits', () {
    expect(findBovaerProcessorStatuses('Valentine sjokolade', country: 'NO'), isEmpty);
    expect(findBovaerProcessorStatuses('TINE Lettmelk', country: 'NO').map((e) => e.id),
        contains('no_tine'));
    expect(findBovaerProcessorStatuses('Synnøve Gulost', country: 'NO').map((e) => e.id),
        contains('no_synnove'));
  });
}
