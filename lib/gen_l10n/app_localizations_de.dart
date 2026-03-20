// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Lebensmittel-Check';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get productNotFound => 'Produkt nicht in der Datenbank gefunden.';

  @override
  String get addToList => 'Zur Einkaufsliste hinzufügen';

  @override
  String get shoppingLists => 'Einkaufslisten';

  @override
  String get history => 'Verlauf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get about => 'Über die App';

  @override
  String get howAppWorks => 'Wie die App Informationen abruft';

  @override
  String get appDescription =>
      'Die App verwendet Open Food Facts und eine interne Markenübersicht zur Identifikation von Produkten mit Bovaer, Insektenmehl, GVO-Futter und anderen umstrittenen Zutaten.';

  @override
  String get alerts => 'Wählen Sie Benachrichtigungen';

  @override
  String get bovaerAlert => 'Bovaer-Warnung';

  @override
  String get insectMealAlert => 'Insektenmehl-Warnung';

  @override
  String get gmoFishAlert => 'GVO-Futter (Fisch)';

  @override
  String get highRisk => 'HOHES RISIKO';

  @override
  String get possibleRisk => 'MÖGLICHES RISIKO';

  @override
  String get safe => 'SICHER';

  @override
  String get unknown => 'UNBEKANNT';

  @override
  String get bovaerRiskDesc =>
      'Der Hersteller ist direkt mit Bovaer verbunden.';

  @override
  String get insectMealRiskDesc => 'Das Produkt kann Insektenmehl enthalten.';

  @override
  String get gmoFishRiskDesc =>
      'Der Hersteller ist mit der Verwendung von GVO-Futter verbunden.';

  @override
  String get safeDesc => 'Das Produkt ist als ökologisch zertifiziert.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Rückverfolgbarkeit';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Schließen';

  @override
  String get create => 'Erstellen';

  @override
  String get search => 'Suchen';

  @override
  String get searchProducts => 'Produkte suchen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get newList => 'Neue Liste';

  @override
  String get deleteList => 'Lange drücken zum Löschen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Wählen Sie die Sprache';

  @override
  String get norwegian => 'Norwegisch';

  @override
  String get swedish => 'Schwedisch';

  @override
  String get danish => 'Dänisch';

  @override
  String get dutch => 'Niederländisch';

  @override
  String get french => 'Französisch';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italienisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get finnish => 'Finnisch';

  @override
  String get korean => 'Koreanisch';

  @override
  String get polish => 'Polnisch';

  @override
  String get russian => 'Russisch';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get arabic => 'Arabisch';

  @override
  String get thai => 'Thailändisch';

  @override
  String get changeListName => 'Listennamen ändern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get manualAddItem => 'Artikel manuell hinzufügen...';

  @override
  String get emptyList => 'Liste ist leer';

  @override
  String get noHistory => 'Keine Verlauf für diese Liste';

  @override
  String get globalHistory => 'Globale Verlauf';

  @override
  String get newShoppingList => 'Neue Einkaufsliste';

  @override
  String get listName => 'Listenname';

  @override
  String get noHistoryFound => 'Kein Verlauf gefunden';

  @override
  String get addedItems => 'E-Nummern';

  @override
  String get identifiedAdditions => 'Identifizierte E-Nummern';

  @override
  String get noAdditionsFound => 'Keine E-Nummern in der Datenbank gefunden.';

  @override
  String get disclaimer =>
      'Haftungsausschluss: Diese Informationen dienen nur zu Informationszwecken und basieren auf öffentlich verfügbaren Daten. Für 100% genaue Informationen sehen Sie bitte auf der Produktverpackung nach oder kontaktieren Sie den Hersteller.';

  @override
  String get bovaerHighRisk =>
      'HOHES RISIKO: Diese Marke ist ein bestätigter Bovaer-Verwender oder gehört einem solchen Hersteller an.';

  @override
  String get gmoHighRisk =>
      'HOHES RISIKO: Der Hersteller ist mit der Verwendung von GVO-Futter verbunden.';

  @override
  String get bovaerPossibleRisk =>
      'UNSICHER: Das Produkt kann Milch von einer Molkerei enthalten, die Milch von Bovaer-Betrieben bezieht.';

  @override
  String get safeProduct =>
      'SICHER: Das Produkt ist als ökologisch zertifiziert.';

  @override
  String get searchHint => 'Suchen... (z.B. Milch)';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteListConfirmTitle => 'Liste löschen?';

  @override
  String get deleteListConfirmMessage =>
      'Sind Sie sicher? Dies löscht auch den Verlauf der Liste.';

  @override
  String get unknownProduct => 'Unbekanntes Produkt';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String get removeAdsInfo =>
      'Werbung entfernen für mehr Platz in der Einkaufsliste';

  @override
  String get removeAdsMenuItem =>
      'Werbung entfernen (49 kr) - unterstützt die Weiterentwicklung';

  @override
  String get premiumTitle => 'Werbung entfernen';

  @override
  String get premiumActiveStatus => 'Werbefrei ist aktiv';

  @override
  String get premiumInactiveStatus => 'Werbefrei ist noch nicht aktiviert';

  @override
  String get buyAdFreeTitle => 'Werbefreie Version kaufen';

  @override
  String get oneTimePurchaseInfo =>
      'Einmalkauf. Kein Abo.\nNach Kaufbestätigung werden Anzeigen dauerhaft für dieses Konto entfernt.';

  @override
  String get storeUnavailable =>
      'Der Shop ist gerade nicht verfügbar. Bitte versuchen Sie es später erneut.';

  @override
  String get productsLoadFailed =>
      'Kaufprodukte konnten nicht geladen werden. Überprüfen Sie Ihr Netzwerk und versuchen Sie es erneut.';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get oneTimePurchaseLabel => 'Einmalkauf';

  @override
  String get buyPermanently => 'Dauerhaft kaufen';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get analyticsEnabled => 'Danke – Analyse aktiviert.';

  @override
  String get analyticsDisabled => 'Analyse deaktiviert.';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get adFreeActive => 'Werbefrei (aktiv)';

  @override
  String get consentLocalOnly =>
      'Die App funktioniert weiterhin und Daten können nur auf Ihrem Gerät verbleiben.';

  @override
  String get allowAnonymousAnalytics => 'Anonyme Analyse zulassen';

  @override
  String get consentOptional =>
      'Dies ist optional. Wenn Sie nicht zustimmen, werden keine Nutzungsdaten an die Analyse gesendet.';
}
