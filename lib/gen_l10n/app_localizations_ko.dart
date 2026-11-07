// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// Draft translation for Korean (`ko`).
/// Pending linguistic QA. This is not a native-reviewed translation.
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '식품 확인';

  @override
  String get scanBarcode => '바코드 스캔';

  @override
  String get productNotFound => '데이터베이스에서 제품을 찾지 못했습니다.';

  @override
  String get addToList => '장보기 목록에 추가';

  @override
  String get shoppingLists => '장보기 목록';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get about => '정보';

  @override
  String get howAppWorks => '앱이 작동하는 방식';

  @override
  String get appDescription => '이 앱은 Open Food Facts와 내부 브랜드 목록으로 Bovaer, 곤충 분말, 유전자변형 사료 및 그 밖의 논란이 있는 성분과 연결된 제품을 표시합니다.';

  @override
  String get alerts => '알림 선택';

  @override
  String get bovaerAlert => 'Bovaer 알림';

  @override
  String get insectMealAlert => '곤충 분말 알림';

  @override
  String get ngtAlert => '숨은 유전자변형(NGT) 알림';

  @override
  String get gmoFishAlert => '유전자변형 어류 사료 알림';

  @override
  String get highRisk => '높은 위험';

  @override
  String get possibleRisk => '위험 가능성';

  @override
  String get safe => '안전';

  @override
  String get unknown => '알 수 없음';

  @override
  String get bovaerRiskDesc => '생산자가 Bovaer와 직접 연결되어 있습니다.';

  @override
  String get insectMealRiskDesc => '제품에 곤충 분말이 들어 있을 수 있습니다.';

  @override
  String get gmoFishRiskDesc => '생산자가 유전자변형 어류 사료 사용과 연결되어 있습니다.';

  @override
  String get safeDesc => '제품이 유기농으로 표시되어 있습니다.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => '추적 가능성';

  @override
  String get beta => '베타';

  @override
  String get close => '닫기';

  @override
  String get create => '만들기';

  @override
  String get search => '검색';

  @override
  String get searchProducts => '제품 검색';

  @override
  String get noResults => '결과 없음';

  @override
  String get newList => '새 목록';

  @override
  String get deleteList => '길게 눌러 삭제';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get norwegian => '노르웨이어';

  @override
  String get swedish => '스웨덴어';

  @override
  String get danish => '덴마크어';

  @override
  String get dutch => '네덜란드어';

  @override
  String get french => '프랑스어';

  @override
  String get english => '영어';

  @override
  String get german => '독일어';

  @override
  String get italian => '이탈리아어';

  @override
  String get spanish => '스페인어';

  @override
  String get portuguese => '포르투갈어';

  @override
  String get finnish => '핀란드어';

  @override
  String get changeListName => '목록 이름 변경';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get manualAddItem => '항목을 직접 추가...';

  @override
  String get emptyList => '목록이 비어 있습니다';

  @override
  String get noHistory => '이 목록의 기록이 없습니다';

  @override
  String get globalHistory => '전체 기록';

  @override
  String get newShoppingList => '새 장보기 목록';

  @override
  String get listName => '목록 이름';

  @override
  String get noHistoryFound => '기록을 찾지 못했습니다';

  @override
  String get addedItems => 'E 번호';

  @override
  String get identifiedAdditions => '확인된 E 번호';

  @override
  String get noAdditionsFound => '데이터베이스에서 E 번호를 찾지 못했습니다.';

  @override
  String get disclaimer => '안내: 이 정보는 공개된 자료를 바탕으로 한 참고입니다. 완전히 정확한 내용은 포장을 보거나 제조사에 확인하세요.';

  @override
  String get bovaerHighRisk => '높은 위험: 생산자가 Bovaer와 직접 연결되어 있습니다.';

  @override
  String get gmoHighRisk => '높은 위험: 생산자가 유전자변형 어류 사료 사용과 연결되어 있습니다.';

  @override
  String get bovaerPossibleRisk => '위험 가능성: 생산자가 Bovaer와 연결된 업체와 협력 관계입니다.';

  @override
  String get safeProduct => '안전: 제품이 유기농으로 표시되어 있습니다.';

  @override
  String get searchHint => '검색... (예: 우유)';

  @override
  String get delete => '삭제';

  @override
  String get deleteListConfirmTitle => '목록을 삭제할까요?';

  @override
  String get deleteListConfirmMessage => '계속할까요? 이 목록의 기록도 삭제됩니다.';

  @override
  String get unknownProduct => '알 수 없는 제품';

  @override
  String get removeAds => '광고 제거';

  @override
  String get removeAdsInfo => '광고를 제거해 장보기 목록 공간을 넓힙니다';

  @override
  String get removeAdsMenuItem => '광고 제거(일회성 구매)';

}
