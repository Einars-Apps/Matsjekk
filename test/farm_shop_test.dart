import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/farm_shops/farm_shop.dart';
import 'package:mat_sjekk/farm_shops/farm_shop_strings.dart';

void main() {
  group('FarmShop.fromJson', () {
    test('parses a lokalmat entry and repairs mojibake', () {
      final shop = FarmShop.fromJson({
        'id': 'lokalmat_1',
        'name': 'Testgård',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': ['KjÃ¸tt', 'Oster', 'Oster'],
        'website': null,
        'lat': 60.6,
        'lon': 6.4,
        'address': 'Gardsvegen 1',
        'source': 'https://www.lokalmat.no/produsenter/test/',
      })!;
      expect(shop.products, ['Kjøtt', 'Oster']);
      expect(shop.displayAddress, 'Gardsvegen 1, Voss, Vestland');
      expect(shop.organic, isFalse);
      expect(shop.source, startsWith('https://www.lokalmat.no'));
    });

    test('detects organic Debio entries and drops bogus websites', () {
      final shop = FarmShop.fromJson({
        'id': 'organic_debio_1',
        'name': 'Alby gård',
        'products': [
          'Salgskanal: Gårdsutsalg',
          'Sertifisering: Ø-merket / Økologisk'
        ],
        'website': 'https://True',
        'lat': 59.15,
        'lon': 10.35,
        'category': 'Økologisk gårdsbutikk',
      })!;
      expect(shop.organic, isTrue);
      expect(shop.website, isNull);
      expect(shop.products.first, 'Gårdsutsalg');
    });

    test('skips entries without coordinates', () {
      expect(FarmShop.fromJson({'name': 'X', 'lat': null, 'lon': 5}), isNull);
      expect(FarmShop.fromJson({'name': '', 'lat': 1, 'lon': 5}), isNull);
    });
  });

  test('distanceKm Oslo–Bergen is about 305 km', () {
    final d = distanceKm(59.9139, 10.7522, 60.3913, 5.3221);
    expect(d, greaterThan(295));
    expect(d, lessThan(315));
  });

  test('mergeFarmShops dedupes same name nearby and keeps organic flag', () {
    final base = parseFarmShops([
      {'id': 1, 'name': 'Alby Gård', 'lat': 59.1558, 'lon': 10.3532},
      {'id': 2, 'name': 'Other', 'lat': 60.0, 'lon': 10.0},
    ]);
    final extras = parseFarmShops([
      {
        'id': 'o1',
        'name': 'Alby gård',
        'lat': 59.1557,
        'lon': 10.3533,
        'category': 'Økologisk gårdsbutikk'
      },
      {'id': 'o2', 'name': 'Far away organic', 'lat': 63.0, 'lon': 10.0},
    ]);
    final merged = mergeFarmShops(base, extras);
    expect(merged.length, 3);
    expect(merged.first.organic, isTrue);
  });

  test('bundled Norway snapshot parses', () {
    final raw = File('assets/farmshops/no.json').readAsStringSync();
    final shops = parseFarmShops(jsonDecode(raw));
    expect(shops.length, greaterThan(1000));
  });

  test('every language defines every farm shop string', () {
    final values = FarmShopStrings.allValues;
    final keys = values['en']!.keys.toSet();
    for (final lang in FarmShopStrings.supportedLanguages) {
      expect(values[lang], isNotNull, reason: lang);
      expect(values[lang]!.keys.toSet(), keys, reason: lang);
    }
  });
}
