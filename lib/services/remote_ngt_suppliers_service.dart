import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/links.dart';

/// One human-approved supplier entry: a brand documented to source from a
/// known GMO supplier. Shown in the app as a YELLOW "MULIG RISIKO" signal.
class NgtSupplierEntry {
  /// Lowercase brand substrings matched against the product brand name.
  final List<String> brandAliases;
  final String reasonNb;
  final String reasonEn;
  final String sourceUrl;

  const NgtSupplierEntry({
    required this.brandAliases,
    required this.reasonNb,
    required this.reasonEn,
    required this.sourceUrl,
  });

  factory NgtSupplierEntry.fromJson(Map<String, dynamic> json) {
    final aliasesRaw = json['brand_aliases'];
    final aliases = aliasesRaw is List
        ? aliasesRaw
            .map((e) => e.toString().trim().toLowerCase())
            .where((e) => e.isNotEmpty)
            .toList()
        : <String>[];
    return NgtSupplierEntry(
      brandAliases: aliases,
      reasonNb: (json['reason_nb'] ?? '').toString(),
      reasonEn: (json['reason_en'] ?? '').toString(),
      sourceUrl: (json['source_url'] ?? '').toString(),
    );
  }
}

/// Fetches and caches the human-approved NGT supplier list published at
/// [kNgtSuppliersUrl]. Approved entries reach the app without a new release.
///
/// Cache strategy mirrors [RemoteRiskRulesService]: read cache instantly,
/// refresh in the background (once per day is enough — the list changes rarely).
class RemoteNgtSuppliersService {
  static const String _cacheKey = 'remote_ngt_suppliers_cache_v1';
  static const String _cacheTimestampKey = 'remote_ngt_suppliers_cache_ts_v1';

  final Box settingsBox;

  RemoteNgtSuppliersService(this.settingsBox);

  List<NgtSupplierEntry> readCached() {
    final raw = settingsBox.get(_cacheKey);
    if (raw is! String || raw.isEmpty) {
      return const [];
    }
    try {
      return _parse(json.decode(raw));
    } catch (_) {
      return const [];
    }
  }

  /// True when the cache is older than [maxAge] (or missing).
  bool isStale({Duration maxAge = const Duration(hours: 24)}) {
    final ts = settingsBox.get(_cacheTimestampKey);
    if (ts is! String || ts.isEmpty) return true;
    final parsed = DateTime.tryParse(ts);
    if (parsed == null) return true;
    return DateTime.now().difference(parsed) > maxAge;
  }

  Future<List<NgtSupplierEntry>> fetchAndCache() async {
    final response = await http
        .get(Uri.parse(kNgtSuppliersUrl))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch NGT suppliers: ${response.statusCode}');
    }

    final decoded = json.decode(response.body);
    final entries = _parse(decoded);

    await settingsBox.put(_cacheKey, response.body);
    await settingsBox.put(
        _cacheTimestampKey, DateTime.now().toIso8601String());
    return entries;
  }

  static List<NgtSupplierEntry> _parse(dynamic decoded) {
    if (decoded is! Map) return const [];
    final list = decoded['suppliers'];
    if (list is! List) return const [];
    final result = <NgtSupplierEntry>[];
    for (final item in list) {
      if (item is Map) {
        final entry =
            NgtSupplierEntry.fromJson(item.cast<String, dynamic>());
        if (entry.brandAliases.isNotEmpty) {
          result.add(entry);
        }
      }
    }
    return result;
  }
}
