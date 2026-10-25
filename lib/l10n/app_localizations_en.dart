// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Food Check';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get productNotFound => 'Product not found in database.';

  @override
  String get addToList => 'Add to Shopping List';

  @override
  String get shoppingLists => 'Shopping Lists';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get howAppWorks => 'How the App Works';

  @override
  String get appDescription => 'The app uses Open Food Facts and an internal brand list to detect products with Bovaer, insect meal, GMO feed, and other controversial ingredients.';

  @override
  String get alerts => 'Select Alerts';

  @override
  String get bovaerAlert => 'Bovaer Alert';

  @override
  String get insectMealAlert => 'Insect Meal Alert';

  @override
  String get ngtAlert => 'Hidden GMO (NGT) Alert';

  @override
  String get gmoFishAlert => 'GMO Fish Feed Alert';

  @override
  String get highRisk => 'HIGH RISK';

  @override
  String get possibleRisk => 'POSSIBLE RISK';

  @override
  String get safe => 'SAFE';

  @override
  String get unknown => 'UNKNOWN';

  @override
  String get bovaerRiskDesc => 'The producer is directly linked to Bovaer.';

  @override
  String get insectMealRiskDesc => 'The product may contain insect meal.';

  @override
  String get gmoFishRiskDesc => 'The producer is linked to GMO fish feed use.';

  @override
  String get safeDesc => 'The product is certified organic.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Traceability';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Close';

  @override
  String get create => 'Create';

  @override
  String get search => 'Search';

  @override
  String get searchProducts => 'Search Products';

  @override
  String get noResults => 'No results';

  @override
  String get newList => 'New List';

  @override
  String get deleteList => 'Long press to delete';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get norwegian => 'Norwegian';

  @override
  String get swedish => 'Swedish';

  @override
  String get danish => 'Danish';

  @override
  String get dutch => 'Dutch';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get italian => 'Italian';

  @override
  String get spanish => 'Spanish';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get finnish => 'Finnish';

  @override
  String get changeListName => 'Change List Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get manualAddItem => 'Add item manually...';

  @override
  String get emptyList => 'List is empty';

  @override
  String get noHistory => 'No history for this list';

  @override
  String get globalHistory => 'Global History';

  @override
  String get newShoppingList => 'New Shopping List';

  @override
  String get listName => 'List Name';

  @override
  String get noHistoryFound => 'No history found';

  @override
  String get addedItems => 'E-numbers';

  @override
  String get identifiedAdditions => 'Identified E-numbers';

  @override
  String get noAdditionsFound => 'No E-numbers found in database.';

  @override
  String get disclaimer => 'Disclaimer: This information is for guidance only and based on publicly available data. For 100% accurate information, see the product packaging or contact the manufacturer.';

  @override
  String get bovaerHighRisk => 'HIGH RISK: The producer is directly linked to Bovaer.';

  @override
  String get gmoHighRisk => 'HIGH RISK: The producer is linked to GMO fish feed use.';

  @override
  String get bovaerPossibleRisk => 'POSSIBLE RISK: The producer is a partner with companies linked to Bovaer.';

  @override
  String get safeProduct => 'SAFE: The product is certified organic.';

  @override
  String get searchHint => 'Search... (e.g. milk)';

  @override
  String get delete => 'Delete';

  @override
  String get deleteListConfirmTitle => 'Delete list?';

  @override
  String get deleteListConfirmMessage => 'Are you sure? This will also delete the history for the list.';

  @override
  String get unknownProduct => 'Unknown product';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removeAdsInfo => 'Remove ads for more space in the shopping list';

  @override
  String get removeAdsMenuItem => 'Remove ads (kr 49,-) — supports further development';

  @override
  String get gmoRegExplicit => 'EU REGULATORY STATUS: The product appears to be in a GMO/NGT-regulated category.';

  @override
  String get gmoRegFeedChain => 'EU REGULATORY STATUS: May be covered by GMO/NGT rules via the feed chain.';

  @override
  String get gmoRegNgt => 'EU REGULATORY STATUS: The product may be covered by the new EU decision on gene editing (NGT).';

  @override
  String get gmoRegSupplyChain => 'EU REGULATORY STATUS: Possible indirect GMO/NGT relevance via the importer/supplier/producer chain.';

  @override
  String get gmoRegCropOrigin => 'EU REGULATORY STATUS: GMO-prone ingredient of American/non-EU origin – may trigger the EU’s GMO labelling requirement.';

  @override
  String get gmoRegCropUnknown => 'EU REGULATORY STATUS: GMO-prone ingredient at the import/supplier stage – the origin should be verified.';

  @override
  String get insectRegExplicit => 'EU REGULATORY STATUS: The product appears to be in an insect/novel-food-regulated category.';

  @override
  String get insectRegNovelFood => 'EU REGULATORY STATUS: The product may be covered by EU rules for insects as novel food.';

  @override
  String get insectRegSupplyChain => 'EU REGULATORY STATUS: Possible indirect relevance via the importer/supplier/producer chain.';

  @override
  String get gmoConsExplicit => 'CONSUMER RISK: Product text/label indicates GMO content.';

  @override
  String get gmoConsFeed => 'CONSUMER RISK: Brand/category matches known GMO feed exposure.';

  @override
  String get gmoConsNgt => 'CONSUMER RISK: May affect the consumer market, but should be verified against the label and producer information.';

  @override
  String get gmoConsSupplyChain => 'CONSUMER RISK: Possible risk via the supply chain (who sells to whom). Verify the label and origin.';

  @override
  String get gmoConsCropOrigin => 'CONSUMER RISK: Contains a GMO-prone ingredient (soy/maize/rapeseed/sugar beet/cotton) imported from a country where the crop is predominantly genetically modified. Check the label for “GMO-free” marking.';

  @override
  String get gmoConsCropUnknown => 'CONSUMER RISK: The product contains a GMO-prone ingredient (soy/maize/rapeseed/sugar beet/cotton). Origin unknown – check the label and country of origin.';

  @override
  String get insectConsExplicit => 'CONSUMER RISK: Product text/ingredients indicate insect meal or insect protein.';

  @override
  String get insectConsNovelFood => 'CONSUMER RISK: Possible insect-related exposure, check the ingredient list.';

  @override
  String get insectConsSupplyChain => 'CONSUMER RISK: Possible risk via the supply chain (who sells to whom).';

  @override
  String get noKnownRisk => 'No known risk in this category.';

  @override
  String get searchBetaNote => 'Beta: Search is continuously being improved. Always double-check product details before making choices.';

  @override
  String get couldNotOpenLink => 'Could not open the link';

  @override
  String get eNumberNoDescription => 'We don’t have a description of this additive yet. The E-number is an additive code used in the EU/EEA.';

  @override
  String get allergensTitle => 'Allergens';

  @override
  String get noAllergensFound => 'No allergens found.';

  @override
  String get nutritionTitle => 'Nutrition (per 100 g)';

  @override
  String get noNutritionFound => 'No nutrition information found.';

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get alertEvidence => 'Evidence:';

  @override
  String get alertInternalListNote => 'Alert: internal list of brand connections';

  @override
  String get alertBrandTrackingNote => 'Alert: brand tracking and public information';

  @override
  String get reportNoteHint => 'Short note (e.g. false positive)';

  @override
  String get report => 'Report';

  @override
  String get send => 'Send';

  @override
  String get reportSaved => 'Thanks — report saved.';

  @override
  String get seeUpdatedStatus => 'See updated status';

  @override
  String get openEuSource => 'Open EU source';

  @override
  String get openInsectSource => 'Open insect source';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get consentOptional => 'This is optional. If you don’t consent, your usage is not sent for analytics.';

  @override
  String get consentWorksAnyway => 'The app works either way, and data can stay on your device only.';

  @override
  String get readPrivacyPolicy => 'Read the privacy policy';

  @override
  String get allowAnonymousAnalytics => 'Allow anonymous analytics';

  @override
  String get analyticsEnabled => 'Thanks — analytics enabled.';

  @override
  String get analyticsDisabled => 'Analytics disabled.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Could not open the link: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Could not save the report: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Severity: $value';
  }

  @override
  String alertReason(String value) {
    return 'Reason: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Confidence: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Suggestions from Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '\"$item\" added to $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energy: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Fat: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'of which saturated fat: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Carbohydrates: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'of which sugars: $value g';
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
  String get countryDataSources => 'Country / data sources';

  @override
  String get chooseCountryTitle => 'Choose country (prioritises sources)';

  @override
  String get privacyIntro => 'Please review the privacy policy the first time you use the app. You can continue without analytics, and your shopping data stays on your device.';
}
