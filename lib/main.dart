import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:wakelock_plus/wakelock_plus.dart';
import 'widgets.dart';
import 'data/risk_brands_by_country.dart';
import 'ui_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'consent.dart';
import 'analytics.dart';
import 'premium_screen.dart';
import 'premium_service.dart';

// --- DEFINISJON AV RISIKO ---
const List<String> bovaerRedBrands = ['arla', 'apetina', 'aptina'];
const List<String> bovaerYellowBrands = [
  'tine',
  'synnøve',
  'fjordland',
  'ostecompagniet',
  'q-meieriene',
  'kavli'
];
const List<String> gmoFishRedBrands = ['lerøy', 'salmar', 'mowi']; // Eksempler
const List<String> greenKeywords = [
  'økologisk',
  'organic',
  'biodynamisk',
  'debio'
];
// --- SLUTT PÅ RISIKO-DEFINISJON ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('handlelister');
  await Hive.openBox('historikk');
  await Hive.openBox('innstillinger');
  await Hive.openBox('list_positions');
  runApp(const MatvareSjekkApp());
}

// Detect when running under `flutter test` so we can avoid scheduling
// background timers/delays that keep the test harness alive.
final bool _isTestEnv = Platform.environment.containsKey('FLUTTER_TEST');

// Global navigator key for language switching
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class MatvareSjekkApp extends StatefulWidget {
  const MatvareSjekkApp({super.key});
  @override
  State<MatvareSjekkApp> createState() => _MatvareSjekkAppState();
}

class _MatvareSjekkAppState extends State<MatvareSjekkApp> {
  String _currentLanguage = 'nb';
  String _currentCountry = 'NO';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() {
    final box = Hive.box('innstillinger');
    final savedLanguage = box.get('selectedLanguage', defaultValue: 'nb');
    final savedCountry =
        box.get('selectedCountry', defaultValue: _defaultCountryCode());
    if (mounted) {
      setState(() {
        _currentLanguage = savedLanguage;
        _currentCountry = savedCountry;
      });
      // language loaded
    }
  }

  String _defaultCountryCode() {
    final locale = Platform.localeName;
    // Locale pattern like nb_NO, en_US. Fallback to NO.
    if (locale.length >= 5) {
      return locale.substring(3, 5).toUpperCase();
    }
    return 'NO';
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp build
    return MaterialApp(
      title: 'Matvare-sjekk',
      navigatorKey: _navigatorKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('nb'),
        Locale('en'),
        Locale('sv'),
        Locale('da'),
        Locale('fi'),
        Locale('de'),
        Locale('nl'),
        Locale('fr'),
        Locale('it'),
        Locale('pt'),
        Locale('es'),
      ],
      locale: Locale(_currentLanguage),
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: ScannerScreen(
          onLanguageChanged: (languageCode) {
            setState(() {
              _currentLanguage = languageCode;
            });
          },
          onCountryChanged: (countryCode) {
            setState(() {
              _currentCountry = countryCode;
            });
          },
          selectedCountry: _currentCountry),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScannerScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final Function(String) onCountryChanged;
  final String selectedCountry;

  const ScannerScreen(
      {super.key,
      required this.onLanguageChanged,
      required this.onCountryChanged,
      required this.selectedCountry});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  MobileScannerController? controller;
  late Box handlelisterBox;
  late Box historikkBox;
  late Box innstillingerBox;
  late Box listPositionsBox;

  Map<String, Offset> listPositions = {};
  bool showList = false;
  bool showFullScreenList = false;
  String activeList = 'Handleliste';
  String listBeforeGlobalHistory = 'Handleliste';
  bool _isLoading = false;
  String _lastEan = '';

  bool varselBovaer = true;
  bool varselInsekt = true;
  bool varselGmo = true;
  bool wakeLockOn = false;
  bool premiumActive = false;
  String selectedLanguage = 'nb'; // Default til norsk
  String selectedCountry = 'NO'; // Default til Norge

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Only create the real controller when not running tests.
    if (!_isTestEnv) {
      controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
    }
    handlelisterBox = Hive.box('handlelister');
    historikkBox = Hive.box('historikk');
    innstillingerBox = Hive.box('innstillinger');
    listPositionsBox = Hive.box('list_positions');
    _loadListerAndPositions();
    _loadInnstillinger();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _archiveCheckedItems();
    try {
      if (controller != null) controller!.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _archiveCheckedItems();
    }
  }

  void _archiveCheckedItems() {
    for (var listName in handlelisterBox.keys) {
      final varer = List<String>.from(
          handlelisterBox.get(listName, defaultValue: <String>[]));
      final histKey = 'historikk_$listName';
      final dynamic oldHistorikk = historikkBox.get(histKey, defaultValue: []);
      final historikk = (oldHistorikk is List &&
              oldHistorikk.isNotEmpty &&
              oldHistorikk.first is String)
          ? oldHistorikk
              .map((e) => {'name': e, 'imageUrl': ''})
              .toList()
              .cast<Map>()
          : List<Map>.from(oldHistorikk);

      final checkedItems = varer.where((v) => v.startsWith('✓ ')).toList();
      if (checkedItems.isNotEmpty) {
        final uncheckedItems = varer.where((v) => !v.startsWith('✓ ')).toList();
        final itemsToAddToHistory = checkedItems.map((item) {
          return {
            'name':
                '${DateTime.now().toLocal().toString().substring(0, 10)} – ${item.substring(2)}',
            'imageUrl': ''
          };
        });
        historikk.insertAll(0, itemsToAddToHistory);
        handlelisterBox.put(listName, uncheckedItems);
        historikkBox.put(histKey, historikk);
      }
    }
  }

  void _loadListerAndPositions() {
    setState(() {
      final listeNavn = handlelisterBox.keys.whereType<String>().toList();
      if (listeNavn.isEmpty) {
        final defaultListName = Platform.localeName.startsWith('nb') ||
                Platform.localeName.startsWith('nn')
            ? 'Handleliste'
            : 'Shopping List';
        handlelisterBox.put(defaultListName, []);
        listeNavn.add(defaultListName);
      }

      // Clean up accidental 'Finn gårdsbutikk' / 'Gårdsbutikker' entries
      // in shopping lists that may have been added erroneously.
      for (var navn in listeNavn) {
        try {
          final current = List<String>.from(
              handlelisterBox.get(navn, defaultValue: <String>[]));
          final cleaned = current.where((item) {
            final s = item.toString().toLowerCase();
            return !(s.contains('gårds') || s.contains('gards'));
          }).toList();
          if (cleaned.length != current.length) {
            handlelisterBox.put(navn, cleaned);
          }
        } catch (_) {}
      }

      final tempPositions = <String, Offset>{};
      for (var navn in listeNavn) {
        final posData = listPositionsBox.get(navn);
        if (posData != null && posData is Map) {
          tempPositions[navn] = Offset(posData['dx'], posData['dy']);
        } else {
          final randomX = 50 + Random().nextInt(250).toDouble();
          final randomY = 100 + Random().nextInt(400).toDouble();
          tempPositions[navn] = Offset(randomX, randomY);
        }
      }
      listPositions = tempPositions;

      if (!listPositions.keys.contains(activeList)) {
        activeList = listPositions.keys.isNotEmpty
            ? listPositions.keys.first
            : (Platform.localeName.startsWith('nb')
                ? 'Handleliste'
                : 'Shopping List');
      }
    });
  }

  void _loadInnstillinger() {
    varselBovaer = innstillingerBox.get('varselBovaer', defaultValue: true);
    varselGmo = innstillingerBox.get('varselGmo', defaultValue: true);
    varselInsekt = innstillingerBox.get('varselInsekt', defaultValue: true);
    wakeLockOn = innstillingerBox.get('wakeLockOn', defaultValue: false);
    selectedLanguage =
        innstillingerBox.get('selectedLanguage', defaultValue: 'nb');
    selectedCountry = innstillingerBox.get('selectedCountry',
        defaultValue: _defaultCountryCode());
    premiumActive =
      innstillingerBox.get(PremiumService.premiumActiveKey, defaultValue: false);
    WakelockPlus.toggle(enable: wakeLockOn);
  }

  // Thin wrappers that delegate to top-level safe UI helpers in `lib/ui_safe.dart`.
  void _safePop([result]) => safePop(context, result);

  Future<T?> _safeShowDialogBuilder<T>(WidgetBuilder builder,
      {bool barrierDismissible = true}) {
    return safeShowDialogBuilder<T>(context, builder,
        barrierDismissible: barrierDismissible);
  }

  void _safeSnack(String message,
          {Duration duration = const Duration(seconds: 2)}) =>
      safeSnack(context, message, duration: duration);

  String _defaultCountryCode() {
    final locale = Platform.localeName;
    if (locale.length >= 5) {
      return locale.substring(3, 5).toUpperCase();
    }
    return 'NO';
  }

  void _handleRename(String oldName, String newName) {
    final pos = listPositions[oldName];
    if (pos != null) {
      listPositionsBox.delete(oldName);
      listPositionsBox.put(newName, {'dx': pos.dx, 'dy': pos.dy});
    }
    setState(() {
      activeList = newName;
      _loadListerAndPositions();
    });
  }

  void _deleteList(String listName) {
    _safeShowDialogBuilder(
      (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.deleteListConfirmTitle ??
            'Slette listen?'),
        content: Text(AppLocalizations.of(context)?.deleteListConfirmMessage ??
            'Er du sikker? Dette vil også slette historikken for listen.'),
        actions: [
          TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Avbryt'),
              onPressed: () => _safePop()),
          TextButton(
            child: Text(AppLocalizations.of(context)?.delete ?? 'Slett',
                style: const TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                handlelisterBox.delete(listName);
                historikkBox.delete('historikk_$listName');
                listPositionsBox.delete(listName);
                if (activeList == listName) {
                  showList = false;
                }
                _loadListerAndPositions();
              });
              _safePop();
            },
          ),
        ],
      ),
    );
  }

  void _toggleWakeLock() {
    setState(() {
      wakeLockOn = !wakeLockOn;
      WakelockPlus.toggle(enable: wakeLockOn);
      innstillingerBox.put('wakeLockOn', wakeLockOn);
    });
  }

  String _farmShopsLabel(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    switch (code) {
      case 'en':
        return 'Find Farm Shops';
      case 'sv':
        return 'Hitta Gårdsbutiker';
      case 'da':
        return 'Find Gårdbutikker';
      case 'fi':
        return 'Löydä Tilamyymälät';
      case 'de':
        return 'Hofläden Finden';
      case 'nl':
        return 'Vind Boerderijwinkels';
      case 'fr':
        return 'Trouver Fermes-Boutiques';
      case 'it':
        return 'Trova Botteghe Agricole';
      case 'pt':
        return 'Encontrar Lojas de Quinta';
      case 'es':
        return 'Encontrar Tiendas de Granja';
      case 'nb':
      default:
        return 'Finn Gårdsbutikker';
    }
  }

  Uri _farmShopsUri(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    return Uri.parse('https://matsjekk.com/gardsbutikker.html?lang=$code');
  }

  Future<void> _openFarmShops() async {
    final uri = _farmShopsUri(context);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      safeSnack(context, 'Kunne ikke åpne lenken');
    }
  }

  String _howAppWorksText(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    if (code == 'nb') {
      return '1. Skann strekkoden på varen.\n'
          '2. Appen henter produktdata fra Open Food Facts.\n'
          '3. Varsler vurderes mot interne merkevare- og ingrediensregler.\n'
          '4. Du får en enkel visning av risiko og kan lagre varer i handlelisten.';
    }
    return '1. Scan the product barcode.\n'
        '2. The app fetches product data from Open Food Facts.\n'
        '3. Alerts are evaluated against internal brand and ingredient rules.\n'
        '4. You get a simple risk view and can save items to your shopping list.';
  }

  String _regionalNewsLabel(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    switch (code) {
      case 'en':
        return 'News in Your Area';
      case 'sv':
        return 'Nyheter i Ditt Område';
      case 'da':
        return 'Nyheder i Dit Område';
      case 'fi':
        return 'Uutiset Alueeltasi';
      case 'de':
        return 'Nachrichten aus Ihrer Region';
      case 'nl':
        return 'Nieuws uit Uw Regio';
      case 'fr':
        return 'Actualités de Votre Région';
      case 'it':
        return 'Notizie della Tua Zona';
      case 'pt':
        return 'Notícias da Sua Região';
      case 'es':
        return 'Noticias de Tu Zona';
      case 'nb':
      default:
        return 'Nyheter i ditt område';
    }
  }

  Uri _regionalNewsUri(BuildContext context) {
    final langCode =
        (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
            .toLowerCase();
    final countryCode =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    return Uri.parse(
        'https://matsjekk.com/index.html?lang=$langCode&country=$countryCode#news');
  }

  Future<void> _openRegionalNews() async {
    final uri = _regionalNewsUri(context);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      safeSnack(context, 'Kunne ikke åpne lenken');
    }
  }

  String _farmThemeTitle(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    switch (code) {
      case 'en':
        return 'Farm Shops & Local Food';
      case 'sv':
        return 'Gårdsbutiker & Lokal Mat';
      case 'da':
        return 'Gårdbutikker & Lokal Mad';
      case 'fi':
        return 'Tilamyymälät ja Lähiruoka';
      case 'de':
        return 'Hofläden & Regionale Lebensmittel';
      case 'nl':
        return 'Boerderijwinkels & Lokale Voeding';
      case 'fr':
        return 'Fermes-Boutiques & Alimentation Locale';
      case 'it':
        return 'Botteghe Agricole e Cibo Locale';
      case 'pt':
        return 'Lojas de Quinta e Alimentação Local';
      case 'es':
        return 'Tiendas de Granja y Comida Local';
      case 'nb':
      default:
        return 'Gårdsbutikker og lokalmat';
    }
  }

  String _farmThemeBody(BuildContext context) {
    final code = (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
    switch (code) {
      case 'en':
        return 'Find nearby farm shops, follow regional updates, and see what products people scan most in your area. This feature is beta and improves continuously.';
      case 'nb':
      default:
        return 'Finn gårdsbutikker i nærheten, følg regionale oppdateringer og se hvilke produkter folk scanner mest i ditt område. Denne funksjonen er i beta og forbedres fortløpende.';
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null || _isLoading) return;
    final ean = barcode!.rawValue!;
    if (ean == _lastEan) return;
    _lastEan = ean;

    setState(() => _isLoading = true);
    _hentInfo(ean).then((info) {
      if (info.isNotEmpty) {
        _visProduktDialog(info);
        Analytics.logEvent('scan', {'ean': ean, 'name': info['navn']});
        final histKey = 'historikk_$activeList';
        final historikk =
            List<Map>.from(historikkBox.get(histKey, defaultValue: <Map>[]));
        final entry = {
          'name':
              '${DateTime.now().toLocal().toString().substring(0, 16)} – ${info['navn']}',
          'imageUrl': info['bildeThumbUrl']
        };

        if (!historikk.any((h) => h['name'] == entry['name'])) {
          historikk.insert(0, entry);
          if (historikk.length > 100) {
            historikk.removeRange(100, historikk.length);
          }
          historikkBox.put(histKey, historikk);
        }
      } else {
        _safeSnack('Produktet ble ikke funnet i databasen.',
            duration: const Duration(seconds: 2));
      }
    }).whenComplete(() {
      setState(() => _isLoading = false);
      if (!_isTestEnv) {
        Future.delayed(const Duration(seconds: 3), () => _lastEan = '');
      }
    });
  }

  Future<Map<String, dynamic>> _hentInfo(String ean) async {
    final sources = _getSourcesForCountry(
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase());
    for (final source in sources) {
      final result = await source(ean);
      if (result.isNotEmpty) return result;
    }
    return {};
  }

  List<Future<Map<String, dynamic>> Function(String ean)> _getSourcesForCountry(
      String countryCode) {
    // Only OpenFoodFacts implemented now, but structure allows future sources per land.
    final openFoodFacts = _fetchFromOpenFoodFacts;
    final Map<String, List<Future<Map<String, dynamic>> Function(String ean)>>
        prioritized = {
      'NO': [openFoodFacts],
      'SE': [openFoodFacts],
      'DK': [openFoodFacts],
      'FI': [openFoodFacts],
      'DE': [openFoodFacts],
      'NL': [openFoodFacts],
      'FR': [openFoodFacts],
      'IT': [openFoodFacts],
      'PT': [openFoodFacts],
      'ES': [openFoodFacts],
      'GB': [openFoodFacts],
      'IE': [openFoodFacts],
      'BE': [openFoodFacts],
      'AT': [openFoodFacts],
      'CH': [openFoodFacts],
      'LU': [openFoodFacts],
    };
    return prioritized[countryCode] ?? [openFoodFacts];
  }

  Future<Map<String, dynamic>> _fetchFromOpenFoodFacts(String ean) async {
    try {
      final uri = Uri.parse(
          'https://world.openfoodfacts.org/api/v2/product/$ean.json?fields=product_name,brands,labels,ingredients_text,ingredients_text_no,image_front_url,nutriscore_grade,additives_tags,categories,image_front_thumb_url');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          final ingredients = product['ingredients_text_no'] ??
              product['ingredients_text'] ??
              '';
          final eStofferFraTags =
              (product['additives_tags'] as List<dynamic>? ?? [])
                  .map((e) => e.toString().replaceAll('en:', '').toUpperCase())
                  .toList();
          final eStofferFraTekst = _parseEStoffer(ingredients);
          final allEStoffer =
              {...eStofferFraTags, ...eStofferFraTekst}.toList();

          Map<String, dynamic> info = {
            'navn': product['product_name'] ?? 'Ukjent navn',
            'merke': product['brands'] ?? '',
            'etiketter': product['labels'] ?? '',
            'kategorier': product['categories'] ?? '',
            'ingredienser': ingredients.isEmpty ? 'Ingen info' : ingredients,
            'bildeUrl': product['image_front_url'] ?? '',
            'bildeThumbUrl': product['image_front_thumb_url'] ?? '',
            'nutriscore':
                (product['nutriscore_grade'] ?? 'ukjent').toUpperCase(),
            'eStoffer': allEStoffer,
          };
            final bovaerAssessment =
              _analyzeBovaerRiskWithText(info['merke']!, info['etiketter']!);
            info['bovaerRisk'] = bovaerAssessment['risk'] as RiskLevel;
            info['bovaerRiskText'] = bovaerAssessment['text'] as String;
              info['bovaerRiskUrl'] = (bovaerAssessment['url'] ?? '').toString();
          info['gmoRisk'] =
              _analyzeGmoRisk(info['merke']!, info['kategorier']!);
          return info;
        }
      }
    } catch (e) {
      debugPrint('Feil ved henting av produktinfo: $e');
    }
    return {};
  }

  void _visProduktDialog(Map<String, dynamic> info) {
    _safeShowDialogBuilder(
      (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: ProductInfoDialogContent(
            info: info,
            onAddItem: (itemName) {
              final listToAddTo = activeList == '_global_'
                  ? listBeforeGlobalHistory
                  : activeList;
              final box = Hive.box('handlelister');
              final list = List<String>.from(
                  box.get(listToAddTo, defaultValue: <String>[]));
              if (!list.any((item) => item.endsWith(itemName))) {
                list.insert(0, itemName);
                box.put(listToAddTo, list);
                _safeSnack('"$itemName" lagt til i $listToAddTo',
                    duration: const Duration(seconds: 2));
                Analytics.logEvent('add_to_list',
                    {'item': itemName, 'list': listToAddTo});
              }
            }),
        actions: [
          TextButton(onPressed: () => _safePop(), child: const Text('Lukk'))
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _visMeny() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.8,
          child: ListView(
            children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)?.language ?? 'Language'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder(
                (context) => StatefulBuilder(
                  builder: (context, setDialogState) => AlertDialog(
                    title: Text(AppLocalizations.of(context)?.selectLanguage ??
                        'Select Language'),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      _languageTile(
                          AppLocalizations.of(context)?.norwegian ??
                              'Norwegian',
                          'nb',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.english ?? 'English',
                          'en',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.swedish ?? 'Swedish',
                          'sv',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.danish ?? 'Danish',
                          'da',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.finnish ?? 'Finnish',
                          'fi',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.german ?? 'German',
                          'de',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.dutch ?? 'Dutch',
                          'nl',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.french ?? 'French',
                          'fr',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.italian ?? 'Italian',
                          'it',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.portuguese ??
                              'Portuguese',
                          'pt',
                          setDialogState),
                      _languageTile(
                          AppLocalizations.of(context)?.spanish ?? 'Spanish',
                          'es',
                          setDialogState),
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () => _safePop(),
                          child: const Text('Lukk'))
                    ],
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Land / datakilder'),
            onTap: () {
              _safePop();
              _visLandDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title:
                Text(AppLocalizations.of(context)?.alerts ?? 'Select Alerts'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder(
                (context) => StatefulBuilder(
                  builder: (context, setDialogState) => AlertDialog(
                    title: Text(AppLocalizations.of(context)?.alerts ??
                        'Select Alerts'),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      SwitchListTile(
                          title: Text(
                              AppLocalizations.of(context)?.bovaerAlert ??
                                  'Bovaer Alert'),
                          value: varselBovaer,
                          onChanged: (v) {
                            setDialogState(() => varselBovaer = v);
                            innstillingerBox.put('varselBovaer', v);
                          }),
                      SwitchListTile(
                          title: Text(
                              AppLocalizations.of(context)?.gmoFishAlert ??
                                  'GMO Fish Alert'),
                          value: varselGmo,
                          onChanged: (v) {
                            setDialogState(() => varselGmo = v);
                            innstillingerBox.put('varselGmo', v);
                          }),
                      SwitchListTile(
                          title: Text(
                              AppLocalizations.of(context)?.insectMealAlert ??
                                  'Insect Meal Alert'),
                          value: varselInsekt,
                          onChanged: (v) {
                            setDialogState(() => varselInsekt = v);
                            innstillingerBox.put('varselInsekt', v);
                          }),
                    ]),
                    actions: [
                      TextButton(
                          onPressed: () => _safePop(),
                          child: const Text('Lukk'))
                    ],
                  ),
                ),
              ).then((_) => setState(() {}));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(AppLocalizations.of(context)?.howAppWorks ??
                'How the App Works'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder((_) => AlertDialog(
                      title: Text(AppLocalizations.of(context)?.howAppWorks ??
                          'How the App Works'),
                  content: Text(_howAppWorksText(context)),
                      actions: [
                        TextButton(
                            onPressed: () => _safePop(),
                            child: const Text('Lukk'))
                      ]));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_important),
            title: const Text('Varsel'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder((_) => AlertDialog(
                      title: const Text('Varsel'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Varsel: intern liste for merkevare-koblinger'),
                          const SizedBox(height: 4),
                          const Text('Varsel: merkevaresporing og offentlig informasjon'),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => _safePop(),
                            child: const Text('Lukk'))
                      ]));
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: Text(_regionalNewsLabel(context)),
            onTap: () {
              _safePop();
              _openRegionalNews();
            },
          ),
          ListTile(
            leading: const Icon(Icons.store_mall_directory),
            title: Text(_farmThemeTitle(context)),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder(
                (_) => AlertDialog(
                  title: Text(_farmThemeTitle(context)),
                  content: Text(_farmThemeBody(context)),
                  actions: [
                    TextButton(
                        onPressed: () => _safePop(), child: const Text('Lukk')),
                    ElevatedButton.icon(
                      onPressed: () {
                        _safePop();
                        _openFarmShops();
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text(_farmShopsLabel(context)),
                    )
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(
                premiumActive ? 'Premium (aktiv)' : 'Premium (7 dagers prøve)'),
            onTap: () {
              _safePop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PremiumScreen(
                    innstillingerBox: innstillingerBox,
                    onPremiumChanged: (active) {
                      if (!mounted) return;
                      setState(() {
                        premiumActive = active;
                      });
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Personvern'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder((_) => const ConsentDialog());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(AppLocalizations.of(context)?.about ?? 'About'),
            onTap: () {
              _safePop();
              _safeShowDialogBuilder((_) => AlertDialog(
                      title: Text(AppLocalizations.of(context)?.appTitle ??
                          'Food Check'),
                      content: const Text(
                          'Version 1.8 – Built for honest food info.'),
                      actions: [
                        TextButton(
                            onPressed: () => _safePop(),
                            child: const Text('Lukk'))
                      ]));
            },
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(String label, String code, Function setDialogState) {
    final selected = selectedLanguage == code;
    return ListTile(
      leading: selected ? const Icon(Icons.radio_button_checked) : const Icon(Icons.radio_button_unchecked),
      title: Text(label),
      onTap: () async {
        if (selected) return;
        innstillingerBox.put('selectedLanguage', code);
        setDialogState(() {
          selectedLanguage = code;
        });
        if (context.mounted) Navigator.of(context).pop();
        if (!_isTestEnv) await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) widget.onLanguageChanged(code);
      },
    );
  }

  void _visLandDialog() {
    final Map<String, String> land = {
      'NO': 'Norge',
      'SE': 'Sverige',
      'DK': 'Danmark',
      'FI': 'Finland',
      'DE': 'Tyskland',
      'NL': 'Nederland',
      'BE': 'Belgia',
      'FR': 'Frankrike',
      'CH': 'Sveits',
      'AT': 'Østerrike',
      'IE': 'Irland',
      'LU': 'Luxembourg',
      'IT': 'Italia',
      'PT': 'Portugal',
      'ES': 'Spania',
      'GB': 'UK',
    };
    final sortedLandEntries = land.entries.toList()
      ..sort((a, b) =>
          a.value.toLowerCase().compareTo(b.value.toLowerCase()));

    _safeShowDialogBuilder(
      (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Velg land (prioriterer kilder)'),
          content: SizedBox(
            width: double.maxFinite,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sortedLandEntries.map((entry) {
                    final code = entry.key;
                    final label = entry.value;
                    final selected = selectedCountry == code;
                    return ListTile(
                      leading: selected
                          ? const Icon(Icons.radio_button_checked)
                          : const Icon(Icons.radio_button_unchecked),
                      title: Text(label),
                      onTap: () async {
                        if (selected) return;
                        innstillingerBox.put('selectedCountry', code);
                        setDialogState(() => selectedCountry = code);
                        _safePop();
                        if (!_isTestEnv) {
                          await Future.delayed(const Duration(milliseconds: 200));
                        }
                        if (mounted) widget.onCountryChanged(code);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => _safePop(), child: const Text('Lukk'))
          ],
        ),
      ),
    ).then((_) => setState(() {}));
  }

  RiskLevel _analyzeBovaerRisk(String brand, String labels) {
    final result = _analyzeBovaerRiskWithText(brand, labels);
    return result['risk'] as RiskLevel;
  }

  Map<String, dynamic> _analyzeBovaerRiskWithText(String brand, String labels) {
    final lowerBrand = brand.toLowerCase();
    final lowerLabels = labels.toLowerCase();
    final country =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    final localGreen = getOrganicKeywords(country);
    final localRed = getBovaerRedBrands(country);
    final localYellow = getBovaerYellowBrands(country);

    final greens = localGreen.isNotEmpty ? localGreen : greenKeywords;
    final reds = localRed.isNotEmpty ? localRed : bovaerRedBrands;
    final yellows = localYellow.isNotEmpty ? localYellow : bovaerYellowBrands;

    final locale =
        (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
            .toLowerCase();
    final isNorwegian = locale == 'nb';
    const bovaerUpdateUrl = 'https://matsjekk.com/index.html#news';
    const tinePartnerBrandAliases = {
      'q-meieriene': 'Q-meieriene',
      'q meieriene': 'Q-meieriene',
      'fjordland': 'Fjordland',
      'synnøve': 'Synnøve',
      'synnove': 'Synnøve',
      'ostecompagniet': 'OsteCompagniet',
      'oste companiet': 'OsteCompagniet',
      'kavli': 'Kavli',
    };

    if (greens.any((keyword) => lowerLabels.contains(keyword.toLowerCase()))) {
      return {
        'risk': RiskLevel.green,
        'text': (AppLocalizations.of(context)?.safeProduct ??
            'SAFE: The product is certified organic.'),
        'url': '',
      };
    }

    if (lowerBrand.contains('arla')) {
      return {
        'risk': RiskLevel.red,
        'text': isNorwegian
            ? 'HØY RISIKO: Arla er direkte koblet i intern Bovaer-sporingsliste.'
            : 'HIGH RISK: Arla is directly linked in the internal Bovaer tracking list.',
        'url': bovaerUpdateUrl,
      };
    }

    if (lowerBrand.contains('apetina') || lowerBrand.contains('aptina')) {
      return {
        'risk': RiskLevel.red,
        'text': isNorwegian
            ? 'HØY RISIKO: Apetina er direkte koblet i intern Bovaer-sporingsliste.'
            : 'HIGH RISK: Apetina is directly linked in the internal Bovaer tracking list.',
        'url': bovaerUpdateUrl,
      };
    }

    if (lowerBrand.contains('tine')) {
      return {
        'risk': RiskLevel.yellow,
        'text': isNorwegian
            ? 'MULIG RISIKO: Tine opplyser at Bovaer-melk ikke lenger blandes inn i produkter, men eldre varer kan fortsatt finnes i butikk. Sjekk produksjonsdato.'
            : 'POSSIBLE RISK: Tine states that Bovaer milk is no longer mixed into products, but older items may still be in stores. Check production date.',
        'url': bovaerUpdateUrl,
      };
    }

    if (reds.any((b) => lowerBrand.contains(b.toLowerCase()))) {
      return {
        'risk': RiskLevel.red,
        'text': (AppLocalizations.of(context)?.bovaerHighRisk ??
            'HIGH RISK: The producer is directly linked to Bovaer.'),
        'url': bovaerUpdateUrl,
      };
    }
    if (yellows.any((b) => lowerBrand.contains(b.toLowerCase()))) {
      final matchedTinePartners = <String>{};
      for (final entry in tinePartnerBrandAliases.entries) {
        if (lowerBrand.contains(entry.key)) {
          matchedTinePartners.add(entry.value);
        }
      }
      final isKnownTinePartner = matchedTinePartners.isNotEmpty;
      final partnerList = matchedTinePartners.join(', ');
      return {
        'risk': RiskLevel.yellow,
        'text': isKnownTinePartner
            ? (isNorwegian
                ? 'MULIG RISIKO: $partnerList er registrert som Tine-tilknyttet samarbeidspartner (samarbeid, eierskap eller melkeleveranser). Sjekk produksjonsdato og etikett.'
                : 'POSSIBLE RISK: $partnerList is registered as a Tine-linked partner (partnership, ownership, or milk supply). Check production date and label.')
            : (isNorwegian
                ? 'MULIG RISIKO: Denne produsenten er registrert som samarbeidspartner i intern sporingsliste. Sjekk etikett og produksjonsdato.'
                : 'POSSIBLE RISK: This producer is listed as a partner in the internal tracking list. Check label and production date.'),
        'url': bovaerUpdateUrl,
      };
    }
    return {'risk': RiskLevel.unknown, 'text': '', 'url': ''};
  }

  RiskLevel _analyzeGmoRisk(String brand, String category) {
    final lowerBrand = brand.toLowerCase();
    final lowerCategory = category.toLowerCase();
    final country =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    final localGmo = getGmoFishRedBrands(country);
    final gmoList = localGmo.isNotEmpty ? localGmo : gmoFishRedBrands;
    if (lowerCategory.contains('salmon') ||
        lowerCategory.contains('laks') ||
        lowerCategory.contains('trout') ||
        lowerCategory.contains('ørret')) {
      if (gmoList.any((b) => lowerBrand.contains(b.toLowerCase()))) {
        return RiskLevel.red;
      }
    }
    return RiskLevel.unknown;
  }

  List<String> _parseEStoffer(String ingredients) {
    final RegExp eNumberRegex = RegExp(r'E\d{3,4}[a-z]?', caseSensitive: false);
    final matches = eNumberRegex.allMatches(ingredients);
    return matches.map((m) => m[0]!.toUpperCase()).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    final farmShopsLabel = _farmShopsLabel(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: _visMeny),
        title: SizedBox(
          height: 42,
          child: ElevatedButton.icon(
          onPressed: _openFarmShops,
          icon: const Icon(Icons.storefront, size: 20),
          label: Text(
            farmShopsLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => setState(() {
                    listBeforeGlobalHistory = activeList;
                    activeList = '_global_';
                    showList = true;
                  })),
          IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: () =>
                  setState(() => showFullScreenList = !showFullScreenList)),
          IconButton(
              icon: wakeLockOn
                  ? const Icon(Icons.screen_lock_portrait)
                  : const Icon(Icons.screen_lock_rotation),
              onPressed: _toggleWakeLock),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();
          _safeShowDialogBuilder(
            (_) => AlertDialog(
              title: Text(AppLocalizations.of(context)?.newShoppingList ??
                  'Ny handleliste'),
              content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.listName ??
                          'Navn på liste')),
              actions: [
                TextButton(
                    onPressed: () => _safePop(),
                    child:
                        Text(AppLocalizations.of(context)?.cancel ?? 'Avbryt')),
                TextButton(
                  onPressed: () {
                    final navn = controller.text.trim();
                    if (navn.isNotEmpty && !handlelisterBox.containsKey(navn)) {
                      handlelisterBox.put(navn, []);
                      _loadListerAndPositions();
                    }
                    _safePop();
                  },
                  child:
                      Text(AppLocalizations.of(context)?.create ?? 'Opprett'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          if (controller != null)
            MobileScanner(controller: controller!, onDetect: _handleBarcode)
          else
            const SizedBox(),
          if (_isLoading)
            Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                child: const Center(
                    child: CircularProgressIndicator(color: Colors.white))),
          ...listPositions.entries.map((entry) {
            final listName = entry.key;
            final position = entry.value;
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    listPositions[listName] = position + d.delta;
                    listPositionsBox.put(listName, {
                      'dx': position.dx + d.delta.dx,
                      'dy': position.dy + d.delta.dy
                    });
                  });
                },
                onTap: () => setState(() {
                  activeList = listName;
                  showList = true;
                }),
                onLongPress: () => _deleteList(listName),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Column(
                        children: [
                          const Icon(Icons.shopping_cart,
                              size: 60, color: Colors.green),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 1),
                            color: Colors.black54,
                            child: Text(listName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable:
                            handlelisterBox.listenable(keys: [listName]),
                        builder: (context, box, child) {
                          final varer =
                              box.get(listName, defaultValue: <String>[]);
                          final antall = varer
                              .where((v) => !v.toString().startsWith('✓'))
                              .length;
                          if (antall == 0) return const SizedBox.shrink();
                          return CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Text('$antall',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          );
                        }),
                  ],
                ),
              ),
            );
          }),
          if (showList || showFullScreenList)
            Align(
              alignment: Alignment.bottomCenter,
              child: activeList == '_global_'
                  ? GlobalHistorikkOverlay(
                      isFullScreen: showFullScreenList,
                      onClose: () => setState(() {
                        showList = false;
                        showFullScreenList = false;
                      }),
                      onToggleFullScreen: () => setState(
                          () => showFullScreenList = !showFullScreenList),
                      onAddItem: (itemName, imageUrl) {
                        final box = Hive.box('handlelister');
                        final list = List<String>.from(box.get(
                            listBeforeGlobalHistory,
                            defaultValue: <String>[]));
                        if (!list.any((item) => item.endsWith(itemName))) {
                          list.insert(0, itemName);
                          box.put(listBeforeGlobalHistory, list);
                          Analytics.logEvent('add_to_list',
                              {'item': itemName, 'list': listBeforeGlobalHistory});
                        }
                      },
                    )
                  : HandlelisteOverlay(
                      listeNavn: activeList,
                      isFullScreen: showFullScreenList,
                      onClose: () => setState(() {
                        showList = false;
                        showFullScreenList = false;
                      }),
                      onToggleFullScreen: () => setState(
                          () => showFullScreenList = !showFullScreenList),
                      onRename: _handleRename,
                      onShowSearch: () => _visSok(),
                    ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              color: Colors.grey[300],
              child: const Center(child: Text('Annonsebanner her')),
            ),
          )
        ],
      ),
    );
  }

  void _visSok() async {
    _safeShowDialogBuilder(
      (context) {
        final searchController = TextEditingController();
        ValueNotifier<List<dynamic>> searchResults = ValueNotifier([]);
        ValueNotifier<bool> isSearching = ValueNotifier(false);

        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.searchProducts ??
              'Søk etter produkt'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha((0.08 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Beta: Søkefunksjonen er under kontinuerlig forbedring. Dobbeltsjekk alltid produktdetaljer før du tar valg.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.searchHint ??
                        'Søk... (f.eks. melk)',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        if (searchController.text.length < 2) return;
                        isSearching.value = true;
                        final response = await http.get(Uri.parse(
                            'https://world.openfoodfacts.org/cgi/search.pl?search_terms=${searchController.text}&search_simple=1&action=process&json=1&page_size=20'));
                        if (response.statusCode == 200) {
                          final data = json.decode(response.body);
                          searchResults.value = data['products'] ?? [];
                        }
                        isSearching.value = false;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: ValueListenableBuilder<bool>(
                  valueListenable: isSearching,
                  builder: (context, searching, child) {
                    if (searching) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ValueListenableBuilder<List<dynamic>>(
                      valueListenable: searchResults,
                      builder: (context, results, child) {
                        if (results.isEmpty) {
                          return Center(
                              child: Text(
                                  AppLocalizations.of(context)?.noResults ??
                                      'Ingen resultater'));
                        }
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final product = results[index];
                            final productName = product['product_name'] ??
                                (AppLocalizations.of(context)?.unknownProduct ??
                                    'Ukjent produkt');
                            final brands = product['brands'] ?? '';
                            final imageUrl =
                                product['image_front_thumb_url'] ?? '';

                            return ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) =>
                                          const Icon(Icons.help))
                                  : const Icon(Icons.shopping_basket),
                              title: Text(productName),
                              subtitle: Text(brands),
                              onTap: () async {
                                _safePop();
                                final ean = product['code'] as String?;
                                if (ean != null) {
                                  setState(() => _isLoading = true);
                                  final info = await _hentInfo(ean);
                                  setState(() => _isLoading = false);
                                  if (info.isNotEmpty) _visProduktDialog(info);
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => _safePop(),
                child: Text(AppLocalizations.of(context)?.close ?? 'Lukk'))
          ],
        );
      },
    );
  }
}

Map<String, dynamic> buildProductsIndex(dynamic payload) {
  final Map<String, dynamic> index = (payload is Map && payload['index'] is Map)
      ? Map<String, dynamic>.from(payload['index'])
      : (payload is Map ? Map<String, dynamic>.from(payload) : {});

  final Map<String, dynamic> offCache =
      (payload is Map && payload['off_cache'] is Map)
          ? Map<String, dynamic>.from(payload['off_cache'])
          : {};

  final Map<String, dynamic> sourceByGtin = {};

  final rawByGtin = index['byGtin'] ?? index;
  if (rawByGtin is Map) {
    rawByGtin.forEach((gtin, entry) {
      final product = <String, dynamic>{};
      if (entry is Map) {
        product['navn'] =
            entry['navn'] ?? entry['name'] ?? entry['product_name'] ?? '';
        product['matvare'] = Map<String, dynamic>.from(entry);
      } else {
        product['navn'] = entry?.toString() ?? '';
      }

      sourceByGtin[gtin.toString()] = {
        'product': product,
        'best_confidence': 0.5,
        'sources': [
          {'source': 'matvaretabellen', 'confidence': 0.5}
        ]
      };
    });
  }

  offCache.forEach((gtin, off) {
    final offMap = (off is Map) ? off : {};
    final offName = offMap['product_name'] ?? offMap['productName'] ?? '';
    final bool hasRich = (offMap['image_front_url'] != null) ||
        (offMap['additives_tags'] != null) ||
        (offMap['ingredients_text'] != null) ||
        (offMap['ingredients_text'] != null);
    final offConfidence = hasRich ? 0.9 : 0.4;

    final key = gtin.toString();
    final existing = sourceByGtin[key];
    if (existing == null) {
      sourceByGtin[key] = {
        'product': {
          'navn': offName,
          'openfoodfacts': Map<String, dynamic>.from(offMap)
        },
        'best_confidence': offConfidence,
        'sources': [
          {'source': 'openfoodfacts', 'confidence': offConfidence}
        ]
      };
    } else {
      final existingConf =
          (existing['best_confidence'] as num?)?.toDouble() ?? 0.0;
      if (offConfidence > existingConf) {
        existing['product'] = {
          'navn': (offName ?? '') == ''
              ? (existing['product']?['navn'] ?? '')
              : offName,
          'openfoodfacts': Map<String, dynamic>.from(offMap),
          'matvare': existing['product']?['matvare']
        };
        existing['best_confidence'] = offConfidence;
        (existing['sources'] as List).insert(
            0, {'source': 'openfoodfacts', 'confidence': offConfidence});
      } else {
        (existing['sources'] as List)
            .add({'source': 'openfoodfacts', 'confidence': offConfidence});
      }
    }
  });

  return {'byGtin': sourceByGtin};
}
