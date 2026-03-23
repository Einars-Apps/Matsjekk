// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Matkoll';

  @override
  String get scanBarcode => 'Skanna streckkod';

  @override
  String get productNotFound => 'Produkten hittades inte i databasen.';

  @override
  String get addToList => 'Lägg till i inköpslista';

  @override
  String get shoppingLists => 'Inköpslistor';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Inställningar';

  @override
  String get about => 'Om appen';

  @override
  String get howAppWorks => 'Hur appen hämtar information';

  @override
  String get appDescription =>
      'Appen använder Open Food Facts och en intern märkeslista för att identifiera produkter med Bovaer, insektsmjöl, GMO-foder och andra kontroversiella ingredienser.';

  @override
  String get alerts => 'Välj aviseringar';

  @override
  String get bovaerAlert => 'Bovaer-avisering';

  @override
  String get insectMealAlert => 'Insektsmjöl-avisering';

  @override
  String get gmoFishAlert => 'GMO-foder (Fisk)';

  @override
  String get highRisk => 'HÖGRISK';

  @override
  String get possibleRisk => 'MÖJLIG RISK';

  @override
  String get safe => 'SÄKER';

  @override
  String get unknown => 'OKÄND';

  @override
  String get bovaerRiskDesc => 'Producenten är direkt kopplad till Bovaer.';

  @override
  String get insectMealRiskDesc => 'Produkten kan innehålla insektsmjöl.';

  @override
  String get gmoFishRiskDesc =>
      'Producenten är kopplad till användning av GMO-foder.';

  @override
  String get safeDesc => 'Produkten är märkt som ekologisk.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Spårbarhet';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Stäng';

  @override
  String get create => 'Skapa';

  @override
  String get search => 'Sök';

  @override
  String get searchProducts => 'Sök produkter';

  @override
  String get noResults => 'Inga resultat';

  @override
  String get newList => 'Ny lista';

  @override
  String get deleteList => 'Långtryck för att ta bort';

  @override
  String get language => 'Språk';

  @override
  String get selectLanguage => 'Välj språk';

  @override
  String get norwegian => 'Norska';

  @override
  String get swedish => 'Svenska';

  @override
  String get danish => 'Dansk';

  @override
  String get dutch => 'Nederländsk';

  @override
  String get french => 'Franska';

  @override
  String get english => 'Engelska';

  @override
  String get german => 'Tysk';

  @override
  String get italian => 'Italiensk';

  @override
  String get spanish => 'Spansk';

  @override
  String get portuguese => 'Portugisisk';

  @override
  String get finnish => 'Finska';

  @override
  String get korean => 'Koreanska';

  @override
  String get polish => 'Polska';

  @override
  String get russian => 'Ryska';

  @override
  String get chinese => 'Kinesiska';

  @override
  String get arabic => 'Arabiska';

  @override
  String get thai => 'Thailändska';

  @override
  String get changeListName => 'Ändra listnamn';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Spara';

  @override
  String get manualAddItem => 'Lägg till artikel manuellt...';

  @override
  String get emptyList => 'Listan är tom';

  @override
  String get noHistory => 'Ingen historik för denna lista';

  @override
  String get globalHistory => 'Global historik';

  @override
  String get newShoppingList => 'Ny inköpslista';

  @override
  String get listName => 'Namn på lista';

  @override
  String get noHistoryFound => 'Ingen historik hittad';

  @override
  String get addedItems => 'E-nummer';

  @override
  String get identifiedAdditions => 'Identifierade E-nummer';

  @override
  String get noAdditionsFound => 'Inga E-nummer hittades i databasen.';

  @override
  String get disclaimer =>
      'Ansvarsfriskrivning: Denna information är endast vägledande och baserad på offentligt tillgänglig data. För 100% korrekt information, se produktförpackningen eller kontakta tillverkaren.';

  @override
  String get bovaerHighRisk =>
      'HÖGRISK: Märket är en bekräftad Bovaer-användare, eller tillhör en producent som är det.';

  @override
  String get gmoHighRisk =>
      'HÖGRISK: Producenten är kopplad till användning av GMO-foder.';

  @override
  String get bovaerPossibleRisk =>
      'OSÄKER: Produkten kan innehålla mjölk från ett mejeri som tar emot mjölk från Bovaer-gårdar.';

  @override
  String get safeProduct => 'SÄKER: Produkten är märkt som ekologisk.';

  @override
  String get searchHint => 'Sök... (t.ex. mjölk)';

  @override
  String get delete => 'Ta bort';

  @override
  String get deleteListConfirmTitle => 'Ta bort lista?';

  @override
  String get deleteListConfirmMessage =>
      'Är du säker? Detta tar också bort historiken för listan.';

  @override
  String get unknownProduct => 'Okänd produkt';

  @override
  String get removeAds => 'Ta bort annonser';

  @override
  String get removeAdsInfo => 'Ta bort annonser för mer plats i inköpslistan';

  @override
  String get removeAdsMenuItem =>
      'Ta bort annonser (49 kr) - stödjer vidare utveckling';

  @override
  String get premiumTitle => 'Ta bort annonser';

  @override
  String get premiumActiveStatus => 'Annonsfri är aktiv';

  @override
  String get premiumInactiveStatus => 'Annonsfri är inte aktiverad ännu';

  @override
  String get buyAdFreeTitle => 'Köp annonsfri version';

  @override
  String get oneTimePurchaseInfo =>
      'Engångsköp. Inget abonnemang.\nEfter bekräftat köp tas annonser bort permanent för detta konto.';

  @override
  String get storeUnavailable =>
      'Butiken är inte tillgänglig just nu. Försök igen senare.';

  @override
  String get productsLoadFailed =>
      'Kunde inte ladda köpprodukter. Kontrollera nätverket och försök igen.';

  @override
  String get tryAgain => 'Försök igen';

  @override
  String get oneTimePurchaseLabel => 'engångsköp';

  @override
  String get buyPermanently => 'Köp permanent';

  @override
  String get restorePurchases => 'Återställ köp';

  @override
  String get analyticsEnabled => 'Tack – analys aktiverad.';

  @override
  String get analyticsDisabled => 'Analys avaktiverad.';

  @override
  String get privacy => 'Integritet';

  @override
  String get adFreeActive => 'Annonsfri (aktiv)';

  @override
  String get consentLocalOnly =>
      'Appen fungerar fortfarande, och data kan stanna kvar på din enhet.';

  @override
  String get allowAnonymousAnalytics => 'Tillåt anonym analys';

  @override
  String get consentOptional =>
      'Detta är valfritt. Om du inte samtycker skickas inga användningsdata till analys.';

  @override
  String get couldNotOpenLink => 'Kunde inte öppna länken';

  @override
  String get howAppWorksSteps =>
      '1. Skanna streckkoden på varan.\n2. Appen hämtar produktdata från Open Food Facts.\n3. Varningar utvärderas mot interna varumärkes- och ingrediensregler.\n4. Du får en enkel riskvy och kan spara varor i inköpslistan.';

  @override
  String get betaWarning =>
      'Viktigt: Detta är en betafunktion. Verifiera alltid information mot förpackning/etikett.';

  @override
  String get matvaretabellenMatches => 'Matvaretabellen-träffar';

  @override
  String get reportSaved => 'Tack — rapport sparad.';

  @override
  String get couldNotSaveReport => 'Kunde inte spara rapport';

  @override
  String get seeUpdatedStatus => 'Se uppdaterad status';

  @override
  String get gmoFeedLabel => 'GMO-foder';

  @override
  String get insectMealLabel => 'Insektsmjöl';

  @override
  String get allergensLabel => 'Allergener';

  @override
  String get noAllergensFound => 'Inga allergener hittade.';

  @override
  String get nutritionPer100g => 'Näringsvärde (per 100g)';

  @override
  String get nutritionSource => 'källa';

  @override
  String get energyLabel => 'Energi';

  @override
  String get fatLabel => 'Fett';

  @override
  String get saturatedFatLabel => 'Varav mättat fett';

  @override
  String get carbohydratesLabel => 'Kolhydrater';

  @override
  String get sugarsLabel => 'Varav sockerarter';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get saltLabel => 'Salt';

  @override
  String get noNutritionFound => 'Ingen näringsinformation hittad.';

  @override
  String get unknownName => 'Okänt namn';

  @override
  String get noInfo => 'Ingen info';

  @override
  String get paymentConfirmed =>
      'Betalning bekräftad. Annonser är nu permanent borttagna.';

  @override
  String get purchaseFailed => 'Köpet misslyckades. Försök igen.';

  @override
  String get purchaseCancelled => 'Köpet avbröts.';

  @override
  String get purchaseStreamError => 'Köpström misslyckades';

  @override
  String get productIdNotFound =>
      'Kunde inte hitta köpprodukten. Kontrollera produkt-ID.';

  @override
  String get internalWarning1 =>
      'Meddelande: intern lista för varumärkeslänkning';

  @override
  String get internalWarning2 =>
      'Meddelande: varumärkesspårning och offentlig information';

  @override
  String addedToList(String item, String list) {
    return '«$item» tillagd i $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Inköpslista: minne och autokomplettering';

  @override
  String get shoppingListMemoryHow => 'Så använder du inköpslistans minne';

  @override
  String get shoppingListMemoryIntro =>
      'Inköpslistan har minne och autokomplettering:';

  @override
  String get shoppingListMemoryStep1 =>
      '1. + lägger till exakt vad du skriver.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Enter lägger till förslaget i inmatningsfältet.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Tryck på en produkt i minneslistan för att lägga till den.';

  @override
  String get appReviewTestTitle => 'App Review testkoder';

  @override
  String get appReviewTestSubtitle => 'Öppna demoprodukter utan kamera';

  @override
  String get appReviewTestInstructions =>
      'Välj en testkod för att öppna en demoprodukt:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Kunde inte hitta demoprodukt för $code';
  }

  @override
  String get adPlaceholderText => 'Annonsplats aktiv';
}
