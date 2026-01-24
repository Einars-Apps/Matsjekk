import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('nb'),
    Locale('nl'),
    Locale('pt'),
    Locale('sv')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Food Check'**
  String get appTitle;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found in database.'**
  String get productNotFound;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add to Shopping List'**
  String get addToList;

  /// No description provided for @shoppingLists.
  ///
  /// In en, this message translates to:
  /// **'Shopping Lists'**
  String get shoppingLists;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @howAppWorks.
  ///
  /// In en, this message translates to:
  /// **'How the App Works'**
  String get howAppWorks;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'The app uses Open Food Facts and an internal brand list to detect products with Bovaer, insect meal, GMO feed, and other controversial ingredients.'**
  String get appDescription;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Select Alerts'**
  String get alerts;

  /// No description provided for @bovaerAlert.
  ///
  /// In en, this message translates to:
  /// **'Bovaer Alert'**
  String get bovaerAlert;

  /// No description provided for @insectMealAlert.
  ///
  /// In en, this message translates to:
  /// **'Insect Meal Alert'**
  String get insectMealAlert;

  /// No description provided for @gmoFishAlert.
  ///
  /// In en, this message translates to:
  /// **'GMO Fish Feed Alert'**
  String get gmoFishAlert;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'HIGH RISK'**
  String get highRisk;

  /// No description provided for @possibleRisk.
  ///
  /// In en, this message translates to:
  /// **'POSSIBLE RISK'**
  String get possibleRisk;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get safe;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get unknown;

  /// No description provided for @bovaerRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'The producer is directly linked to Bovaer.'**
  String get bovaerRiskDesc;

  /// No description provided for @insectMealRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'The product may contain insect meal.'**
  String get insectMealRiskDesc;

  /// No description provided for @gmoFishRiskDesc.
  ///
  /// In en, this message translates to:
  /// **'The producer is linked to GMO fish feed use.'**
  String get gmoFishRiskDesc;

  /// No description provided for @safeDesc.
  ///
  /// In en, this message translates to:
  /// **'The product is certified organic.'**
  String get safeDesc;

  /// No description provided for @nutriScore.
  ///
  /// In en, this message translates to:
  /// **'Nutri-Score'**
  String get nutriScore;

  /// No description provided for @traceability.
  ///
  /// In en, this message translates to:
  /// **'Traceability'**
  String get traceability;

  /// No description provided for @beta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get beta;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProducts;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// No description provided for @newList.
  ///
  /// In en, this message translates to:
  /// **'New List'**
  String get newList;

  /// No description provided for @deleteList.
  ///
  /// In en, this message translates to:
  /// **'Long press to delete'**
  String get deleteList;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @norwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get norwegian;

  /// No description provided for @swedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedish;

  /// No description provided for @danish.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get danish;

  /// No description provided for @dutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @italian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @finnish.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get finnish;

  /// No description provided for @changeListName.
  ///
  /// In en, this message translates to:
  /// **'Change List Name'**
  String get changeListName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @manualAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item manually...'**
  String get manualAddItem;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'List is empty'**
  String get emptyList;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history for this list'**
  String get noHistory;

  /// No description provided for @globalHistory.
  ///
  /// In en, this message translates to:
  /// **'Global History'**
  String get globalHistory;

  /// No description provided for @newShoppingList.
  ///
  /// In en, this message translates to:
  /// **'New Shopping List'**
  String get newShoppingList;

  /// No description provided for @listName.
  ///
  /// In en, this message translates to:
  /// **'List Name'**
  String get listName;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No history found'**
  String get noHistoryFound;

  /// No description provided for @addedItems.
  ///
  /// In en, this message translates to:
  /// **'E-numbers'**
  String get addedItems;

  /// No description provided for @identifiedAdditions.
  ///
  /// In en, this message translates to:
  /// **'Identified E-numbers'**
  String get identifiedAdditions;

  /// No description provided for @noAdditionsFound.
  ///
  /// In en, this message translates to:
  /// **'No E-numbers found in database.'**
  String get noAdditionsFound;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: This information is for guidance only and based on publicly available data. For 100% accurate information, see the product packaging or contact the manufacturer.'**
  String get disclaimer;

  /// No description provided for @bovaerHighRisk.
  ///
  /// In en, this message translates to:
  /// **'HIGH RISK: The producer is directly linked to Bovaer.'**
  String get bovaerHighRisk;

  /// No description provided for @gmoHighRisk.
  ///
  /// In en, this message translates to:
  /// **'HIGH RISK: The producer is linked to GMO fish feed use.'**
  String get gmoHighRisk;

  /// No description provided for @bovaerPossibleRisk.
  ///
  /// In en, this message translates to:
  /// **'POSSIBLE RISK: The producer is a partner with companies linked to Bovaer.'**
  String get bovaerPossibleRisk;

  /// No description provided for @safeProduct.
  ///
  /// In en, this message translates to:
  /// **'SAFE: The product is certified organic.'**
  String get safeProduct;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search... (e.g. milk)'**
  String get searchHint;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteListConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete list?'**
  String get deleteListConfirmTitle;

  /// No description provided for @deleteListConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This will also delete the history for the list.'**
  String get deleteListConfirmMessage;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown product'**
  String get unknownProduct;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'da',
        'de',
        'en',
        'es',
        'fi',
        'fr',
        'it',
        'nb',
        'nl',
        'pt',
        'sv'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
