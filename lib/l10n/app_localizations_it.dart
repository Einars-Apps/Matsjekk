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
  String get appDescription => 'L\'app utilizza Open Food Facts e un elenco interno di marchi per identificare prodotti con Bovaer, farina di insetti, mangimi OGM e altri ingredienti controversi.';

  @override
  String get alerts => 'Seleziona avvisi';

  @override
  String get bovaerAlert => 'Avviso Bovaer';

  @override
  String get insectMealAlert => 'Avviso farina di insetti';

  @override
  String get ngtAlert => 'Avviso OGM nascosti (NGT)';

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
  String get bovaerRiskDesc => 'Il produttore è direttamente collegato a Bovaer.';

  @override
  String get insectMealRiskDesc => 'Il prodotto può contenere farina di insetti.';

  @override
  String get gmoFishRiskDesc => 'Il produttore è collegato all\'uso di mangimi OGM.';

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
  String get disclaimer => 'Disclaimer: Queste informazioni sono solo a scopo informativo e basate su dati disponibili al pubblico. Per informazioni 100% accurate, consultare l\'imballaggio del prodotto o contattare il produttore.';

  @override
  String get bovaerHighRisk => 'RISCHIO ALTO: Il produttore è direttamente collegato a Bovaer.';

  @override
  String get gmoHighRisk => 'RISCHIO ALTO: Il produttore è collegato all\'uso di mangimi OGM.';

  @override
  String get bovaerPossibleRisk => 'RISCHIO POSSIBILE: Il produttore è partner di aziende collegate a Bovaer.';

  @override
  String get safeProduct => 'SICURO: Il prodotto è certificato biologico.';

  @override
  String get searchHint => 'Cerca... (es. latte)';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteListConfirmTitle => 'Eliminare la lista?';

  @override
  String get deleteListConfirmMessage => 'Sei sicuro? Verrà eliminata anche la cronologia della lista.';

  @override
  String get unknownProduct => 'Prodotto sconosciuto';

  @override
  String get removeAds => 'Rimuovi pubblicità';

  @override
  String get removeAdsInfo => 'Rimuovi la pubblicità per avere più spazio nella lista della spesa';

  @override
  String get removeAdsMenuItem => 'Rimuovi pubblicità (49 kr) – sostiene lo sviluppo';

  @override
  String get gmoRegExplicit => 'STATO NORMATIVO UE: Il prodotto sembra rientrare in una categoria regolamentata OGM/NGT.';

  @override
  String get gmoRegFeedChain => 'STATO NORMATIVO UE: Può rientrare nelle norme OGM/NGT tramite la filiera dei mangimi.';

  @override
  String get gmoRegNgt => 'STATO NORMATIVO UE: Il prodotto può rientrare nella nuova decisione UE sull’editing genetico (NGT).';

  @override
  String get gmoRegSupplyChain => 'STATO NORMATIVO UE: Possibile rilevanza indiretta OGM/NGT tramite la catena importatore/fornitore/produttore.';

  @override
  String get gmoRegCropOrigin => 'STATO NORMATIVO UE: Materia prima a rischio OGM di origine americana/extra-UE – può far scattare l’obbligo UE di etichettatura OGM.';

  @override
  String get gmoRegCropUnknown => 'STATO NORMATIVO UE: Materia prima a rischio OGM nella fase di importazione/fornitura – l’origine va verificata.';

  @override
  String get insectRegExplicit => 'STATO NORMATIVO UE: Il prodotto sembra rientrare in una categoria regolamentata insetti/novel food.';

  @override
  String get insectRegNovelFood => 'STATO NORMATIVO UE: Il prodotto può rientrare nelle norme UE sugli insetti come novel food.';

  @override
  String get insectRegSupplyChain => 'STATO NORMATIVO UE: Possibile rilevanza indiretta tramite la catena importatore/fornitore/produttore.';

  @override
  String get gmoConsExplicit => 'RISCHIO PER IL CONSUMATORE: Il testo/l’etichetta del prodotto indica contenuto OGM.';

  @override
  String get gmoConsFeed => 'RISCHIO PER IL CONSUMATORE: Marchio/categoria corrisponde a un’esposizione nota a mangimi OGM.';

  @override
  String get gmoConsNgt => 'RISCHIO PER IL CONSUMATORE: Può influire sul mercato dei consumatori, ma va verificato con l’etichetta e le informazioni del produttore.';

  @override
  String get gmoConsSupplyChain => 'RISCHIO PER IL CONSUMATORE: Possibile rischio tramite la filiera (chi vende a chi). Verifica etichetta e origine.';

  @override
  String get gmoConsCropOrigin => 'RISCHIO PER IL CONSUMATORE: Contiene una materia prima a rischio OGM (soia/mais/colza/barbabietola da zucchero/cotone) importata da un paese in cui la coltura è prevalentemente geneticamente modificata. Cerca in etichetta la dicitura “senza OGM”.';

  @override
  String get gmoConsCropUnknown => 'RISCHIO PER IL CONSUMATORE: Il prodotto contiene una materia prima a rischio OGM (soia/mais/colza/barbabietola da zucchero/cotone). Origine sconosciuta – verifica etichetta e paese di origine.';

  @override
  String get insectConsExplicit => 'RISCHIO PER IL CONSUMATORE: Il testo/gli ingredienti del prodotto indicano farina o proteine di insetti.';

  @override
  String get insectConsNovelFood => 'RISCHIO PER IL CONSUMATORE: Possibile esposizione legata agli insetti, verifica l’elenco degli ingredienti.';

  @override
  String get insectConsSupplyChain => 'RISCHIO PER IL CONSUMATORE: Possibile rischio tramite la filiera (chi vende a chi).';

  @override
  String get noKnownRisk => 'Nessun rischio noto in questa categoria.';

  @override
  String get searchBetaNote => 'Beta: la ricerca è in continuo miglioramento. Verifica sempre i dettagli del prodotto prima di scegliere.';

  @override
  String get couldNotOpenLink => 'Impossibile aprire il link';

  @override
  String get eNumberNoDescription => 'Non abbiamo ancora una descrizione di questo additivo. Il numero E è un codice per additivi usato in UE/SEE.';

  @override
  String get allergensTitle => 'Allergeni';

  @override
  String get noAllergensFound => 'Nessun allergene trovato.';

  @override
  String get nutritionTitle => 'Valori nutrizionali (per 100 g)';

  @override
  String get noNutritionFound => 'Nessuna informazione nutrizionale trovata.';

  @override
  String get alertsTitle => 'Avvisi';

  @override
  String get alertEvidence => 'Prove:';

  @override
  String get alertInternalListNote => 'Avviso: elenco interno dei collegamenti tra marchi';

  @override
  String get alertBrandTrackingNote => 'Avviso: tracciamento dei marchi e informazioni pubbliche';

  @override
  String get reportNoteHint => 'Nota breve (es. falso positivo)';

  @override
  String get report => 'Segnala';

  @override
  String get send => 'Invia';

  @override
  String get reportSaved => 'Grazie — segnalazione salvata.';

  @override
  String get seeUpdatedStatus => 'Vedi lo stato aggiornato';

  @override
  String get openEuSource => 'Apri la fonte UE';

  @override
  String get openInsectSource => 'Apri la fonte sugli insetti';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get consentOptional => 'È facoltativo. Se non acconsenti, il tuo utilizzo non viene inviato per l’analisi.';

  @override
  String get consentWorksAnyway => 'L’app funziona comunque e i dati possono restare solo sul tuo dispositivo.';

  @override
  String get readPrivacyPolicy => 'Leggi l’informativa sulla privacy';

  @override
  String get allowAnonymousAnalytics => 'Consenti analisi anonime';

  @override
  String get analyticsEnabled => 'Grazie – analisi attivata.';

  @override
  String get analyticsDisabled => 'Analisi disattivata.';

  @override
  String couldNotOpenLinkError(String error) {
    return 'Impossibile aprire il link: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return 'Impossibile salvare la segnalazione: $error';
  }

  @override
  String alertSeverity(String value) {
    return 'Gravità: $value';
  }

  @override
  String alertReason(String value) {
    return 'Motivo: $value';
  }

  @override
  String alertConfidence(String value) {
    return 'Affidabilità: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Suggerimenti da Matvaretabellen: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '\"$item\" aggiunto a $list';
  }

  @override
  String nutritionEnergy(String value) {
    return 'Energia: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return 'Grassi: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'di cui acidi grassi saturi: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return 'Carboidrati: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'di cui zuccheri: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'Proteine: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return 'Sale: $value g';
  }

  @override
  String get countryDataSources => 'Paese / fonti dei dati';

  @override
  String get chooseCountryTitle => 'Scegli il paese (dà priorità alle fonti)';
}
