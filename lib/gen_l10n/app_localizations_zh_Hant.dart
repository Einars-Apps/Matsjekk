// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// Draft translation for Traditional Chinese (`zh_Hant`).
/// Pending linguistic QA. This is not a native-reviewed translation.
class AppLocalizationsZhHant extends AppLocalizations {
  AppLocalizationsZhHant([String locale = 'zh_Hant']) : super(locale);

  @override
  String get appTitle => '食品檢查';

  @override
  String get scanBarcode => '掃描條碼';

  @override
  String get productNotFound => '資料庫中找不到這項產品。';

  @override
  String get addToList => '加入購物清單';

  @override
  String get shoppingLists => '購物清單';

  @override
  String get history => '紀錄';

  @override
  String get settings => '設定';

  @override
  String get about => '關於';

  @override
  String get howAppWorks => '應用程式如何運作';

  @override
  String get appDescription => '本應用程式使用 Open Food Facts 和內部品牌名單，標出與 Bovaer、昆蟲粉、基因改造飼料和其他有爭議成分相關的產品。';

  @override
  String get alerts => '選擇提醒';

  @override
  String get bovaerAlert => 'Bovaer 提醒';

  @override
  String get insectMealAlert => '昆蟲粉提醒';

  @override
  String get ngtAlert => '隱性基因改造（NGT）提醒';

  @override
  String get gmoFishAlert => '基因改造魚飼料提醒';

  @override
  String get highRisk => '高風險';

  @override
  String get possibleRisk => '可能有風險';

  @override
  String get safe => '安全';

  @override
  String get unknown => '未知';

  @override
  String get bovaerRiskDesc => '生產商與 Bovaer 有直接關聯。';

  @override
  String get insectMealRiskDesc => '產品可能含有昆蟲粉。';

  @override
  String get gmoFishRiskDesc => '生產商與基因改造魚飼料的使用有關聯。';

  @override
  String get safeDesc => '產品標示為有機。';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => '可追溯性';

  @override
  String get beta => '測試版';

  @override
  String get close => '關閉';

  @override
  String get create => '建立';

  @override
  String get search => '搜尋';

  @override
  String get searchProducts => '搜尋產品';

  @override
  String get noResults => '沒有結果';

  @override
  String get newList => '新清單';

  @override
  String get deleteList => '長按即可刪除';

  @override
  String get language => '語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get norwegian => '挪威語';

  @override
  String get swedish => '瑞典語';

  @override
  String get danish => '丹麥語';

  @override
  String get dutch => '荷蘭語';

  @override
  String get french => '法語';

  @override
  String get english => '英語';

  @override
  String get german => '德語';

  @override
  String get italian => '義大利語';

  @override
  String get spanish => '西班牙語';

  @override
  String get portuguese => '葡萄牙語';

  @override
  String get finnish => '芬蘭語';

  @override
  String get changeListName => '變更清單名稱';

  @override
  String get cancel => '取消';

  @override
  String get save => '儲存';

  @override
  String get manualAddItem => '手動新增商品...';

  @override
  String get emptyList => '清單是空的';

  @override
  String get noHistory => '此清單沒有紀錄';

  @override
  String get globalHistory => '全部紀錄';

  @override
  String get newShoppingList => '新購物清單';

  @override
  String get listName => '清單名稱';

  @override
  String get noHistoryFound => '找不到紀錄';

  @override
  String get addedItems => 'E 編號';

  @override
  String get identifiedAdditions => '已識別的 E 編號';

  @override
  String get noAdditionsFound => '資料庫中找不到 E 編號。';

  @override
  String get disclaimer => '聲明：這些資訊僅供參考，並基於公開資料。如需完全準確的資訊，請查看產品包裝或聯絡生產商。';

  @override
  String get bovaerHighRisk => '高風險：生產商與 Bovaer 有直接關聯。';

  @override
  String get gmoHighRisk => '高風險：生產商與基因改造魚飼料的使用有關聯。';

  @override
  String get bovaerPossibleRisk => '可能有風險：生產商與涉及 Bovaer 的企業有合作關係。';

  @override
  String get safeProduct => '安全：產品標示為有機。';

  @override
  String get searchHint => '搜尋...（例如牛奶）';

  @override
  String get delete => '刪除';

  @override
  String get deleteListConfirmTitle => '刪除清單？';

  @override
  String get deleteListConfirmMessage => '確定嗎？這也會刪除此清單的紀錄。';

  @override
  String get unknownProduct => '未知產品';

  @override
  String get removeAds => '移除廣告';

  @override
  String get removeAdsInfo => '移除廣告，讓購物清單有更多空間';

  @override
  String get removeAdsMenuItem => '移除廣告（一次性購買）';

  // Draft additions for map/l10n keys. Pending linguistic QA.
  @override
  String get gmoRegExplicit => '歐盟監管狀態：產品看起來屬於受基因改造/NGT 監管的類別。';

  @override
  String get gmoRegFeedChain => '歐盟監管狀態：可能透過飼料鏈適用基因改造/NGT 規則。';

  @override
  String get gmoRegNgt => '歐盟監管狀態：產品可能適用歐盟關於基因編輯（NGT）的新決定。';

  @override
  String get gmoRegSupplyChain => '歐盟監管狀態：可能透過進口商、供應商或生產商鏈條間接涉及基因改造/NGT。';

  @override
  String get gmoRegCropOrigin => '歐盟監管狀態：來自美國或非歐盟的易基因改造原料，可能觸發歐盟基因改造標示要求。';

  @override
  String get gmoRegCropUnknown => '歐盟監管狀態：進口或供應環節有易基因改造原料，來源應當核實。';

  @override
  String get insectRegExplicit => '歐盟監管狀態：產品看起來屬於受昆蟲或新穎食品監管的類別。';

  @override
  String get insectRegNovelFood => '歐盟監管狀態：產品可能適用歐盟把昆蟲作為新穎食品的規則。';

  @override
  String get insectRegSupplyChain => '歐盟監管狀態：可能透過進口商、供應商或生產商鏈條間接相關。';

  @override
  String get gmoConsExplicit => '消費者風險：產品文字或標籤顯示含有基因改造。';

  @override
  String get gmoConsFeed => '消費者風險：品牌或類別與已知的基因改造飼料暴露相符。';

  @override
  String get gmoConsNgt => '消費者風險：可能影響消費市場，但應對照標籤和生產商資訊核實。';

  @override
  String get gmoConsSupplyChain => '消費者風險：可能透過供應鏈（誰賣給誰）存在風險。請核實標籤和來源。';

  @override
  String get gmoConsCropOrigin => '消費者風險：含有易基因改造原料（大豆、玉米、油菜、甜菜或棉花），並從該作物以基因改造為主的國家進口。請查看標籤是否標有「非基因改造」。';

  @override
  String get gmoConsCropUnknown => '消費者風險：產品含有易基因改造原料（大豆、玉米、油菜、甜菜或棉花）。來源未知，請查看標籤和原產國。';

  @override
  String get insectConsExplicit => '消費者風險：產品文字或配料顯示昆蟲粉或昆蟲蛋白。';

  @override
  String get insectConsNovelFood => '消費者風險：可能與昆蟲有關，請查看配料表。';

  @override
  String get insectConsSupplyChain => '消費者風險：可能透過供應鏈（誰賣給誰）存在風險。';

  @override
  String get noKnownRisk => '此類別沒有已知風險。';

  @override
  String get searchBetaNote => '測試版：搜尋仍在改進。做選擇前請再次核對產品資訊。';

  @override
  String get couldNotOpenLink => '無法開啟連結';

  @override
  String get eNumberNoDescription => '我們還沒有這種添加劑的說明。E 編號是歐盟/歐洲經濟區使用的添加劑代碼。';

  @override
  String get allergensTitle => '過敏原';

  @override
  String get noAllergensFound => '未找到過敏原。';

  @override
  String get nutritionTitle => '營養（每 100 克）';

  @override
  String get noNutritionFound => '未找到營養資訊。';

  @override
  String get alertsTitle => '提醒';

  @override
  String get alertEvidence => '依據：';

  @override
  String get alertInternalListNote => '提醒：內部品牌關聯名單';

  @override
  String get alertBrandTrackingNote => '提醒：品牌追蹤和公開資訊';

  @override
  String get reportNoteHint => '簡短說明（例如誤報）';

  @override
  String get report => '回報';

  @override
  String get send => '送出';

  @override
  String get reportSaved => '謝謝，回報已儲存。';

  @override
  String get seeUpdatedStatus => '查看更新後的狀態';

  @override
  String get openEuSource => '開啟歐盟來源';

  @override
  String get openInsectSource => '開啟昆蟲來源';

  @override
  String get privacyTitle => '隱私';

  @override
  String get consentOptional => '這是可選的。如果不同意，使用情況不會被送去分析。';

  @override
  String get consentWorksAnyway => '無論是否同意，應用程式都能使用，資料可以只留在這台裝置上。';

  @override
  String get readPrivacyPolicy => '閱讀隱私說明';

  @override
  String get allowAnonymousAnalytics => '允許匿名分析';

  @override
  String get analyticsEnabled => '謝謝，分析已開啟。';

  @override
  String get analyticsDisabled => '分析已關閉。';

  @override
  String get countryDataSources => '國家 / 資料來源';

  @override
  String get chooseCountryTitle => '選擇國家（優先使用現有來源）';

  @override
  String get privacyIntro => '請在首次使用時查看隱私說明。你可以不啟用分析並繼續使用，購物資料保存在這台裝置上。';

  @override
  String couldNotOpenLinkError(String error) {
    return '無法開啟連結：$error';
  }

  @override
  String reportSaveFailed(String error) {
    return '無法儲存回報：$error';
  }

  @override
  String alertSeverity(String value) {
    return '嚴重程度：$value';
  }

  @override
  String alertReason(String value) {
    return '原因：$value';
  }

  @override
  String alertConfidence(String value) {
    return '信心程度：$value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return '來自 Matvaretabellen 的建議：$count';
  }

  @override
  String addedToList(String item, String list) {
    return '「$item」已加入 $list';
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
    return '其中飽和脂肪：$value 克';
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
    return '蛋白質：$value 克';
  }

  @override
  String nutritionSalt(String value) {
    return '鹽：$value 克';
  }

}
