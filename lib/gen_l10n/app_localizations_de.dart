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
  String get appDescription => 'Die App verwendet Open Food Facts und eine interne Markenübersicht zur Identifikation von Produkten mit Bovaer, Insektenmehl, GVO-Futter und anderen umstrittenen Zutaten.';

  @override
  String get alerts => 'Wählen Sie Benachrichtigungen';

  @override
  String get bovaerAlert => 'Bovaer-Warnung';

  @override
  String get insectMealAlert => 'Insektenmehl-Warnung';

  @override
  String get ngtAlert => 'Warnung vor versteckter Gentechnik (NGT)';

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
  String get bovaerRiskDesc => 'Der Hersteller ist direkt mit Bovaer verbunden.';

  @override
  String get insectMealRiskDesc => 'Das Produkt kann Insektenmehl enthalten.';

  @override
  String get gmoFishRiskDesc => 'Der Hersteller ist mit der Verwendung von GVO-Futter verbunden.';

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
  String get disclaimer => 'Haftungsausschluss: Diese Informationen dienen nur zu Informationszwecken und basieren auf öffentlich verfügbaren Daten. Für 100% genaue Informationen sehen Sie bitte auf der Produktverpackung nach oder kontaktieren Sie den Hersteller.';

  @override
  String get bovaerHighRisk => 'HOHES RISIKO: Der Hersteller ist direkt mit Bovaer verbunden.';

  @override
  String get gmoHighRisk => 'HOHES RISIKO: Der Hersteller ist mit der Verwendung von GVO-Futter verbunden.';

  @override
  String get bovaerPossibleRisk => 'MÖGLICHES RISIKO: Der Hersteller ist Partner von Unternehmen, die mit Bovaer verbunden sind.';

  @override
  String get safeProduct => 'SICHER: Das Produkt ist als ökologisch zertifiziert.';

  @override
  String get searchHint => 'Suchen... (z. B. Milch)';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteListConfirmTitle => 'Liste löschen?';

  @override
  String get deleteListConfirmMessage => 'Bist du sicher? Dadurch wird auch der Verlauf der Liste gelöscht.';

  @override
  String get unknownProduct => 'Unbekanntes Produkt';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String get removeAdsInfo => 'Werbung entfernen für mehr Platz in der Einkaufsliste';

  @override
  String get removeAdsMenuItem => 'Werbung entfernen (49 kr) – unterstützt die Weiterentwicklung';

  @override
  String get gmoRegExplicit => 'EU-RECHTSSTATUS: Das Produkt scheint in eine GVO/NGT-regulierte Kategorie zu fallen.';

  @override
  String get gmoRegFeedChain => 'EU-RECHTSSTATUS: Kann über die Futtermittelkette unter GVO/NGT-Vorschriften fallen.';

  @override
  String get gmoRegNgt => 'EU-RECHTSSTATUS: Das Produkt kann unter den neuen EU-Beschluss zur Genom-Editierung (NGT) fallen.';

  @override
  String get gmoRegSupplyChain => 'EU-RECHTSSTATUS: Mögliche indirekte GVO/NGT-Relevanz über die Kette Importeur/Lieferant/Hersteller.';

  @override
  String get gmoRegCropOrigin => 'EU-RECHTSSTATUS: GVO-anfälliger Rohstoff amerikanischer/außereuropäischer Herkunft – kann die GVO-Kennzeichnungspflicht der EU auslösen.';

  @override
  String get gmoRegCropUnknown => 'EU-RECHTSSTATUS: GVO-anfälliger Rohstoff auf Import-/Lieferantenebene – die Herkunft sollte geprüft werden.';

  @override
  String get insectRegExplicit => 'EU-RECHTSSTATUS: Das Produkt scheint in eine als Insekten/Novel Food regulierte Kategorie zu fallen.';

  @override
  String get insectRegNovelFood => 'EU-RECHTSSTATUS: Das Produkt kann unter die EU-Vorschriften für Insekten als Novel Food fallen.';

  @override
  String get insectRegSupplyChain => 'EU-RECHTSSTATUS: Mögliche indirekte Relevanz über die Kette Importeur/Lieferant/Hersteller.';

  @override
  String get gmoConsExplicit => 'VERBRAUCHERRISIKO: Produkttext/Etikett weist auf GVO-Gehalt hin.';

  @override
  String get gmoConsFeed => 'VERBRAUCHERRISIKO: Marke/Kategorie entspricht bekanntem Einsatz von GVO-Futter.';

  @override
  String get gmoConsNgt => 'VERBRAUCHERRISIKO: Kann den Verbrauchermarkt betreffen, sollte aber anhand von Etikett und Herstellerangaben geprüft werden.';

  @override
  String get gmoConsSupplyChain => 'VERBRAUCHERRISIKO: Mögliches Risiko über die Lieferkette (wer an wen verkauft). Etikett und Herkunft prüfen.';

  @override
  String get gmoConsCropOrigin => 'VERBRAUCHERRISIKO: Enthält einen GVO-anfälligen Rohstoff (Soja/Mais/Raps/Zuckerrübe/Baumwolle) aus einem Land, in dem die Kultur überwiegend gentechnisch verändert ist. Achte auf dem Etikett auf „ohne Gentechnik“.';

  @override
  String get gmoConsCropUnknown => 'VERBRAUCHERRISIKO: Das Produkt enthält einen GVO-anfälligen Rohstoff (Soja/Mais/Raps/Zuckerrübe/Baumwolle). Herkunft unbekannt – Etikett und Ursprungsland prüfen.';

  @override
  String get insectConsExplicit => 'VERBRAUCHERRISIKO: Produkttext/Zutaten weisen auf Insektenmehl oder Insektenprotein hin.';

  @override
  String get insectConsNovelFood => 'VERBRAUCHERRISIKO: Mögliche insektenbezogene Exposition, Zutatenliste prüfen.';

  @override
  String get insectConsSupplyChain => 'VERBRAUCHERRISIKO: Mögliches Risiko über die Lieferkette (wer an wen verkauft).';

  @override
  String get noKnownRisk => 'Kein bekanntes Risiko in dieser Kategorie.';

  @override
  String get searchBetaNote => 'Beta: Die Suche wird laufend verbessert. Prüfe Produktangaben immer, bevor du dich entscheidest.';

  @override
  String get couldNotOpenLink => 'Link konnte nicht geöffnet werden';

  @override
  String get eNumberNoDescription => 'Für diesen Zusatzstoff haben wir noch keine Beschreibung. Die E-Nummer ist ein in der EU/im EWR verwendeter Code für Zusatzstoffe.';

  @override
  String get allergensTitle => 'Allergene';

  @override
  String get noAllergensFound => 'Keine Allergene gefunden.';

  @override
  String get nutritionTitle => 'Nährwerte (pro 100 g)';

  @override
  String get noNutritionFound => 'Keine Nährwertangaben gefunden.';

  @override
  String get alertsTitle => 'Warnungen';

  @override
  String get alertEvidence => 'Belege:';

  @override
  String get alertInternalListNote => 'Warnung: interne Liste von Markenverbindungen';

  @override
  String get alertBrandTrackingNote => 'Warnung: Markenverfolgung und öffentliche Informationen';

  @override
  String get reportNoteHint => 'Kurze Notiz (z. B. Fehlalarm)';

  @override
  String get report => 'Melden';

  @override
  String get send => 'Senden';

  @override
  String get reportSaved => 'Danke — Meldung gespeichert.';

  @override
  String get seeUpdatedStatus => 'Aktuellen Status ansehen';

  @override
  String get openEuSource => 'EU-Quelle öffnen';

  @override
  String get openInsectSource => 'Insektenquelle öffnen';

  @override
  String get privacyTitle => 'Datenschutz';

  @override
  String get consentOptional => 'Dies ist freiwillig. Ohne deine Zustimmung wird deine Nutzung nicht zur Analyse gesendet.';

  @override
  String get consentWorksAnyway => 'Die App funktioniert so oder so, und Daten können ausschließlich auf deinem Gerät bleiben.';

  @override
  String get readPrivacyPolicy => 'Datenschutzerklärung lesen';

  @override
  String get allowAnonymousAnalytics => 'Anonyme Analyse erlauben';

  @override
  String get analyticsEnabled => 'Danke – Analyse aktiviert.';

  @override
  String get analyticsDisabled => 'Analyse deaktiviert.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Link konnte nicht geöffnet werden: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Meldung konnte nicht gespeichert werden: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Schweregrad: $value';
  }

  @override
  String alertReason(String value) {
    return 'Grund: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Konfidenz: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Vorschläge aus Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '„$item“ zu $list hinzugefügt';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energie: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Fett: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'davon gesättigte Fettsäuren: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Kohlenhydrate: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'davon Zucker: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Eiweiß: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Salz: $value g';
  }

  @override
  String get countryDataSources => 'Land / Datenquellen';

  @override
  String get chooseCountryTitle => 'Land wählen (priorisiert Quellen)';
}
