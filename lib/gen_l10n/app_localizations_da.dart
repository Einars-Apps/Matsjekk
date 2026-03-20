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
  String get finnish => 'Finsk';

  @override
  String get korean => 'Koreansk';

  @override
  String get polish => 'Polsk';

  @override
  String get russian => 'Russisk';

  @override
  String get chinese => 'Kinesisk';

  @override
  String get arabic => 'Arabisk';

  @override
  String get thai => 'Thailandsk';

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
      'HØJ RISIKO: Mærket er bekræftet bruger af Bovaer, eller tilhører en producent som er det.';

  @override
  String get gmoHighRisk =>
      'HØJ RISIKO: Producenten er forbundet med brugen af GMO-foder.';

  @override
  String get bovaerPossibleRisk =>
      'USIKKER: Produktet kan indeholde mælk fra et mejeri, der modtager mælk fra Bovaer-landmænd.';

  @override
  String get safeProduct => 'SIKKER: Produktet er mærket som økologisk.';

  @override
  String get searchHint => 'Søg... (f.eks. mælk)';

  @override
  String get delete => 'Slet';

  @override
  String get deleteListConfirmTitle => 'Slet liste?';

  @override
  String get deleteListConfirmMessage =>
      'Er du sikker? Dette vil også slette historikken for listen.';

  @override
  String get unknownProduct => 'Ukendt produkt';

  @override
  String get removeAds => 'Fjern reklamer';

  @override
  String get removeAdsInfo => 'Fjern reklamer for mere plads i indkøbslisten';

  @override
  String get removeAdsMenuItem =>
      'Fjern reklamer (49 kr) - støtter videre udvikling';

  @override
  String get premiumTitle => 'Fjern reklamer';

  @override
  String get premiumActiveStatus => 'Reklamefri er aktiv';

  @override
  String get premiumInactiveStatus => 'Reklamefri er ikke aktiveret endnu';

  @override
  String get buyAdFreeTitle => 'Køb reklamefri version';

  @override
  String get oneTimePurchaseInfo =>
      'Engangskøb. Intet abonnement.\nEfter bekræftet køb fjernes reklamer permanent for denne konto.';

  @override
  String get storeUnavailable =>
      'Butikken er ikke tilgængelig lige nu. Prøv igen senere.';

  @override
  String get productsLoadFailed =>
      'Kunne ikke indlæse købsprodukter. Tjek dit netværk og prøv igen.';

  @override
  String get tryAgain => 'Prøv igen';

  @override
  String get oneTimePurchaseLabel => 'engangskøb';

  @override
  String get buyPermanently => 'Køb permanent';

  @override
  String get restorePurchases => 'Gendan køb';

  @override
  String get analyticsEnabled => 'Tak – analyse aktiveret.';

  @override
  String get analyticsDisabled => 'Analyse deaktiveret.';

  @override
  String get privacy => 'Privatliv';

  @override
  String get adFreeActive => 'Reklamefri (aktiv)';

  @override
  String get consentLocalOnly =>
      'Appen fungerer stadig, og data kan forblive kun på din enhed.';

  @override
  String get allowAnonymousAnalytics => 'Tillad anonym analyse';

  @override
  String get consentOptional =>
      'Dette er valgfrit. Hvis du ikke giver samtykke, sendes ingen brugsdata til analyse.';
}
