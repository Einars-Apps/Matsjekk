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
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @ngtAlert.
  ///
  /// In en, this message translates to:
  /// **'Hidden GMO (NGT) Alert'**
  String get ngtAlert;

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

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @removeAdsInfo.
  ///
  /// In en, this message translates to:
  /// **'Remove ads for more space in the shopping list'**
  String get removeAdsInfo;

  /// No description provided for @removeAdsMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Remove ads (kr 49,-) — supports further development'**
  String get removeAdsMenuItem;

  /// No description provided for @gmoRegExplicit.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: The product appears to be in a GMO/NGT-regulated category.'**
  String get gmoRegExplicit;

  /// No description provided for @gmoRegFeedChain.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: May be covered by GMO/NGT rules via the feed chain.'**
  String get gmoRegFeedChain;

  /// No description provided for @gmoRegNgt.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: The product may be covered by the new EU decision on gene editing (NGT).'**
  String get gmoRegNgt;

  /// No description provided for @gmoRegSupplyChain.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: Possible indirect GMO/NGT relevance via the importer/supplier/producer chain.'**
  String get gmoRegSupplyChain;

  /// No description provided for @gmoRegCropOrigin.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: GMO-prone ingredient of American/non-EU origin – may trigger the EU’s GMO labelling requirement.'**
  String get gmoRegCropOrigin;

  /// No description provided for @gmoRegCropUnknown.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: GMO-prone ingredient at the import/supplier stage – the origin should be verified.'**
  String get gmoRegCropUnknown;

  /// No description provided for @insectRegExplicit.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: The product appears to be in an insect/novel-food-regulated category.'**
  String get insectRegExplicit;

  /// No description provided for @insectRegNovelFood.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: The product may be covered by EU rules for insects as novel food.'**
  String get insectRegNovelFood;

  /// No description provided for @insectRegSupplyChain.
  ///
  /// In en, this message translates to:
  /// **'EU REGULATORY STATUS: Possible indirect relevance via the importer/supplier/producer chain.'**
  String get insectRegSupplyChain;

  /// No description provided for @gmoConsExplicit.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Product text/label indicates GMO content.'**
  String get gmoConsExplicit;

  /// No description provided for @gmoConsFeed.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Brand/category matches known GMO feed exposure.'**
  String get gmoConsFeed;

  /// No description provided for @gmoConsNgt.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: May affect the consumer market, but should be verified against the label and producer information.'**
  String get gmoConsNgt;

  /// No description provided for @gmoConsSupplyChain.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Possible risk via the supply chain (who sells to whom). Verify the label and origin.'**
  String get gmoConsSupplyChain;

  /// No description provided for @gmoConsCropOrigin.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Contains a GMO-prone ingredient (soy/maize/rapeseed/sugar beet/cotton) imported from a country where the crop is predominantly genetically modified. Check the label for “GMO-free” marking.'**
  String get gmoConsCropOrigin;

  /// No description provided for @gmoConsCropUnknown.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: The product contains a GMO-prone ingredient (soy/maize/rapeseed/sugar beet/cotton). Origin unknown – check the label and country of origin.'**
  String get gmoConsCropUnknown;

  /// No description provided for @insectConsExplicit.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Product text/ingredients indicate insect meal or insect protein.'**
  String get insectConsExplicit;

  /// No description provided for @insectConsNovelFood.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Possible insect-related exposure, check the ingredient list.'**
  String get insectConsNovelFood;

  /// No description provided for @insectConsSupplyChain.
  ///
  /// In en, this message translates to:
  /// **'CONSUMER RISK: Possible risk via the supply chain (who sells to whom).'**
  String get insectConsSupplyChain;

  /// No description provided for @noKnownRisk.
  ///
  /// In en, this message translates to:
  /// **'No known risk in this category.'**
  String get noKnownRisk;

  /// No description provided for @searchBetaNote.
  ///
  /// In en, this message translates to:
  /// **'Beta: Search is continuously being improved. Always double-check product details before making choices.'**
  String get searchBetaNote;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get couldNotOpenLink;

  /// No description provided for @eNumberNoDescription.
  ///
  /// In en, this message translates to:
  /// **'We don’t have a description of this additive yet. The E-number is an additive code used in the EU/EEA.'**
  String get eNumberNoDescription;

  /// No description provided for @allergensTitle.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergensTitle;

  /// No description provided for @noAllergensFound.
  ///
  /// In en, this message translates to:
  /// **'No allergens found.'**
  String get noAllergensFound;

  /// No description provided for @nutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition (per 100 g)'**
  String get nutritionTitle;

  /// No description provided for @noNutritionFound.
  ///
  /// In en, this message translates to:
  /// **'No nutrition information found.'**
  String get noNutritionFound;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// No description provided for @alertEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence:'**
  String get alertEvidence;

  /// No description provided for @alertInternalListNote.
  ///
  /// In en, this message translates to:
  /// **'Alert: internal list of brand connections'**
  String get alertInternalListNote;

  /// No description provided for @alertBrandTrackingNote.
  ///
  /// In en, this message translates to:
  /// **'Alert: brand tracking and public information'**
  String get alertBrandTrackingNote;

  /// No description provided for @reportNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Short note (e.g. false positive)'**
  String get reportNoteHint;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @reportSaved.
  ///
  /// In en, this message translates to:
  /// **'Thanks — report saved.'**
  String get reportSaved;

  /// No description provided for @seeUpdatedStatus.
  ///
  /// In en, this message translates to:
  /// **'See updated status'**
  String get seeUpdatedStatus;

  /// No description provided for @openEuSource.
  ///
  /// In en, this message translates to:
  /// **'Open EU source'**
  String get openEuSource;

  /// No description provided for @openInsectSource.
  ///
  /// In en, this message translates to:
  /// **'Open insect source'**
  String get openInsectSource;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @consentOptional.
  ///
  /// In en, this message translates to:
  /// **'This is optional. If you don’t consent, your usage is not sent for analytics.'**
  String get consentOptional;

  /// No description provided for @consentWorksAnyway.
  ///
  /// In en, this message translates to:
  /// **'The app works either way, and data can stay on your device only.'**
  String get consentWorksAnyway;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read the privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @allowAnonymousAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Allow anonymous analytics'**
  String get allowAnonymousAnalytics;

  /// No description provided for @analyticsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Thanks — analytics enabled.'**
  String get analyticsEnabled;

  /// No description provided for @analyticsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics disabled.'**
  String get analyticsDisabled;

  /// No description provided for @couldNotOpenLinkError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link: {error}'**
  String couldNotOpenLinkError(String error);

  /// No description provided for @reportSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the report: {error}'**
  String reportSaveFailed(String error);

  /// No description provided for @alertSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity: {value}'**
  String alertSeverity(String value);

  /// No description provided for @alertReason.
  ///
  /// In en, this message translates to:
  /// **'Reason: {value}'**
  String alertReason(String value);

  /// No description provided for @alertConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {value}'**
  String alertConfidence(String value);

  /// No description provided for @matvaretabellenSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Suggestions from Matvaretabellen: {count}'**
  String matvaretabellenSuggestions(String count);

  /// No description provided for @addedToList.
  ///
  /// In en, this message translates to:
  /// **'\"{item}\" added to {list}'**
  String addedToList(String item, String list);

  /// No description provided for @nutritionEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy: {value} kcal'**
  String nutritionEnergy(String value);

  /// No description provided for @nutritionFat.
  ///
  /// In en, this message translates to:
  /// **'Fat: {value} g'**
  String nutritionFat(String value);

  /// No description provided for @nutritionSaturatedFat.
  ///
  /// In en, this message translates to:
  /// **'of which saturated fat: {value} g'**
  String nutritionSaturatedFat(String value);

  /// No description provided for @nutritionCarbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates: {value} g'**
  String nutritionCarbohydrates(String value);

  /// No description provided for @nutritionSugars.
  ///
  /// In en, this message translates to:
  /// **'of which sugars: {value} g'**
  String nutritionSugars(String value);

  /// No description provided for @nutritionProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein: {value} g'**
  String nutritionProtein(String value);

  /// No description provided for @nutritionSalt.
  ///
  /// In en, this message translates to:
  /// **'Salt: {value} g'**
  String nutritionSalt(String value);

  /// No description provided for @countryDataSources.
  ///
  /// In en, this message translates to:
  /// **'Country / data sources'**
  String get countryDataSources;

  /// No description provided for @chooseCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose country (prioritises sources)'**
  String get chooseCountryTitle;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Please review the privacy policy the first time you use the app. You can continue without analytics, and your shopping data stays on your device.'**
  String get privacyIntro;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['da', 'de', 'en', 'es', 'fi', 'fr', 'it', 'nb', 'nl', 'pt', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da': return AppLocalizationsDa();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fi': return AppLocalizationsFi();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'nb': return AppLocalizationsNb();
    case 'nl': return AppLocalizationsNl();
    case 'pt': return AppLocalizationsPt();
    case 'sv': return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
