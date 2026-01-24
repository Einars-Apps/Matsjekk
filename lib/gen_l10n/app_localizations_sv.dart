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
  String get finnish => 'Finnish';

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
      'HÖGRISK: Producenten är direkt kopplad till Bovaer.';

  @override
  String get gmoHighRisk =>
      'HÖGRISK: Producenten är kopplad till användning av GMO-foder.';

  @override
  String get bovaerPossibleRisk =>
      'MÖJLIG RISK: Producenten är en partner med företag kopplade till Bovaer.';

  @override
  String get safeProduct => 'SÄKER: Produkten är märkt som ekologisk.';

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
