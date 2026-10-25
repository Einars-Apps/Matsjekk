// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Mat-check';

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
  String get appDescription => 'Appen använder Open Food Facts och en intern märkeslista för att identifiera produkter med Bovaer, insektsmjöl, GMO-foder och andra kontroversiella ingredienser.';

  @override
  String get alerts => 'Välj aviseringar';

  @override
  String get bovaerAlert => 'Bovaer-avisering';

  @override
  String get insectMealAlert => 'Insektsmjöl-avisering';

  @override
  String get ngtAlert => 'Varning för dold GMO (NGT)';

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
  String get gmoFishRiskDesc => 'Producenten är kopplad till användning av GMO-foder.';

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
  String get dutch => 'Nederländska';

  @override
  String get french => 'Franska';

  @override
  String get english => 'Engelska';

  @override
  String get german => 'Tyska';

  @override
  String get italian => 'Italienska';

  @override
  String get spanish => 'Spanska';

  @override
  String get portuguese => 'Portugisiska';

  @override
  String get finnish => 'Finska';

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
  String get disclaimer => 'Ansvarsfriskrivning: Denna information är endast vägledande och baserad på offentligt tillgänglig data. För 100% korrekt information, se produktförpackningen eller kontakta tillverkaren.';

  @override
  String get bovaerHighRisk => 'HÖGRISK: Producenten är direkt kopplad till Bovaer.';

  @override
  String get gmoHighRisk => 'HÖGRISK: Producenten är kopplad till användning av GMO-foder.';

  @override
  String get bovaerPossibleRisk => 'MÖJLIG RISK: Producenten är en partner med företag kopplade till Bovaer.';

  @override
  String get safeProduct => 'SÄKER: Produkten är märkt som ekologisk.';

  @override
  String get searchHint => 'Sök... (t.ex. mjölk)';

  @override
  String get delete => 'Radera';

  @override
  String get deleteListConfirmTitle => 'Radera listan?';

  @override
  String get deleteListConfirmMessage => 'Är du säker? Detta raderar även historiken för listan.';

  @override
  String get unknownProduct => 'Okänd produkt';

  @override
  String get removeAds => 'Ta bort annonser';

  @override
  String get removeAdsInfo => 'Ta bort annonser för mer plats i inköpslistan';

  @override
  String get removeAdsMenuItem => 'Ta bort annonser (49 kr) – stöder fortsatt utveckling';

  @override
  String get gmoRegExplicit => 'EU-REGELSTATUS: Produkten verkar tillhöra en GMO/NGT-reglerad kategori.';

  @override
  String get gmoRegFeedChain => 'EU-REGELSTATUS: Kan omfattas av GMO/NGT-regler via foderkedjan.';

  @override
  String get gmoRegNgt => 'EU-REGELSTATUS: Produkten kan omfattas av det nya EU-beslutet om genredigering (NGT).';

  @override
  String get gmoRegSupplyChain => 'EU-REGELSTATUS: Möjlig indirekt GMO/NGT-relevans via importör/leverantör/producentkedja.';

  @override
  String get gmoRegCropOrigin => 'EU-REGELSTATUS: GMO-utsatt råvara med amerikanskt/icke-EU-ursprung – kan utlösa EU:s krav på GMO-märkning.';

  @override
  String get gmoRegCropUnknown => 'EU-REGELSTATUS: GMO-utsatt råvara i import-/leverantörsledet – ursprunget bör verifieras.';

  @override
  String get insectRegExplicit => 'EU-REGELSTATUS: Produkten verkar tillhöra en kategori som regleras som insekter/nya livsmedel.';

  @override
  String get insectRegNovelFood => 'EU-REGELSTATUS: Produkten kan omfattas av EU:s regler för insekter som nya livsmedel.';

  @override
  String get insectRegSupplyChain => 'EU-REGELSTATUS: Möjlig indirekt relevans via importör/leverantör/producentkedja.';

  @override
  String get gmoConsExplicit => 'KONSUMENTRISK: Produkttext/etikett tyder på GMO-innehåll.';

  @override
  String get gmoConsFeed => 'KONSUMENTRISK: Märke/kategori matchar känd exponering för GMO-foder.';

  @override
  String get gmoConsNgt => 'KONSUMENTRISK: Kan påverka konsumentmarknaden, men bör verifieras mot etikett och producentinformation.';

  @override
  String get gmoConsSupplyChain => 'KONSUMENTRISK: Möjlig risk via leverantörskedjan (vem som säljer till vem). Kontrollera etikett och ursprung.';

  @override
  String get gmoConsCropOrigin => 'KONSUMENTRISK: Innehåller GMO-utsatt råvara (soja/majs/raps/sockerbeta/bomull) importerad från ett land där grödan till övervägande del är genmodifierad. Kontrollera etiketten efter märkningen ”GMO-fri”.';

  @override
  String get gmoConsCropUnknown => 'KONSUMENTRISK: Produkten innehåller en GMO-utsatt råvara (soja/majs/raps/sockerbeta/bomull). Ursprunget är okänt – kontrollera etikett och ursprungsland.';

  @override
  String get insectConsExplicit => 'KONSUMENTRISK: Produkttext/ingredienser tyder på insektsmjöl eller insektsprotein.';

  @override
  String get insectConsNovelFood => 'KONSUMENTRISK: Möjlig insektsrelaterad exponering, kontrollera ingrediensförteckningen.';

  @override
  String get insectConsSupplyChain => 'KONSUMENTRISK: Möjlig risk via leverantörskedjan (vem som säljer till vem).';

  @override
  String get noKnownRisk => 'Ingen känd risk i denna kategori.';

  @override
  String get searchBetaNote => 'Beta: Sökfunktionen förbättras kontinuerligt. Dubbelkolla alltid produktinformationen innan du gör val.';

  @override
  String get couldNotOpenLink => 'Kunde inte öppna länken';

  @override
  String get eNumberNoDescription => 'Vi har ingen beskrivning av denna tillsats ännu. E-numret är en kod för tillsatser som används i EU/EES.';

  @override
  String get allergensTitle => 'Allergener';

  @override
  String get noAllergensFound => 'Inga allergener hittades.';

  @override
  String get nutritionTitle => 'Näringsinnehåll (per 100 g)';

  @override
  String get noNutritionFound => 'Ingen näringsinformation hittades.';

  @override
  String get alertsTitle => 'Varningar';

  @override
  String get alertEvidence => 'Underlag:';

  @override
  String get alertInternalListNote => 'Varning: intern lista över varumärkeskopplingar';

  @override
  String get alertBrandTrackingNote => 'Varning: varumärkesspårning och offentlig information';

  @override
  String get reportNoteHint => 'Kort anteckning (t.ex. falskt positiv)';

  @override
  String get report => 'Rapportera';

  @override
  String get send => 'Skicka';

  @override
  String get reportSaved => 'Tack — rapporten har sparats.';

  @override
  String get seeUpdatedStatus => 'Se uppdaterad status';

  @override
  String get openEuSource => 'Öppna EU-källa';

  @override
  String get openInsectSource => 'Öppna insektskälla';

  @override
  String get privacyTitle => 'Integritet';

  @override
  String get consentOptional => 'Detta är valfritt. Om du inte samtycker skickas din användning inte för analys.';

  @override
  String get consentWorksAnyway => 'Appen fungerar ändå, och data kan stanna enbart på din enhet.';

  @override
  String get readPrivacyPolicy => 'Läs integritetspolicyn';

  @override
  String get allowAnonymousAnalytics => 'Tillåt anonym analys';

  @override
  String get analyticsEnabled => 'Tack – analys aktiverad.';

  @override
  String get analyticsDisabled => 'Analys avaktiverad.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Kunde inte öppna länken: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Kunde inte spara rapporten: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Allvarlighetsgrad: $value';
  }

  @override
  String alertReason(String value) {
    return 'Orsak: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Säkerhet: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Förslag från Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '”$item” har lagts till i $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energi: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Fett: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'varav mättat fett: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Kolhydrater: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'varav sockerarter: $value g';
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
  String get countryDataSources => 'Land / datakällor';

  @override
  String get chooseCountryTitle => 'Välj land (prioriterar källor)';

  @override
  String get privacyIntro => 'Läs integritetspolicyn första gången du använder appen. Du kan använda appen utan analys, och dina inköpsdata stannar lokalt på enheten.';
}
