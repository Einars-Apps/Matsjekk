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

}
