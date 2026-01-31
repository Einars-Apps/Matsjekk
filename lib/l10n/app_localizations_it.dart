// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Controllo Alimenti';

  @override
  String get scanBarcode => 'Scansiona codice a barre';

  @override
  String get productNotFound => 'Prodotto non trovato nel database.';

  @override
  String get addToList => 'Aggiungi alla lista della spesa';

  @override
  String get shoppingLists => 'Liste della spesa';

  @override
  String get history => 'Cronologia';

  @override
  String get settings => 'Impostazioni';

  @override
  String get about => 'Informazioni sull\'app';

  @override
  String get howAppWorks => 'Come l\'app recupera le informazioni';

  @override
  String get appDescription =>
      'L\'app utilizza Open Food Facts e un elenco interno di marchi per identificare prodotti con Bovaer, farina di insetti, mangimi OGM e altri ingredienti controversi.';

  @override
  String get alerts => 'Seleziona avvisi';

  @override
  String get bovaerAlert => 'Avviso Bovaer';

  @override
  String get insectMealAlert => 'Avviso farina di insetti';

  @override
  String get gmoFishAlert => 'Mangimi OGM (Pesce)';

  @override
  String get highRisk => 'RISCHIO ALTO';

  @override
  String get possibleRisk => 'RISCHIO POSSIBILE';

  @override
  String get safe => 'SICURO';

  @override
  String get unknown => 'SCONOSCIUTO';

  @override
  String get bovaerRiskDesc =>
      'Il produttore è direttamente collegato a Bovaer.';

  @override
  String get insectMealRiskDesc =>
      'Il prodotto può contenere farina di insetti.';

  @override
  String get gmoFishRiskDesc =>
      'Il produttore è collegato all\'uso di mangimi OGM.';

  @override
  String get safeDesc => 'Il prodotto è certificato biologico.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Tracciabilità';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Chiudi';

  @override
  String get create => 'Crea';

  @override
  String get search => 'Ricerca';

  @override
  String get searchProducts => 'Cerca prodotti';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get newList => 'Nuova lista';

  @override
  String get deleteList => 'Tocca a lungo per eliminare';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get norwegian => 'Norvegese';

  @override
  String get swedish => 'Svedese';

  @override
  String get danish => 'Danese';

  @override
  String get dutch => 'Olandese';

  @override
  String get french => 'Francese';

  @override
  String get english => 'Inglese';

  @override
  String get german => 'Tedesco';

  @override
  String get italian => 'Italiano';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get finnish => 'Finnish';

  @override
  String get changeListName => 'Cambia nome lista';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get manualAddItem => 'Aggiungi articolo manualmente...';

  @override
  String get emptyList => 'La lista è vuota';

  @override
  String get noHistory => 'Nessuna cronologia per questa lista';

  @override
  String get globalHistory => 'Cronologia globale';

  @override
  String get newShoppingList => 'Nuova lista della spesa';

  @override
  String get listName => 'Nome lista';

  @override
  String get noHistoryFound => 'Nessuna cronologia trovata';

  @override
  String get addedItems => 'Additivi E';

  @override
  String get identifiedAdditions => 'Additivi E identificati';

  @override
  String get noAdditionsFound => 'Nessun additivo E trovato nel database.';

  @override
  String get disclaimer =>
      'Disclaimer: Queste informazioni sono solo a scopo informativo e basate su dati disponibili al pubblico. Per informazioni 100% accurate, consultare l\'imballaggio del prodotto o contattare il produttore.';

  @override
  String get bovaerHighRisk =>
      'RISCHIO ALTO: Il produttore è direttamente collegato a Bovaer.';

  @override
  String get gmoHighRisk =>
      'RISCHIO ALTO: Il produttore è collegato all\'uso di mangimi OGM.';

  @override
  String get bovaerPossibleRisk =>
      'RISCHIO POSSIBILE: Il produttore è partner di aziende collegate a Bovaer.';

  @override
  String get safeProduct => 'SICURO: Il prodotto è certificato biologico.';

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
