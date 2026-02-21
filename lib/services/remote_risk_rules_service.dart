import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/links.dart';

class RemoteRiskRulesService {
  static const String _cacheKey = 'remote_risk_rules_cache_v2';
  static const String _cacheTimestampKey = 'remote_risk_rules_cache_ts_v2';

  final Box settingsBox;

  RemoteRiskRulesService(this.settingsBox);

  Map<String, Map<String, List<String>>> readCachedRules() {
    final raw = settingsBox.get(_cacheKey);
    if (raw is! String || raw.isEmpty) {
      return {};
    }

    try {
      final decoded = json.decode(raw);
      return _parseRules(decoded);
    } catch (_) {
      return {};
    }
  }

  Future<Map<String, Map<String, List<String>>>> fetchAndCacheRules() async {
    final uri = Uri.parse(kSupplierRulesUrl);
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch rules: ${response.statusCode}');
    }

    final decoded = json.decode(response.body);
    final rules = _parseRules(decoded);
    if (rules.isEmpty) {
      throw Exception('Remote rules are empty or invalid');
    }

    await settingsBox.put(_cacheKey, response.body);
    await settingsBox.put(_cacheTimestampKey, DateTime.now().toIso8601String());
    return rules;
  }

  String? cachedAtIsoString() {
    final value = settingsBox.get(_cacheTimestampKey);
    return value is String ? value : null;
  }

  static Map<String, Map<String, List<String>>> _parseRules(dynamic decoded) {
    if (decoded is! Map) {
      return {};
    }

    final dynamic countriesRaw =
        decoded.containsKey('countries') ? decoded['countries'] : decoded;

    if (countriesRaw is! Map) {
      return {};
    }

    final result = <String, Map<String, List<String>>>{};

    for (final entry in countriesRaw.entries) {
      final countryCode = entry.key.toString().toUpperCase();
      final countryValue = entry.value;

      if (countryValue is! Map) {
        continue;
      }

      final parsedCountry = <String, List<String>>{};
      for (final key in const [
        'bovaer_red',
        'bovaer_yellow',
        'gmo_fish_red',
        'organic_keywords',
      ]) {
        final rawList = countryValue[key];
        if (rawList is List) {
          parsedCountry[key] = rawList
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList();
        }
      }

      if (parsedCountry.isNotEmpty) {
        result[countryCode] = parsedCountry;
      }
    }

    return result;
  }
}
