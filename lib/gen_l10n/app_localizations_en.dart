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
  String get appDescription =>
      'The app uses Open Food Facts and an internal brand list to detect products with Bovaer, insect meal, GMO feed, and other controversial ingredients.';

  @override
  String get alerts => 'Select Alerts';

  @override
  String get bovaerAlert => 'Bovaer Alert';

  @override
  String get insectMealAlert => 'Insect Meal Alert';

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
  String get korean => 'Korean';

  @override
  String get polish => 'Polish';

  @override
  String get russian => 'Russian';

  @override
  String get chinese => 'Chinese';

  @override
  String get arabic => 'Arabic';

  @override
  String get thai => 'Thai';

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
  String get disclaimer =>
      'Disclaimer: This information is for guidance only and based on publicly available data. For 100% accurate information, see the product packaging or contact the manufacturer.';

  @override
  String get bovaerHighRisk =>
      'HIGH RISK: This brand is a confirmed Bovaer user or belongs to a producer that is.';

  @override
  String get gmoHighRisk =>
      'HIGH RISK: The producer is linked to GMO fish feed use.';

  @override
  String get bovaerPossibleRisk =>
      'UNCERTAIN: The product may contain milk from a dairy that sources from Bovaer-enrolled farms.';

  @override
  String get safeProduct => 'SAFE: The product is certified organic.';

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

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removeAdsInfo => 'Remove ads for more space in the shopping list';

  @override
  String get removeAdsMenuItem => 'Remove ads - supports further development';

  @override
  String get premiumTitle => 'Remove ads';

  @override
  String get premiumActiveStatus => 'Ad-free is active';

  @override
  String get premiumInactiveStatus => 'Ad-free is not active yet';

  @override
  String get buyAdFreeTitle => 'Buy ad-free version';

  @override
  String get oneTimePurchaseInfo =>
      'One-time purchase. No subscription.\nAfter purchase confirmation, ads are removed permanently for this account.';

  @override
  String get storeUnavailable =>
      'Store is unavailable right now. Please try again later.';

  @override
  String get productsLoadFailed =>
      'Could not load purchase products. Check your network and try again.';

  @override
  String get purchaseNotAvailableOnDevice =>
      'In-app purchases are not available on this device. If you have already purchased ad-free, it will be restored automatically.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get oneTimePurchaseLabel => 'one-time purchase';

  @override
  String get buyPermanently => 'Buy permanently';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get analyticsEnabled => 'Thanks - analytics enabled.';

  @override
  String get analyticsDisabled => 'Analytics disabled.';

  @override
  String get privacy => 'Privacy';

  @override
  String get adFreeActive => 'Ad-free (active)';

  @override
  String get consentLocalOnly =>
      'The app still works, and data can remain only on your device.';

  @override
  String get allowAnonymousAnalytics => 'Allow anonymous analytics';

  @override
  String get consentOptional =>
      'This is optional. If you do not consent, your usage is not sent to analytics.';

  @override
  String get couldNotOpenLink => 'Could not open link';

  @override
  String get howAppWorksSteps =>
      '1. Scan the product barcode.\n2. The app fetches product data from Open Food Facts.\n3. Alerts are evaluated against internal brand and ingredient rules.\n4. You get a simple risk view and can save items to your shopping list.';

  @override
  String get betaWarning =>
      'Important: This is a beta feature. Always verify information against packaging/label.';

  @override
  String get matvaretabellenMatches => 'Matvaretabellen matches';

  @override
  String get reportSaved => 'Thanks — report saved.';

  @override
  String get couldNotSaveReport => 'Could not save report';

  @override
  String get seeUpdatedStatus => 'See updated status';

  @override
  String get gmoFeedLabel => 'GMO Feed';

  @override
  String get insectMealLabel => 'Insect Meal';

  @override
  String get allergensLabel => 'Allergens';

  @override
  String get noAllergensFound => 'No allergens found.';

  @override
  String get nutritionPer100g => 'Nutrition (per 100g)';

  @override
  String get nutritionSource => 'source';

  @override
  String get energyLabel => 'Energy';

  @override
  String get fatLabel => 'Fat';

  @override
  String get saturatedFatLabel => 'Of which saturated fat';

  @override
  String get carbohydratesLabel => 'Carbohydrates';

  @override
  String get sugarsLabel => 'Of which sugars';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get saltLabel => 'Salt';

  @override
  String get noNutritionFound => 'No nutrition information found.';

  @override
  String get unknownName => 'Unknown name';

  @override
  String get noInfo => 'No info';

  @override
  String get paymentConfirmed =>
      'Payment confirmed. Ads are now permanently removed.';

  @override
  String get purchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get purchaseCancelled => 'Purchase was cancelled.';

  @override
  String get purchaseStreamError => 'Purchase stream failed';

  @override
  String get productIdNotFound =>
      'Could not find purchase product. Check product ID.';

  @override
  String get internalWarning1 =>
      'Notice: internal list for brand-link tracking';

  @override
  String get internalWarning2 =>
      'Notice: brand tracking and public information';

  @override
  String addedToList(String item, String list) {
    return '\"$item\" added to $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Shopping list: memory and autocomplete';

  @override
  String get shoppingListMemoryHow => 'How to use the shopping list memory';

  @override
  String get shoppingListMemoryIntro =>
      'The shopping list has memory and autocomplete:';

  @override
  String get shoppingListMemoryStep1 => '1. + adds exactly what you type.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Enter adds the suggestion in the input field.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Tap a product in the memory list to add it.';

  @override
  String get appReviewTestTitle => 'App Review Test Codes';

  @override
  String get appReviewTestSubtitle => 'Open demo products without camera';

  @override
  String get appReviewTestInstructions =>
      'Choose a test code to open a demo product:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Could not find demo product for $code';
  }

  @override
  String get adPlaceholderText => 'Ad placement active';
}
