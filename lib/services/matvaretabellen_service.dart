import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Service for fuzzy-matching scanned products against
/// the Norwegian Food Composition Database (Matvaretabellen).
/// Data: assets/matvaretabellen_compact.json (~860 KB, 2121 foods).
class MatvaretabellenService {
  List<Map<String, dynamic>>? _foods;
  bool _loaded = false;

  /// Load the compact JSON from Flutter assets. Call once, e.g. in initState.
  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw =
          await rootBundle.loadString('assets/matvaretabellen_compact.json');
      final list = json.decode(raw) as List<dynamic>;
      _foods = list.cast<Map<String, dynamic>>();
      _loaded = true;
    } catch (_) {
      _foods = [];
      _loaded = true;
    }
  }

  bool get isLoaded => _loaded;

  /// Find candidate foods matching the product name and/or brand.
  /// Returns up to [limit] matches sorted by relevance, each containing:
  ///   name, url, calories, nutrition (mapped to app keys).
  List<Map<String, dynamic>> findCandidates(
    String productName,
    String brand, {
    int limit = 3,
  }) {
    if (_foods == null || _foods!.isEmpty) return [];
    final query = _normalize('$productName $brand');
    if (query.isEmpty) return [];

    final queryWords = query.split(RegExp(r'\s+'));

    final scored = <_ScoredFood>[];
    for (final food in _foods!) {
      final foodName = _normalize(food['n'] as String? ?? '');
      final keywords = (food['k'] as List<dynamic>?)
              ?.map((e) => _normalize(e.toString()))
              .toList() ??
          [];

      double score = 0;

      // Exact substring match in food name (strong signal)
      for (final w in queryWords) {
        if (w.length < 3) continue;
        if (foodName.contains(w)) {
          score += w.length / query.length * 2.0;
        }
        for (final kw in keywords) {
          if (kw.contains(w)) {
            score += w.length / query.length * 1.0;
          }
        }
      }

      // Food name words in query (reverse match)
      final foodWords = foodName.split(RegExp(r'\s+'));
      for (final fw in foodWords) {
        if (fw.length < 3) continue;
        if (query.contains(fw)) {
          score += fw.length / foodName.length * 1.5;
        }
      }

      if (score > 0.3) {
        scored.add(_ScoredFood(food, score));
      }
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    return scored.take(limit).map((s) {
      final food = s.food;
      final nt = food['nt'] as Map<String, dynamic>? ?? {};
      return <String, dynamic>{
        'name': food['n'] ?? '',
        'url': food['u'] ?? '',
        'calories': food['cal'] ?? 0,
        'foodGroupId': food['g'] ?? '',
        'nutrition': _mapNutrition(nt),
      };
    }).toList();
  }

  /// Map Matvaretabellen nutrient IDs to the app's standard keys.
  static Map<String, double> _mapNutrition(Map<String, dynamic> nt) {
    double qty(String key) {
      final entry = nt[key];
      if (entry is Map) {
        final q = entry['q'];
        if (q is num) return q.toDouble();
      }
      return 0.0;
    }

    return {
      'energy_kcal': 0, // filled from 'cal' field by caller if needed
      'fat': qty('Fett'),
      'saturated_fat': qty('Metfett'),
      'carbohydrates': qty('Karbo'),
      'sugars': qty('Mono+Di'),
      'protein': qty('Protein'),
      'salt': qty('NaCl'),
      'fiber': qty('Fiber'),
    };
  }

  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll(RegExp(r'[^\wæøåäöü\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

class _ScoredFood {
  final Map<String, dynamic> food;
  final double score;
  _ScoredFood(this.food, this.score);
}
