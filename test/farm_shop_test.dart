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

  group('farm shop cleanup', () {
    test('repairs cp1252 mojibake such as "Ã˜"', () {
      expect(repairMojibake('Ã˜yens Hjemmebakeri AS'), 'Øyens Hjemmebakeri AS');
      expect(repairMojibake('Bakken Ã˜vre GÃ¥rdsmat'), 'Bakken Øvre Gårdsmat');
      expect(repairMojibake('KjÃ¸tt'), 'Kjøtt');
      // Mixed correct text and mojibake.
      expect(repairMojibake('Åsen GÃ¥rd'), 'Åsen Gård');
      // Correct text is left alone.
      expect(repairMojibake('Øyens Hjemmebakeri AS'), 'Øyens Hjemmebakeri AS');
      expect(repairMojibake('Straße Café Ändern'), 'Straße Café Ändern');
    });

    test('drops obvious alcohol retail but keeps producers', () {
      final shops = parseFarmShops([
        {
          'id': 'b',
          'name': 'Booze of Norway AS',
          'products': ['Alkoholholdige drikker'],
          'lat': 59.8276,
          'lon': 10.4347,
        },
        {'id': 'l', 'name': 'Local Liquor', 'lat': -33.0, 'lon': 151.0},
        {'id': 's', 'name': 'Systembolaget', 'lat': 59.3, 'lon': 18.0},
        {
          'id': 'k',
          'name': 'Some Shop',
          'category': 'Liquor store',
          'lat': 50.0,
          'lon': 8.0,
        },
        {
          'id': 'br',
          'name': 'Ekeby Gårdsbryggeri',
          'products': ['Alkoholholdige drikker'],
          'lat': 59.0,
          'lon': 10.0,
        },
        {'id': 'it', 'name': 'Liquorificio L\'alambicco', 'lat': 45.0, 'lon': 9.0},
        {'id': 'a', 'name': 'Aaby Gård', 'lat': 59.84, 'lon': 10.46},
        {'id': 'd', 'name': 'Sun Liquor Distillery', 'lat': 47.6, 'lon': -122.3},
      ]);
      final res = cleanFarmShops(shops);
      expect(res.droppedNonFarm.length, 4);
      expect(res.shops.map((s) => s.name), [
        'Ekeby Gårdsbryggeri',
        'Liquorificio L\'alambicco',
        'Aaby Gård',
        'Sun Liquor Distillery',
      ]);
    });

    test('dedupes same normalised name within 200 m, after mojibake repair',
        () {
      final shops = parseFarmShops([
        {'id': 1, 'name': 'Bergvang gårdsbutikk', 'lat': 59.8502, 'lon': 10.4122},
        {
          'id': 2,
          'name': 'Bergvang GÃ¥rdsbutikk',
          'website': 'https://bergvang.no',
          'lat': 59.8505,
          'lon': 10.4125,
        },
        {'id': 3, 'name': 'Ã˜yens Hjemmebakeri AS', 'lat': 60.0, 'lon': 11.0},
        {'id': 4, 'name': 'Øyens hjemmebakeri AS', 'lat': 60.0005, 'lon': 11.0},
        // Same name but far away: a different shop.
        {'id': 5, 'name': 'Bergvang gårdsbutikk', 'lat': 63.0, 'lon': 10.0},
      ]);
      final res = cleanFarmShops(shops);
      expect(res.duplicatesRemoved, 2);
      expect(res.shops.length, 3);
      expect(res.shops.first.website, 'https://bergvang.no');
      expect(res.shops[1].name, 'Øyens Hjemmebakeri AS');
    });

    test('published Norway data has no Booze, mojibake or Bergvang duplicate',
        () {
      final raw =
          File('docs/data/farmshops_by_country/no.json').readAsStringSync();
      final res = cleanFarmShops(parseFarmShops(jsonDecode(raw)));
      final names = res.shops.map((s) => s.name).toList();
      expect(names.where((n) => n.toLowerCase().contains('booze')), isEmpty);
      expect(names.where(hasMojibake), isEmpty);
      expect(
          names.where((n) => n.toLowerCase() == 'bergvang gårdsbutikk').length,
          1);
    });
  });
}
