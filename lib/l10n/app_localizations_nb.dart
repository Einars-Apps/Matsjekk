// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Matvare-sjekk';

  @override
  String get scanBarcode => 'Scan strekkode';

  @override
  String get productNotFound => 'Produktet ble ikke funnet i databasen.';

  @override
  String get addToList => 'Legg i handleliste';

  @override
  String get shoppingLists => 'Handlelister';

  @override
  String get history => 'Historikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get about => 'Om appen';

  @override
  String get howAppWorks => 'Hvordan appen henter info';

  @override
  String get appDescription => 'Appen bruker Open Food Facts og en intern liste for merkevare-koblinger til Bovaer, insektmel, GMO-fôr og andre kontroversielle ingredienser.';

  @override
  String get alerts => 'Velg varsler';

  @override
  String get bovaerAlert => 'Bovaer-varsel';

  @override
  String get insectMealAlert => 'Insektmel-varsel';

  @override
  String get gmoFishAlert => 'GMO-fôr (Fisk)';

  @override
  String get highRisk => 'HØY RISIKO';

  @override
  String get possibleRisk => 'MULIG RISIKO';

  @override
  String get safe => 'TRYGG';

  @override
  String get unknown => 'UKJENT';

  @override
  String get bovaerRiskDesc => 'Produsenten er direkte knyttet til Bovaer.';

  @override
  String get insectMealRiskDesc => 'Produktet kan inneholde insektmel.';

  @override
  String get gmoFishRiskDesc => 'Produsenten er knyttet til bruk av GMO-fôr.';

  @override
  String get safeDesc => 'Produktet er merket som økologisk.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Sporbarhet';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Lukk';

  @override
  String get create => 'Opprett';

  @override
  String get search => 'Søk';

  @override
  String get searchProducts => 'Søk etter produkt';

  @override
  String get noResults => 'Ingen resultater';

  @override
  String get newList => 'Ny liste';

  @override
  String get deleteList => 'Langtikk for å slette';

  @override
  String get language => 'Språk / Language';

  @override
  String get selectLanguage => 'Velg språk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get swedish => 'Svenska';

  @override
  String get danish => 'Dansk';

  @override
  String get dutch => 'Nederlands';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Español';

  @override
  String get portuguese => 'Português';

  @override
  String get finnish => 'Finsk';

  @override
  String get changeListName => 'Endre listenavn';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Lagre';

  @override
  String get manualAddItem => 'Legg til vare manuelt...';

  @override
  String get emptyList => 'Listen er tom';

  @override
  String get noHistory => 'Ingen historikk for denne listen';

  @override
  String get globalHistory => 'Global Historikk';

  @override
  String get newShoppingList => 'Ny handleliste';

  @override
  String get listName => 'Navn på liste';

  @override
  String get noHistoryFound => 'Ingen historikk funnet';

  @override
  String get addedItems => 'E-stoffer';

  @override
  String get identifiedAdditions => 'Identifiserte E-stoffer';

  @override
  String get noAdditionsFound => 'Ingen E-stoffer funnet i databasen.';

  @override
  String get disclaimer => 'Ansvarsfraskrivelse: Informasjonen er veiledende og basert på offentlig kjente data. For 100% nøyaktig informasjon, se produktets emballasje eller kontakt produsenten.';

  @override
  String get bovaerHighRisk => 'HØY RISIKO: Produsenten er direkte knyttet til Bovaer.';

  @override
  String get gmoHighRisk => 'HØY RISIKO: Produsenten er knyttet til bruk av GMO-fôr.';

  @override
  String get bovaerPossibleRisk => 'MULIG RISIKO: Produsenten er en samarbeidspartner med aktører som er knyttet til Bovaer.';

  @override
  String get safeProduct => 'TRYGG: Produktet er merket som økologisk.';

  @override
  String get searchHint => 'Søk... (f.eks. melk)';

  @override
  String get delete => 'Slett';

  @override
  String get deleteListConfirmTitle => 'Slette liste?';

  @override
  String get deleteListConfirmMessage => 'Er du sikker? Dette vil også slette historikken for listen.';

  @override
  String get unknownProduct => 'Ukjent produkt';
}
