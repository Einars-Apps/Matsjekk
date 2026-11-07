// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// Draft translation for Japanese (`ja`).
/// Pending linguistic QA. This is not a native-reviewed translation.
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '食品チェック';

  @override
  String get scanBarcode => 'バーコードをスキャン';

  @override
  String get productNotFound => 'データベースに製品が見つかりません。';

  @override
  String get addToList => '買い物リストに追加';

  @override
  String get shoppingLists => '買い物リスト';

  @override
  String get history => '履歴';

  @override
  String get settings => '設定';

  @override
  String get about => 'このアプリについて';

  @override
  String get howAppWorks => 'アプリの仕組み';

  @override
  String get appDescription => 'このアプリは Open Food Facts と内部のブランド一覧を使い、Bovaer、昆虫粉、遺伝子組み換え飼料、その他の議論のある成分に関係する製品を示します。';

  @override
  String get alerts => '警告を選ぶ';

  @override
  String get bovaerAlert => 'Bovaer の警告';

  @override
  String get insectMealAlert => '昆虫粉の警告';

  @override
  String get ngtAlert => '隠れた遺伝子組み換え（NGT）の警告';

  @override
  String get gmoFishAlert => '遺伝子組み換え魚用飼料の警告';

  @override
  String get highRisk => '高リスク';

  @override
  String get possibleRisk => 'リスクの可能性';

  @override
  String get safe => '安全';

  @override
  String get unknown => '不明';

  @override
  String get bovaerRiskDesc => '生産者が Bovaer と直接関係しています。';

  @override
  String get insectMealRiskDesc => '製品に昆虫粉が含まれている可能性があります。';

  @override
  String get gmoFishRiskDesc => '生産者が遺伝子組み換え魚用飼料の使用と関係しています。';

  @override
  String get safeDesc => '製品は有機と表示されています。';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => 'トレーサビリティ';

  @override
  String get beta => 'ベータ';

  @override
  String get close => '閉じる';

  @override
  String get create => '作成';

  @override
  String get search => '検索';

  @override
  String get searchProducts => '製品を検索';

  @override
  String get noResults => '結果なし';

  @override
  String get newList => '新しいリスト';

  @override
  String get deleteList => '長押しで削除';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get norwegian => 'ノルウェー語';

  @override
  String get swedish => 'スウェーデン語';

  @override
  String get danish => 'デンマーク語';

  @override
  String get dutch => 'オランダ語';

  @override
  String get french => 'フランス語';

  @override
  String get english => '英語';

  @override
  String get german => 'ドイツ語';

  @override
  String get italian => 'イタリア語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get portuguese => 'ポルトガル語';

  @override
  String get finnish => 'フィンランド語';

  @override
  String get changeListName => 'リスト名を変更';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get manualAddItem => '商品を手入力...';

  @override
  String get emptyList => 'リストは空です';

  @override
  String get noHistory => 'このリストの履歴はありません';

  @override
  String get globalHistory => '全体の履歴';

  @override
  String get newShoppingList => '新しい買い物リスト';

  @override
  String get listName => 'リスト名';

  @override
  String get noHistoryFound => '履歴が見つかりません';

  @override
  String get addedItems => 'E番号';

  @override
  String get identifiedAdditions => '見つかったE番号';

  @override
  String get noAdditionsFound => 'データベースにE番号はありません。';

  @override
  String get disclaimer => '注意：この情報は公開データに基づく目安です。完全に正確な情報は、包装を確認するか製造者に問い合わせてください。';

  @override
  String get bovaerHighRisk => '高リスク：生産者が Bovaer と直接関係しています。';

  @override
  String get gmoHighRisk => '高リスク：生産者が遺伝子組み換え魚用飼料の使用と関係しています。';

  @override
  String get bovaerPossibleRisk => 'リスクの可能性：生産者は Bovaer と関係する企業と提携しています。';

  @override
  String get safeProduct => '安全：製品は有機と表示されています。';

  @override
  String get searchHint => '検索...（例：牛乳）';

  @override
  String get delete => '削除';

  @override
  String get deleteListConfirmTitle => 'リストを削除しますか？';

  @override
  String get deleteListConfirmMessage => 'よろしいですか？このリストの履歴も削除されます。';

  @override
  String get unknownProduct => '不明な製品';

  @override
  String get removeAds => '広告を消す';

  @override
  String get removeAdsInfo => '広告を消して、買い物リストの表示を広げます';

  @override
  String get removeAdsMenuItem => '広告を消す（買い切り）';

  // Draft additions for map/l10n keys. Pending linguistic QA.
  @override
  String get gmoRegExplicit => 'EU の規制状況：製品は遺伝子組み換え/NGT の規制区分に当たるようです。';

  @override
  String get gmoRegFeedChain => 'EU の規制状況：飼料の流れを通じて遺伝子組み換え/NGT の規則が適用される可能性があります。';

  @override
  String get gmoRegNgt => 'EU の規制状況：製品は遺伝子編集（NGT）に関する EU の新しい決定の対象になる可能性があります。';

  @override
  String get gmoRegSupplyChain => 'EU の規制状況：輸入者、供給者または生産者の連鎖を通じて、間接的に遺伝子組み換え/NGT と関係する可能性があります。';

  @override
  String get gmoRegCropOrigin => 'EU の規制状況：米国または EU 域外の、遺伝子組み換えが多い原料です。EU の表示義務の対象になる可能性があります。';

  @override
  String get gmoRegCropUnknown => 'EU の規制状況：輸入または供給の段階に遺伝子組み換えが多い原料があります。原産は確認が必要です。';

  @override
  String get insectRegExplicit => 'EU の規制状況：製品は昆虫または新規食品の規制区分に当たるようです。';

  @override
  String get insectRegNovelFood => 'EU の規制状況：製品は昆虫を新規食品とする EU 規則の対象になる可能性があります。';

  @override
  String get insectRegSupplyChain => 'EU の規制状況：輸入者、供給者または生産者の連鎖を通じて間接的に関係する可能性があります。';

  @override
  String get gmoConsExplicit => '消費者リスク：製品の文字または表示が遺伝子組み換えを示しています。';

  @override
  String get gmoConsFeed => '消費者リスク：ブランドまたは分類が、既知の遺伝子組み換え飼料への接触と一致します。';

  @override
  String get gmoConsNgt => '消費者リスク：消費市場に影響する可能性がありますが、表示と生産者情報で確認してください。';

  @override
  String get gmoConsSupplyChain => '消費者リスク：サプライチェーン（誰が誰に売るか）を通じたリスクの可能性があります。表示と原産を確認してください。';

  @override
  String get gmoConsCropOrigin => '消費者リスク：遺伝子組み換えが多い原料（大豆、トウモロコシ、菜種、てん菜、綿）を、その作物が主に遺伝子組み換えの国から輸入しています。表示に「遺伝子組み換えでない」とあるか確認してください。';

  @override
  String get gmoConsCropUnknown => '消費者リスク：製品には遺伝子組み換えが多い原料（大豆、トウモロコシ、菜種、てん菜、綿）が含まれます。原産は不明です。表示と原産国を確認してください。';

  @override
  String get insectConsExplicit => '消費者リスク：製品の文字または原材料が昆虫粉または昆虫たんぱくを示しています。';

  @override
  String get insectConsNovelFood => '消費者リスク：昆虫と関係する可能性があります。原材料を確認してください。';

  @override
  String get insectConsSupplyChain => '消費者リスク：サプライチェーン（誰が誰に売るか）を通じたリスクの可能性があります。';

  @override
  String get noKnownRisk => 'この区分に既知のリスクはありません。';

  @override
  String get searchBetaNote => 'ベータ版：検索は改善中です。選ぶ前に製品情報を再確認してください。';

  @override
  String get couldNotOpenLink => 'リンクを開けませんでした';

  @override
  String get eNumberNoDescription => 'この添加物の説明はまだありません。E 番号は EU/EEA で使われる添加物コードです。';

  @override
  String get allergensTitle => 'アレルゲン';

  @override
  String get noAllergensFound => 'アレルゲンは見つかりませんでした。';

  @override
  String get nutritionTitle => '栄養（100 g あたり）';

  @override
  String get noNutritionFound => '栄養情報は見つかりませんでした。';

  @override
  String get alertsTitle => '警告';

  @override
  String get alertEvidence => '根拠：';

  @override
  String get alertInternalListNote => '警告：内部のブランド関連リスト';

  @override
  String get alertBrandTrackingNote => '警告：ブランドの追跡と公開情報';

  @override
  String get reportNoteHint => '短いメモ（例：誤検知）';

  @override
  String get report => '報告';

  @override
  String get send => '送信';

  @override
  String get reportSaved => 'ありがとう。報告を保存しました。';

  @override
  String get seeUpdatedStatus => '更新された状態を見る';

  @override
  String get openEuSource => 'EU の出典を開く';

  @override
  String get openInsectSource => '昆虫の出典を開く';

  @override
  String get privacyTitle => 'プライバシー';

  @override
  String get consentOptional => 'これは任意です。同意しない場合、利用状況は分析に送られません。';

  @override
  String get consentWorksAnyway => '同意してもしなくてもアプリは使えます。データはこの端末だけに残せます。';

  @override
  String get readPrivacyPolicy => 'プライバシー説明を読む';

  @override
  String get allowAnonymousAnalytics => '匿名の分析を許可する';

  @override
  String get analyticsEnabled => 'ありがとう。分析を有効にしました。';

  @override
  String get analyticsDisabled => '分析を無効にしました。';

  @override
  String get countryDataSources => '国 / データ源';

  @override
  String get chooseCountryTitle => '国を選択（既存の情報源を優先）';

  @override
  String get privacyIntro => '初めて使うときはプライバシー説明を確認してください。分析を使わずに続行でき、買い物データはこの端末に残ります。';

  @override
  String couldNotOpenLinkError(String error) {
    return 'リンクを開けませんでした：$error';
  }

  @override
  String reportSaveFailed(String error) {
    return '報告を保存できませんでした：$error';
  }

  @override
  String alertSeverity(String value) {
    return '重大度：$value';
  }

  @override
  String alertReason(String value) {
    return '理由：$value';
  }

  @override
  String alertConfidence(String value) {
    return '確信度：$value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Matvaretabellen からの候補：$count';
  }

  @override
  String addedToList(String item, String list) {
    return '「$item」を $list に追加しました';
  }

  @override
  String nutritionEnergy(String value) {
    return 'エネルギー：$value kcal';
  }

  @override
  String nutritionFat(String value) {
    return '脂質：$value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return 'うち飽和脂肪酸：$value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return '炭水化物：$value g';
  }

  @override
  String nutritionSugars(String value) {
    return 'うち糖類：$value g';
  }

  @override
  String nutritionProtein(String value) {
    return 'たんぱく質：$value g';
  }

  @override
  String nutritionSalt(String value) {
    return '食塩相当量：$value g';
  }

}
