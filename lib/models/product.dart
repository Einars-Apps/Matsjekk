// Removed unused import

class Product {
  final String? gtin;
  final String name;
  final String brand;
  final List<String> labels;
  final List<String> categories;
  final String ingredientsText;
  final List<String> eNumbers;
  final List<String> allergens;
  final Map<String, double> nutrition; // per 100g, keys: energy_kcal, fat, saturated_fat, carbs, sugars, protein, salt
  final String imageUrl;
  final String nutriscore;
  final double sourceConfidence;

  Product({
    this.gtin,
    required this.name,
    required this.brand,
    required this.labels,
    required this.categories,
    required this.ingredientsText,
    required this.eNumbers,
    required this.allergens,
    required this.nutrition,
    required this.imageUrl,
    required this.nutriscore,
    required this.sourceConfidence,
  });

  Map<String, dynamic> toMap() {
    return {
      'navn': name,
      'merke': brand,
      'etiketter': labels.join(','),
      'kategorier': categories.join(','),
      'ingredienser': ingredientsText.isEmpty ? 'Ingen info' : ingredientsText,
      'allergener': allergens,
      'næringsinnhold': nutrition,
      'bildeUrl': imageUrl,
      'bildeThumbUrl': imageUrl,
      'nutriscore': nutriscore.toString().toUpperCase(),
      'eStoffer': eNumbers,
      'sourceConfidence': sourceConfidence,
    };
  }

  // Helper: extract E-numbers from a free text ingredients string
  static List<String> extractENumbers(String text) {
    final reg = RegExp(r'e\s*\d{2,4}[a-z]?|E\d{2,4}[a-z]?', caseSensitive: false);
    final matches = reg.allMatches(text);
    return matches.map((m) => m[0]!.toUpperCase().replaceAll(' ', '')).toSet().toList();
  }

  // Very small allergen extractor from free-text ingredients.
  static List<String> extractAllergensFromIngredients(String text) {
    if (text.trim().isEmpty) return <String>[];
    final lower = text.toLowerCase();
    final Map<String, List<String>> allergensMap = {
      'melk': ['milk', 'melk', 'mælk', 'milk powder'],
      'egg': ['egg'],
      'soya': ['soy', 'soya', 'sojabønner'],
      'peanøtt': ['peanut', 'peanøtt', 'peanuts'],
      'nøtter': ['nut', 'nøtt', 'almond', 'cashew', 'hazelnut', 'walnut'],
      'hvete': ['wheat', 'hvete', 'gluten', 'rye', 'barley', 'bygg'],
      'fisk': ['fish', 'fisk', 'salmon', 'laks', 'tuna', 'tunfisk'],
      'skalldyr': ['shellfish', 'skalldyr', 'shrimp', 'reker'],
      'sesam': ['sesame', 'sesam'],
      'selleri': ['celery', 'selleri'],
      'sennep': ['mustard', 'sennep'],
      'sulfitt': ['sulphite', 'sulfite', 'sulfitt'],
    };
    final found = <String>{};
    for (final entry in allergensMap.entries) {
      for (final kw in entry.value) {
        if (lower.contains(kw)) {
          found.add(entry.key);
          break;
        }
      }
    }
    return found.toList();
  }

  // Extract common nutrition values from OpenFoodFacts 'nutriments' map or similar.
  static Map<String, double> extractNutrition(Map<String, dynamic>? nutriments) {
    final result = <String, double>{};
    if (nutriments == null) return result;
    double? tryGet(List<String> keys) {
      for (final k in keys) {
        if (nutriments.containsKey(k)) {
          final v = nutriments[k];
          if (v is num) return v.toDouble();
          if (v is String) {
            final parsed = double.tryParse(v.replaceAll(',', '.'));
            if (parsed != null) return parsed;
          }
        }
      }
      return null;
    }

    result['energy_kcal'] = tryGet(['energy-kcal_100g', 'energy-kcal', 'energy_100g', 'energy-kcal_value']) ?? 0.0;
    result['fat'] = tryGet(['fat_100g', 'fat']) ?? 0.0;
    result['saturated_fat'] = tryGet(['saturated-fat_100g', 'saturated_fat_100g', 'saturated-fat']) ?? 0.0;
    result['carbohydrates'] = tryGet(['carbohydrates_100g', 'carbohydrates']) ?? 0.0;
    result['sugars'] = tryGet(['sugars_100g', 'sugars']) ?? 0.0;
    result['protein'] = tryGet(['proteins_100g', 'protein_100g', 'protein']) ?? 0.0;
    result['salt'] = tryGet(['salt_100g', 'salt']) ?? 0.0;
    return result;
  }

  // Map from OpenFoodFacts product JSON to our Product model
  static Product fromOpenFoodFacts(Map<String, dynamic> offProduct) {
    final productName = (offProduct['product_name'] ?? offProduct['product_name_en'] ?? '') as String? ?? '';
    final brands = (offProduct['brands'] ?? '') as String? ?? '';
    final labelsRaw = (offProduct['labels'] ?? '') as String? ?? '';
    final categoriesRaw = (offProduct['categories'] ?? '') as String? ?? '';
    final ingredients = (offProduct['ingredients_text_no'] ?? offProduct['ingredients_text'] ?? '') as String? ?? '';
    final image = (offProduct['image_front_url'] ?? offProduct['image_front'] ?? '') as String? ?? '';
    final nutri = ((offProduct['nutriscore_grade'] ?? offProduct['nutriscore'] ?? '') as String).toString();
    // additives_tags often like ['en:e102']
    final additiveTags = (offProduct['additives_tags'] as List<dynamic>?) ?? <dynamic>[];
    final eFromTags = additiveTags.map((e) => e.toString().replaceAll('en:', '').toUpperCase()).where((s) => s.isNotEmpty).toList();
    final eFromText = extractENumbers(ingredients);
    final eNumbers = {...eFromTags, ...eFromText}.toList();

    // Allergens
    final allergensList = <String>[];
    if (offProduct['allergens_tags'] is List) {
      final tags = List<dynamic>.from(offProduct['allergens_tags']);
      for (final t in tags) {
        final s = t.toString().replaceAll('en:', '').replaceAll('fr:', '').replaceAll('es:', '');
        if (s.isNotEmpty) allergensList.add(s);
      }
    }
    if (allergensList.isEmpty) {
      final extracted = extractAllergensFromIngredients(ingredients);
      allergensList.addAll(extracted);
    }

    // Nutrition
    final nutriments = (offProduct['nutriments'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final nutrition = extractNutrition(nutriments);

    final labels = labelsRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final categories = categoriesRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    // Simple confidence heuristic: product_name + either ingredients or image increases confidence
    double confidence = 0.3;
    if (productName.isNotEmpty) confidence += 0.3;
    if (ingredients.isNotEmpty) confidence += 0.2;
    if (image.isNotEmpty) confidence += 0.2;
    if (confidence > 1.0) confidence = 1.0;

    return Product(
      gtin: null,
      name: productName.isEmpty ? 'Ukjent navn' : productName,
      brand: brands,
      labels: labels,
      categories: categories,
      ingredientsText: ingredients,
      eNumbers: eNumbers,
      allergens: allergensList,
      nutrition: nutrition,
      imageUrl: image,
      nutriscore: nutri.isEmpty ? 'ukjent' : nutri,
      sourceConfidence: confidence,
    );
  }

  // Map from Matvaretabellen entry (bulk or product) to Product model
  static Product fromMatvare(Map<String, dynamic> entry) {
    final name = (entry['name'] ?? entry['foodName'] ?? entry['product_name'] ?? entry['navn'] ?? '') as String? ?? '';
    final brand = (entry['brand'] ?? entry['brands'] ?? entry['merke'] ?? '') as String? ?? '';
    final labelsRaw = (entry['labels'] ?? '') as String? ?? '';
    final categoriesRaw = (entry['categories'] ?? entry['kategorier'] ?? '') as String? ?? '';
    final ingredients = (entry['ingredients'] ?? entry['ingredients_text'] ?? entry['ingredienser'] ?? '') as String? ?? '';
    final image = (entry['image'] ?? entry['image_front_url'] ?? entry['image_url'] ?? '') as String? ?? '';
    final nutri = ((entry['nutriscore'] ?? '') as String).toString();

    // GTIN/EAN handling
    String? gtin;
    for (final k in ['ean', 'gtin', 'code', 'barcode', 'product_code', 'id']) {
      if (entry.containsKey(k)) {
        final v = entry[k];
        if (v is String && v.trim().isNotEmpty) { gtin = v.trim(); break; }
        if (v is List && v.isNotEmpty) { gtin = v.first.toString().trim(); break; }
      }
    }

    // Extract E-numbers from ingredients if present
    final eFromText = extractENumbers(ingredients);
    // Allergens from fields or ingredients
    final allergensList = <String>[];
    if (entry.containsKey('allergens')) {
      final a = entry['allergens'];
      if (a is String) allergensList.addAll(a.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty));
      if (a is List) allergensList.addAll(a.map((s) => s.toString()).where((s) => s.isNotEmpty));
    }
    if (allergensList.isEmpty) {
      allergensList.addAll(extractAllergensFromIngredients(ingredients));
    }

    // Nutrition parsing from Matvare fields if present
    Map<String, double> nutrition = {};
    if (entry.containsKey('nutriments') && entry['nutriments'] is Map) {
      nutrition = extractNutrition(Map<String, dynamic>.from(entry['nutriments']));
    }

    final labels = labelsRaw.toString().split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final categories = categoriesRaw.toString().split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    // Heuristic confidence: Matvaretabellen entry with name and ingredients is high confidence
    double confidence = 0.4;
    if (name.isNotEmpty) confidence += 0.3;
    if (ingredients.isNotEmpty) confidence += 0.2;
    if (image.isNotEmpty) confidence += 0.1;
    if (confidence > 1.0) confidence = 1.0;

    return Product(
      gtin: gtin,
      name: name.isEmpty ? 'Ukjent navn' : name,
      brand: brand,
      labels: labels,
      categories: categories,
      ingredientsText: ingredients,
      eNumbers: eFromText,
      allergens: allergensList,
      nutrition: nutrition,
      imageUrl: image,
      nutriscore: nutri.isEmpty ? 'ukjent' : nutri,
      sourceConfidence: confidence,
    );
  }
}
