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
import 'config/links.dart';
import 'services/remote_risk_rules_service.dart';
import 'services/matvaretabellen_service.dart';
import 'models/product.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_banner.dart';

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

const Map<String, Map<String, dynamic>> appReviewSampleProducts = {
  '0000000000000': {
    'product_name': 'Testprodukt Eplejuice',
    'brands': 'Mat-sjekk Demo',
    'labels': 'Økologisk',
    'ingredients_text_no': 'Økologisk eplejuice fra konsentrat',
    'categories': 'Drikkevarer, Juice',
    'image_front_url': '',
    'image_front_thumb_url': '',
    'nutriscore_grade': 'B',
    'additives_tags': <String>[]
  },
  '0123456789012': {
    'product_name': 'Testprodukt Havregryn',
    'brands': 'Mat-sjekk Demo',
    'labels': '',
    'ingredients_text_no': 'Havregryn',
    'categories': 'Frokostblandinger og korn',
    'image_front_url': '',
    'image_front_thumb_url': '',
    'nutriscore_grade': 'A',
    'additives_tags': <String>[]
  }
};
// --- SLUTT PÅ RISIKO-DEFINISJON ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox('handlelister');
  await Hive.openBox('historikk');
  await Hive.openBox('innstillinger');
  await Hive.openBox('list_positions');
  await Hive.openBox('product_memory');
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
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'Food Check',
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
        Locale('ko'),
        Locale('pl'),
        Locale('ru'),
        Locale('zh'),
        Locale('ar'),
        Locale('th'),
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
  Map<String, Map<String, List<String>>> _remoteRiskRulesByCountry = {};
  final MatvaretabellenService _matvaretabellenService = MatvaretabellenService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Only create the real controller when not running tests.
    if (!_isTestEnv) {
      controller =
          MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
    }
    handlelisterBox = Hive.box('handlelister');
    historikkBox = Hive.box('historikk');
    innstillingerBox = Hive.box('innstillinger');
    listPositionsBox = Hive.box('list_positions');
    _loadListerAndPositions();
    _loadInnstillinger();
    if (!_isTestEnv) {
      _loadRemoteRiskRules();
      _matvaretabellenService.load();
    }
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
    premiumActive = innstillingerBox.get(PremiumService.premiumActiveKey,
        defaultValue: false);
    WakelockPlus.toggle(enable: wakeLockOn);
  }

  Future<void> _loadRemoteRiskRules() async {
    final service = RemoteRiskRulesService(innstillingerBox);

    final cachedRules = service.readCachedRules();
    if (cachedRules.isNotEmpty && mounted) {
      setState(() {
        _remoteRiskRulesByCountry = cachedRules;
      });
    }

    try {
      final fetchedRules = await service.fetchAndCacheRules();
      if (!mounted) return;
      setState(() {
        _remoteRiskRulesByCountry = fetchedRules;
      });
    } catch (_) {
      // Keep cached/local fallback when remote fetch fails.
    }
  }

  List<String> _countryRulesList(
    String countryCode,
    String ruleKey,
    List<String> fallback,
  ) {
    final remote = _remoteRiskRulesByCountry[countryCode]?[ruleKey] ?? [];
    if (remote.isNotEmpty) return remote;

    final local = getRiskBrandsForCountry(countryCode)[ruleKey] ?? [];
    if (local.isNotEmpty) return local;

    return fallback;
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

  String _menuLanguageCode(BuildContext context) {
    return (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
        .toLowerCase();
  }

  String _countryDataSourcesMenuLabel(BuildContext context) {
    switch (_menuLanguageCode(context)) {
      case 'en':
        return 'Country / data sources';
      case 'sv':
        return 'Land / datakällor';
      case 'da':
        return 'Land / datakilder';
      case 'fi':
        return 'Maa / tietolähteet';
      case 'de':
        return 'Land / Datenquellen';
      case 'nl':
        return 'Land / gegevensbronnen';
      case 'fr':
        return 'Pays / sources de donnees';
      case 'it':
        return 'Paese / fonti dati';
      case 'pt':
        return 'Pais / fontes de dados';
      case 'es':
        return 'Pais / fuentes de datos';
      case 'ko':
        return '국가 / 데이터 소스';
      case 'pl':
        return 'Kraj / zrodla danych';
      case 'ru':
        return 'Страна / источники данных';
      case 'zh':
        return '国家 / 数据来源';
      case 'ar':
        return 'البلد / مصادر البيانات';
      case 'th':
        return 'ประเทศ / แหล่งข้อมูล';
      case 'nb':
      default:
        return 'Land / datakilder';
    }
  }

  String _selectCountrySourcesTitle(BuildContext context) {
    switch (_menuLanguageCode(context)) {
      case 'en':
        return 'Select country (prioritizes data sources)';
      case 'sv':
        return 'Valj land (prioriterar datakallor)';
      case 'da':
        return 'Vaelg land (prioriterer datakilder)';
      case 'fi':
        return 'Valitse maa (priorisoi lahteet)';
      case 'de':
        return 'Land auswahlen (priorisiert Datenquellen)';
      case 'nl':
        return 'Land kiezen (prioriteert gegevensbronnen)';
      case 'fr':
        return 'Choisir un pays (priorise les sources)';
      case 'it':
        return 'Seleziona paese (priorita alle fonti)';
      case 'pt':
        return 'Selecionar pais (prioriza fontes de dados)';
      case 'es':
        return 'Seleccionar pais (prioriza fuentes de datos)';
      case 'ko':
        return '국가 선택 (데이터 소스 우선)';
      case 'pl':
        return 'Wybierz kraj (priorytet zrodel danych)';
      case 'ru':
        return 'Выберите страну (приоритет источников данных)';
      case 'zh':
        return '选择国家（优先数据来源）';
      case 'ar':
        return 'اختر البلد (ترتيب أولويات مصادر البيانات)';
      case 'th':
        return 'เลือกประเทศ (จัดลําดับแหล่งข้อมูล)';
      case 'nb':
      default:
        return 'Velg land (prioriterer kilder)';
    }
  }

  String _countryName(String code) {
    switch (code.toUpperCase()) {
      case 'NO':
        return 'Norway';
      case 'SE':
        return 'Sweden';
      case 'DK':
        return 'Denmark';
      case 'FI':
        return 'Finland';
      case 'DE':
        return 'Germany';
      case 'NL':
        return 'Netherlands';
      case 'BE':
        return 'Belgium';
      case 'FR':
        return 'France';
      case 'CH':
        return 'Switzerland';
      case 'AT':
        return 'Austria';
      case 'IE':
        return 'Ireland';
      case 'LU':
        return 'Luxembourg';
      case 'IT':
        return 'Italy';
      case 'PT':
        return 'Portugal';
      case 'ES':
        return 'Spain';
      case 'GB':
        return 'United Kingdom';
      default:
        return code.toUpperCase();
    }
  }

  bool _isEuropeanCountry(String code) {
    const european = {
      'NO',
      'SE',
      'DK',
      'FI',
      'DE',
      'NL',
      'BE',
      'FR',
      'CH',
      'AT',
      'IE',
      'LU',
      'IT',
      'PT',
      'ES',
      'GB',
    };
    return european.contains(code.toUpperCase());
  }

  String _privacyMenuLabel(BuildContext context) {
    switch (_menuLanguageCode(context)) {
      case 'nb':
        return 'Personvern';
      case 'sv':
        return 'Integritet';
      case 'da':
        return 'Privatliv';
      case 'fi':
        return 'Tietosuoja';
      case 'de':
        return 'Datenschutz';
      case 'nl':
        return 'Privacy';
      case 'fr':
        return 'Confidentialite';
      case 'it':
        return 'Privacy';
      case 'pt':
        return 'Privacidade';
      case 'es':
        return 'Privacidad';
      case 'ko':
        return '개인정보';
      case 'pl':
        return 'Prywatnosc';
      case 'ru':
        return 'Конфиденциальность';
      case 'zh':
        return '隐私';
      case 'ar':
        return 'الخصوصية';
      case 'th':
        return 'ความเป็นส่วนตัว';
      case 'en':
      default:
        return 'Privacy';
    }
  }

  String _farmShopsLabel(BuildContext context) {
    final code = _menuLanguageCode(context);
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
      case 'ko':
        return '농장 직판장 찾기';
      case 'pl':
        return 'Znajdz sklepy gospodarskie';
      case 'ru':
        return 'Найти фермерские магазины';
      case 'zh':
        return '查找农场商店';
      case 'ar':
        return 'ابحث عن متاجر المزارع';
      case 'th':
        return 'ค้นหาร้านฟาร์ม';
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
      safeSnack(context, AppLocalizations.of(context)?.couldNotOpenLink ?? 'Could not open link');
    }
  }

  String _howAppWorksText(BuildContext context) {
    return AppLocalizations.of(context)?.howAppWorksSteps ??
        '1. Scan the product barcode.\n'
        '2. The app fetches product data from Open Food Facts.\n'
        '3. Alerts are evaluated against internal brand and ingredient rules.\n'
        '4. You get a simple risk view and can save items to your shopping list.';
  }

  String _regionalNewsLabel(BuildContext context) {
    final countryCode =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    if (!_isEuropeanCountry(countryCode)) {
      return 'News';
    }
    final code = _menuLanguageCode(context);
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
      case 'ko':
        return '내 지역 뉴스';
      case 'pl':
        return 'Wiadomosci w Twoim regionie';
      case 'ru':
        return 'Новости в вашем регионе';
      case 'zh':
        return '你所在地区的新闻';
      case 'ar':
        return 'أخبار منطقتك';
      case 'th':
        return 'ข่าวสารในพื้นที่ของคุณ';
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
      safeSnack(context, AppLocalizations.of(context)?.couldNotOpenLink ?? 'Could not open link');
    }
  }

  String _farmThemeTitle(BuildContext context) {
    final code = _menuLanguageCode(context);
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
      case 'ko':
        return '농장 직판장과 로컬푸드';
      case 'pl':
        return 'Sklepy gospodarskie i zywnosc lokalna';
      case 'ru':
        return 'Фермерские магазины и местные продукты';
      case 'zh':
        return '农场商店与本地食品';
      case 'ar':
        return 'متاجر المزارع والطعام المحلي';
      case 'th':
        return 'ร้านฟาร์มและอาหารท้องถิ่น';
      case 'nb':
      default:
        return 'Gårdsbutikker og lokalmat';
    }
  }

  String _farmThemeBody(BuildContext context) {
    final code = _menuLanguageCode(context);
    switch (code) {
      case 'en':
        return 'Find nearby farm shops, follow regional updates, and see what products people scan most in your area. This feature is beta and improves continuously.';
      case 'ko':
        return '근처 농장 직판장을 찾고, 지역 소식을 확인하며, 내 지역에서 많이 스캔되는 제품을 볼 수 있습니다. 이 기능은 베타이며 계속 개선됩니다.';
      case 'pl':
        return 'Znajdz pobliskie sklepy gospodarskie, sledz regionalne aktualnosci i sprawdzaj, jakie produkty sa najczesciej skanowane w Twojej okolicy. Funkcja jest w wersji beta i jest stale ulepszana.';
      case 'ru':
        return 'Ищите ближайшие фермерские магазины, следите за региональными обновлениями и смотрите, какие товары чаще всего сканируют в вашем районе. Функция находится в бета-версии и постоянно улучшается.';
      case 'zh':
        return '查找附近农场商店，关注本地更新，并查看你所在地区最常被扫描的产品。此功能为测试版，会持续改进。';
      case 'ar':
        return 'اعثر على متاجر المزارع القريبة، وتابع التحديثات المحلية، وشاهد المنتجات الأكثر مسحا في منطقتك. هذه الميزة تجريبية ويتم تحسينها باستمرار.';
      case 'th':
        return 'ค้นหาร้านฟาร์มใกล้คุณ ติดตามข่าวอัปเดตในพื้นที่ และดูว่าสินค้าใดถูกสแกนมากที่สุดในบริเวณของคุณ ฟีเจอร์นี้อยู่ในช่วงเบต้าและกำลังพัฒนาอย่างต่อเนื่อง';
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

    final notFoundMsg = AppLocalizations.of(context)?.productNotFound ?? 'Product not found in database.';
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
        _safeSnack(notFoundMsg,
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
    final reviewSamples = _fetchFromReviewSampleData;
    final openFoodFacts = _fetchFromOpenFoodFacts;
    final Map<String, List<Future<Map<String, dynamic>> Function(String ean)>>
        prioritized = {
      'NO': [reviewSamples, openFoodFacts],
      'SE': [reviewSamples, openFoodFacts],
      'DK': [reviewSamples, openFoodFacts],
      'FI': [reviewSamples, openFoodFacts],
      'DE': [reviewSamples, openFoodFacts],
      'NL': [reviewSamples, openFoodFacts],
      'FR': [reviewSamples, openFoodFacts],
      'IT': [reviewSamples, openFoodFacts],
      'PT': [reviewSamples, openFoodFacts],
      'ES': [reviewSamples, openFoodFacts],
      'GB': [reviewSamples, openFoodFacts],
      'IE': [reviewSamples, openFoodFacts],
      'BE': [reviewSamples, openFoodFacts],
      'AT': [reviewSamples, openFoodFacts],
      'CH': [reviewSamples, openFoodFacts],
      'LU': [reviewSamples, openFoodFacts],
    };
    return prioritized[countryCode] ?? [reviewSamples, openFoodFacts];
  }

  Future<Map<String, dynamic>> _fetchFromReviewSampleData(String ean) async {
    final sample = appReviewSampleProducts[ean];
    if (sample == null) return {};

    final info = _buildProductInfo(
      ean: ean,
      navn: (sample['product_name'] ?? '').toString(),
      merke: (sample['brands'] ?? '').toString(),
      etiketter: (sample['labels'] ?? '').toString(),
      kategorier: (sample['categories'] ?? '').toString(),
      ingredienser: (sample['ingredients_text_no'] ?? '').toString(),
      bildeUrl: (sample['image_front_url'] ?? '').toString(),
      bildeThumbUrl: (sample['image_front_thumb_url'] ?? '').toString(),
      nutriscore: (sample['nutriscore_grade'] ?? 'UKJENT').toString(),
      additivesTags:
          (sample['additives_tags'] as List<dynamic>? ?? const <dynamic>[]),
    );
    info['isReviewSample'] = true;
    return info;
  }

  Future<Map<String, dynamic>> _fetchFromOpenFoodFacts(String ean) async {
    try {
      final uri = Uri.parse(
          'https://world.openfoodfacts.org/api/v2/product/$ean.json?fields=product_name,brands,labels,ingredients_text,ingredients_text_no,image_front_url,nutriscore_grade,additives_tags,categories,image_front_thumb_url,nutriments,allergens_tags');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];
          return _buildProductInfo(
            ean: ean,
            navn: (product['product_name'] ?? '').toString(),
            merke: (product['brands'] ?? '').toString(),
            etiketter: (product['labels'] ?? '').toString(),
            kategorier: (product['categories'] ?? '').toString(),
            ingredienser: (product['ingredients_text_no'] ??
                    product['ingredients_text'] ??
                    '')
                .toString(),
            bildeUrl: (product['image_front_url'] ?? '').toString(),
            bildeThumbUrl: (product['image_front_thumb_url'] ?? '').toString(),
            nutriscore: (product['nutriscore_grade'] ?? 'ukjent').toString(),
            additivesTags:
                (product['additives_tags'] as List<dynamic>? ?? const []),
            nutriments:
                (product['nutriments'] as Map<String, dynamic>?) ?? const {},
            allergensTags:
                (product['allergens_tags'] as List<dynamic>?) ?? const [],
          );
        }
      }
    } catch (e) {
      debugPrint('Feil ved henting av produktinfo: $e');
    }
    return {};
  }

  Map<String, dynamic> _buildProductInfo({
    required String ean,
    required String navn,
    required String merke,
    required String etiketter,
    required String kategorier,
    required String ingredienser,
    required String bildeUrl,
    required String bildeThumbUrl,
    required String nutriscore,
    List<dynamic> additivesTags = const [],
    Map<String, dynamic> nutriments = const {},
    List<dynamic> allergensTags = const [],
  }) {
    final cleanedIngredients = ingredienser.trim();
    final eStofferFraTags = additivesTags
        .map((e) => e.toString().replaceAll('en:', '').toUpperCase())
        .toList();
    final eStofferFraTekst = _parseEStoffer(cleanedIngredients);
    final allEStoffer = {...eStofferFraTags, ...eStofferFraTekst}.toList();

    final info = <String, dynamic>{
      'ean': ean,
      'navn': navn,
      'merke': merke,
      'etiketter': etiketter,
      'kategorier': kategorier,
      'ingredienser':
          cleanedIngredients.isEmpty ? '' : cleanedIngredients,
      'bildeUrl': bildeUrl,
      'bildeThumbUrl': bildeThumbUrl,
      'nutriscore': nutriscore.toUpperCase(),
      'eStoffer': allEStoffer,
    };

    final bovaerAssessment = _analyzeBovaerRiskWithText(merke, etiketter);
    info['bovaerRisk'] = bovaerAssessment['risk'] as RiskLevel;
    info['bovaerRiskText'] = bovaerAssessment['text'] as String;
    info['bovaerRiskUrl'] = (bovaerAssessment['url'] ?? '').toString();
    info['gmoRisk'] = _analyzeGmoRisk(merke, kategorier, cleanedIngredients);

    final insectAssessment =
        _analyzeInsectRisk(cleanedIngredients, etiketter, allEStoffer);
    info['insectRisk'] = insectAssessment['risk'] as RiskLevel;
    info['insectRiskText'] = insectAssessment['text'] as String;

    // Nutrition from OpenFoodFacts nutriments
    if (nutriments.isNotEmpty) {
      info['næringsinnhold'] =
          Product.extractNutrition(nutriments);
    }

    // Allergens from OFF tags, with ingredient-text fallback
    final allergens = <String>[];
    if (allergensTags.isNotEmpty) {
      for (final t in allergensTags) {
        final s = t
            .toString()
            .replaceAll('en:', '')
            .replaceAll('fr:', '')
            .replaceAll('es:', '');
        if (s.isNotEmpty) allergens.add(s);
      }
    }
    if (allergens.isEmpty && cleanedIngredients.isNotEmpty) {
      allergens.addAll(
          Product.extractAllergensFromIngredients(cleanedIngredients));
    }
    if (allergens.isNotEmpty) {
      info['allergener'] = allergens;
    }

    // Matvaretabellen fuzzy match for enrichment
    if (_matvaretabellenService.isLoaded) {
      final candidates = _matvaretabellenService.findCandidates(navn, merke);
      if (candidates.isNotEmpty) {
        info['matvareCandidates'] = candidates;
        // Use Matvaretabellen nutrition as fallback if OFF had none
        if (!info.containsKey('næringsinnhold') ||
            (info['næringsinnhold'] as Map).isEmpty) {
          final best = candidates.first;
          final mvtNutrition =
              Map<String, double>.from(best['nutrition'] as Map);
          mvtNutrition['energy_kcal'] =
              (best['calories'] as num?)?.toDouble() ?? 0.0;
          info['næringsinnhold'] = mvtNutrition;
          info['næringsinnholdKilde'] = 'Matvaretabellen';
        }
      }
    }

    return info;
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
                _safeSnack(AppLocalizations.of(context)?.addedToList(itemName, listToAddTo) ?? '"$itemName" added to $listToAddTo',
                    duration: const Duration(seconds: 2));
                Analytics.logEvent(
                    'add_to_list', {'item': itemName, 'list': listToAddTo});
              }
            }),
        actions: [
          TextButton(onPressed: () => _safePop(), child: Text(AppLocalizations.of(context)?.close ?? 'Close'))
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
              if (!premiumActive)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AdBanner(),
                ),
              ListTile(
                leading: const Icon(Icons.language),
                title:
                    Text(AppLocalizations.of(context)?.language ?? 'Language'),
                onTap: () {
                  _safePop();
                  _safeShowDialogBuilder(
                    (context) => StatefulBuilder(
                      builder: (context, setDialogState) => AlertDialog(
                        title: Text(
                            AppLocalizations.of(context)?.selectLanguage ??
                                'Select Language'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!premiumActive)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: AdBanner(),
                              ),
                            SizedBox(
                              width: double.maxFinite,
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView(
                                children: [
                              _languageTile(
                                  AppLocalizations.of(context)?.norwegian ??
                                      'Norwegian',
                                  'nb',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.english ??
                                      'English',
                                  'en',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.swedish ??
                                      'Swedish',
                                  'sv',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.danish ??
                                      'Danish',
                                  'da',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.finnish ??
                                      'Finnish',
                                  'fi',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.german ??
                                      'German',
                                  'de',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.dutch ??
                                      'Dutch',
                                  'nl',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.french ??
                                      'French',
                                  'fr',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.italian ??
                                      'Italian',
                                  'it',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.portuguese ??
                                      'Portuguese',
                                  'pt',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.spanish ??
                                      'Spanish',
                                  'es',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.korean ?? '한국어',
                                  'ko',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.polish ??
                                      'Polski',
                                  'pl',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.russian ??
                                      'Русский',
                                  'ru',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.chinese ??
                                      '中文',
                                  'zh',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.arabic ??
                                      'العربية',
                                  'ar',
                                  setDialogState),
                              _languageTile(
                                  AppLocalizations.of(context)?.thai ??
                                      'ภาษาไทย',
                                  'th',
                                  setDialogState),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => _safePop(),
                              child: Text(
                                  AppLocalizations.of(context)?.close ??
                                      'Close'))
                        ],
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: Text(_countryDataSourcesMenuLabel(context)),
                onTap: () {
                  _safePop();
                  _visLandDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: Text(premiumActive
                    ? (AppLocalizations.of(context)?.adFreeActive ??
                        'Ad-free (active)')
                    : (AppLocalizations.of(context)?.removeAdsMenuItem ??
                        'Remove ads (kr 49,-) - supports further development')),
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
                leading: const Icon(Icons.warning),
                title: Text(
                    AppLocalizations.of(context)?.alerts ?? 'Select Alerts'),
                onTap: () {
                  _safePop();
                  _safeShowDialogBuilder(
                    (context) => StatefulBuilder(
                      builder: (context, setDialogState) => AlertDialog(
                        title: Text(AppLocalizations.of(context)?.alerts ??
                            'Select Alerts'),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          if (!premiumActive)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: AdBanner(),
                            ),
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
                              title: Text(AppLocalizations.of(context)
                                      ?.insectMealAlert ??
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
                              child: Text(
                                  AppLocalizations.of(context)?.close ??
                                      'Close'))
                        ],
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              ListTile(
                leading: const Icon(Icons.tips_and_updates),
                title: Text(AppLocalizations.of(context)?.shoppingListMemoryTitle ?? 'Shopping list: memory and autocomplete'),
                onTap: () {
                  _safePop();
                  _safeShowDialogBuilder((_) => AlertDialog(
                        title: Text(AppLocalizations.of(context)?.shoppingListMemoryHow ?? 'How to use the shopping list memory'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!premiumActive)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: AdBanner(),
                              ),
                            Text(AppLocalizations.of(context)?.shoppingListMemoryIntro ?? 'The shopping list has memory and autocomplete:'),
                            const SizedBox(height: 8),
                            Text(AppLocalizations.of(context)?.shoppingListMemoryStep1 ?? '1. + adds exactly what you type.'),
                            Text(AppLocalizations.of(context)?.shoppingListMemoryStep2 ?? '2. Enter adds the suggestion in the input field.'),
                            Text(AppLocalizations.of(context)?.shoppingListMemoryStep3 ?? '3. Tap a product in the memory list to add it.'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => _safePop(),
                            child: Text(
                                AppLocalizations.of(context)?.close ?? 'Close'),
                          ),
                        ],
                      ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(AppLocalizations.of(context)?.howAppWorks ??
                    'How the App Works'),
                onTap: () {
                  _safePop();
                  _safeShowDialogBuilder((_) => AlertDialog(
                          title: Text(
                              AppLocalizations.of(context)?.howAppWorks ??
                                  'How the App Works'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!premiumActive)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: AdBanner(),
                                ),
                              Text(_howAppWorksText(context)),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => _safePop(),
                                child: Text(
                                    AppLocalizations.of(context)?.close ??
                                        'Close'))
                          ]));
                },
              ),
              if (Platform.isIOS)
                ListTile(
                  leading: const Icon(Icons.verified),
                  title: Text(AppLocalizations.of(context)?.appReviewTestTitle ?? 'App Review Test Codes'),
                  subtitle: Text(AppLocalizations.of(context)?.appReviewTestSubtitle ?? 'Open demo products without camera'),
                  onTap: () {
                    _safePop();
                    _showAppReviewTestDialog();
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
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!premiumActive)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: AdBanner(),
                            ),
                          Text(_farmThemeBody(context)),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => _safePop(),
                            child: Text(
                                AppLocalizations.of(context)?.close ??
                                    'Close')),
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
                leading: const Icon(Icons.privacy_tip),
                title: Text(_privacyMenuLabel(context)),
                onTap: () {
                  _safePop();
                  _safeShowDialogBuilder(
                      (_) => ConsentDialog(showAdBanner: !premiumActive));
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
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!premiumActive)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: AdBanner(),
                                ),
                              const Text(
                                  'Version 1.8 – Built for honest food info.'),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => _safePop(),
                                child: Text(
                                    AppLocalizations.of(context)?.close ??
                                        'Close'))
                          ]));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppReviewTestDialog() {
    final sampleCodes = appReviewSampleProducts.keys.toList(growable: false);
    _safeShowDialogBuilder(
      (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.appReviewTestTitle ?? 'App Review Test Codes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)?.appReviewTestInstructions ?? 'Choose a test code to open a demo product:'),
            const SizedBox(height: 12),
            ...sampleCodes.map(
              (code) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    _safePop();
                    setState(() => _isLoading = true);
                    final info = await _hentInfo(code);
                    if (!mounted) return;
                    setState(() => _isLoading = false);
                    if (info.isNotEmpty) {
                      _visProduktDialog(info);
                    } else {
                      _safeSnack(AppLocalizations.of(context)?.appReviewDemoNotFound(code) ?? 'Could not find demo product for $code');
                    }
                  },
                  icon: const Icon(Icons.qr_code),
                  label: Text(code),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => _safePop(), child: Text(AppLocalizations.of(context)?.close ?? 'Close')),
        ],
      ),
    );
  }

  Widget _languageTile(String label, String code, Function setDialogState) {
    final selected = selectedLanguage == code;
    return ListTile(
      leading: selected
          ? const Icon(Icons.radio_button_checked)
          : const Icon(Icons.radio_button_unchecked),
      title: Text(label),
      onTap: () async {
        if (selected) return;
        innstillingerBox.put('selectedLanguage', code);
        setDialogState(() {
          selectedLanguage = code;
        });
        if (context.mounted) Navigator.of(context).pop();
        if (!_isTestEnv) {
          await Future.delayed(const Duration(milliseconds: 300));
        }
        if (mounted) widget.onLanguageChanged(code);
      },
    );
  }

  void _visLandDialog() {
    const landCodes = [
      'NO',
      'SE',
      'DK',
      'FI',
      'DE',
      'NL',
      'BE',
      'FR',
      'CH',
      'AT',
      'IE',
      'LU',
      'IT',
      'PT',
      'ES',
      'GB',
    ];
    final sortedLandCodes = landCodes.toList()
      ..sort((a, b) => _countryName(a).compareTo(_countryName(b)));

    _safeShowDialogBuilder(
      (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_selectCountrySourcesTitle(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!premiumActive)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: AdBanner(),
                ),
              SizedBox(
                width: double.maxFinite,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: sortedLandCodes.map((code) {
                    final label = _countryName(code);
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
                          await Future.delayed(
                              const Duration(milliseconds: 200));
                        }
                        if (mounted) widget.onCountryChanged(code);
                      },
                    );
                  }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => _safePop(),
                child: Text(AppLocalizations.of(context)?.close ?? 'Close'))
          ],
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Map<String, dynamic> _analyzeBovaerRiskWithText(String brand, String labels) {
    final lowerBrand = brand.toLowerCase();
    final lowerLabels = labels.toLowerCase();
    final country =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    final greens =
        _countryRulesList(country, 'organic_keywords', greenKeywords);
    final reds = _countryRulesList(country, 'bovaer_red', bovaerRedBrands);
    final yellows =
        _countryRulesList(country, 'bovaer_yellow', bovaerYellowBrands);

    final locale =
        (AppLocalizations.of(context)?.localeName ?? selectedLanguage)
            .toLowerCase();
    final isNorwegian = locale == 'nb';
    final useCustomNarrative = isNorwegian || locale == 'en';
    const bovaerUpdateUrl = kSupplierStatusUrl;
    const tinePartnerBrandAliases = {
      'q-meieriene': 'Q-meieriene',
      'q meieriene': 'Q-meieriene',
      'fjordland': 'Fjordland',
      'synnøve': 'Synnøve',
      'synnove': 'Synnøve',
      'sunnøve': 'Synnøve',
      'sunnove': 'Synnøve',
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
        'text': !useCustomNarrative
            ? ''
            : isNorwegian
            ? 'HØY RISIKO: Arla er direkte koblet i intern Bovaer-sporingsliste.'
            : 'HIGH RISK: Arla is directly linked in the internal Bovaer tracking list.',
        'url': bovaerUpdateUrl,
      };
    }

    if (lowerBrand.contains('apetina') || lowerBrand.contains('aptina')) {
      return {
        'risk': RiskLevel.red,
        'text': !useCustomNarrative
            ? ''
            : isNorwegian
            ? 'HØY RISIKO: Apetina er direkte koblet i intern Bovaer-sporingsliste.'
            : 'HIGH RISK: Apetina is directly linked in the internal Bovaer tracking list.',
        'url': bovaerUpdateUrl,
      };
    }

    if (lowerBrand.contains('tine')) {
      return {
        'risk': RiskLevel.yellow,
        'text': !useCustomNarrative
            ? ''
            : isNorwegian
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
      final matchedYellowBrands = <String>{};
      for (final yellowBrand in yellows) {
        if (lowerBrand.contains(yellowBrand.toLowerCase())) {
          matchedYellowBrands.add(yellowBrand);
        }
      }
      final matchedTinePartners = <String>{};
      for (final entry in tinePartnerBrandAliases.entries) {
        if (lowerBrand.contains(entry.key)) {
          matchedTinePartners.add(entry.value);
        }
      }
      final isKnownTinePartner = matchedTinePartners.isNotEmpty;
      final normalizedPartnerAliases = {
        for (final entry in tinePartnerBrandAliases.entries)
          entry.key.toLowerCase(): entry.value,
      };
      final matchedLabelList = matchedYellowBrands
          .map((brand) =>
              normalizedPartnerAliases[brand.toLowerCase()] ??
              (brand.isNotEmpty
                  ? '${brand[0].toUpperCase()}${brand.substring(1)}'
                  : brand))
          .toSet()
          .join(', ');
      final partnerList = matchedTinePartners.join(', ');
      if (!useCustomNarrative) {
        return {
          'risk': RiskLevel.yellow,
          'text': '',
          'url': bovaerUpdateUrl,
        };
      }
      return {
        'risk': RiskLevel.yellow,
        'text': isKnownTinePartner
            ? (isNorwegian
                ? 'MULIG RISIKO: $partnerList samarbeider med Tine. Sjekk produksjonsdato og etikett.'
                : 'POSSIBLE RISK: $partnerList collaborates with Tine. Check production date and label.')
            : (isNorwegian
                ? 'MULIG RISIKO: ${matchedLabelList.isEmpty ? 'Dette merket' : matchedLabelList} er registrert som samarbeidspartner i intern sporingsliste. Se oppdatert status for leverandørinformasjon, og sjekk etikett og produksjonsdato.'
                : 'POSSIBLE RISK: ${matchedLabelList.isEmpty ? 'This brand' : matchedLabelList} is listed as a partner in the internal tracking list. See updated supplier status, and check label and production date.'),
        'url': bovaerUpdateUrl,
      };
    }
    return {'risk': RiskLevel.unknown, 'text': '', 'url': ''};
  }

  RiskLevel _analyzeGmoRisk(
      String brand, String category, String ingredients) {
    final lowerBrand = brand.toLowerCase();
    final lowerCategory = category.toLowerCase();
    final lowerIngredients = ingredients.toLowerCase();
    final country =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    final gmoList =
        _countryRulesList(country, 'gmo_fish_red', gmoFishRedBrands);

    // Fish keywords to detect in category OR ingredients
    const fishKeywords = [
      'salmon', 'laks', 'trout', 'ørret', 'pangasius', 'tilapia',
      'sjøørret', 'fjordørret', 'oppdrettslaks', 'atlantisk laks',
      'fish', 'fisk', 'sushi', 'sashimi',
    ];

    final hasFishSignal = fishKeywords.any(
        (kw) => lowerCategory.contains(kw) || lowerIngredients.contains(kw));

    if (hasFishSignal) {
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

  Map<String, dynamic> _analyzeInsectRisk(
      String ingredients, String labels, List<String> eNumbers) {
    if (!varselInsekt) {
      return {'risk': RiskLevel.unknown, 'text': ''};
    }

    final country =
        (selectedCountry.isEmpty ? _defaultCountryCode() : selectedCountry)
            .toUpperCase();
    final isNorwegian =
        country == 'NO' || Platform.localeName.startsWith('nb');

    final lowerIngredients = ingredients.toLowerCase();
    final lowerLabels = labels.toLowerCase();
    final combined = '$lowerIngredients $lowerLabels';

    // 1. Check for EU novel food scientific names (universal, highest confidence)
    for (final sciName in insectScientificNames) {
      if (combined.contains(sciName)) {
        return {
          'risk': RiskLevel.red,
          'text': isNorwegian
              ? 'INNEHOLDER INSEKT: Påvist "$sciName" i ingredienslisten. '
                  'EU-godkjent Novel Food-insekt.'
              : 'CONTAINS INSECT: Found "$sciName" in ingredients. '
                  'EU-approved Novel Food insect.',
        };
      }
    }

    // 2. Check country-specific insect keywords
    final localKeywords = _countryRulesList(
        country, 'insect_keywords', insectKeywordsFallback);
    for (final keyword in localKeywords) {
      if (combined.contains(keyword.toLowerCase())) {
        return {
          'risk': RiskLevel.red,
          'text': isNorwegian
              ? 'INNEHOLDER INSEKT: Påvist "$keyword" i produktet. '
                  'Sjekk ingredienslisten nøye.'
              : 'CONTAINS INSECT: Found "$keyword" in product. '
                  'Check the ingredients list carefully.',
        };
      }
    }

    // 3. Check insect-derived E-numbers (E120=cochineal, E901=beeswax, E904=shellac)
    final upperENumbers = eNumbers.map((e) => e.toUpperCase()).toSet();
    final matchedInsectE = insectENumbers
        .where((e) => upperENumbers.contains(e.toUpperCase()))
        .toList();
    if (matchedInsectE.isNotEmpty) {
      final eList = matchedInsectE.join(', ');
      return {
        'risk': RiskLevel.yellow,
        'text': isNorwegian
            ? 'INSEKT-TILSETNING: Inneholder $eList '
                '(insektbasert tilsetningsstoff). '
                'E120 = karmin fra skjoldlus, E901 = bivoks, E904 = skjellakk fra lakkskjoldlus.'
            : 'INSECT ADDITIVE: Contains $eList '
                '(insect-derived additive). '
                'E120 = carmine from cochineal, E901 = beeswax, E904 = shellac from lac bug.',
      };
    }

    return {'risk': RiskLevel.unknown, 'text': ''};
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (controller != null)
                  MobileScanner(
                      controller: controller!, onDetect: _handleBarcode)
                else
                  const SizedBox(),
                if (_isLoading)
                  Container(
                      color: const Color.fromRGBO(0, 0, 0, 0.5),
                      child: const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white))),
                ...listPositions.entries.map((entry) {
                  final listName = entry.key;
                  final position = entry.value;
                  return Positioned(
                    key: ValueKey('cart_$listName'),
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
                              if (!list
                                  .any((item) => item.endsWith(itemName))) {
                                list.insert(0, itemName);
                                box.put(listBeforeGlobalHistory, list);
                                Analytics.logEvent('add_to_list', {
                                  'item': itemName,
                                  'list': listBeforeGlobalHistory
                                });
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
                            showPremiumUpsell: !premiumActive,
                            onPremiumTap: () {
                              setState(() {
                                showList = false;
                                showFullScreenList = false;
                              });
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
                  )
              ],
            ),
          ),
          if (!premiumActive)
            const SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Center(child: AdBanner()),
              ),
            ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                            'https://search.openfoodfacts.org/search?q=${Uri.encodeComponent(searchController.text)}&page_size=20&fields=product_name,brands,code,image_front_thumb_url'));
                        if (response.statusCode == 200) {
                          final data = json.decode(response.body);
                          final hits = data['hits'] as List<dynamic>? ?? [];
                          // Normalize brands from array to string for compatibility
                          for (final hit in hits) {
                            if (hit['brands'] is List) {
                              hit['brands'] = (hit['brands'] as List).join(', ');
                            }
                          }
                          searchResults.value = hits;
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
