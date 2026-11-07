import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ad_helper.dart';
import '../config/links.dart';
import '../premium_service.dart';
import 'farm_shop.dart';
import 'farm_shop_repository.dart';
import 'farm_shop_strings.dart';

const String _kFarmShopsCountryKey = 'farmShopsCountry';
const String _kLocationAskedKey = 'farmShopsLocationAsked';
const int _kMaxMarkers = 600;

/// Opens the native farm shop screen, reading country and ad state from the
/// app's settings box when the caller does not provide them.
Future<void> openFarmShopsScreen(
  BuildContext context, {
  String? countryCode,
  bool? showAds,
}) {
  Box? settings;
  if (Hive.isBoxOpen('innstillinger')) settings = Hive.box('innstillinger');
  final adsRemoved =
      settings?.get(PremiumService.premiumActiveKey, defaultValue: false) ==
          true;
  final country = countryCode ??
      (settings?.get('selectedCountry', defaultValue: 'NO') as String? ?? 'NO');
  return Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => FarmShopsScreen(
      countryCode: country,
      showAds: showAds ?? !adsRemoved,
    ),
  ));
}

class FarmShopsScreen extends StatefulWidget {
  const FarmShopsScreen({
    super.key,
    required this.countryCode,
    this.showAds = true,
    this.repository,
  });

  final String countryCode;
  final bool showAds;
  final FarmShopRepository? repository;

  @override
  State<FarmShopsScreen> createState() => _FarmShopsScreenState();
}

class _FarmShopsScreenState extends State<FarmShopsScreen> {
  late final FarmShopRepository _repo =
      widget.repository ?? FarmShopRepository();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  late String _country;
  List<FarmShop> _all = const [];
  List<_ShopWithDistance> _visible = const [];
  bool _loading = true;
  bool _loadFailed = false;
  FarmShopDataOrigin? _origin;
  bool _organicOnly = false;
  String _query = '';

  LatLng? _userPos;
  LatLng? _reference; // point the list is sorted from
  bool _referenceIsUser = false;
  bool _mapReady = false;
  bool _locating = false;

  BannerAd? _banner;
  bool _bannerLoaded = false;

  bool get _isTestEnv => Platform.environment.containsKey('FLUTTER_TEST');

  Box? get _settings =>
      Hive.isBoxOpen('innstillinger') ? Hive.box('innstillinger') : null;

  @override
  void initState() {
    super.initState();
    final saved = _settings?.get(_kFarmShopsCountryKey) as String?;
    final requested = widget.countryCode.toUpperCase();
    _country = kFarmShopCountries.containsKey(saved)
        ? saved!
        : (kFarmShopCountries.containsKey(requested) ? requested : 'NO');
    _reference = _countryCentre(_country);
    _load();
    if (widget.showAds && !_isTestEnv && !kScreenshotMode) _loadBanner();
    if (!_isTestEnv) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _banner?.dispose();
    super.dispose();
  }

  void _loadBanner() {
    _banner = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _bannerLoaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _banner = null;
          if (mounted) setState(() => _bannerLoaded = false);
        },
      ),
    )..load();
  }

  LatLng _countryCentre(String cc) {
    final c = kCountryCentres[cc];
    if (c != null) return LatLng(c[0], c[1]);
    if (_all.isNotEmpty) {
      final lat = _all.map((s) => s.lat).reduce((a, b) => a + b) / _all.length;
      final lon = _all.map((s) => s.lon).reduce((a, b) => a + b) / _all.length;
      return LatLng(lat, lon);
    }
    return const LatLng(61.5, 9.5);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final result = await _repo.load(_country);
      if (!mounted) return;
      _all = result.shops;
      _origin = result.origin;
      if (_userPos == null) {
        _reference = _countryCentre(_country);
        _referenceIsUser = false;
        _moveMap(_reference!, 5.5);
      }
      _recompute();
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadFailed = true;
      });
    }
  }

  void _recompute() {
    final q = _query.trim().toLowerCase();
    final ref = _reference ?? _countryCentre(_country);
    final out = <_ShopWithDistance>[];
    for (final s in _all) {
      if (_organicOnly && !s.organic) continue;
      if (q.isNotEmpty && !s.searchText.contains(q)) continue;
      out.add(_ShopWithDistance(
          s, distanceKm(ref.latitude, ref.longitude, s.lat, s.lon)));
    }
    out.sort((a, b) => a.km.compareTo(b.km));
    _visible = out;
  }

  void _moveMap(LatLng to, double zoom) {
    if (!_mapReady) return;
    try {
      _mapController.move(to, zoom);
    } catch (_) {}
  }

  // ---------- location ----------

  Future<void> _initLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {
        await _locate(silent: true);
        return;
      }
      final asked = _settings?.get(_kLocationAskedKey, defaultValue: false);
      if (perm == LocationPermission.denied && asked != true && mounted) {
        await _askForLocation();
      }
    } catch (_) {}
  }

  Future<void> _askForLocation() async {
    final s = FarmShopStrings.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.location_on_outlined),
        title: Text(s.locationTitle),
        content: Text(s.locationBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(s.notNow)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(s.allow)),
        ],
      ),
    );
    _settings?.put(_kLocationAskedKey, true);
    if (ok == true) {
      await _locate();
    } else if (mounted) {
      _snack(s.locationDenied);
    }
  }

  Future<void> _locate({bool silent = false}) async {
    final s = FarmShopStrings.of(context);
    if (_locating) return;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!silent) {
          _snackWithSettings(s.locationServiceOff, appSettings: false);
        }
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        if (!silent) {
          _snackWithSettings(s.locationDeniedForever, appSettings: true);
        }
        return;
      }
      if (perm == LocationPermission.denied) {
        if (!silent) _snackWithSettings(s.locationDenied, appSettings: true);
        return;
      }
      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }
      if (!mounted) return;
      if (pos == null) {
        if (!silent) {
          _snackWithSettings(s.locationUnavailable, appSettings: false);
        }
        return;
      }
      final here = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _userPos = here;
        _reference = here;
        _referenceIsUser = true;
        _recompute();
      });
      _moveMap(here, 10);
    } catch (_) {
      if (!silent) {
        _snackWithSettings(s.locationUnavailable, appSettings: false);
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _sortFromMapCentre() {
    if (!_mapReady) return;
    setState(() {
      _reference = _mapController.camera.center;
      _referenceIsUser = false;
      _recompute();
    });
  }

  // ---------- actions ----------

  /// Location problem message with a shortcut to the relevant settings page
  /// (app permissions or the phone's location settings).
  void _snackWithSettings(String msg, {required bool appSettings}) {
    if (!mounted) return;
    final s = FarmShopStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(
        label: s.openSettings,
        onPressed: () {
          if (appSettings) {
            Geolocator.openAppSettings();
          } else {
            Geolocator.openLocationSettings();
          }
        },
      ),
    ));
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _open(Uri uri) async {
    final s = FarmShopStrings.of(context);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) _snack(s.couldNotOpen);
    } catch (_) {
      _snack(s.couldNotOpen);
    }
  }

  Uri _directionsUri(FarmShop shop) {
    final dest = '${shop.lat},${shop.lon}';
    if (Platform.isIOS) {
      return Uri.parse(
          'https://maps.apple.com/?daddr=$dest&q=${Uri.encodeComponent(shop.name)}');
    }
    return Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$dest');
  }

  void _changeCountry(String cc) {
    if (cc == _country) return;
    _settings?.put(_kFarmShopsCountryKey, cc);
    setState(() {
      _country = cc;
      _all = const [];
      _visible = const [];
      if (_userPos == null) _reference = _countryCentre(cc);
    });
    if (_userPos == null) _moveMap(_countryCentre(cc), 5.5);
    _load();
  }

  void _showShop(FarmShop shop, double? km) {
    final s = FarmShopStrings.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(shop.name,
                          style: Theme.of(ctx).textTheme.titleLarge),
                    ),
                    if (shop.organic) _OrganicBadge(label: s.organic),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place_outlined, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(shop.displayAddress.isNotEmpty
                          ? shop.displayAddress
                          : s.noAddress),
                    ),
                    if (km != null) Text(s.distance(km)),
                  ],
                ),
                if (shop.category != null) ...[
                  const SizedBox(height: 6),
                  Text(shop.category!,
                      style: Theme.of(ctx).textTheme.bodySmall),
                ],
                if (shop.products.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(s.sells,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: shop.products
                        .map((p) => Chip(
                              label: Text(p),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _open(_directionsUri(shop)),
                      icon: const Icon(Icons.directions),
                      label: Text(s.directions),
                    ),
                    if (shop.website != null)
                      OutlinedButton.icon(
                        onPressed: () => _open(Uri.parse(shop.website!)),
                        icon: const Icon(Icons.language),
                        label: Text(s.website),
                      ),
                    if (shop.phone != null)
                      OutlinedButton.icon(
                        onPressed: () => _open(Uri(
                            scheme: 'tel',
                            path: shop.phone!
                                .replaceAll(RegExp(r'[^0-9+]'), ''))),
                        icon: const Icon(Icons.call),
                        label: Text(s.call),
                      ),
                    if (shop.source != null && shop.source != shop.website)
                      TextButton.icon(
                        onPressed: () => _open(Uri.parse(shop.source!)),
                        icon: const Icon(Icons.info_outline),
                        label: Text(s.source),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(s.dataNote, style: Theme.of(ctx).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _focusShop(_ShopWithDistance item) {
    _moveMap(LatLng(item.shop.lat, item.shop.lon), 13);
    _showShop(item.shop, _referenceIsUser ? item.km : null);
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final s = FarmShopStrings.of(context);
    final hasOrganic = _all.any((x) => x.organic);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(s.title),
        actions: [
          PopupMenuButton<String>(
            tooltip: s.country,
            icon: Text(countryFlag(_country),
                style: const TextStyle(fontSize: 22)),
            onSelected: _changeCountry,
            itemBuilder: (_) => kFarmShopCountries.entries
                .map((e) => CheckedPopupMenuItem<String>(
                      value: e.key,
                      checked: e.key == _country,
                      child: Text('${countryFlag(e.key)}  ${e.value}'),
                    ))
                .toList(),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'web') {
                _open(Uri.parse(
                    '$kFarmShopsWebUrl?lang=${s.languageCode}'));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'web',
                child: ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: Text(s.openWebVersion),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Same pattern as the other menu screens: ad banner at the top.
          if (widget.showAds && _bannerLoaded && _banner != null)
            SafeArea(
              bottom: false,
              child: SizedBox(
                width: _banner!.size.width.toDouble(),
                height: _banner!.size.height.toDouble(),
                child: AdWidget(ad: _banner!),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                hintText: s.searchHint,
                border: const OutlineInputBorder(),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                            _recompute();
                          });
                        },
                      ),
              ),
              onChanged: (v) {
                _searchDebounce?.cancel();
                _searchDebounce = Timer(const Duration(milliseconds: 250), () {
                  if (!mounted) return;
                  setState(() {
                    _query = v;
                    _recompute();
                  });
                });
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                if (hasOrganic)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: const Icon(Icons.eco, size: 18),
                      label: Text(s.organicOnly),
                      selected: _organicOnly,
                      onSelected: (v) => setState(() {
                        _organicOnly = v;
                        _recompute();
                      }),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    avatar: _locating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location, size: 18),
                    label: Text(s.useMyLocation),
                    onPressed: _locating ? null : () => _locate(),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.center_focus_strong, size: 18),
                  label: Text(s.sortFromMapCentre),
                  onPressed: _sortFromMapCentre,
                ),
              ],
            ),
          ),
          Expanded(flex: 5, child: _buildMap()),
          _buildStatusBar(s),
          Expanded(flex: 6, child: _buildList(s)),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final markers = <Marker>[
      for (final item in _visible.take(_kMaxMarkers))
        Marker(
          point: LatLng(item.shop.lat, item.shop.lon),
          width: 34,
          height: 34,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => _showShop(item.shop, _referenceIsUser ? item.km : null),
            child: Icon(
              Icons.location_on,
              size: 34,
              color: item.shop.organic
                  ? Colors.green.shade800
                  : Colors.deepOrange.shade700,
              shadows: const [Shadow(blurRadius: 3, color: Colors.black26)],
            ),
          ),
        ),
      if (_userPos != null)
        Marker(
          point: _userPos!,
          width: 22,
          height: 22,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(blurRadius: 4, color: Colors.black26)
              ],
            ),
          ),
        ),
    ];
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _reference ?? _countryCentre(_country),
        initialZoom: 5.5,
        minZoom: 3,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: () {
          _mapReady = true;
          final target = _userPos ?? _reference;
          if (target != null) {
            _moveMap(target, _userPos != null ? 10 : 5.5);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ebors.matsjekk',
          maxNativeZoom: 19,
        ),
        MarkerLayer(markers: markers),
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => _open(Uri.parse(kOsmCopyrightUrl)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(FarmShopStrings s) {
    final theme = Theme.of(context);
    String text;
    if (_loading) {
      text = s.loading;
    } else if (_loadFailed) {
      text = s.loadError;
    } else {
      text =
          '${s.shopCount(_visible.length)} · ${_referenceIsUser ? s.sortedFromYou : s.sortedFromCentre}';
      if (_origin == FarmShopDataOrigin.cache ||
          _origin == FarmShopDataOrigin.bundled) {
        text = '$text\n${s.offlineData}';
      }
    }
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
          if (_loadFailed)
            TextButton(onPressed: _load, child: Text(s.retry)),
        ],
      ),
    );
  }

  Widget _buildList(FarmShopStrings s) {
    if (_loading && _all.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_visible.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_loadFailed ? s.loadError : s.noResults,
              textAlign: TextAlign.center),
        ),
      );
    }
    return ListView.separated(
      itemCount: _visible.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final item = _visible[i];
        final shop = item.shop;
        final subtitle = [
          if (shop.displayAddress.isNotEmpty) shop.displayAddress,
          if (shop.products.isNotEmpty) shop.products.take(3).join(', '),
        ].join('\n');
        return ListTile(
          leading: Icon(shop.organic ? Icons.eco : Icons.storefront,
              color: shop.organic ? Colors.green.shade800 : Colors.brown),
          title: Text(shop.name),
          subtitle: subtitle.isEmpty
              ? null
              : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: _referenceIsUser ? Text(s.distance(item.km)) : null,
          onTap: () => _focusShop(item),
        );
      },
    );
  }
}

class _ShopWithDistance {
  final FarmShop shop;
  final double km;
  const _ShopWithDistance(this.shop, this.km);
}

class _OrganicBadge extends StatelessWidget {
  const _OrganicBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco, size: 16, color: Colors.green.shade800),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: Colors.green.shade900, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
