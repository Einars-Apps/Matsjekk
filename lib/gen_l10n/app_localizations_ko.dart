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

  // Draft additions for map/l10n keys. Pending linguistic QA.
  @override
  String get gmoRegExplicit => 'EU 규제 상태: 제품이 유전자변형/NGT 규제 범주에 해당하는 것으로 보입니다.';

  @override
  String get gmoRegFeedChain => 'EU 규제 상태: 사료 경로를 통해 유전자변형/NGT 규칙이 적용될 수 있습니다.';

  @override
  String get gmoRegNgt => 'EU 규제 상태: 제품이 유전자편집(NGT)에 대한 EU의 새 결정 대상일 수 있습니다.';

  @override
  String get gmoRegSupplyChain => 'EU 규제 상태: 수입업자, 공급자 또는 생산자 연결을 통해 간접적으로 유전자변형/NGT와 관련될 수 있습니다.';

  @override
  String get gmoRegCropOrigin => 'EU 규제 상태: 미국 또는 EU 밖에서 온, 유전자변형이 많은 원료입니다. EU 표시 요건이 적용될 수 있습니다.';

  @override
  String get gmoRegCropUnknown => 'EU 규제 상태: 수입 또는 공급 단계에 유전자변형이 많은 원료가 있습니다. 원산지는 확인이 필요합니다.';

  @override
  String get insectRegExplicit => 'EU 규제 상태: 제품이 곤충 또는 신규식품 규제 범주에 해당하는 것으로 보입니다.';

  @override
  String get insectRegNovelFood => 'EU 규제 상태: 제품이 곤충을 신규식품으로 보는 EU 규칙의 대상일 수 있습니다.';

  @override
  String get insectRegSupplyChain => 'EU 규제 상태: 수입업자, 공급자 또는 생산자 연결을 통해 간접적으로 관련될 수 있습니다.';

  @override
  String get gmoConsExplicit => '소비자 위험: 제품 문구 또는 표시가 유전자변형을 나타냅니다.';

  @override
  String get gmoConsFeed => '소비자 위험: 브랜드 또는 분류가 알려진 유전자변형 사료 노출과 맞습니다.';

  @override
  String get gmoConsNgt => '소비자 위험: 소비 시장에 영향을 줄 수 있지만, 표시와 생산자 정보로 확인해야 합니다.';

  @override
  String get gmoConsSupplyChain => '소비자 위험: 공급망(누가 누구에게 파는지)을 통한 위험 가능성이 있습니다. 표시와 원산지를 확인하세요.';

  @override
  String get gmoConsCropOrigin => '소비자 위험: 유전자변형이 많은 원료(대두, 옥수수, 유채, 사탕무, 면화)가 그 작물이 주로 유전자변형인 나라에서 수입되었습니다. 표시에 “유전자변형 아님”이 있는지 확인하세요.';

  @override
  String get gmoConsCropUnknown => '소비자 위험: 제품에 유전자변형이 많은 원료(대두, 옥수수, 유채, 사탕무, 면화)가 있습니다. 원산지는 알 수 없습니다. 표시와 원산국을 확인하세요.';

  @override
  String get insectConsExplicit => '소비자 위험: 제품 문구 또는 원재료가 곤충 분말 또는 곤충 단백질을 나타냅니다.';

  @override
  String get insectConsNovelFood => '소비자 위험: 곤충과 관련될 수 있습니다. 원재료를 확인하세요.';

  @override
  String get insectConsSupplyChain => '소비자 위험: 공급망(누가 누구에게 파는지)을 통한 위험 가능성이 있습니다.';

  @override
  String get noKnownRisk => '이 범주에서 알려진 위험은 없습니다.';

  @override
  String get searchBetaNote => '베타: 검색은 계속 개선 중입니다. 선택하기 전에 제품 정보를 다시 확인하세요.';

  @override
  String get couldNotOpenLink => '링크를 열 수 없습니다';

  @override
  String get eNumberNoDescription => '이 첨가물에 대한 설명이 아직 없습니다. E 번호는 EU/EEA에서 쓰는 첨가물 코드입니다.';

  @override
  String get allergensTitle => '알레르기 유발물질';

  @override
  String get noAllergensFound => '알레르기 유발물질을 찾지 못했습니다.';

  @override
  String get nutritionTitle => '영양 (100 g당)';

  @override
  String get noNutritionFound => '영양 정보를 찾지 못했습니다.';

  @override
  String get alertsTitle => '알림';

  @override
  String get alertEvidence => '근거:';

  @override
  String get alertInternalListNote => '알림: 내부 브랜드 연결 목록';

  @override
  String get alertBrandTrackingNote => '알림: 브랜드 추적과 공개 정보';

  @override
  String get reportNoteHint => '짧은 메모 (예: 오탐)';

  @override
  String get report => '신고';

  @override
  String get send => '보내기';

  @override
  String get reportSaved => '감사합니다. 신고를 저장했습니다.';

  @override
  String get seeUpdatedStatus => '갱신된 상태 보기';

  @override
  String get openEuSource => 'EU 출처 열기';

  @override
  String get openInsectSource => '곤충 출처 열기';

  @override
  String get privacyTitle => '개인정보';

  @override
  String get consentOptional => '선택 사항입니다. 동의하지 않으면 사용 정보는 분석으로 전송되지 않습니다.';

  @override
  String get consentWorksAnyway => '동의 여부와 관계없이 앱은 동작하며, 데이터는 이 기기에만 남을 수 있습니다.';

  @override
  String get readPrivacyPolicy => '개인정보 안내 읽기';

  @override
  String get allowAnonymousAnalytics => '익명 분석 허용';

  @override
  String get analyticsEnabled => '감사합니다. 분석을 켰습니다.';

  @override
  String get analyticsDisabled => '분석을 껐습니다.';

  @override
  String get countryDataSources => '국가 / 데이터 출처';

  @override
  String get chooseCountryTitle => '국가 선택 (기존 출처를 우선)';

  @override
  String get privacyIntro => '처음 사용할 때 개인정보 안내를 확인하세요. 분석을 켜지 않고 계속할 수 있으며, 장보기 데이터는 이 기기에 남습니다.';

  @override
  String couldNotOpenLinkError(String error) {
    return '링크를 열 수 없습니다: $error';
  }

  @override
  String reportSaveFailed(String error) {
    return '신고를 저장할 수 없습니다: $error';
  }

  @override
  String alertSeverity(String value) {
    return '심각도: $value';
  }

  @override
  String alertReason(String value) {
    return '이유: $value';
  }

  @override
  String alertConfidence(String value) {
    return '확신도: $value';
  }

  @override
  String matvaretabellenSuggestions(String count) {
    return 'Matvaretabellen 제안: $count';
  }

  @override
  String addedToList(String item, String list) {
    return '"$item"을(를) $list에 추가했습니다';
  }

  @override
  String nutritionEnergy(String value) {
    return '에너지: $value kcal';
  }

  @override
  String nutritionFat(String value) {
    return '지방: $value g';
  }

  @override
  String nutritionSaturatedFat(String value) {
    return '그중 포화지방: $value g';
  }

  @override
  String nutritionCarbohydrates(String value) {
    return '탄수화물: $value g';
  }

  @override
  String nutritionSugars(String value) {
    return '그중 당류: $value g';
  }

  @override
  String nutritionProtein(String value) {
    return '단백질: $value g';
  }

  @override
  String nutritionSalt(String value) {
    return '소금: $value g';
  }

}
