// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Проверка продуктов';

  @override
  String get scanBarcode => 'Сканировать штрихкод';

  @override
  String get productNotFound => 'Продукт не найден в базе данных.';

  @override
  String get addToList => 'Добавить в список покупок';

  @override
  String get shoppingLists => 'Списки покупок';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get about => 'О приложении';

  @override
  String get howAppWorks => 'Как работает приложение';

  @override
  String get appDescription =>
      'Приложение использует Open Food Facts и внутренний список брендов для выявления продуктов, связанных с Bovaer, насекомой мукой, кормами GMO и другими спорными ингредиентами.';

  @override
  String get alerts => 'Выберите предупреждения';

  @override
  String get bovaerAlert => 'Предупреждение Bovaer';

  @override
  String get insectMealAlert => 'Предупреждение о насекомой муке';

  @override
  String get gmoFishAlert => 'Предупреждение о корме GMO для рыбы';

  @override
  String get highRisk => 'ВЫСОКИЙ РИСК';

  @override
  String get possibleRisk => 'ВОЗМОЖНЫЙ РИСК';

  @override
  String get safe => 'БЕЗОПАСНО';

  @override
  String get unknown => 'НЕИЗВЕСТНО';

  @override
  String get bovaerRiskDesc => 'Производитель напрямую связан с Bovaer.';

  @override
  String get insectMealRiskDesc => 'Продукт может содержать насекомую муку.';

  @override
  String get gmoFishRiskDesc =>
      'Производитель связан с использованием корма GMO для рыбы.';

  @override
  String get safeDesc => 'Продукт сертифицирован как органический.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'Прослеживаемость';

  @override
  String get beta => 'Бета';

  @override
  String get close => 'Закрыть';

  @override
  String get create => 'Создать';

  @override
  String get search => 'Поиск';

  @override
  String get searchProducts => 'Поиск продуктов';

  @override
  String get noResults => 'Нет результатов';

  @override
  String get newList => 'Новый список';

  @override
  String get deleteList => 'Удерживайте для удаления';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get norwegian => 'Норвежский';

  @override
  String get swedish => 'Шведский';

  @override
  String get danish => 'Датский';

  @override
  String get dutch => 'Нидерландский';

  @override
  String get french => 'Французский';

  @override
  String get english => 'Английский';

  @override
  String get german => 'Немецкий';

  @override
  String get italian => 'Итальянский';

  @override
  String get spanish => 'Испанский';

  @override
  String get portuguese => 'Португальский';

  @override
  String get finnish => 'Финский';

  @override
  String get korean => 'Корейский';

  @override
  String get polish => 'Польский';

  @override
  String get russian => 'Русский';

  @override
  String get chinese => 'Китайский';

  @override
  String get arabic => 'Арабский';

  @override
  String get thai => 'Тайский';

  @override
  String get changeListName => 'Изменить название списка';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get manualAddItem => 'Добавить товар вручную...';

  @override
  String get emptyList => 'Список пуст';

  @override
  String get noHistory => 'Нет истории для этого списка';

  @override
  String get globalHistory => 'Глобальная история';

  @override
  String get newShoppingList => 'Новый список покупок';

  @override
  String get listName => 'Название списка';

  @override
  String get noHistoryFound => 'История не найдена';

  @override
  String get addedItems => 'E-номера';

  @override
  String get identifiedAdditions => 'Обнаруженные E-номера';

  @override
  String get noAdditionsFound => 'E-номера не найдены в базе данных.';

  @override
  String get disclaimer =>
      'Отказ от ответственности: информация носит справочный характер и основана на общедоступных данных. Для 100% точной информации смотрите упаковку продукта или свяжитесь с производителем.';

  @override
  String get bovaerHighRisk =>
      'ВЫСОКИЙ РИСК: Этот бренд подтвержденно использует Bovaer или принадлежит такому производителю.';

  @override
  String get gmoHighRisk =>
      'ВЫСОКИЙ РИСК: Производитель связан с использованием кормов GMO для рыбы.';

  @override
  String get bovaerPossibleRisk =>
      'НЕОПРЕДЕЛЕННО: Продукт может содержать молоко от молокозавода, получающего сырье от ферм с Bovaer.';

  @override
  String get safeProduct =>
      'БЕЗОПАСНО: Продукт сертифицирован как органический.';

  @override
  String get searchHint => 'Поиск... (например, молоко)';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteListConfirmTitle => 'Удалить список?';

  @override
  String get deleteListConfirmMessage =>
      'Вы уверены? Это также удалит историю этого списка.';

  @override
  String get unknownProduct => 'Неизвестный продукт';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String get removeAdsInfo =>
      'Уберите рекламу, чтобы освободить больше места в списке покупок';

  @override
  String get removeAdsMenuItem =>
      'Отключить рекламу (49 NOK) - поддержка дальнейшей разработки приложения';

  @override
  String get premiumTitle => 'Отключить рекламу';

  @override
  String get premiumActiveStatus => 'Режим без рекламы активен.';

  @override
  String get premiumInactiveStatus => 'Режим без рекламы еще не активен.';

  @override
  String get buyAdFreeTitle => 'Купить версию без рекламы';

  @override
  String get oneTimePurchaseInfo =>
      'Единовременная покупка. Без подписки.\nПосле подтверждения покупки реклама будет удалена навсегда для этой учетной записи.';

  @override
  String get storeUnavailable =>
      'Магазин сейчас недоступен. Пожалуйста, попробуйте позже.';

  @override
  String get productsLoadFailed =>
      'Не удалось загрузить товары для покупки. Проверьте сеть и попробуйте снова.';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get oneTimePurchaseLabel => 'единовременная покупка';

  @override
  String get buyPermanently => 'Купить навсегда';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get analyticsEnabled => 'Спасибо. Анонимная аналитика включена.';

  @override
  String get analyticsDisabled => 'Анонимная аналитика отключена.';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get adFreeActive => 'Без рекламы (включено)';

  @override
  String get consentLocalOnly =>
      'Приложение продолжает работать, а данные могут оставаться только на вашем устройстве.';

  @override
  String get allowAnonymousAnalytics => 'Разрешить анонимную аналитику';

  @override
  String get consentOptional =>
      'Это необязательно. Если вы не согласны, данные об использовании не будут отправляться в аналитику.';
}
