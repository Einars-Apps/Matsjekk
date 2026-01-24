// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Mad-check';

  @override
  String get scanBarcode => 'Scan stregkode';

  @override
  String get productNotFound => 'Produktet blev ikke fundet i databasen.';

  @override
  String get addToList => 'Tilføj til indkøbsliste';

  @override
  String get shoppingLists => 'Indkøbslister';

  @override
  String get history => 'Historik';

  @override
  String get settings => 'Indstillinger';

  @override
  String get about => 'Om appen';

  @override
  String get howAppWorks => 'Sådan henter appen oplysninger';

  @override
  String get appDescription =>
      'Appen bruger Open Food Facts og en intern mærkeliste til at identificere produkter med Bovaer, insektmel, GMO-foder og andre kontroversielle ingredienser.';

  @override
  String get alerts => 'Vælg advarsler';

  @override
  String get bovaerAlert => 'Bovaer-advarsel';

  @override
  String get insectMealAlert => 'Insektmel-advarsel';

  @override
  String get gmoFishAlert => 'GMO-foder (Fisk)';

  @override
  String get highRisk => 'HØJ RISIKO';

  @override
  String get possibleRisk => 'MULIG RISIKO';

  @override
  String get safe => 'SIKKER';

  @override
  String get unknown => 'UKENDT';

  @override
  String get bovaerRiskDesc => 'Producenten er direkte forbundet med Bovaer.';

  @override
  String get insectMealRiskDesc => 'Produktet kan indeholde insektmel.';

  @override
  String get gmoFishRiskDesc =>
      'Producenten er forbundet med brugen af GMO-foder.';

  @override
  String get safeDesc => 'Produktet er mærket som økologisk.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Sporbarhed';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Luk';

  @override
  String get create => 'Opret';

  @override
  String get search => 'Søg';

  @override
  String get searchProducts => 'Søg efter produkter';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get newList => 'Ny liste';

  @override
  String get deleteList => 'Langt tryk for at slette';

  @override
  String get language => 'Sprog';

  @override
  String get selectLanguage => 'Vælg sprog';

  @override
  String get norwegian => 'Norsk';

  @override
  String get swedish => 'Svensk';

  @override
  String get danish => 'Dansk';

  @override
  String get dutch => 'Hollandsk';

  @override
  String get french => 'Fransk';

  @override
  String get english => 'Engelsk';

  @override
  String get german => 'Tysk';

  @override
  String get italian => 'Italiensk';

  @override
  String get spanish => 'Spansk';

  @override
  String get portuguese => 'Portugisisk';

  @override
  String get finnish => 'Finnish';

  @override
  String get changeListName => 'Skift listenavn';

  @override
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get manualAddItem => 'Tilføj vare manuelt...';

  @override
  String get emptyList => 'Listen er tom';

  @override
  String get noHistory => 'Ingen historik for denne liste';

  @override
  String get globalHistory => 'Global historik';

  @override
  String get newShoppingList => 'Ny indkøbsliste';

  @override
  String get listName => 'Navn på liste';

  @override
  String get noHistoryFound => 'Ingen historik fundet';

  @override
  String get addedItems => 'E-numre';

  @override
  String get identifiedAdditions => 'Identificerede E-numre';

  @override
  String get noAdditionsFound => 'Ingen E-numre fundet i databasen.';

  @override
  String get disclaimer =>
      'Ansvarsfraskrivelse: Disse oplysninger er kun vejledende og baseret på offentligt tilgængelige data. For 100% nøjagtige oplysninger skal du se produktets emballage eller kontakte producenten.';

  @override
  String get bovaerHighRisk =>
      'HØJ RISIKO: Producenten er direkte forbundet med Bovaer.';

  @override
  String get gmoHighRisk =>
      'HØJ RISIKO: Producenten er forbundet med brugen af GMO-foder.';

  @override
  String get bovaerPossibleRisk =>
      'MULIG RISIKO: Producenten er partner med virksomheder forbundet med Bovaer.';

  @override
  String get safeProduct => 'SIKKER: Produktet er mærket som økologisk.';

  @override
  String get searchHint => 'Search... (e.g. milk)';

  @override
  String get delete => 'Delete';

  @override
  String get deleteListConfirmTitle => 'Delete list?';

  @override
  String get deleteListConfirmMessage =>
      'Are you sure? This will also delete the history for the list.';

  @override
  String get unknownProduct => 'Unknown product';
}
