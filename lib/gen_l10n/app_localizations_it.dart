// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Controlla Cibo';

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
  String get ngtAlert => 'Hidden GMO (NGT) Alert';

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
  String get finnish => 'Finlandese';

  @override
  String get korean => 'Coreano';

  @override
  String get polish => 'Polacco';

  @override
  String get russian => 'Russo';

  @override
  String get chinese => 'Cinese';

  @override
  String get arabic => 'Arabo';

  @override
  String get thai => 'Thailandese';

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
      'RISCHIO ALTO: Il marchio è un utilizzatore confermato di Bovaer o appartiene a un produttore che lo è.';

  @override
  String get gmoHighRisk =>
      'RISCHIO ALTO: Il produttore è collegato all\'uso di mangimi OGM.';

  @override
  String get bovaerPossibleRisk =>
      'INCERTO: Il prodotto può contenere latte di un caseificio che riceve latte da allevamenti con Bovaer.';

  @override
  String get safeProduct => 'SICURO: Il prodotto è certificato biologico.';

  @override
  String get searchHint => 'Cerca... (es. latte)';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteListConfirmTitle => 'Eliminare la lista?';

  @override
  String get deleteListConfirmMessage =>
      'Sei sicuro? Questo eliminerà anche la cronologia della lista.';

  @override
  String get unknownProduct => 'Prodotto sconosciuto';

  @override
  String get removeAds => 'Rimuovi annunci';

  @override
  String get removeAdsInfo =>
      'Rimuovi gli annunci per avere più spazio nella lista della spesa';

  @override
  String get removeAdsMenuItem =>
      'Rimuovi annunci - supporta lo sviluppo continuo';

  @override
  String get premiumTitle => 'Rimuovi annunci';

  @override
  String get premiumActiveStatus => 'Senza annunci è attivo';

  @override
  String get premiumInactiveStatus => 'Senza annunci non è ancora attivo';

  @override
  String get buyAdFreeTitle => 'Acquista versione senza annunci';

  @override
  String get oneTimePurchaseInfo =>
      'Acquisto unico. Nessun abbonamento.\nDopo la conferma dell\'acquisto, gli annunci vengono rimossi permanentemente per questo account.';

  @override
  String get storeUnavailable =>
      'Il negozio non è disponibile al momento. Riprova più tardi.';

  @override
  String get productsLoadFailed =>
      'Impossibile caricare i prodotti di acquisto. Controlla la rete e riprova.';

  @override
  String get purchaseNotAvailableOnDevice =>
      'In-app purchases are not available on this device. If you have already purchased ad-free, it will be restored automatically.';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get oneTimePurchaseLabel => 'acquisto unico';

  @override
  String get buyPermanently => 'Acquista permanentemente';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get analyticsEnabled => 'Grazie – analisi attivata.';

  @override
  String get analyticsDisabled => 'Analisi disattivata.';

  @override
  String get privacy => 'Privacy';

  @override
  String get adFreeActive => 'Senza annunci (attivo)';

  @override
  String get consentLocalOnly =>
      'L\'app continua a funzionare e i dati possono rimanere solo sul tuo dispositivo.';

  @override
  String get allowAnonymousAnalytics => 'Consenti analisi anonima';

  @override
  String get consentOptional =>
      'Questo è facoltativo. Se non acconsenti, i tuoi dati di utilizzo non vengono inviati all\'analisi.';

  @override
  String get couldNotOpenLink => 'Impossibile aprire il link';

  @override
  String get howAppWorksSteps =>
      '1. Scansiona il codice a barre del prodotto.\n2. L\'app recupera i dati del prodotto da Open Food Facts.\n3. Gli avvisi vengono valutati secondo le regole interne di marchi e ingredienti.\n4. Ottieni una semplice vista del rischio e puoi salvare articoli nella lista della spesa.';

  @override
  String get betaWarning =>
      'Importante: Questa è una funzione beta. Verifica sempre le informazioni sulla confezione/etichetta.';

  @override
  String get matvaretabellenMatches => 'Risultati Matvaretabellen';

  @override
  String get reportSaved => 'Grazie — rapporto salvato.';

  @override
  String get couldNotSaveReport => 'Impossibile salvare il rapporto';

  @override
  String get seeUpdatedStatus => 'Vedi stato aggiornato';

  @override
  String get gmoFeedLabel => 'Mangime OGM';

  @override
  String get insectMealLabel => 'Farina di insetti';

  @override
  String get ngtLabel => 'Hidden GMO (NGT)';

  @override
  String get allergensLabel => 'Allergeni';

  @override
  String get noAllergensFound => 'Nessun allergene trovato.';

  @override
  String get nutritionPer100g => 'Valori nutrizionali (per 100g)';

  @override
  String get nutritionSource => 'fonte';

  @override
  String get energyLabel => 'Energia';

  @override
  String get fatLabel => 'Grassi';

  @override
  String get saturatedFatLabel => 'Di cui grassi saturi';

  @override
  String get carbohydratesLabel => 'Carboidrati';

  @override
  String get sugarsLabel => 'Di cui zuccheri';

  @override
  String get proteinLabel => 'Proteine';

  @override
  String get saltLabel => 'Sale';

  @override
  String get noNutritionFound => 'Nessuna informazione nutrizionale trovata.';

  @override
  String get unknownName => 'Nome sconosciuto';

  @override
  String get noInfo => 'Nessuna info';

  @override
  String get paymentConfirmed =>
      'Pagamento confermato. Le pubblicità sono state rimosse definitivamente.';

  @override
  String get purchaseFailed => 'Acquisto fallito. Riprova.';

  @override
  String get purchaseCancelled => 'L\'acquisto è stato annullato.';

  @override
  String get purchaseStreamError => 'Flusso di acquisto fallito';

  @override
  String get productIdNotFound =>
      'Prodotto di acquisto non trovato. Controlla l\'ID prodotto.';

  @override
  String get internalWarning1 =>
      'Avviso: lista interna per il monitoraggio dei marchi';

  @override
  String get internalWarning2 =>
      'Avviso: monitoraggio marchi e informazioni pubbliche';

  @override
  String addedToList(String item, String list) {
    return '«$item» aggiunto a $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Lista della spesa: memoria e completamento automatico';

  @override
  String get shoppingListMemoryHow =>
      'Come usare la memoria della lista della spesa';

  @override
  String get shoppingListMemoryIntro =>
      'La lista della spesa ha memoria e completamento automatico:';

  @override
  String get shoppingListMemoryStep1 =>
      '1. + aggiunge esattamente quello che scrivi.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Invio aggiunge il suggerimento nel campo.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Tocca un prodotto nella lista memoria per aggiungerlo.';

  @override
  String get appReviewTestTitle => 'Codici di test App Review';

  @override
  String get appReviewTestSubtitle => 'Apri prodotti demo senza fotocamera';

  @override
  String get appReviewTestInstructions =>
      'Scegli un codice di test per aprire un prodotto demo:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Prodotto demo non trovato per $code';
  }

  @override
  String get adPlaceholderText => 'Spazio pubblicitario attivo';
}
