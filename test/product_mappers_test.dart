import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/models/product.dart';

void main() {
  test('extractENumbers finds E-numbers in text', () {
    const text = 'Ingredients: E202, e 330 and e100a and something else';
    final list = Product.extractENumbers(text);
    final set = list.map((s) => s.toUpperCase()).toSet();
    expect(set.contains('E202'), isTrue);
    expect(set.contains('E330'), isTrue);
    expect(set.contains('E100A'), isTrue);
  });

  test('extractAllergensFromIngredients detects common allergens', () {
    const text = 'Contains Milk, peanuts and soybeans.';
    final allergens = Product.extractAllergensFromIngredients(text);
    // returns keys in Norwegian like 'melk' and 'peanøtt' and 'soya'
    expect(allergens.contains('melk') || allergens.contains('milk'), isTrue);
    expect(
        allergens.contains('peanøtt') || allergens.contains('peanut'), isTrue);
    expect(allergens.contains('soya') || allergens.contains('soy'), isTrue);
  });

  test('extractNutrition parses nutriments map with mixed types', () {
    final nutriments = {
      'energy-kcal_100g': '250',
      'fat_100g': 10.5,
      'sugars_100g': '2',
      'protein_100g': '5,2',
      'salt_100g': 0.12,
    };
    final n = Product.extractNutrition(nutriments);
    expect(n['energy_kcal'], equals(250.0));
    expect(n['fat'], equals(10.5));
    expect(n['sugars'], equals(2.0));
    expect(n['protein'], equals(5.2));
    expect(n['salt'], equals(0.12));
  });

  test('fromOpenFoodFacts maps fields and extracts E-numbers/allergens', () {
    final off = {
      'product_name': 'Test Milk',
      'brands': 'TestBrand',
      'labels': 'Organic, EU',
      'ingredients_text': 'Milk, sugar, E100, e202',
      'additives_tags': ['en:e100'],
      'allergens_tags': ['en:milk'],
      'image_front_url': 'https://example.com/img.png',
      'nutriscore_grade': 'b',
      'nutriments': {'energy-kcal_100g': '50', 'fat_100g': '1'}
    };
    final p = Product.fromOpenFoodFacts(off);
    expect(p.name, equals('Test Milk'));
    expect(p.brand, equals('TestBrand'));
    expect(p.eNumbers.any((e) => e.toUpperCase().contains('E100')), isTrue);
    expect(
        p.allergens.contains('milk') || p.allergens.contains('melk'), isTrue);
    expect(p.nutrition['energy_kcal'], equals(50.0));
    expect(p.imageUrl, contains('example.com'));
  });

  test('fromMatvare maps gtin, name, ingredients and nutrition', () {
    final entry = {
      'name': 'Matvare Produkt',
      'brand': 'MatMerke',
      'ingredients': 'hvete, melk, e330',
      'ean': '1234567890123',
      'nutriments': {'energy-kcal_100g': 100, 'fat_100g': '2.5'}
    };
    final p = Product.fromMatvare(entry);
    expect(p.gtin, equals('1234567890123'));
    expect(p.name, contains('Matvare'));
    expect(p.eNumbers.any((e) => e.toUpperCase().contains('E330')), isTrue);
    expect(p.allergens.isNotEmpty, isTrue);
    expect(p.nutrition['energy_kcal'], equals(100.0));
  });
}
