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
  String get finnish => 'Finnish';

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
      'HOOG RISICO: De producent is rechtstreeks gekoppeld aan Bovaer.';

  @override
  String get gmoHighRisk =>
      'HOOG RISICO: De producent is gekoppeld aan het gebruik van GMO-voer.';

  @override
  String get bovaerPossibleRisk =>
      'MOGELIJK RISICO: De producent is partner van bedrijven gekoppeld aan Bovaer.';

  @override
  String get safeProduct => 'VEILIG: Het product is gecertificeerd biologisch.';

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
}
