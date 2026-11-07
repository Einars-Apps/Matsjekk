// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Voedsel Check';

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get productNotFound => 'Product niet in database gevonden.';

  @override
  String get addToList => 'Toevoegen aan boodschappenlijst';

  @override
  String get shoppingLists => 'Boodschappenlisten';

  @override
  String get history => 'Geschiedenis';

  @override
  String get settings => 'Instellingen';

  @override
  String get about => 'Over de app';

  @override
  String get howAppWorks => 'Hoe de app informatie ophaalt';

  @override
  String get appDescription => 'De app gebruikt Open Food Facts en een interne merklijst om producten met Bovaer, insectenmeel, GMO-voer en andere controversiële ingrediënten te identificeren.';

  @override
  String get alerts => 'Selecteer waarschuwingen';

  @override
  String get bovaerAlert => 'Bovaer-waarschuwing';

  @override
  String get insectMealAlert => 'Insectenmeel-waarschuwing';

  @override
  String get ngtAlert => 'Waarschuwing verborgen GGO (NGT)';

  @override
  String get gmoFishAlert => 'GMO-voer (Vis)';

  @override
  String get highRisk => 'HOOG RISICO';

  @override
  String get possibleRisk => 'MOGELIJK RISICO';

  @override
  String get safe => 'VEILIG';

  @override
  String get unknown => 'ONBEKEND';

  @override
  String get bovaerRiskDesc => 'De producent is rechtstreeks gekoppeld aan Bovaer.';

  @override
  String get insectMealRiskDesc => 'Het product kan insectenmeel bevatten.';

  @override
  String get gmoFishRiskDesc => 'De producent is gekoppeld aan het gebruik van GMO-voer.';

  @override
  String get safeDesc => 'Het product is gecertificeerd biologisch.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Traceerbaarheid';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Sluiten';

  @override
  String get create => 'Aanmaken';

  @override
  String get search => 'Zoeken';

  @override
  String get searchProducts => 'Producten zoeken';

  @override
  String get noResults => 'Geen resultaten';

  @override
  String get newList => 'Nieuwe lijst';

  @override
  String get deleteList => 'Lang indrukken om te verwijderen';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Selecteer taal';

  @override
  String get norwegian => 'Noors';

  @override
  String get swedish => 'Zweeds';

  @override
  String get danish => 'Deens';

  @override
  String get dutch => 'Nederlands';

  @override
  String get french => 'Frans';

  @override
  String get english => 'Engels';

  @override
  String get german => 'Duits';

  @override
  String get italian => 'Italiaans';

  @override
  String get spanish => 'Spaans';

  @override
  String get portuguese => 'Portugees';

  @override
  String get finnish => 'Fins';

  @override
  String get changeListName => 'Naam van lijst wijzigen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get manualAddItem => 'Artikel handmatig toevoegen...';

  @override
  String get emptyList => 'Lijst is leeg';

  @override
  String get noHistory => 'Geen historiek voor deze lijst';

  @override
  String get globalHistory => 'Globale historiek';

  @override
  String get newShoppingList => 'Nieuwe boodschappenlijst';

  @override
  String get listName => 'Naam van lijst';

  @override
  String get noHistoryFound => 'Geen historiek gevonden';

  @override
  String get addedItems => 'E-nummers';

  @override
  String get identifiedAdditions => 'Geïdentificeerde E-nummers';

  @override
  String get noAdditionsFound => 'Geen E-nummers in database gevonden.';

  @override
  String get disclaimer => 'Disclaimer: Deze informatie is alleen ter oriëntatie en gebaseerd op openbaar beschikbare gegevens. Voor 100% nauwkeurige informatie raadpleegt u de verpakking van het product of neemt u contact op met de fabrikant.';

  @override
  String get bovaerHighRisk => 'HOOG RISICO: De producent is rechtstreeks gekoppeld aan Bovaer.';

  @override
  String get gmoHighRisk => 'HOOG RISICO: De producent is gekoppeld aan het gebruik van GMO-voer.';

  @override
  String get bovaerPossibleRisk => 'MOGELIJK RISICO: De producent is partner van bedrijven gekoppeld aan Bovaer.';

  @override
  String get safeProduct => 'VEILIG: Het product is gecertificeerd biologisch.';

  @override
  String get searchHint => 'Zoeken... (bijv. melk)';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteListConfirmTitle => 'Lijst verwijderen?';

  @override
  String get deleteListConfirmMessage => 'Weet je het zeker? Hiermee wordt ook de geschiedenis van de lijst verwijderd.';

  @override
  String get unknownProduct => 'Onbekend product';

  @override
  String get removeAds => 'Advertenties verwijderen';

  @override
  String get removeAdsInfo => 'Verwijder advertenties voor meer ruimte in de boodschappenlijst';

  @override
  String get removeAdsMenuItem => 'Advertenties verwijderen (49 kr) – steunt verdere ontwikkeling';

  @override
  String get gmoRegExplicit => 'EU-REGELGEVING: Het product lijkt in een door GGO/NGT-regels gereguleerde categorie te vallen.';

  @override
  String get gmoRegFeedChain => 'EU-REGELGEVING: Kan via de diervoederketen onder GGO/NGT-regels vallen.';

  @override
  String get gmoRegNgt => 'EU-REGELGEVING: Het product kan onder het nieuwe EU-besluit over genbewerking (NGT) vallen.';

  @override
  String get gmoRegSupplyChain => 'EU-REGELGEVING: Mogelijk indirect GGO/NGT-relevant via de keten importeur/leverancier/producent.';

  @override
  String get gmoRegCropOrigin => 'EU-REGELGEVING: GGO-gevoelige grondstof van Amerikaanse/niet-EU-herkomst – kan de EU-etiketteringsplicht voor GGO’s activeren.';

  @override
  String get gmoRegCropUnknown => 'EU-REGELGEVING: GGO-gevoelige grondstof in de import-/leveranciersschakel – de herkomst moet worden gecontroleerd.';

  @override
  String get insectRegExplicit => 'EU-REGELGEVING: Het product lijkt in een als insecten/nieuw voedingsmiddel gereguleerde categorie te vallen.';

  @override
  String get insectRegNovelFood => 'EU-REGELGEVING: Het product kan onder de EU-regels voor insecten als nieuw voedingsmiddel vallen.';

  @override
  String get insectRegSupplyChain => 'EU-REGELGEVING: Mogelijk indirect relevant via de keten importeur/leverancier/producent.';

  @override
  String get gmoConsExplicit => 'CONSUMENTENRISICO: Producttekst/etiket wijst op GGO-inhoud.';

  @override
  String get gmoConsFeed => 'CONSUMENTENRISICO: Merk/categorie komt overeen met bekende blootstelling aan GGO-voer.';

  @override
  String get gmoConsNgt => 'CONSUMENTENRISICO: Kan de consumentenmarkt beïnvloeden, maar controleer dit met het etiket en de producentinformatie.';

  @override
  String get gmoConsSupplyChain => 'CONSUMENTENRISICO: Mogelijk risico via de toeleveringsketen (wie aan wie verkoopt). Controleer etiket en herkomst.';

  @override
  String get gmoConsCropOrigin => 'CONSUMENTENRISICO: Bevat een GGO-gevoelige grondstof (soja/maïs/koolzaad/suikerbiet/katoen) uit een land waar het gewas overwegend genetisch gemodificeerd is. Kijk op het etiket naar een “GGO-vrij”-vermelding.';

  @override
  String get gmoConsCropUnknown => 'CONSUMENTENRISICO: Het product bevat een GGO-gevoelige grondstof (soja/maïs/koolzaad/suikerbiet/katoen). Herkomst onbekend – controleer etiket en land van herkomst.';

  @override
  String get insectConsExplicit => 'CONSUMENTENRISICO: Producttekst/ingrediënten wijzen op insectenmeel of insecteneiwit.';

  @override
  String get insectConsNovelFood => 'CONSUMENTENRISICO: Mogelijke blootstelling aan insecten, controleer de ingrediëntenlijst.';

  @override
  String get insectConsSupplyChain => 'CONSUMENTENRISICO: Mogelijk risico via de toeleveringsketen (wie aan wie verkoopt).';

  @override
  String get noKnownRisk => 'Geen bekend risico in deze categorie.';

  @override
  String get searchBetaNote => 'Bèta: De zoekfunctie wordt voortdurend verbeterd. Controleer productgegevens altijd voordat je keuzes maakt.';

  @override
  String get couldNotOpenLink => 'Kan de link niet openen';

  @override
  String get eNumberNoDescription => 'We hebben nog geen beschrijving van dit additief. Het E-nummer is een additievencode die in de EU/EER wordt gebruikt.';

  @override
  String get allergensTitle => 'Allergenen';

  @override
  String get noAllergensFound => 'Geen allergenen gevonden.';

  @override
  String get nutritionTitle => 'Voedingswaarde (per 100 g)';

  @override
  String get noNutritionFound => 'Geen voedingsinformatie gevonden.';

  @override
  String get alertsTitle => 'Waarschuwingen';

  @override
  String get alertEvidence => 'Bewijs:';

  @override
  String get alertInternalListNote => 'Waarschuwing: interne lijst met merkkoppelingen';

  @override
  String get alertBrandTrackingNote => 'Waarschuwing: merktracering en openbare informatie';

  @override
  String get reportNoteHint => 'Korte notitie (bijv. vals positief)';

  @override
  String get report => 'Melden';

  @override
  String get send => 'Versturen';

  @override
  String get reportSaved => 'Bedankt — melding opgeslagen.';

  @override
  String get seeUpdatedStatus => 'Bekijk de actuele status';

  @override
  String get openEuSource => 'EU-bron openen';

  @override
  String get openInsectSource => 'Insectenbron openen';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get consentOptional => 'Dit is optioneel. Als je geen toestemming geeft, wordt je gebruik niet voor analyse verzonden.';

  @override
  String get consentWorksAnyway => 'De app werkt hoe dan ook, en gegevens kunnen alleen op je apparaat blijven.';

  @override
  String get readPrivacyPolicy => 'Lees het privacybeleid';

  @override
  String get allowAnonymousAnalytics => 'Anonieme analyse toestaan';

  @override
  String get analyticsEnabled => 'Bedankt – analyse ingeschakeld.';

  @override
  String get analyticsDisabled => 'Analyse uitgeschakeld.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Kan de link niet openen: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Kan de melding niet opslaan: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Ernst: $value';
  }

  @override
  String alertReason(String value) {
    return 'Reden: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Zekerheid: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Suggesties uit Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '\"$item\" toegevoegd aan $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energie: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Vet: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'waarvan verzadigd vet: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Koolhydraten: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'waarvan suikers: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Eiwitten: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Zout: $value g';
  }

  @override
  String get countryDataSources => 'Land / gegevensbronnen';

  @override
  String get chooseCountryTitle => 'Kies land (geeft bronnen voorrang)';

  @override
  String get privacyIntro => 'Lees het privacybeleid wanneer je de app voor het eerst gebruikt. Je kunt de app zonder analyse gebruiken en je boodschappengegevens blijven op je apparaat.';
}
