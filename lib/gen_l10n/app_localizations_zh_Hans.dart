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

  // Draft additions for map/l10n keys. Pending linguistic QA.
  @override
  String get gmoRegExplicit => '欧盟监管状态：产品看起来属于受转基因/NGT 监管的类别。';

  @override
  String get gmoRegFeedChain => '欧盟监管状态：可能通过饲料链适用转基因/NGT 规则。';

  @override
  String get gmoRegNgt => '欧盟监管状态：产品可能适用欧盟关于基因编辑（NGT）的新决定。';

  @override
  String get gmoRegSupplyChain => '欧盟监管状态：可能通过进口商、供应商或生产商链条间接涉及转基因/NGT。';

  @override
  String get gmoRegCropOrigin => '欧盟监管状态：来自美国或非欧盟的易转基因原料，可能触发欧盟转基因标识要求。';

  @override
  String get gmoRegCropUnknown => '欧盟监管状态：进口或供应环节有易转基因原料，来源应当核实。';

  @override
  String get insectRegExplicit => '欧盟监管状态：产品看起来属于受昆虫或新食品监管的类别。';

  @override
  String get insectRegNovelFood => '欧盟监管状态：产品可能适用欧盟把昆虫作为新食品的规则。';

  @override
  String get insectRegSupplyChain => '欧盟监管状态：可能通过进口商、供应商或生产商链条间接相关。';

  @override
  String get gmoConsExplicit => '消费者风险：产品文字或标签显示含有转基因。';

  @override
  String get gmoConsFeed => '消费者风险：品牌或类别与已知的转基因饲料暴露相符。';

  @override
  String get gmoConsNgt => '消费者风险：可能影响消费市场，但应对照标签和生产商信息核实。';

  @override
  String get gmoConsSupplyChain => '消费者风险：可能通过供应链（谁卖给谁）存在风险。请核实标签和来源。';

  @override
  String get gmoConsCropOrigin => '消费者风险：含有易转基因原料（大豆、玉米、油菜、甜菜或棉花），并从该作物以转基因为主的国家进口。请查看标签是否标有“非转基因”。';

  @override
  String get gmoConsCropUnknown => '消费者风险：产品含有易转基因原料（大豆、玉米、油菜、甜菜或棉花）。来源未知，请查看标签和原产国。';

  @override
  String get insectConsExplicit => '消费者风险：产品文字或配料显示昆虫粉或昆虫蛋白。';

  @override
  String get insectConsNovelFood => '消费者风险：可能与昆虫有关，请查看配料表。';

  @override
  String get insectConsSupplyChain => '消费者风险：可能通过供应链（谁卖给谁）存在风险。';

  @override
  String get noKnownRisk => '此类别没有已知风险。';

  @override
  String get searchBetaNote => '测试版：搜索仍在改进。做选择前请再次核对产品信息。';

  @override
  String get couldNotOpenLink => '无法打开链接';

  @override
  String get eNumberNoDescription => '我们还没有这种添加剂的说明。E 编号是欧盟/欧洲经济区使用的添加剂代码。';

  @override
  String get allergensTitle => '过敏原';

  @override
  String get noAllergensFound => '未找到过敏原。';

  @override
  String get nutritionTitle => '营养（每 100 克）';

  @override
  String get noNutritionFound => '未找到营养信息。';

  @override
  String get alertsTitle => '提醒';

  @override
  String get alertEvidence => '依据：';

  @override
  String get alertInternalListNote => '提醒：内部品牌关联名单';

  @override
  String get alertBrandTrackingNote => '提醒：品牌追踪和公开信息';

  @override
  String get reportNoteHint => '简短说明（例如误报）';

  @override
  String get report => '报告';

  @override
  String get send => '发送';

  @override
  String get reportSaved => '谢谢，报告已保存。';

  @override
  String get seeUpdatedStatus => '查看更新后的状态';

  @override
  String get openEuSource => '打开欧盟来源';

  @override
  String get openInsectSource => '打开昆虫来源';

  @override
  String get privacyTitle => '隐私';

  @override
  String get consentOptional => '这是可选的。如果不同意，使用情况不会被送去分析。';

  @override
  String get consentWorksAnyway => '无论是否同意，应用都能使用，数据可以只留在这台设备上。';

  @override
  String get readPrivacyPolicy => '阅读隐私说明';

  @override
  String get allowAnonymousAnalytics => '允许匿名分析';

  @override
  String get analyticsEnabled => '谢谢，分析已开启。';

  @override
  String get analyticsDisabled => '分析已关闭。';

  @override
  String get countryDataSources => '国家 / 数据来源';

  @override
  String get chooseCountryTitle => '选择国家（优先使用现有来源）';

  @override
  String get privacyIntro => '请在首次使用时查看隐私说明。你可以不启用分析并继续使用，购物数据保存在这台设备上。';

  @override
  String couldNotOpenLinkError(String error) {
    return '无法打开链接：$error';
  }

  @override
  String reportSaveFailed(String error) {
    return '无法保存报告：$error';
  }

  @override
  String alertSeverity(String value) {
    return '严重程度：$value';
  }

  @override
  String alertReason(String value) {
    return '原因：$value';
  }

  @override
  String alertConfidence(String value) {
    return '置信度：$value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return '来自 Matvaretabellen 的建议：$count';
  }

  @override
  String addedToList(String item, String list) {
    return '“$item”已加入 $list';
  }

  @override
  String nutritionEnergy(String value) {
    return '能量：$value 千卡';
  }

  @override
  String nutritionFat(String value) {
    return '脂肪：$value 克';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return '其中饱和脂肪：$value 克';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return '碳水化合物：$value 克';
  }

  @override
  String nutritionSugars(String value) {
    return '其中糖：$value 克';
  }

  @override
  String nutritionProtein(String value) {
    return '蛋白质：$value 克';
  }

  @override
  String nutritionSalt(String value) {
    return '盐：$value 克';
  }

}
