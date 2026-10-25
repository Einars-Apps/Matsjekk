import 'dart:convert';
import 'dart:math' as math;

/// A single farm shop / local food producer as published in
/// docs/data/farmshops_by_country/<cc>.json and
/// docs/data/organic_farmshops.json on matsjekk.com.
class FarmShop {
  final String id;
  final String name;
  final String? country;
  final String? region;
  final String? municipality;
  final String? address;
  final String? website;
  final String? phone;
  final String? source;
  final String? category;
  final List<String> products;
  final double lat;
  final double lon;
  final bool organic;

  const FarmShop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.country,
    this.region,
    this.municipality,
    this.address,
    this.website,
    this.phone,
    this.source,
    this.category,
    this.products = const [],
    this.organic = false,
  });

  /// Parses one entry. Returns null when the entry lacks a name or valid
  /// coordinates (those cannot be shown on a map or sorted by distance).
  static FarmShop? fromJson(Map<String, dynamic> json) {
    final name = cleanText(json['name']);
    final lat = _toDouble(json['lat'] ?? json['latitude']);
    final lon = _toDouble(json['lon'] ?? json['lng'] ?? json['longitude']);
    if (name == null || lat == null || lon == null) return null;
    if (lat.abs() > 90 || lon.abs() > 180 || (lat == 0 && lon == 0)) {
      return null;
    }
    final rawProducts = json['products'];
    final products = <String>[];
    if (rawProducts is List) {
      for (final p in rawProducts) {
        final text = cleanProduct(p);
        if (text != null && !products.contains(text)) products.add(text);
      }
    }
    final category = cleanText(json['category']);
    final website = sanitizeWebsite(json['website'] ?? json['url']);
    final phone = sanitizePhone(json['phone'] ?? json['telephone']);
    final source = sanitizeWebsite(json['source']);
    final organic = isOrganicText([
      name,
      category ?? '',
      ...products,
      if (rawProducts is List) ...rawProducts.map((e) => '$e'),
    ].join(' '));
    return FarmShop(
      id: '${json['id'] ?? '$name|$lat|$lon'}',
      name: name,
      lat: lat,
      lon: lon,
      country: cleanText(json['country']),
      region: cleanText(json['region']),
      municipality: cleanText(json['municipality']),
      address: cleanText(json['address']),
      website: website,
      phone: phone,
      source: source,
      category: category,
      products: products,
      organic: organic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
        'region': region,
        'municipality': municipality,
        'address': address,
        'website': website,
        'phone': phone,
        'source': source,
        'category': category,
        'products': products,
        'lat': lat,
        'lon': lon,
        if (organic) 'organic': true,
      };

  /// "Street 1, Municipality, Region" – skipping missing/duplicate parts.
  String get displayAddress {
    final parts = <String>[];
    for (final p in [address, municipality, region]) {
      if (p == null || p.isEmpty) continue;
      if (parts.any((e) => e.toLowerCase() == p.toLowerCase())) continue;
      parts.add(p);
    }
    return parts.join(', ');
  }

  /// Lower-cased text used by the search field.
  String get searchText => [
        name,
        address ?? '',
        municipality ?? '',
        region ?? '',
        category ?? '',
        ...products,
      ].join(' ').toLowerCase();

  FarmShop mergedWith(FarmShop other) => FarmShop(
        id: id,
        name: name,
        lat: lat,
        lon: lon,
        country: country ?? other.country,
        region: region ?? other.region,
        municipality: municipality ?? other.municipality,
        address: address ?? other.address,
        website: website ?? other.website,
        phone: phone ?? other.phone,
        source: source ?? other.source,
        category: category ?? other.category,
        products: [
          ...products,
          ...other.products.where((p) => !products.contains(p)),
        ],
        organic: organic || other.organic,
      );
}

double? _toDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.trim());
  return null;
}

/// Repairs common UTF-8-read-as-Latin-1 mojibake ("KjÃ¸tt" -> "Kjøtt").
String repairMojibake(String input) {
  if (!input.contains('Ã') && !input.contains('Â')) return input;
  try {
    return utf8.decode(latin1.encode(input));
  } catch (_) {
    return input;
  }
}

String? cleanText(dynamic v) {
  if (v == null) return null;
  final s = repairMojibake('$v').replaceAll(RegExp(r'\s+'), ' ').trim();
  if (s.isEmpty || s.toLowerCase() == 'null') return null;
  return s;
}

/// Turns "Salgskanal: Gårdsutsalg" into "Gårdsutsalg".
String? cleanProduct(dynamic v) {
  final s = cleanText(v);
  if (s == null) return null;
  final idx = s.indexOf(':');
  if (idx > 0 && idx < 20 && idx < s.length - 1) {
    return s.substring(idx + 1).trim();
  }
  return s;
}

String? sanitizeWebsite(dynamic v) {
  final s = cleanText(v);
  if (s == null) return null;
  var candidate = s;
  if (!candidate.startsWith(RegExp(r'https?://', caseSensitive: false))) {
    if (!candidate.contains('.') || candidate.contains(' ')) return null;
    candidate = 'https://$candidate';
  }
  final uri = Uri.tryParse(candidate);
  if (uri == null || uri.host.isEmpty || !uri.host.contains('.')) return null;
  final host = uri.host.toLowerCase();
  if (host == 'true' || host == 'false' || host == 'null') return null;
  return candidate;
}

String? sanitizePhone(dynamic v) {
  final s = cleanText(v);
  if (s == null) return null;
  final digits = s.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.replaceAll('+', '').length < 5) return null;
  return s;
}

const List<String> _organicMarkers = [
  'økolog',
  'okolog',
  'ökolog',
  'ekolog',
  'organic',
  'debio',
  'ø-merk',
  'biodynam',
  'demeter',
  'luomu',
  'biologi',
  'biológ',
  'agriculture biologique',
];

bool isOrganicText(String text) {
  final t = text.toLowerCase();
  return _organicMarkers.any(t.contains);
}

/// Great-circle distance in kilometres.
double distanceKm(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(lat2 - lat1);
  final dLon = rad(lon2 - lon1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(rad(lat1)) *
          math.cos(rad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  return 2 * r * math.asin(math.min(1, math.sqrt(a)));
}

/// Parses a JSON array payload into shops, skipping unusable rows.
List<FarmShop> parseFarmShops(dynamic payload) {
  if (payload is! List) return const [];
  final out = <FarmShop>[];
  for (final row in payload) {
    if (row is Map) {
      final shop = FarmShop.fromJson(Map<String, dynamic>.from(row));
      if (shop != null) out.add(shop);
    }
  }
  return out;
}

String _normName(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9æøåäöüéèáàíóúñç]'), '');

/// Merges [extras] (e.g. the Debio organic list) into [base]. Entries with the
/// same normalised name within 1 km are treated as the same shop.
List<FarmShop> mergeFarmShops(List<FarmShop> base, List<FarmShop> extras) {
  final result = List<FarmShop>.from(base);
  final byName = <String, List<int>>{};
  for (var i = 0; i < result.length; i++) {
    byName.putIfAbsent(_normName(result[i].name), () => []).add(i);
  }
  for (final extra in extras) {
    final key = _normName(extra.name);
    final candidates = byName[key] ?? const <int>[];
    int? match;
    for (final i in candidates) {
      final s = result[i];
      if (distanceKm(s.lat, s.lon, extra.lat, extra.lon) < 1.0) {
        match = i;
        break;
      }
    }
    if (match != null) {
      result[match] = result[match].mergedWith(extra);
    } else {
      byName.putIfAbsent(key, () => []).add(result.length);
      result.add(extra);
    }
  }
  return result;
}

/// Country slices published under docs/data/farmshops_by_country/.
/// Value is the English country name used in the data's "country" field.
const Map<String, String> kFarmShopCountries = {
  'NO': 'Norway',
  'SE': 'Sweden',
  'DK': 'Denmark',
  'FI': 'Finland',
  'IS': 'Iceland',
  'DE': 'Germany',
  'NL': 'Netherlands',
  'BE': 'Belgium',
  'LU': 'Luxembourg',
  'FR': 'France',
  'IT': 'Italy',
  'ES': 'Spain',
  'PT': 'Portugal',
  'GB': 'United Kingdom',
  'IE': 'Ireland',
  'AT': 'Austria',
  'CH': 'Switzerland',
  'LI': 'Liechtenstein',
  'PL': 'Poland',
  'CZ': 'Czechia',
  'SK': 'Slovakia',
  'HU': 'Hungary',
  'SI': 'Slovenia',
  'HR': 'Croatia',
  'BA': 'Bosnia and Herzegovina',
  'RS': 'Serbia',
  'ME': 'Montenegro',
  'MK': 'North Macedonia',
  'AL': 'Albania',
  'GR': 'Greece',
  'CY': 'Cyprus',
  'BG': 'Bulgaria',
  'RO': 'Romania',
  'EE': 'Estonia',
  'LV': 'Latvia',
  'LT': 'Lithuania',
  'US': 'United States',
  'CA': 'Canada',
  'AU': 'Australia',
  'NZ': 'New Zealand',
  'AR': 'Argentina',
  'BR': 'Brazil',
  'CL': 'Chile',
  'CO': 'Colombia',
  'EC': 'Ecuador',
  'PE': 'Peru',
  'BO': 'Bolivia',
  'PY': 'Paraguay',
  'UY': 'Uruguay',
  'VE': 'Venezuela',
};

/// Approximate map centre used when location permission is not granted.
const Map<String, List<double>> kCountryCentres = {
  'NO': [61.5, 9.5],
  'SE': [60.1, 15.6],
  'DK': [56.0, 10.0],
  'FI': [62.5, 25.5],
  'IS': [64.9, -18.6],
  'DE': [51.2, 10.4],
  'NL': [52.2, 5.3],
  'BE': [50.6, 4.6],
  'LU': [49.7, 6.1],
  'FR': [46.6, 2.4],
  'IT': [42.8, 12.5],
  'ES': [40.2, -3.7],
  'PT': [39.6, -8.0],
  'GB': [53.5, -1.9],
  'IE': [53.3, -7.9],
  'AT': [47.6, 14.1],
  'CH': [46.8, 8.2],
  'PL': [52.1, 19.4],
  'US': [39.8, -98.6],
  'CA': [56.1, -106.3],
  'AU': [-25.3, 133.8],
  'NZ': [-41.3, 174.0],
};

/// Regional-indicator flag emoji for a 2-letter country code.
String countryFlag(String code) {
  if (code.length != 2) return '';
  final upper = code.toUpperCase();
  return String.fromCharCodes(
      upper.codeUnits.map((c) => 0x1F1E6 + (c - 0x41)));
}
