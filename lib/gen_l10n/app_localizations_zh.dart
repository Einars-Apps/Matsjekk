// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '食品检查';

  @override
  String get scanBarcode => '扫描条码';

  @override
  String get productNotFound => '在数据库中未找到该产品。';

  @override
  String get addToList => '添加到购物清单';

  @override
  String get shoppingLists => '购物清单';

  @override
  String get history => '历史';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get howAppWorks => '应用如何工作';

  @override
  String get appDescription =>
      '该应用使用 Open Food Facts 和内部品牌列表来检测与 Bovaer、昆虫粉、GMO 饲料及其他有争议成分相关的产品。';

  @override
  String get alerts => '选择提醒';

  @override
  String get bovaerAlert => 'Bovaer 提醒';

  @override
  String get insectMealAlert => '昆虫粉提醒';

  @override
  String get gmoFishAlert => '鱼类 GMO 饲料提醒';

  @override
  String get highRisk => '高风险';

  @override
  String get possibleRisk => '可能风险';

  @override
  String get safe => '安全';

  @override
  String get unknown => '未知';

  @override
  String get bovaerRiskDesc => '该生产商与 Bovaer 直接相关。';

  @override
  String get insectMealRiskDesc => '该产品可能含有昆虫粉。';

  @override
  String get gmoFishRiskDesc => '该生产商与使用鱼类 GMO 饲料有关。';

  @override
  String get safeDesc => '该产品已获得有机认证。';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => '可追溯性';

  @override
  String get beta => '测试版';

  @override
  String get close => '关闭';

  @override
  String get create => '创建';

  @override
  String get search => '搜索';

  @override
  String get searchProducts => '搜索产品';

  @override
  String get noResults => '无结果';

  @override
  String get newList => '新建清单';

  @override
  String get deleteList => '长按删除';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get norwegian => '挪威语';

  @override
  String get swedish => '瑞典语';

  @override
  String get danish => '丹麦语';

  @override
  String get dutch => '荷兰语';

  @override
  String get french => '法语';

  @override
  String get english => '英语';

  @override
  String get german => '德语';

  @override
  String get italian => '意大利语';

  @override
  String get spanish => '西班牙语';

  @override
  String get portuguese => '葡萄牙语';

  @override
  String get finnish => '芬兰语';

  @override
  String get korean => '韩语';

  @override
  String get polish => '波兰语';

  @override
  String get russian => '俄语';

  @override
  String get chinese => '中文';

  @override
  String get arabic => '阿拉伯语';

  @override
  String get thai => '泰语';

  @override
  String get changeListName => '更改清单名称';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get manualAddItem => '手动添加商品...';

  @override
  String get emptyList => '清单为空';

  @override
  String get noHistory => '该清单没有历史记录';

  @override
  String get globalHistory => '全局历史';

  @override
  String get newShoppingList => '新购物清单';

  @override
  String get listName => '清单名称';

  @override
  String get noHistoryFound => '未找到历史记录';

  @override
  String get addedItems => 'E 编号';

  @override
  String get identifiedAdditions => '已识别的 E 编号';

  @override
  String get noAdditionsFound => '数据库中未找到 E 编号。';

  @override
  String get disclaimer => '免责声明：此信息仅供参考，基于公开数据。若需 100% 准确信息，请查看产品包装或联系制造商。';

  @override
  String get bovaerHighRisk => '高风险：该品牌已确认使用 Bovaer，或属于相关生产商。';

  @override
  String get gmoHighRisk => '高风险：该生产商与使用鱼类 GMO 饲料有关。';

  @override
  String get bovaerPossibleRisk => '不确定：该产品可能含有来自使用 Bovaer 农场供奶乳品厂的牛奶。';

  @override
  String get safeProduct => '安全：该产品已获得有机认证。';

  @override
  String get searchHint => '搜索...（例如：牛奶）';

  @override
  String get delete => '删除';

  @override
  String get deleteListConfirmTitle => '删除清单？';

  @override
  String get deleteListConfirmMessage => '确定吗？这也会删除该清单的历史记录。';

  @override
  String get unknownProduct => '未知产品';

  @override
  String get removeAds => '去除广告';

  @override
  String get removeAdsInfo => '移除广告以获得更多购物清单空间';

  @override
  String get removeAdsMenuItem => '移除广告（49 NOK）- 支持应用持续开发';

  @override
  String get premiumTitle => '去除广告';

  @override
  String get premiumActiveStatus => '无广告已启用';

  @override
  String get premiumInactiveStatus => '无广告尚未启用';

  @override
  String get buyAdFreeTitle => '购买去广告版本';

  @override
  String get oneTimePurchaseInfo => '一次性购买，无订阅。\n购买确认后，该账号将永久移除广告。';

  @override
  String get storeUnavailable => '商店当前不可用，请稍后再试。';

  @override
  String get productsLoadFailed => '无法加载购买商品。请检查网络并重试。';

  @override
  String get tryAgain => '重试';

  @override
  String get oneTimePurchaseLabel => '一次性购买';

  @override
  String get buyPermanently => '永久购买';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get analyticsEnabled => '感谢支持，匿名分析已开启。';

  @override
  String get analyticsDisabled => '匿名分析已关闭。';

  @override
  String get privacy => '隐私';

  @override
  String get adFreeActive => '无广告（启用中）';

  @override
  String get consentLocalOnly => '应用仍可正常使用，数据也可以仅保存在您的设备上。';

  @override
  String get allowAnonymousAnalytics => '允许匿名分析';

  @override
  String get consentOptional => '这是可选项。若不同意，您的使用数据不会发送到分析服务。';
}
