// Kassalapp (kassal.app) API client.
//
// Provides Norwegian grocery product data (ingredients, allergens, nutrition)
// that OpenFoodFacts often lacks for products sold in Norway. Used to enrich a
// product lookup so additive/E-number detection has something to work with.
//
// Auth: a free "Hobby" bearer token from https://kassal.app/profil/api.
// The token is read from a compile-time environment variable so it never has
// to be committed to git:
//
//   flutter run --dart-define=KASSALAPP_TOKEN=your_token_here
//
// Without a token the client is disabled and all calls return null, so the app
// degrades gracefully to OpenFoodFacts only.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class KassalappProduct {
  final String name;
  final String brand;
  final String ingredients;
  final String imageUrl;
  final List<String> allergens; // display names where "contains" == YES
  final Map<String, double> nutrition; // app nutrition keys -> amount per 100g

  const KassalappProduct({
    required this.name,
    required this.brand,
    required this.ingredients,
    required this.imageUrl,
    required this.allergens,
    required this.nutrition,
  });
}

class KassalappService {
  KassalappService({String? token, http.Client? client})
      : _token = (token == null || token.isEmpty)
            ? const String.fromEnvironment('KASSALAPP_TOKEN')
            : token,
        _client = client ?? http.Client();

  final String _token;
  final http.Client _client;

  static const String _base = 'https://kassal.app/api/v1';

  /// Human-readable status of the most recent lookup, for surfacing in the UI.
  /// Null until the first call.
  String? lastStatus;

  /// True when a token is configured and the client can make authenticated
  /// requests.
  bool get isEnabled => _token.isNotEmpty;

  /// Looks up a product by EAN (barcode). Returns null when disabled, not
  /// found, or on any error (the caller should fall back to other sources).
  Future<KassalappProduct?> fetchByEan(String ean) async {
    if (!isEnabled) {
      lastStatus = 'Kassalapp er ikke aktivert (mangler API-token).';
      return null;
    }
    try {
      final uri = Uri.parse('$_base/products/ean/$ean');
      final response = await _client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 401 || response.statusCode == 403) {
        lastStatus = 'Kassalapp avviste tokenet (${response.statusCode}). '
            'Sjekk at API-nøkkelen er gyldig.';
        return null;
      }
      if (response.statusCode == 404) {
        lastStatus = 'Produktet finnes ikke i Kassalapp.';
        return null;
      }
      if (response.statusCode == 429) {
        lastStatus = 'Kassalapp: for mange forespørsler (429). Prøv igjen senere.';
        return null;
      }
      if (response.statusCode != 200) {
        lastStatus = 'Kassalapp svarte med feil (${response.statusCode}).';
        return null;
      }
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) {
        lastStatus = 'Kassalapp: tomt svar for produktet.';
        return null;
      }

      // products[] holds one entry per store; pick the first with ingredients.
      final products = (data['products'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
      Map<String, dynamic>? best;
      for (final p in products) {
        final ing = (p['ingredients'] ?? '').toString().trim();
        if (ing.isNotEmpty) {
          best = p;
          break;
        }
      }
      best ??= products.isNotEmpty ? products.first : null;

      final ingredients = (best?['ingredients'] ?? '').toString().trim();
      final name = (best?['name'] ?? '').toString().trim();
      final brand = (best?['brand'] ?? '').toString().trim();
      final imageUrl = (best?['image'] ?? '').toString().trim();

      // Allergens that the product actually contains.
      final allergens = <String>[];
      for (final a in (data['allergens'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()) {
        final contains = (a['contains'] ?? '').toString().toUpperCase();
        final display = (a['display_name'] ?? '').toString().trim();
        if (display.isNotEmpty && contains == 'YES') {
          allergens.add(display);
        }
      }

      final nutrition = _mapNutrition(
          (data['nutrition'] as List<dynamic>? ?? const [])
              .whereType<Map<String, dynamic>>()
              .toList());

      if (ingredients.isEmpty) {
        lastStatus = 'Kassalapp fant produktet, men har ingen ingrediensliste.';
      } else {
        lastStatus = 'OK (Kassalapp).';
      }

      return KassalappProduct(
        name: name,
        brand: brand,
        ingredients: ingredients,
        imageUrl: imageUrl,
        allergens: allergens,
        nutrition: nutrition,
      );
    } catch (e) {
      debugPrint('Kassalapp lookup failed: $e');
      lastStatus = 'Kassalapp: nettverks-/parsefeil ($e).';
      return null;
    }
  }

  // Maps Kassalapp nutrition codes to the app's internal nutrition keys.
  Map<String, double> _mapNutrition(List<Map<String, dynamic>> items) {
    const codeMap = <String, String>{
      'kcal': 'energy_kcal',
      'energi': 'energy_kcal',
      'energy': 'energy_kcal',
      'fett': 'fat',
      'fat': 'fat',
      'mettet_fett': 'saturated_fat',
      'mettedefettsyrer': 'saturated_fat',
      'saturated_fat': 'saturated_fat',
      'karbohydrater': 'carbohydrates',
      'karbohydrat': 'carbohydrates',
      'carbohydrates': 'carbohydrates',
      'sukkerarter': 'sugars',
      'sukker': 'sugars',
      'sugars': 'sugars',
      'protein': 'proteins',
      'proteiner': 'proteins',
      'proteins': 'proteins',
      'salt': 'salt',
    };
    final result = <String, double>{};
    for (final item in items) {
      final code = (item['code'] ?? '').toString().toLowerCase();
      final key = codeMap[code];
      final amount = item['amount'];
      if (key != null && amount is num) {
        result[key] = amount.toDouble();
      }
    }
    return result;
  }
}
