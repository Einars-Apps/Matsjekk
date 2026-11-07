import 'package:flutter/widgets.dart';

/// Draft UI copy for the first Asian locale batch.
///
/// Status: draft, pending linguistic QA. Not a native-reviewed translation.
/// The country list stays the existing European source countries.
const String kDraftLocaleReviewStatus = 'draft-pending-linguistic-qa';

const Set<String> kDraftLocaleCodes = {
  'zh_Hans',
  'zh_Hant',
  'ja',
  'ko',
};

/// Existing source-country codes. Do not add China, Japan or Korea here:
/// the app has no grocery database for those countries.
const List<String> kSourceCountryCodes = [
  'NO',
  'SE',
  'DK',
  'FI',
  'DE',
  'NL',
  'BE',
  'FR',
  'CH',
  'AT',
  'IE',
  'LU',
  'IT',
  'PT',
  'ES',
  'GB',
];

Locale appLocaleFromCode(String code) {
  switch (code) {
    case 'zh_Hans':
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    case 'zh_Hant':
      return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    default:
      return Locale(code);
  }
}

String appLanguageCode(Locale locale) {
  if (locale.languageCode == 'zh') {
    return locale.scriptCode == 'Hant' ? 'zh_Hant' : 'zh_Hans';
  }
  return locale.languageCode;
}

String? draftFarmShopsLabel(String code) {
  switch (code) {
    case 'zh_Hans':
      return '农场店（挪威和欧洲）';
    case 'zh_Hant':
      return '農場店（挪威和歐洲）';
    case 'ja':
      return '農場直売（ノルウェーと欧州）';
    case 'ko':
      return '농장 상점(노르웨이와 유럽)';
  }
  return null;
}

String? draftHowAppWorks(String code) {
  switch (code) {
    case 'zh_Hans':
      return '1. 扫描商品条码。\n'
          '2. 应用从 Open Food Facts 获取产品数据。\n'
          '3. 提醒依据内部品牌和成分规则。\n'
          '4. 你可以看到风险提示，并把商品存入购物清单。';
    case 'zh_Hant':
      return '1. 掃描商品條碼。\n'
          '2. 應用程式從 Open Food Facts 取得產品資料。\n'
          '3. 提醒依據內部品牌和成分規則。\n'
          '4. 你可以看到風險提示，並把商品存入購物清單。';
    case 'ja':
      return '1. 商品のバーコードをスキャンします。\n'
          '2. アプリは Open Food Facts から製品データを取得します。\n'
          '3. 警告は内部のブランドと成分の規則で判断します。\n'
          '4. リスク表示を見て、商品を買い物リストに保存できます。';
    case 'ko':
      return '1. 상품 바코드를 스캔합니다.\n'
          '2. 앱이 Open Food Facts에서 제품 정보를 가져옵니다.\n'
          '3. 알림은 내부 브랜드와 성분 규칙으로 판단합니다.\n'
          '4. 위험 표시를 보고 장보기 목록에 저장할 수 있습니다.';
  }
  return null;
}

String? draftRegionalNewsLabel(String code) {
  switch (code) {
    case 'zh_Hans':
      return '所选地区的新闻';
    case 'zh_Hant':
      return '所選地區的新聞';
    case 'ja':
      return '選んだ地域のニュース';
    case 'ko':
      return '선택한 지역의 소식';
  }
  return null;
}

String? draftFarmThemeTitle(String code) {
  switch (code) {
    case 'zh_Hans':
      return '农场店与本地食品';
    case 'zh_Hant':
      return '農場店與本地食品';
    case 'ja':
      return '農場直売と地元の食品';
    case 'ko':
      return '농장 상점과 지역 식품';
  }
  return null;
}

String? draftFarmThemeBody(String code) {
  switch (code) {
    case 'zh_Hans':
      return '打开现有的农场店页面。数据范围是挪威和欧洲部分地区，不是中国、日本或韩国的商店名录。此功能为测试版，并会继续改进。';
    case 'zh_Hant':
      return '開啟現有的農場店頁面。資料範圍是挪威和歐洲部分地區，不是中國、日本或韓國的商店名錄。此功能為測試版，並會繼續改進。';
    case 'ja':
      return '既存の農場直売ページを開きます。データの範囲はノルウェーと欧州の一部であり、中国、日本、韓国の店舗目録ではありません。この機能はベータ版で、継続して改善されます。';
    case 'ko':
      return '기존 농장 상점 페이지를 엽니다. 데이터 범위는 노르웨이와 유럽 일부이며, 중국, 일본, 한국의 상점 목록이 아닙니다. 이 기능은 베타이며 계속 개선됩니다.';
  }
  return null;
}

String? draftPrivacyIntro(String code) {
  switch (code) {
    case 'zh_Hans':
      return '请在首次使用时查看隐私说明。你可以不启用分析并继续使用，购物数据保存在这台设备上。';
    case 'zh_Hant':
      return '請在首次使用時查看隱私說明。你可以不啟用分析並繼續使用，購物資料保存在這台裝置上。';
    case 'ja':
      return '初めて使うときはプライバシー説明を確認してください。分析を使わずに続行でき、買い物データはこの端末に残ります。';
    case 'ko':
      return '처음 사용할 때 개인정보 안내를 확인하세요. 분석을 켜지 않고 계속할 수 있으며, 장보기 데이터는 이 기기에 남습니다.';
  }
  return null;
}

String? draftCountryPickerTitle(String code) {
  switch (code) {
    case 'zh_Hans':
      return '选择国家（用于优先现有来源）';
    case 'zh_Hant':
      return '選擇國家（用於優先現有來源）';
    case 'ja':
      return '国を選択（既存の情報源を優先）';
    case 'ko':
      return '국가 선택(기존 출처를 우선)';
  }
  return null;
}

const Map<String, Map<String, String>> _countryNames = {
  'zh_Hans': {
    'NO': '挪威',
    'SE': '瑞典',
    'DK': '丹麦',
    'FI': '芬兰',
    'DE': '德国',
    'NL': '荷兰',
    'BE': '比利时',
    'FR': '法国',
    'CH': '瑞士',
    'AT': '奥地利',
    'IE': '爱尔兰',
    'LU': '卢森堡',
    'IT': '意大利',
    'PT': '葡萄牙',
    'ES': '西班牙',
    'GB': '英国',
  },
  'zh_Hant': {
    'NO': '挪威',
    'SE': '瑞典',
    'DK': '丹麥',
    'FI': '芬蘭',
    'DE': '德國',
    'NL': '荷蘭',
    'BE': '比利時',
    'FR': '法國',
    'CH': '瑞士',
    'AT': '奧地利',
    'IE': '愛爾蘭',
    'LU': '盧森堡',
    'IT': '義大利',
    'PT': '葡萄牙',
    'ES': '西班牙',
    'GB': '英國',
  },
  'ja': {
    'NO': 'ノルウェー',
    'SE': 'スウェーデン',
    'DK': 'デンマーク',
    'FI': 'フィンランド',
    'DE': 'ドイツ',
    'NL': 'オランダ',
    'BE': 'ベルギー',
    'FR': 'フランス',
    'CH': 'スイス',
    'AT': 'オーストリア',
    'IE': 'アイルランド',
    'LU': 'ルクセンブルク',
    'IT': 'イタリア',
    'PT': 'ポルトガル',
    'ES': 'スペイン',
    'GB': '英国',
  },
  'ko': {
    'NO': '노르웨이',
    'SE': '스웨덴',
    'DK': '덴마크',
    'FI': '핀란드',
    'DE': '독일',
    'NL': '네덜란드',
    'BE': '벨기에',
    'FR': '프랑스',
    'CH': '스위스',
    'AT': '오스트리아',
    'IE': '아일랜드',
    'LU': '룩셈부르크',
    'IT': '이탈리아',
    'PT': '포르투갈',
    'ES': '스페인',
    'GB': '영국',
  },
};

String? draftCountryName(String languageCode, String countryCode) {
  return _countryNames[languageCode]?[countryCode];
}

class DraftPurchaseCopy {
  final String shortTitle;
  final String active;
  final String inactive;
  final String heading;
  final String body;
  final String storeUnavailable;
  final String retry;
  final String productsUnavailable;
  final String productNotReturned;
  final String oneTimeSuffix;
  final String buy;
  final String restore;

  const DraftPurchaseCopy({
    required this.shortTitle,
    required this.active,
    required this.inactive,
    required this.heading,
    required this.body,
    required this.storeUnavailable,
    required this.retry,
    required this.productsUnavailable,
    required this.productNotReturned,
    required this.oneTimeSuffix,
    required this.buy,
    required this.restore,
  });
}

DraftPurchaseCopy? draftPurchaseCopy(String code) {
  switch (code) {
    case 'zh_Hans':
      return const DraftPurchaseCopy(
        shortTitle: '去除广告',
        active: '已去除广告',
        inactive: '尚未去除广告',
        heading: '购买无广告版本',
        body: '一次性购买，不是订阅。商店确认购买后，广告会在这台设备上去除。',
        storeUnavailable: '商店暂时不可用。请稍后再试。',
        retry: '重试',
        productsUnavailable: '向商店查询购买项目时出错。请再试一次。',
        productNotReturned:
            'Google Play 没有返回一次性商品 matsjekk_remove_ads_lifetime。这个版本询问的是 Google Play，不是 AppGallery。',
        oneTimeSuffix: '一次性购买',
        buy: '一次性购买',
        restore: '恢复购买',
      );
    case 'zh_Hant':
      return const DraftPurchaseCopy(
        shortTitle: '移除廣告',
        active: '已移除廣告',
        inactive: '尚未移除廣告',
        heading: '購買無廣告版本',
        body: '一次性購買，不是訂閱。商店確認購買後，廣告會在這台裝置上移除。',
        storeUnavailable: '商店暫時無法使用。請稍後再試。',
        retry: '重試',
        productsUnavailable: '向商店查詢購買項目時出錯。請再試一次。',
        productNotReturned:
            'Google Play 沒有返回一次性商品 matsjekk_remove_ads_lifetime。這個版本詢問的是 Google Play，不是 AppGallery。',
        oneTimeSuffix: '一次性購買',
        buy: '一次性購買',
        restore: '恢復購買',
      );
    case 'ja':
      return const DraftPurchaseCopy(
        shortTitle: '広告を消す',
        active: '広告は消えています',
        inactive: '広告はまだ消えていません',
        heading: '広告なし版を購入',
        body: '買い切りです。サブスクリプションではありません。ストアが購入を確認すると、この端末から広告が消えます。',
        storeUnavailable: 'ストアを現在利用できません。後でもう一度試してください。',
        retry: '再試行',
        productsUnavailable: 'ストアへの問い合わせでエラーが起きました。もう一度試してください。',
        productNotReturned:
            'Google Play は買い切り商品 matsjekk_remove_ads_lifetime を返しませんでした。このビルドが問い合わせるのは Google Play であり、AppGallery ではありません。',
        oneTimeSuffix: '買い切り',
        buy: '買い切りで購入',
        restore: '購入を復元',
      );
    case 'ko':
      return const DraftPurchaseCopy(
        shortTitle: '광고 제거',
        active: '광고가 제거되었습니다',
        inactive: '아직 광고가 제거되지 않았습니다',
        heading: '광고 없는 버전 구매',
        body: '일회성 구매이며 구독이 아닙니다. 스토어가 구매를 확인하면 이 기기에서 광고가 제거됩니다.',
        storeUnavailable: '스토어를 지금 사용할 수 없습니다. 나중에 다시 시도하세요.',
        retry: '다시 시도',
        productsUnavailable: '스토어 조회 중 오류가 났습니다. 다시 시도하세요.',
        productNotReturned:
            'Google Play가 일회성 상품 matsjekk_remove_ads_lifetime을 반환하지 않았습니다. 이 빌드가 조회하는 곳은 Google Play이며 AppGallery가 아닙니다.',
        oneTimeSuffix: '일회성 구매',
        buy: '일회성 구매',
        restore: '구매 복원',
      );
  }
  return null;
}
