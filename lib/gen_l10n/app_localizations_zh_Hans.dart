// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// Draft translation for Simplified Chinese (`zh_Hans`).
/// Pending linguistic QA. This is not a native-reviewed translation.
class AppLocalizationsZhHans extends AppLocalizations {
  AppLocalizationsZhHans([String locale = 'zh_Hans']) : super(locale);

  @override
  String get appTitle => '食品检查';

  @override
  String get scanBarcode => '扫描条码';

  @override
  String get productNotFound => '数据库中未找到该产品。';

  @override
  String get addToList => '加入购物清单';

  @override
  String get shoppingLists => '购物清单';

  @override
  String get history => '历史';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get howAppWorks => '应用如何运作';

  @override
  String get appDescription => '本应用使用 Open Food Facts 和内部品牌名单，标出与 Bovaer、昆虫粉、转基因饲料和其他有争议成分相关的产品。';

  @override
  String get alerts => '选择提醒';

  @override
  String get bovaerAlert => 'Bovaer 提醒';

  @override
  String get insectMealAlert => '昆虫粉提醒';

  @override
  String get ngtAlert => '隐性转基因（NGT）提醒';

  @override
  String get gmoFishAlert => '转基因鱼饲料提醒';

  @override
  String get highRisk => '高风险';

  @override
  String get possibleRisk => '可能有风险';

  @override
  String get safe => '安全';

  @override
  String get unknown => '未知';

  @override
  String get bovaerRiskDesc => '生产商与 Bovaer 有直接关联。';

  @override
  String get insectMealRiskDesc => '产品可能含有昆虫粉。';

  @override
  String get gmoFishRiskDesc => '生产商与转基因鱼饲料的使用有关联。';

  @override
  String get safeDesc => '产品标为有机。';

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
  String get newList => '新清单';

  @override
  String get deleteList => '长按可删除';

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
  String get changeListName => '修改清单名称';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get manualAddItem => '手动添加商品...';

  @override
  String get emptyList => '清单是空的';

  @override
  String get noHistory => '此清单没有历史';

  @override
  String get globalHistory => '全部历史';

  @override
  String get newShoppingList => '新购物清单';

  @override
  String get listName => '清单名称';

  @override
  String get noHistoryFound => '未找到历史';

  @override
  String get addedItems => 'E 编号';

  @override
  String get identifiedAdditions => '已识别的 E 编号';

  @override
  String get noAdditionsFound => '数据库中未找到 E 编号。';

  @override
  String get disclaimer => '声明：这些信息仅供参考，并基于公开数据。如需完全准确的信息，请查看产品包装或联系生产商。';

  @override
  String get bovaerHighRisk => '高风险：生产商与 Bovaer 有直接关联。';

  @override
  String get gmoHighRisk => '高风险：生产商与转基因鱼饲料的使用有关联。';

  @override
  String get bovaerPossibleRisk => '可能有风险：生产商与涉及 Bovaer 的企业有合作关系。';

  @override
  String get safeProduct => '安全：产品标为有机。';

  @override
  String get searchHint => '搜索...（例如牛奶）';

  @override
  String get delete => '删除';

  @override
  String get deleteListConfirmTitle => '删除清单？';

  @override
  String get deleteListConfirmMessage => '确定吗？这也会删除该清单的历史。';

  @override
  String get unknownProduct => '未知产品';

  @override
  String get removeAds => '去除广告';

  @override
  String get removeAdsInfo => '去除广告，让购物清单有更多空间';

  @override
  String get removeAdsMenuItem => '去除广告（一次性购买）';

}
