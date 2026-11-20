// Prints how many entries the app's client-side farm shop filter removes
// from the published data in docs/data/. Run from the repo root:
//   dart run tool/farm_shop_cleanup_report.dart [NO]
import 'dart:convert';
import 'dart:io';

import 'package:mat_sjekk/farm_shops/farm_shop.dart';

void main(List<String> args) {
  final only = args.isEmpty ? null : args.first.toUpperCase();
  final organicRaw = jsonDecode(
      File('docs/data/organic_farmshops.json').readAsStringSync());
  final organic = parseFarmShops(organicRaw);
  var totalIn = 0, totalNonFarm = 0, totalDup = 0, totalMojibake = 0;
  for (final entry in kFarmShopCountries.entries) {
    final cc = entry.key;
    if (only != null && cc != only) continue;
    final f = File('docs/data/farmshops_by_country/${cc.toLowerCase()}.json');
    if (!f.existsSync()) continue;
    final raw = jsonDecode(f.readAsStringSync());
    final mojibake = raw is List
        ? raw.where((r) => r is Map && hasMojibake('${r['name']}')).length
        : 0;
    final base = parseFarmShops(raw);
    final extras = organic
        .where((s) => (s.country ?? '').toLowerCase() == entry.value.toLowerCase())
        .toList();
    final merged = mergeFarmShops(base, extras);
    final cleaned = cleanFarmShops(merged);
    totalIn += merged.length;
    totalNonFarm += cleaned.droppedNonFarm.length;
    totalDup += cleaned.duplicatesRemoved;
    totalMojibake += mojibake;
    stdout.writeln('$cc: ${merged.length} -> ${cleaned.shops.length} '
        '(non-farm ${cleaned.droppedNonFarm.length}, '
        'duplicates ${cleaned.duplicatesRemoved}, '
        'mojibake names repaired $mojibake)');
    if (only != null) {
      for (final d in cleaned.droppedNonFarm) {
        stdout.writeln('  dropped $d');
      }
    }
  }
  stdout.writeln('TOTAL: $totalIn -> ${totalIn - totalNonFarm - totalDup} '
      '(non-farm $totalNonFarm, duplicates $totalDup, '
      'mojibake names repaired $totalMojibake)');
}
