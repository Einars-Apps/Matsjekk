// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Ruoka-tarkistus';

  @override
  String get scanBarcode => 'Skannaa viivakoodi';

  @override
  String get productNotFound => 'Tuotetta ei löytynyt tietokannasta.';

  @override
  String get addToList => 'Lisää ostoslistalle';

  @override
  String get shoppingLists => 'Ostoslistat';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Asetukset';

  @override
  String get about => 'Tietoja sovelluksesta';

  @override
  String get howAppWorks => 'Kuinka sovellus toimii';

  @override
  String get appDescription =>
      'Sovellus käyttää Open Food Facts -tietokantaa ja sisäistä merkkilistaa havaitakseen tuotteita, joissa voi olla Bovaer, hyönteislantaa, GMO-rehua ja muita kiistanalaisia aineosia.';

  @override
  String get alerts => 'Valitse hälytykset';

  @override
  String get bovaerAlert => 'Bovaer-hälytys';

  @override
  String get insectMealAlert => 'Hyönteislanta-hälytys';

  @override
  String get gmoFishAlert => 'GMO-kalarehu -hälytys';

  @override
  String get highRisk => 'KORKEA RISKI';

  @override
  String get possibleRisk => 'MAHDOLLINEN RISKI';

  @override
  String get safe => 'TURVALLINEN';

  @override
  String get unknown => 'TUNNISTAMATON';

  @override
  String get bovaerRiskDesc => 'Tuottajalla on suora yhteys Bovaeriin.';

  @override
  String get insectMealRiskDesc => 'Tuote saattaa sisältää hyönteisproteiinia.';

  @override
  String get gmoFishRiskDesc => 'Tuottaja liittyy GMO-rehun käyttöön.';

  @override
  String get safeDesc => 'Tuote on luomusertifioitu.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Jäljitettävyys';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Sulje';

  @override
  String get create => 'Luo';

  @override
  String get search => 'Hae';

  @override
  String get searchProducts => 'Hae tuotteita';

  @override
  String get noResults => 'Ei tuloksia';

  @override
  String get newList => 'Uusi lista';

  @override
  String get deleteList => 'Poista pitkällä painalluksella';

  @override
  String get language => 'Kieli';

  @override
  String get selectLanguage => 'Valitse kieli';

  @override
  String get norwegian => 'Norja';

  @override
  String get swedish => 'Ruotsi';

  @override
  String get danish => 'Tanska';

  @override
  String get dutch => 'Hollanti';

  @override
  String get french => 'Ranska';

  @override
  String get english => 'Englanti';

  @override
  String get german => 'Saksa';

  @override
  String get italian => 'Italia';

  @override
  String get spanish => 'Espanja';

  @override
  String get portuguese => 'Portugali';

  @override
  String get finnish => 'Suomi';

  @override
  String get changeListName => 'Vaihda listan nimeä';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get manualAddItem => 'Lisää tuote manuaalisesti...';

  @override
  String get emptyList => 'Lista on tyhjä';

  @override
  String get noHistory => 'Ei historiaa tälle listalle';

  @override
  String get globalHistory => 'Koko historia';

  @override
  String get newShoppingList => 'Uusi ostoslista';

  @override
  String get listName => 'Listan nimi';

  @override
  String get noHistoryFound => 'Ei historiaa';

  @override
  String get addedItems => 'E-aineet';

  @override
  String get identifiedAdditions => 'Tunnistetut E-aineet';

  @override
  String get noAdditionsFound => 'Ei E-aineita tietokannassa.';

  @override
  String get disclaimer =>
      'Vastuuvapaus: Tämä tieto on ohjeellinen ja perustuu julkisesti saatavilla olevaan dataan. Tarkista tuotteen pakkauksesta tai ota yhteyttä valmistajaan saadaksesi 100% tarkan tiedon.';

  @override
  String get bovaerHighRisk =>
      'KORKEA RISKI: Valmistajalla on suora yhteys Bovaeriin.';

  @override
  String get gmoHighRisk =>
      'KORKEA RISKI: Valmistaja liittyy GMO-rehun käyttöön.';

  @override
  String get bovaerPossibleRisk =>
      'MAHDOLLINEN RISKI: Valmistaja on kumppani yritysten kanssa, jotka liittyvät Bovaeriin.';

  @override
  String get safeProduct => 'TURVALLINEN: Tuote on luomusertifioitu.';

  @override
  String get searchHint => 'Hae... (esim. maito)';

  @override
  String get delete => 'Poista';

  @override
  String get deleteListConfirmTitle => 'Poistetaanko lista?';

  @override
  String get deleteListConfirmMessage =>
      'Haluatko varmasti poistaa? Tämä poistaa myös listan historian.';

  @override
  String get unknownProduct => 'Tuntematon tuote';
}
