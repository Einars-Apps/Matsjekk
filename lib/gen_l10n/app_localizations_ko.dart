// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '식품 검사';

  @override
  String get scanBarcode => '바코드 스캔';

  @override
  String get productNotFound => '데이터베이스에서 제품을 찾을 수 없습니다.';

  @override
  String get addToList => '쇼핑 목록에 추가';

  @override
  String get shoppingLists => '쇼핑 목록';

  @override
  String get history => '기록';

  @override
  String get settings => '설정';

  @override
  String get about => '앱 정보';

  @override
  String get howAppWorks => '앱 작동 방식';

  @override
  String get appDescription =>
      '이 앱은 Open Food Facts와 내부 브랜드 목록을 사용하여 Bovaer, 곤충분말, GMO 사료 및 기타 논란 성분을 감지합니다.';

  @override
  String get alerts => '알림 선택';

  @override
  String get bovaerAlert => 'Bovaer 알림';

  @override
  String get insectMealAlert => '곤충분말 알림';

  @override
  String get gmoFishAlert => 'GMO 어류 사료 알림';

  @override
  String get highRisk => '고위험';

  @override
  String get possibleRisk => '잠재적 위험';

  @override
  String get safe => '안전';

  @override
  String get unknown => '알 수 없음';

  @override
  String get bovaerRiskDesc => '생산자가 Bovaer와 직접 연관되어 있습니다.';

  @override
  String get insectMealRiskDesc => '제품에 곤충분말이 포함될 수 있습니다.';

  @override
  String get gmoFishRiskDesc => '생산자가 GMO 어류 사료 사용과 연관되어 있습니다.';

  @override
  String get safeDesc => '이 제품은 유기농 인증 제품입니다.';

  @override
  String get nutriScore => 'Nutri-Score';

  @override
  String get traceability => '추적 가능성';

  @override
  String get beta => '베타';

  @override
  String get close => '닫기';

  @override
  String get create => '생성';

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
  String get korean => '한국어';

  @override
  String get polish => '폴란드어';

  @override
  String get russian => '러시아어';

  @override
  String get chinese => '중국어';

  @override
  String get arabic => '아랍어';

  @override
  String get thai => '태국어';

  @override
  String get changeListName => '목록 이름 변경';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get manualAddItem => '항목 수동 추가...';

  @override
  String get emptyList => '목록이 비어 있습니다';

  @override
  String get noHistory => '이 목록의 기록이 없습니다';

  @override
  String get globalHistory => '전체 기록';

  @override
  String get newShoppingList => '새 쇼핑 목록';

  @override
  String get listName => '목록 이름';

  @override
  String get noHistoryFound => '기록을 찾을 수 없습니다';

  @override
  String get addedItems => 'E-번호';

  @override
  String get identifiedAdditions => '식별된 E-번호';

  @override
  String get noAdditionsFound => '데이터베이스에서 E-번호를 찾을 수 없습니다.';

  @override
  String get disclaimer =>
      '면책 고지: 이 정보는 공개된 데이터를 기반으로 한 참고용입니다. 100% 정확한 정보는 제품 포장을 확인하거나 제조사에 문의하세요.';

  @override
  String get bovaerHighRisk => '고위험: 이 브랜드는 Bovaer 사용이 확인되었거나 해당 생산자에 속합니다.';

  @override
  String get gmoHighRisk => '고위험: 생산자가 GMO 어류 사료 사용과 연관되어 있습니다.';

  @override
  String get bovaerPossibleRisk => '불확실: Bovaer 참여 농가에서 원유를 공급받는 유제품일 수 있습니다.';

  @override
  String get safeProduct => '안전: 이 제품은 유기농 인증 제품입니다.';

  @override
  String get searchHint => '검색... (예: 우유)';

  @override
  String get delete => '삭제';

  @override
  String get deleteListConfirmTitle => '목록을 삭제할까요?';

  @override
  String get deleteListConfirmMessage => '정말 삭제하시겠습니까? 이 목록의 기록도 함께 삭제됩니다.';

  @override
  String get unknownProduct => '알 수 없는 제품';

  @override
  String get removeAds => '광고 제거';

  @override
  String get removeAdsInfo => '쇼핑 목록 공간을 넓히기 위해 광고를 제거하세요';

  @override
  String get removeAdsMenuItem => '광고 제거 (NOK 49) - 앱 개발을 지원합니다';

  @override
  String get premiumTitle => '광고 제거하기';

  @override
  String get premiumActiveStatus => '광고 제거가 활성화되었습니다';

  @override
  String get premiumInactiveStatus => '광고 제거가 아직 활성화되지 않았습니다';

  @override
  String get buyAdFreeTitle => '광고 없는 버전 구입';

  @override
  String get oneTimePurchaseInfo =>
      '일회성 구매이며 구독이 아닙니다.\n구매가 확인되면 이 계정에서 광고가 영구적으로 제거됩니다.';

  @override
  String get storeUnavailable => '현재 스토어를 사용할 수 없습니다. 나중에 다시 시도해 주세요.';

  @override
  String get productsLoadFailed => '구매 상품을 불러올 수 없습니다. 네트워크를 확인하고 다시 시도해 주세요.';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get oneTimePurchaseLabel => '일회성 구매';

  @override
  String get buyPermanently => '영구 구매';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get analyticsEnabled => '감사합니다. 익명 분석이 활성화되었습니다.';

  @override
  String get analyticsDisabled => '익명 분석이 비활성화되었습니다.';

  @override
  String get privacy => '개인정보 보호';

  @override
  String get adFreeActive => '광고 없음(활성)';

  @override
  String get consentLocalOnly => '앱은 계속 작동하며, 데이터는 기기에만 저장할 수 있습니다.';

  @override
  String get allowAnonymousAnalytics => '익명 분석 허용';

  @override
  String get consentOptional =>
      '이 항목은 선택 사항입니다. 동의하지 않으면 사용 데이터가 분석으로 전송되지 않습니다.';

  @override
  String get couldNotOpenLink => '링크를 열 수 없습니다';

  @override
  String get howAppWorksSteps =>
      '1. 제품의 바코드를 스캔합니다.\n2. 앱이 Open Food Facts에서 제품 데이터를 가져옵니다.\n3. 내부 브랜드 및 성분 규칙에 따라 경고가 평가됩니다.\n4. 간단한 위험 보기를 얻고 쇼핑 목록에 저장할 수 있습니다.';

  @override
  String get betaWarning => '중요: 이것은 베타 기능입니다. 항상 포장/라벨에서 정보를 확인하세요.';

  @override
  String get matvaretabellenMatches => 'Matvaretabellen 결과';

  @override
  String get reportSaved => '감사합니다 — 보고서가 저장되었습니다.';

  @override
  String get couldNotSaveReport => '보고서를 저장할 수 없습니다';

  @override
  String get seeUpdatedStatus => '업데이트된 상태 보기';

  @override
  String get gmoFeedLabel => 'GMO 사료';

  @override
  String get insectMealLabel => '곤충 단백질';

  @override
  String get allergensLabel => '알레르견';

  @override
  String get noAllergensFound => '알레르견이 발견되지 않았습니다.';

  @override
  String get nutritionPer100g => '영양정보 (100g당)';

  @override
  String get nutritionSource => '출처';

  @override
  String get energyLabel => '에너지';

  @override
  String get fatLabel => '지방';

  @override
  String get saturatedFatLabel => '포화지방';

  @override
  String get carbohydratesLabel => '탄수화물';

  @override
  String get sugarsLabel => '당류';

  @override
  String get proteinLabel => '단백질';

  @override
  String get saltLabel => '나트륨';

  @override
  String get noNutritionFound => '영양 정보를 찾을 수 없습니다.';

  @override
  String get unknownName => '알 수 없는 이름';

  @override
  String get noInfo => '정보 없음';

  @override
  String get paymentConfirmed => '결제 확인. 광고가 영구적으로 제거되었습니다.';

  @override
  String get purchaseFailed => '구매에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get purchaseCancelled => '구매가 취소되었습니다.';

  @override
  String get purchaseStreamError => '구매 스트림 실패';

  @override
  String get productIdNotFound => '구매 제품을 찾을 수 없습니다. 제품 ID를 확인하세요.';

  @override
  String get internalWarning1 => '알림: 브랜드 링크 추적을 위한 내부 목록';

  @override
  String get internalWarning2 => '알림: 브랜드 추적 및 공개 정보';

  @override
  String addedToList(String item, String list) {
    return '«$item»이(가) $list에 추가됨';
  }

  @override
  String get shoppingListMemoryTitle => '장바구니 목록: 기억 및 자동 완성';

  @override
  String get shoppingListMemoryHow => '장바구니 목록 기억 사용법';

  @override
  String get shoppingListMemoryIntro => '장바구니 목록에는 기억과 자동 완성 기능이 있습니다:';

  @override
  String get shoppingListMemoryStep1 => '1. +는 입력한 내용을 그대로 추가합니다.';

  @override
  String get shoppingListMemoryStep2 => '2. Enter는 입력란의 제안을 추가합니다.';

  @override
  String get shoppingListMemoryStep3 => '3. 기억 목록의 제품을 탭하여 추가합니다.';

  @override
  String get appReviewTestTitle => 'App Review 테스트 코드';

  @override
  String get appReviewTestSubtitle => '카메라 없이 데모 제품 열기';

  @override
  String get appReviewTestInstructions => '데모 제품을 열려면 테스트 코드를 선택하세요:';

  @override
  String appReviewDemoNotFound(String code) {
    return '$code에 대한 데모 제품을 찾을 수 없습니다';
  }

  @override
  String get adPlaceholderText => '광고 위치 활성';
}
