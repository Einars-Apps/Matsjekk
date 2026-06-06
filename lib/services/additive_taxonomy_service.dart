// OpenFoodFacts additive taxonomy lookup.
//
// Free, no-token international register that returns the official name of any
// E-number plus a link to the EFSA evaluation. Used as a fallback when the
// curated `additive_info.dart` database has no entry, so every detected
// E-number can still show at least an authoritative name and source.
//
// Endpoint: https://world.openfoodfacts.org/additive/en:e450.json

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdditiveTaxonomyInfo {
  final String eNumber; // e.g. "E450"
  final String name; // Official name, e.g. "Diphosphates"
  final String? efsaUrl; // Link to EFSA evaluation, if available
  final bool? vegan;
  final bool? vegetarian;

  const AdditiveTaxonomyInfo({
    required this.eNumber,
    required this.name,
    this.efsaUrl,
    this.vegan,
    this.vegetarian,
  });
}

class AdditiveTaxonomyService {
  AdditiveTaxonomyService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, AdditiveTaxonomyInfo?> _cache = {};

  /// Fetches the official name + EFSA link for an E-number from the
  /// OpenFoodFacts additive taxonomy. Returns null when not found or on error.
  /// [localeCode] selects the preferred language for the name (falls back to
  /// English).
  Future<AdditiveTaxonomyInfo?> lookup(String eNumber,
      {String localeCode = 'en'}) async {
    final key = eNumber.toLowerCase().replaceAll(' ', '').trim();
    if (_cache.containsKey(key)) return _cache[key];
    try {
      final uri = Uri.parse(
          'https://world.openfoodfacts.org/additive/en:$key.json');
      final response = await _client.get(uri, headers: {
        'Accept': 'application/json',
        'User-Agent': 'mat_sjekk/1.0 (additive-info)',
      });
      if (response.statusCode != 200) {
        _cache[key] = null;
        return null;
      }
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final tag = decoded['tag'] as Map<String, dynamic>?;
      if (tag == null) {
        _cache[key] = null;
        return null;
      }

      // Name: prefer localized, then English.
      String name = '';
      final nameField = tag['name'];
      if (nameField is Map) {
        name = (nameField[localeCode] ?? nameField['en'] ?? '').toString();
      } else if (nameField is String) {
        name = nameField;
      }
      if (name.isEmpty) {
        _cache[key] = null;
        return null;
      }

      // EFSA evaluation URL, if present.
      String? efsaUrl;
      final efsa = tag['efsa_evaluation_url'];
      if (efsa is String && efsa.isNotEmpty) {
        efsaUrl = efsa;
      }

      bool? parseTriState(dynamic v) {
        if (v == null) return null;
        final s = v.toString().toLowerCase();
        if (s == 'yes') return true;
        if (s == 'no') return false;
        return null;
      }

      final info = AdditiveTaxonomyInfo(
        eNumber: eNumber.toUpperCase(),
        name: name,
        efsaUrl: efsaUrl,
        vegan: parseTriState(tag['vegan']),
        vegetarian: parseTriState(tag['vegetarian']),
      );
      _cache[key] = info;
      return info;
    } catch (e) {
      debugPrint('Additive taxonomy lookup failed for $eNumber: $e');
      _cache[key] = null;
      return null;
    }
  }
}
