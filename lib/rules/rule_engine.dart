import 'dart:math';

import '../data/risk_brands_by_country.dart';

class RuleTrigger {
  final String id;
  final String description;
  final double minConfidence; // 0.0 - 1.0 threshold
  final List<String> preferredSources; // e.g. ['Matvaretabellen', 'OpenFoodFacts']
  final bool enabled;

  const RuleTrigger({required this.id, required this.description, this.minConfidence = 0.0, this.preferredSources = const [], this.enabled = true});
}

class AlertResult {
  final String ruleId;
  final String severity; // e.g. 'red','yellow','green'
  final String reason;
  final double confidence;
  final List<Map<String, dynamic>> evidence;

  AlertResult({required this.ruleId, required this.severity, required this.reason, required this.confidence, this.evidence = const []});

  Map<String, dynamic> toMap() {
    return {
      'ruleId': ruleId,
      'severity': severity,
      'reason': reason,
      'confidence': confidence,
      'evidence': evidence,
    };
  }
}

class RuleEngine {
  final List<RuleTrigger> rules;

  RuleEngine({this.rules = const []});

  /// Normalize available per-source evidence from product snapshot.
  /// Accepts product['sources'] as List<Map{source,confidence,...}] or falls back to sourceConfidence.
  List<Map<String, dynamic>> _collectSources(Map<String, dynamic> product) {
    final List<Map<String, dynamic>> out = [];
    final raw = product['sources'];
    if (raw is List) {
      for (var e in raw) {
        if (e is Map) {
          final source = (e['source'] ?? e['kilde'] ?? '').toString();
          final conf = (e['confidence'] is num) ? (e['confidence'] as num).toDouble() : double.tryParse(e['confidence']?.toString() ?? '') ?? 0.0;
          out.add({'source': source, 'confidence': conf, 'raw': e});
        }
      }
    }
    // fallback
    final fallback = (product['sourceConfidence'] is num) ? (product['sourceConfidence'] as num).toDouble() : double.tryParse(product['sourceConfidence']?.toString() ?? '') ?? 0.0;
    final fallbackName = (product['source'] ?? product['kilde'] ?? '').toString();
    if (out.isEmpty) {
      out.add({'source': fallbackName, 'confidence': fallback, 'raw': product});
    }
    return out;
  }

  double _combinedConfidenceAny(List<Map<String, dynamic>> sources) {
    if (sources.isEmpty) return 0.0;
    // probabilistic OR: 1 - prod(1 - p_i)
    double prod = 1.0;
    for (var s in sources) {
      final p = (s['confidence'] as double? ?? 0.0).clamp(0.0, 1.0);
      prod *= (1.0 - p);
    }
    return (1.0 - prod).clamp(0.0, 1.0);
  }

  double _combinedConfidencePreferred(List<Map<String, dynamic>> sources, List<String> preferred) {
    if (sources.isEmpty || preferred.isEmpty) return 0.0;
    final matches = sources.where((s) {
      final src = s['source']?.toString().toLowerCase() ?? '';
      return preferred.any((p) => src.contains(p.toLowerCase()));
    }).toList();
    return _combinedConfidenceAny(matches);
  }

  // ignore: unused_element
  double _bestConfidenceForSources(List<Map<String, dynamic>> sources, List<String> preferred) {
    if (sources.isEmpty) return 0.0;
    // Try preferred sources first
    double anyBest = sources.map((m) => (m['confidence'] as double? ?? 0.0)).reduce(max);
    double prefBest = 0.0;
    if (preferred.isNotEmpty) {
      for (var p in preferred) {
        final matches = sources.where((s) => s['source']?.toString().toLowerCase().contains(p.toLowerCase()) == true).toList();
        if (matches.isNotEmpty) {
          final bm = matches.map((m) => (m['confidence'] as double? ?? 0.0)).reduce(max);
          prefBest = max(prefBest, bm);
        }
      }
    }
    // Return anyBest as default; caller may prefer prefBest if needed.
    return anyBest;
  }

  /// Evaluate a canonical product snapshot (map) and return alert results.
  List<AlertResult> evaluate(Map<String, dynamic> product) {
    final List<AlertResult> results = [];
    if (product.isEmpty) return results;

    final brand = (product['merke'] ?? product['brand'] ?? '').toString().toLowerCase();
    final labels = (product['etiketter'] ?? product['labels'] ?? '')?.toString().toLowerCase() ?? '';
    final categories = (product['kategorier'] ?? product['categories'] ?? '')?.toString().toLowerCase() ?? '';
    final ingredients = (product['ingredienser'] ?? product['ingredients_text'] ?? product['ingredients'] ?? '')?.toString().toLowerCase() ?? '';

    final sources = _collectSources(product);

    for (final r in rules) {
      if (!r.enabled) continue;
      // Compute combined confidences (probabilistic OR) for preferred sources and any sources
      final anyCombined = _combinedConfidenceAny(sources);
      final prefCombined = _combinedConfidencePreferred(sources, r.preferredSources);
      final usedPreferred = prefCombined >= r.minConfidence && prefCombined > 0.0;
      final bestConf = usedPreferred ? prefCombined : anyCombined;
      if (r.id == 'bovaer') {
        final red = getBovaerRedBrands('NO').any((b) => brand.contains(b));
        final yellow = getBovaerYellowBrands('NO').any((b) => brand.contains(b));
        if (red && bestConf >= r.minConfidence) {
          results.add(AlertResult(
            ruleId: r.id,
            severity: 'red',
            reason: 'Merke i rød-liste',
            confidence: bestConf,
            evidence: [
              {'brand': brand, 'sources': sources, 'preferredUsed': usedPreferred, 'combinedPreferred': prefCombined, 'combinedAny': anyCombined}
            ],
          ));
        } else if (yellow && bestConf >= r.minConfidence) {
          results.add(AlertResult(
            ruleId: r.id,
            severity: 'yellow',
            reason: 'Merke i gul-liste',
            confidence: bestConf,
            evidence: [
              {'brand': brand, 'sources': sources, 'preferredUsed': usedPreferred, 'combinedPreferred': prefCombined, 'combinedAny': anyCombined}
            ],
          ));
        }
      } else if (r.id == 'gmo_fish') {
        final fish = getGmoFishRedBrands('NO').any((b) => brand.contains(b));
        final labelGmo = labels.contains('gmo') || labels.contains('genmodifisert') || labels.contains('genmodifisert fôr');
        if ((fish || labelGmo) && bestConf >= r.minConfidence) {
          results.add(AlertResult(
            ruleId: r.id,
            severity: 'red',
            reason: 'GMO-fôr mistenkt',
            confidence: bestConf,
            evidence: [
              {'brand': brand, 'labels': labels, 'sources': sources, 'preferredUsed': usedPreferred, 'combinedPreferred': prefCombined, 'combinedAny': anyCombined}
            ],
          ));
        }
      } else if (r.id == 'insect_meal') {
        final insectKeywords = ['insektsmel', 'insektsprotein', 'insekt', 'insek', 'insect', 'mealworm', 'black soldier', 'larve'];
        final hasInsect = insectKeywords.any((k) => ingredients.contains(k) || categories.contains(k) || labels.contains(k));
        if (hasInsect && bestConf >= r.minConfidence) {
          results.add(AlertResult(
            ruleId: r.id,
            severity: 'red',
            reason: 'Insektsmåltid oppdaget i ingredienser',
            confidence: bestConf,
            evidence: [
              {'ingredients': ingredients, 'sources': sources, 'preferredUsed': usedPreferred, 'combinedPreferred': prefCombined, 'combinedAny': anyCombined}
            ],
          ));
        }
      }
    }

    return results;
  }
}

// Default rules convenience getter.
List<RuleTrigger> defaultRules() {
  return [
    const RuleTrigger(id: 'bovaer', description: 'Bovaer brand lists', minConfidence: 0.0, preferredSources: ['Matvaretabellen', 'OpenFoodFacts'], enabled: true),
    const RuleTrigger(id: 'gmo_fish', description: 'GMO fish farms', minConfidence: 0.0, preferredSources: ['Matvaretabellen', 'OpenFoodFacts'], enabled: true),
    const RuleTrigger(id: 'insect_meal', description: 'Insect meal detection', minConfidence: 0.0, preferredSources: ['OpenFoodFacts', 'Matvaretabellen'], enabled: true),
  ];
}

// Configure rules from persisted thresholds and enabled map.
List<RuleTrigger> configureRules(Map<String, double> thresholds, Map<String, bool> enabledMap) {
  final defaults = defaultRules();
  return defaults.map((r) {
    final minC = thresholds[r.id] ?? r.minConfidence;
    final en = enabledMap.containsKey(r.id) ? enabledMap[r.id]! : r.enabled;
    return RuleTrigger(id: r.id, description: r.description, minConfidence: minC, preferredSources: r.preferredSources, enabled: en);
  }).toList();
}
