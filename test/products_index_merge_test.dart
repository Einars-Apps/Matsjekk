import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/main.dart' show buildProductsIndex;

void main() {
  test('OFF entry with higher confidence overrides Matvare entry', () {
    final matvareEntry = {
      'name': 'Matvare Name',
      'brand': 'BrandA',
      'ingredients': 'milk, sugar',
      'ean': '111'
    };

    final index = {
      'byGtin': {
        '111': matvareEntry,
      }
    };

    // OFF product with image -> higher confidence in fromOpenFoodFacts
    final offProd = {
      'product_name': 'OFF SuperName',
      'brands': 'BrandA',
      'ingredients_text': 'Milk, sugar, E100',
      'image_front_url': 'https://img.example/off.png',
      'nutriscore_grade': 'a',
      'additives_tags': ['en:e100']
    };

    final param = {'index': index, 'off_cache': {'111': offProd}};
    final merged = buildProductsIndex(param);
    expect(merged['byGtin'].containsKey('111'), isTrue);
    final entry = merged['byGtin']['111'];
    final name = (entry['product'] ?? {})['navn'] ?? (entry['product'] ?? {})['name'];
    expect(name.toString().toLowerCase(), contains('off supername'));
  });

  test('Matvare entry remains when OFF has lower confidence', () {
    final matvareEntry = {
      'name': 'Matvare Name',
      'brand': 'BrandA',
      'ingredients': 'hvete, melk',
      'ean': '222'
    };

    final index = {
      'byGtin': {
        '222': matvareEntry,
      }
    };

    // OFF product minimal -> lower confidence
    final offProd = {
      'product_name': 'Tiny OFF',
      'brands': '',
    };

    final param = {'index': index, 'off_cache': {'222': offProd}};
    final merged = buildProductsIndex(param);
    expect(merged['byGtin'].containsKey('222'), isTrue);
    final entry = merged['byGtin']['222'];
    final name = (entry['product'] ?? {})['navn'] ?? (entry['product'] ?? {})['name'];
    expect(name.toString().toLowerCase(), contains('matvare name'));
  });
}
