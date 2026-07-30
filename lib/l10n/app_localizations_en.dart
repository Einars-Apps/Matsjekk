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
}
