// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Voedselcheck';

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
  String get appDescription =>
      'De app gebruikt Open Food Facts en een interne merklijst om producten met Bovaer, insectenmeel, GMO-voer en andere controversiële ingrediënten te identificeren.';

  @override
  String get alerts => 'Selecteer waarschuwingen';

  @override
  String get bovaerAlert => 'Bovaer-waarschuwing';

  @override
  String get insectMealAlert => 'Insectenmeel-waarschuwing';

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
  String get bovaerRiskDesc =>
      'De producent is rechtstreeks gekoppeld aan Bovaer.';

  @override
  String get insectMealRiskDesc => 'Het product kan insectenmeel bevatten.';

  @override
  String get gmoFishRiskDesc =>
      'De producent is gekoppeld aan het gebruik van GMO-voer.';

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
  String get korean => 'Koreaans';

  @override
  String get polish => 'Pools';

  @override
  String get russian => 'Russisch';

  @override
  String get chinese => 'Chinees';

  @override
  String get arabic => 'Arabisch';

  @override
  String get thai => 'Thais';

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
  String get disclaimer =>
      'Disclaimer: Deze informatie is alleen ter oriëntatie en gebaseerd op openbaar beschikbare gegevens. Voor 100% nauwkeurige informatie raadpleegt u de verpakking van het product of neemt u contact op met de fabrikant.';

  @override
  String get bovaerHighRisk =>
      'HOOG RISICO: Dit merk is een bevestigde Bovaer-gebruiker of behoort toe aan een producent die dat is.';

  @override
  String get gmoHighRisk =>
      'HOOG RISICO: De producent is gekoppeld aan het gebruik van GMO-voer.';

  @override
  String get bovaerPossibleRisk =>
      'ONZEKER: Het product kan melk bevatten van een zuivelbedrijf dat melk ontvangt van Bovaer-boerderijen.';

  @override
  String get safeProduct => 'VEILIG: Het product is gecertificeerd biologisch.';

  @override
  String get searchHint => 'Zoeken... (bijv. melk)';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteListConfirmTitle => 'Lijst verwijderen?';

  @override
  String get deleteListConfirmMessage =>
      'Weet u het zeker? Dit verwijdert ook de geschiedenis van de lijst.';

  @override
  String get unknownProduct => 'Onbekend product';

  @override
  String get removeAds => 'Advertenties verwijderen';

  @override
  String get removeAdsInfo =>
      'Verwijder advertenties voor meer ruimte in de boodschappenlijst';

  @override
  String get removeAdsMenuItem =>
      'Advertenties verwijderen - ondersteunt verdere ontwikkeling';

  @override
  String get premiumTitle => 'Advertenties verwijderen';

  @override
  String get premiumActiveStatus => 'Advertentievrij is actief';

  @override
  String get premiumInactiveStatus => 'Advertentievrij is nog niet geactiveerd';

  @override
  String get buyAdFreeTitle => 'Advertentievrije versie kopen';

  @override
  String get oneTimePurchaseInfo =>
      'Eenmalige aankoop. Geen abonnement.\nNa bevestigde aankoop worden advertenties permanent verwijderd voor dit account.';

  @override
  String get storeUnavailable =>
      'De winkel is momenteel niet beschikbaar. Probeer het later opnieuw.';

  @override
  String get productsLoadFailed =>
      'Koopproducten konden niet worden geladen. Controleer uw netwerk en probeer het opnieuw.';

  @override
  String get purchaseNotAvailableOnDevice =>
      'In-app purchases are not available on this device. If you have already purchased ad-free, it will be restored automatically.';

  @override
  String get tryAgain => 'Probeer opnieuw';

  @override
  String get oneTimePurchaseLabel => 'eenmalige aankoop';

  @override
  String get buyPermanently => 'Permanent kopen';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get analyticsEnabled => 'Bedankt – analyse ingeschakeld.';

  @override
  String get analyticsDisabled => 'Analyse uitgeschakeld.';

  @override
  String get privacy => 'Privacy';

  @override
  String get adFreeActive => 'Advertentievrij (actief)';

  @override
  String get consentLocalOnly =>
      'De app blijft werken en gegevens kunnen alleen op uw apparaat blijven.';

  @override
  String get allowAnonymousAnalytics => 'Anonieme analyse toestaan';

  @override
  String get consentOptional =>
      'Dit is optioneel. Als u niet akkoord gaat, worden er geen gebruiksgegevens naar analyse verzonden.';

  @override
  String get couldNotOpenLink => 'Kon link niet openen';

  @override
  String get howAppWorksSteps =>
      '1. Scan de barcode van het product.\n2. De app haalt productgegevens op via Open Food Facts.\n3. Waarschuwingen worden geëvalueerd aan de hand van interne merk- en ingrediëntregels.\n4. U krijgt een eenvoudig risico-overzicht en kunt producten opslaan in uw boodschappenlijst.';

  @override
  String get betaWarning =>
      'Belangrijk: Dit is een bètafunctie. Controleer informatie altijd aan de hand van de verpakking/het etiket.';

  @override
  String get matvaretabellenMatches => 'Matvaretabellen-overeenkomsten';

  @override
  String get reportSaved => 'Bedankt — rapport opgeslagen.';

  @override
  String get couldNotSaveReport => 'Kon rapport niet opslaan';

  @override
  String get seeUpdatedStatus => 'Bekijk bijgewerkte status';

  @override
  String get gmoFeedLabel => 'GMO-voer';

  @override
  String get insectMealLabel => 'Insectenmeel';

  @override
  String get allergensLabel => 'Allergenen';

  @override
  String get noAllergensFound => 'Geen allergenen gevonden.';

  @override
  String get nutritionPer100g => 'Voedingswaarde (per 100g)';

  @override
  String get nutritionSource => 'bron';

  @override
  String get energyLabel => 'Energie';

  @override
  String get fatLabel => 'Vet';

  @override
  String get saturatedFatLabel => 'Waarvan verzadigd vet';

  @override
  String get carbohydratesLabel => 'Koolhydraten';

  @override
  String get sugarsLabel => 'Waarvan suikers';

  @override
  String get proteinLabel => 'Eiwit';

  @override
  String get saltLabel => 'Zout';

  @override
  String get noNutritionFound => 'Geen voedingsinformatie gevonden.';

  @override
  String get unknownName => 'Onbekende naam';

  @override
  String get noInfo => 'Geen info';

  @override
  String get paymentConfirmed =>
      'Betaling bevestigd. Advertenties zijn nu permanent verwijderd.';

  @override
  String get purchaseFailed => 'Aankoop mislukt. Probeer het opnieuw.';

  @override
  String get purchaseCancelled => 'Aankoop geannuleerd.';

  @override
  String get purchaseStreamError => 'Aankoopstroom mislukt';

  @override
  String get productIdNotFound =>
      'Aankoopproduct niet gevonden. Controleer het product-ID.';

  @override
  String get internalWarning1 =>
      'Mededeling: interne lijst voor merkkoppelingen';

  @override
  String get internalWarning2 =>
      'Mededeling: merkregistratie en openbare informatie';

  @override
  String addedToList(String item, String list) {
    return '«$item» toegevoegd aan $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Boodschappenlijst: geheugen en automatisch aanvullen';

  @override
  String get shoppingListMemoryHow =>
      'Zo gebruik je het boodschappenlijstgeheugen';

  @override
  String get shoppingListMemoryIntro =>
      'De boodschappenlijst heeft geheugen en automatisch aanvullen:';

  @override
  String get shoppingListMemoryStep1 => '1. + voegt precies toe wat je typt.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Enter voegt de suggestie toe in het invoerveld.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Tik op een product in de geheugenlijst om het toe te voegen.';

  @override
  String get appReviewTestTitle => 'App Review testcodes';

  @override
  String get appReviewTestSubtitle => 'Open demoproducten zonder camera';

  @override
  String get appReviewTestInstructions =>
      'Kies een testcode om een demoproduct te openen:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Demoproduct voor $code niet gevonden';
  }

  @override
  String get adPlaceholderText => 'Advertentieplaats actief';
}
