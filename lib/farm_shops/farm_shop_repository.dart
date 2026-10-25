import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../config/links.dart';
import 'farm_shop.dart';

enum FarmShopDataOrigin { network, cache, bundled }

class FarmShopLoadResult {
  final List<FarmShop> shops;
  final FarmShopDataOrigin origin;
  const FarmShopLoadResult(this.shops, this.origin);
}

/// Loads farm shops for one country from matsjekk.com, caches the raw JSON
/// on the device for offline use, and falls back to the bundled Norway
/// snapshot (assets/farmshops/) when there is neither network nor cache.
class FarmShopRepository {
  FarmShopRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _timeout = Duration(seconds: 20);
  static const _headers = {
    'User-Agent': 'Matsjekk/1.2 (com.ebors.matsjekk; +https://matsjekk.com)',
    'Accept': 'application/json',
  };

  Future<FarmShopLoadResult> load(String countryCode) async {
    final cc = countryCode.toUpperCase();
    final countryName = kFarmShopCountries[cc];

    var origin = FarmShopDataOrigin.network;
    String? baseBody = await _fetch(farmShopsCountryUrl(cc));
    if (baseBody != null) {
      await _writeCache('$cc.json', baseBody);
    } else {
      baseBody = await _readCache('$cc.json');
      origin = FarmShopDataOrigin.cache;
      if (baseBody == null && cc == 'NO') {
        baseBody = await _readAsset('assets/farmshops/no.json');
        origin = FarmShopDataOrigin.bundled;
      }
    }
    if (baseBody == null) {
      throw const FarmShopLoadException();
    }

    String? organicBody = await _fetch(kOrganicFarmShopsUrl);
    if (organicBody != null) {
      await _writeCache('organic.json', organicBody);
    } else {
      organicBody = await _readCache('organic.json') ??
          await _readAsset('assets/farmshops/organic.json');
    }

    final base = parseFarmShops(_decode(baseBody));
    var extras = organicBody == null
        ? const <FarmShop>[]
        : parseFarmShops(_decode(organicBody));
    extras = extras
        .where((s) =>
            countryName != null &&
            (s.country ?? '').toLowerCase() == countryName.toLowerCase())
        .toList();
    final cleaned = cleanFarmShops(mergeFarmShops(base, extras));
    if (cleaned.removed > 0) {
      debugPrint('FarmShops[$cc]: removed ${cleaned.removed} entries '
          '(${cleaned.droppedNonFarm.length} non-farm, '
          '${cleaned.duplicatesRemoved} duplicates)');
      for (final d in cleaned.droppedNonFarm) {
        debugPrint('FarmShops[$cc]: dropped non-farm entry $d');
      }
    }
    return FarmShopLoadResult(cleaned.shops, origin);
  }

  dynamic _decode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return const [];
    }
  }

  Future<String?> _fetch(String url) async {
    try {
      final res =
          await _client.get(Uri.parse(url), headers: _headers).timeout(_timeout);
      if (res.statusCode != 200) return null;
      final body = utf8.decode(res.bodyBytes);
      final decoded = jsonDecode(body);
      if (decoded is! List) return null;
      return body;
    } catch (_) {
      return null;
    }
  }

  Future<Directory?> _cacheDir() async {
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}${Platform.pathSeparator}farmshops');
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String name, String body) async {
    try {
      final dir = await _cacheDir();
      if (dir == null) return;
      await File('${dir.path}${Platform.pathSeparator}$name')
          .writeAsString(body, flush: true);
    } catch (_) {}
  }

  Future<String?> _readCache(String name) async {
    try {
      final dir = await _cacheDir();
      if (dir == null) return null;
      final f = File('${dir.path}${Platform.pathSeparator}$name');
      if (!await f.exists()) return null;
      return await f.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _readAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (_) {
      return null;
    }
  }
}

class FarmShopLoadException implements Exception {
  const FarmShopLoadException();
}
