// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Kontrola Żywności';

  @override
  String get scanBarcode => 'Skanuj kod kreskowy';

  @override
  String get productNotFound => 'Nie znaleziono produktu w bazie danych.';

  @override
  String get addToList => 'Dodaj do listy zakupów';

  @override
  String get shoppingLists => 'Listy zakupów';

  @override
  String get history => 'Historia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get about => 'O aplikacji';

  @override
  String get howAppWorks => 'Jak działa aplikacja';

  @override
  String get appDescription =>
      'Aplikacja używa Open Food Facts i wewnętrznej listy marek do wykrywania produktów związanych z Bovaer, mączką owadzą, paszą GMO i innymi kontrowersyjnymi składnikami.';

  @override
  String get alerts => 'Wybierz alerty';

  @override
  String get bovaerAlert => 'Alert Bovaer';

  @override
  String get insectMealAlert => 'Alert mączki owadziej';

  @override
  String get ngtAlert => 'Hidden GMO (NGT) Alert';

  @override
  String get gmoFishAlert => 'Alert paszy GMO dla ryb';

  @override
  String get highRisk => 'WYSOKIE RYZYKO';

  @override
  String get possibleRisk => 'MOŻLIWE RYZYKO';

  @override
  String get safe => 'BEZPIECZNE';

  @override
  String get unknown => 'NIEZNANE';

  @override
  String get bovaerRiskDesc =>
      'Producent jest bezpośrednio powiązany z Bovaer.';

  @override
  String get insectMealRiskDesc => 'Produkt może zawierać mączkę owadzią.';

  @override
  String get gmoFishRiskDesc =>
      'Producent jest powiązany z użyciem paszy GMO dla ryb.';

  @override
  String get safeDesc => 'Produkt ma certyfikat ekologiczny.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Śledzenie pochodzenia';

  @override
  String get beta => 'Beta';

  @override
  String get close => 'Zamknij';

  @override
  String get create => 'Utwórz';

  @override
  String get search => 'Szukaj';

  @override
  String get searchProducts => 'Szukaj produktów';

  @override
  String get noResults => 'Brak wyników';

  @override
  String get newList => 'Nowa lista';

  @override
  String get deleteList => 'Przytrzymaj, aby usunąć';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get norwegian => 'Norweski';

  @override
  String get swedish => 'Szwedzki';

  @override
  String get danish => 'Duński';

  @override
  String get dutch => 'Niderlandzki';

  @override
  String get french => 'Francuski';

  @override
  String get english => 'Angielski';

  @override
  String get german => 'Niemiecki';

  @override
  String get italian => 'Włoski';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get portuguese => 'Portugalski';

  @override
  String get finnish => 'Fiński';

  @override
  String get korean => 'Koreański';

  @override
  String get polish => 'Polski';

  @override
  String get russian => 'Rosyjski';

  @override
  String get chinese => 'Chiński';

  @override
  String get arabic => 'Arabski';

  @override
  String get thai => 'Tajski';

  @override
  String get changeListName => 'Zmień nazwę listy';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get manualAddItem => 'Dodaj produkt ręcznie...';

  @override
  String get emptyList => 'Lista jest pusta';

  @override
  String get noHistory => 'Brak historii dla tej listy';

  @override
  String get globalHistory => 'Historia globalna';

  @override
  String get newShoppingList => 'Nowa lista zakupów';

  @override
  String get listName => 'Nazwa listy';

  @override
  String get noHistoryFound => 'Nie znaleziono historii';

  @override
  String get addedItems => 'E-numery';

  @override
  String get identifiedAdditions => 'Wykryte E-numery';

  @override
  String get noAdditionsFound => 'Nie znaleziono E-numerów w bazie danych.';

  @override
  String get disclaimer =>
      'Zastrzeżenie: Informacje mają charakter orientacyjny i opierają się na publicznie dostępnych danych. Aby uzyskać 100% dokładności, sprawdź opakowanie produktu lub skontaktuj się z producentem.';

  @override
  String get bovaerHighRisk =>
      'WYSOKIE RYZYKO: Ta marka jest potwierdzonym użytkownikiem Bovaer lub należy do takiego producenta.';

  @override
  String get gmoHighRisk =>
      'WYSOKIE RYZYKO: Producent jest powiązany z użyciem paszy GMO dla ryb.';

  @override
  String get bovaerPossibleRisk =>
      'NIEPEWNE: Produkt może zawierać mleko z mleczarni skupującej mleko od gospodarstw używających Bovaer.';

  @override
  String get safeProduct => 'BEZPIECZNE: Produkt ma certyfikat ekologiczny.';

  @override
  String get searchHint => 'Szukaj... (np. mleko)';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteListConfirmTitle => 'Usunąć listę?';

  @override
  String get deleteListConfirmMessage =>
      'Czy na pewno? To usunie również historię tej listy.';

  @override
  String get unknownProduct => 'Nieznany produkt';

  @override
  String get removeAds => 'Usuń reklamy';

  @override
  String get removeAdsInfo =>
      'Usuń reklamy, aby zyskać więcej miejsca na liście zakupów';

  @override
  String get removeAdsMenuItem =>
      'Usuń reklamy - wspierasz dalszy rozwój aplikacji';

  @override
  String get premiumTitle => 'Usuń reklamy';

  @override
  String get premiumActiveStatus => 'Wersja bez reklam jest aktywna.';

  @override
  String get premiumInactiveStatus =>
      'Wersja bez reklam nie jest jeszcze aktywna.';

  @override
  String get buyAdFreeTitle => 'Kup wersję bez reklam';

  @override
  String get oneTimePurchaseInfo =>
      'Zakup jednorazowy. Bez subskrypcji.\nPo potwierdzeniu zakupu reklamy zostaną trwale usunięte z tego konta.';

  @override
  String get storeUnavailable =>
      'Sklep jest obecnie niedostępny. Spróbuj ponownie później.';

  @override
  String get productsLoadFailed =>
      'Nie udało się załadować produktów do zakupu. Sprawdź sieć i spróbuj ponownie.';

  @override
  String get purchaseNotAvailableOnDevice =>
      'In-app purchases are not available on this device. If you have already purchased ad-free, it will be restored automatically.';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get oneTimePurchaseLabel => 'zakup jednorazowy';

  @override
  String get buyPermanently => 'Kup na stałe';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get analyticsEnabled =>
      'Dziękujemy. Analityka anonimowa została włączona.';

  @override
  String get analyticsDisabled => 'Analityka anonimowa została wyłączona.';

  @override
  String get privacy => 'Prywatność';

  @override
  String get adFreeActive => 'Bez reklam (aktywna)';

  @override
  String get consentLocalOnly =>
      'Aplikacja nadal działa, a dane mogą pozostać wyłącznie na Twoim urządzeniu.';

  @override
  String get allowAnonymousAnalytics => 'Zezwól na anonimową analitykę';

  @override
  String get consentOptional =>
      'To jest opcjonalne. Jeśli nie wyrazisz zgody, dane o użyciu nie będą wysyłane do analityki.';

  @override
  String get couldNotOpenLink => 'Nie można otworzyć linku';

  @override
  String get howAppWorksSteps =>
      '1. Zeskanuj kod kreskowy produktu.\n2. Aplikacja pobiera dane produktu z Open Food Facts.\n3. Alerty są oceniane według wewnętrznych reguł marek i składników.\n4. Otrzymujesz prosty widok ryzyka i możesz zapisywać produkty na liście zakupów.';

  @override
  String get betaWarning =>
      'Ważne: To jest funkcja beta. Zawsze weryfikuj informacje z opakowania/etykiety.';

  @override
  String get matvaretabellenMatches => 'Wyniki Matvaretabellen';

  @override
  String get reportSaved => 'Dziękujemy — raport zapisany.';

  @override
  String get couldNotSaveReport => 'Nie można zapisać raportu';

  @override
  String get seeUpdatedStatus => 'Zobacz zaktualizowany status';

  @override
  String get gmoFeedLabel => 'Pasza GMO';

  @override
  String get insectMealLabel => 'Mączka owadzia';

  @override
  String get ngtLabel => 'Hidden GMO (NGT)';

  @override
  String get allergensLabel => 'Alergeny';

  @override
  String get noAllergensFound => 'Nie znaleziono alergenów.';

  @override
  String get nutritionPer100g => 'Wartości odżywcze (na 100g)';

  @override
  String get nutritionSource => 'źródło';

  @override
  String get energyLabel => 'Energia';

  @override
  String get fatLabel => 'Tłuszcz';

  @override
  String get saturatedFatLabel => 'W tym kwasy tłuszczowe nasycone';

  @override
  String get carbohydratesLabel => 'Węglowodany';

  @override
  String get sugarsLabel => 'W tym cukry';

  @override
  String get proteinLabel => 'Białko';

  @override
  String get saltLabel => 'Sól';

  @override
  String get noNutritionFound =>
      'Nie znaleziono informacji o wartościach odżywczych.';

  @override
  String get unknownName => 'Nieznana nazwa';

  @override
  String get noInfo => 'Brak info';

  @override
  String get paymentConfirmed =>
      'Płatność potwierdzona. Reklamy zostały trwale usunięte.';

  @override
  String get purchaseFailed => 'Zakup nie powiódł się. Spróbuj ponownie.';

  @override
  String get purchaseCancelled => 'Zakup został anulowany.';

  @override
  String get purchaseStreamError => 'Strumień zakupów nie powiódł się';

  @override
  String get productIdNotFound =>
      'Nie znaleziono produktu zakupowego. Sprawdź ID produktu.';

  @override
  String get internalWarning1 => 'Uwaga: wewnętrzna lista powiązań marek';

  @override
  String get internalWarning2 =>
      'Uwaga: śledzenie marek i informacje publiczne';

  @override
  String addedToList(String item, String list) {
    return '«$item» dodano do $list';
  }

  @override
  String get shoppingListMemoryTitle =>
      'Lista zakupów: pamięć i autouzupełnianie';

  @override
  String get shoppingListMemoryHow => 'Jak korzystać z pamięci listy zakupów';

  @override
  String get shoppingListMemoryIntro =>
      'Lista zakupów ma pamięć i autouzupełnianie:';

  @override
  String get shoppingListMemoryStep1 =>
      '1. + dodaje dokładnie to, co wpisujesz.';

  @override
  String get shoppingListMemoryStep2 =>
      '2. Enter dodaje sugestie w polu tekstowym.';

  @override
  String get shoppingListMemoryStep3 =>
      '3. Stuknij produkt na liście pamięci, aby go dodać.';

  @override
  String get appReviewTestTitle => 'Kody testowe App Review';

  @override
  String get appReviewTestSubtitle => 'Otwórz produkty demo bez kamery';

  @override
  String get appReviewTestInstructions =>
      'Wybierz kod testowy, aby otworzyć produkt demo:';

  @override
  String appReviewDemoNotFound(String code) {
    return 'Nie znaleziono produktu demo dla $code';
  }

  @override
  String get adPlaceholderText => 'Miejsce reklamowe aktywne';
}
