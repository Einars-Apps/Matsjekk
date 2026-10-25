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
  String get appDescription => 'Appen bruger Open Food Facts og en intern mærkeliste til at identificere produkter med Bovaer, insektmel, GMO-foder og andre kontroversielle ingredienser.';

  @override
  String get alerts => 'Vælg advarsler';

  @override
  String get bovaerAlert => 'Bovaer-advarsel';

  @override
  String get insectMealAlert => 'Insektmel-advarsel';

  @override
  String get ngtAlert => 'Advarsel om skjult GMO (NGT)';

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
  String get gmoFishRiskDesc => 'Producenten er forbundet med brugen af GMO-foder.';

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
  String get disclaimer => 'Ansvarsfraskrivelse: Disse oplysninger er kun vejledende og baseret på offentligt tilgængelige data. For 100% nøjagtige oplysninger skal du se produktets emballage eller kontakte producenten.';

  @override
  String get bovaerHighRisk => 'HØJ RISIKO: Producenten er direkte forbundet med Bovaer.';

  @override
  String get gmoHighRisk => 'HØJ RISIKO: Producenten er forbundet med brugen af GMO-foder.';

  @override
  String get bovaerPossibleRisk => 'MULIG RISIKO: Producenten er partner med virksomheder forbundet med Bovaer.';

  @override
  String get safeProduct => 'SIKKER: Produktet er mærket som økologisk.';

  @override
  String get searchHint => 'Søg... (f.eks. mælk)';

  @override
  String get delete => 'Slet';

  @override
  String get deleteListConfirmTitle => 'Slet listen?';

  @override
  String get deleteListConfirmMessage => 'Er du sikker? Dette sletter også historikken for listen.';

  @override
  String get unknownProduct => 'Ukendt produkt';

  @override
  String get removeAds => 'Fjern reklamer';

  @override
  String get removeAdsInfo => 'Fjern reklamer for mere plads i indkøbslisten';

  @override
  String get removeAdsMenuItem => 'Fjern reklamer (49 kr) – støtter videre udvikling';

  @override
  String get gmoRegExplicit => 'EU-REGELSTATUS: Produktet ser ud til at være i en GMO/NGT-reguleret kategori.';

  @override
  String get gmoRegFeedChain => 'EU-REGELSTATUS: Kan være omfattet af GMO/NGT-regler via foderkæden.';

  @override
  String get gmoRegNgt => 'EU-REGELSTATUS: Produktet kan være omfattet af den nye EU-beslutning om genredigering (NGT).';

  @override
  String get gmoRegSupplyChain => 'EU-REGELSTATUS: Mulig indirekte GMO/NGT-relevans via importør/leverandør/producentkæde.';

  @override
  String get gmoRegCropOrigin => 'EU-REGELSTATUS: GMO-udsat råvare med amerikansk/ikke-EU-oprindelse – kan udløse EU’s krav om GMO-mærkning.';

  @override
  String get gmoRegCropUnknown => 'EU-REGELSTATUS: GMO-udsat råvare i import-/leverandørleddet – oprindelsen bør verificeres.';

  @override
  String get insectRegExplicit => 'EU-REGELSTATUS: Produktet ser ud til at være i en kategori reguleret som insekter/novel food.';

  @override
  String get insectRegNovelFood => 'EU-REGELSTATUS: Produktet kan være omfattet af EU-regler for insekter som novel food.';

  @override
  String get insectRegSupplyChain => 'EU-REGELSTATUS: Mulig indirekte relevans via importør/leverandør/producentkæde.';

  @override
  String get gmoConsExplicit => 'FORBRUGERRISIKO: Produkttekst/etiket tyder på GMO-indhold.';

  @override
  String get gmoConsFeed => 'FORBRUGERRISIKO: Mærke/kategori matcher kendt eksponering for GMO-foder.';

  @override
  String get gmoConsNgt => 'FORBRUGERRISIKO: Kan påvirke forbrugermarkedet, men bør verificeres mod etiket og producentoplysninger.';

  @override
  String get gmoConsSupplyChain => 'FORBRUGERRISIKO: Mulig risiko via leverandørkæden (hvem der sælger til hvem). Tjek etiket og oprindelse.';

  @override
  String get gmoConsCropOrigin => 'FORBRUGERRISIKO: Indeholder GMO-udsat råvare (soja/majs/raps/sukkerroe/bomuld) importeret fra et land, hvor afgrøden overvejende er genmodificeret. Tjek etiketten for mærkningen “GMO-fri”.';

  @override
  String get gmoConsCropUnknown => 'FORBRUGERRISIKO: Produktet indeholder en GMO-udsat råvare (soja/majs/raps/sukkerroe/bomuld). Oprindelsen er ukendt – tjek etiket og oprindelsesland.';

  @override
  String get insectConsExplicit => 'FORBRUGERRISIKO: Produkttekst/ingredienser tyder på insektmel eller insektprotein.';

  @override
  String get insectConsNovelFood => 'FORBRUGERRISIKO: Mulig insektrelateret eksponering, tjek ingredienslisten.';

  @override
  String get insectConsSupplyChain => 'FORBRUGERRISIKO: Mulig risiko via leverandørkæden (hvem der sælger til hvem).';

  @override
  String get noKnownRisk => 'Ingen kendt risiko i denne kategori.';

  @override
  String get searchBetaNote => 'Beta: Søgefunktionen forbedres løbende. Dobbelttjek altid produktoplysningerne, før du træffer valg.';

  @override
  String get couldNotOpenLink => 'Kunne ikke åbne linket';

  @override
  String get eNumberNoDescription => 'Vi har endnu ingen beskrivelse af dette tilsætningsstof. E-nummeret er en kode for tilsætningsstoffer, der bruges i EU/EØS.';

  @override
  String get allergensTitle => 'Allergener';

  @override
  String get noAllergensFound => 'Ingen allergener fundet.';

  @override
  String get nutritionTitle => 'Næringsindhold (pr. 100 g)';

  @override
  String get noNutritionFound => 'Ingen næringsoplysninger fundet.';

  @override
  String get alertsTitle => 'Advarsler';

  @override
  String get alertEvidence => 'Dokumentation:';

  @override
  String get alertInternalListNote => 'Advarsel: intern liste over mærkeforbindelser';

  @override
  String get alertBrandTrackingNote => 'Advarsel: mærkesporing og offentlig information';

  @override
  String get reportNoteHint => 'Kort note (f.eks. falsk positiv)';

  @override
  String get report => 'Rapportér';

  @override
  String get send => 'Send';

  @override
  String get reportSaved => 'Tak — rapporten er gemt.';

  @override
  String get seeUpdatedStatus => 'Se opdateret status';

  @override
  String get openEuSource => 'Åbn EU-kilde';

  @override
  String get openInsectSource => 'Åbn insektkilde';

  @override
  String get privacyTitle => 'Privatliv';

  @override
  String get consentOptional => 'Dette er valgfrit. Hvis du ikke giver samtykke, sendes din brug ikke til analyse.';

  @override
  String get consentWorksAnyway => 'Appen virker under alle omstændigheder, og data kan forblive kun på din enhed.';

  @override
  String get readPrivacyPolicy => 'Læs privatlivspolitikken';

  @override
  String get allowAnonymousAnalytics => 'Tillad anonym analyse';

  @override
  String get analyticsEnabled => 'Tak – analyse aktiveret.';

  @override
  String get analyticsDisabled => 'Analyse deaktiveret.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Kunne ikke åbne linket: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Kunne ikke gemme rapporten: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Alvorlighed: $value';
  }

  @override
  String alertReason(String value) {
    return 'Årsag: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Sikkerhed: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Forslag fra Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '“$item” er tilføjet til $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energi: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Fedt: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'heraf mættede fedtsyrer: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Kulhydrater: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'heraf sukkerarter: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Protein: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Salt: $value g';
  }

  @override
  String get countryDataSources => 'Land / datakilder';

  @override
  String get chooseCountryTitle => 'Vælg land (prioriterer kilder)';
}
