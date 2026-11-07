import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mat_sjekk/gen_l10n/app_localizations.dart';
import 'package:mat_sjekk/l10n/draft_locale_copy.dart';
import 'package:mat_sjekk/premium_service.dart';
import 'package:mat_sjekk/ui_safe.dart';

void main() {
  final en = _arb('app_en.arb');
  final drafts = {
    'zh_Hans': _arb('app_zh_Hans.arb'),
    'zh_Hant': _arb('app_zh_Hant.arb'),
    'ja': _arb('app_ja.arb'),
    'ko': _arb('app_ko.arb'),
  };

  test('verified Huawei facts stay factual and the refusal cause stays unknown', () {
    final text = File('store/appgallery/DRAFT-listings-zh-ja-ko.md').readAsStringSync();
    expect(text, contains('matsjekk_remove_ads_lifetime'));
    expect(text, contains('CNY 35.26'));
    expect(text, contains('no subscription groups'));
    expect(text, contains('Paid Apps Distribution Service Agreement is unsigned'));
    expect(text, contains('has not been accepted'));
    expect(text, contains('This build asks Google Play, not AppGallery'));
    expect(text, contains('The refusal cause is not known'));
    expect(text.toLowerCase(), isNot(contains('rejected because')));
    expect(text, isNot(contains('Matsjekk Plus')));
  });

  test('Play query uses the live AppGallery lifetime id and does not invent Plus', () {
    expect(PremiumService.removeAdsProductId, 'matsjekk_remove_ads_lifetime');
    for (final code in kDraftLocaleCodes) {
      final missing = draftPurchaseCopy(code)!.productNotReturned;
      expect(missing, contains('matsjekk_remove_ads_lifetime'));
      expect(missing, contains('AppGallery'));
      expect(missing, isNot(contains('网络')));
      expect(missing, isNot(contains('ネットワーク')));
      expect(missing, isNot(contains('네트워크')));
    }
  });

  testWidgets('a narrow label keeps the word version on one span',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Center(
        child: SizedBox(
          width: 64,
          child: RobustLabel('Buy ad-free version'),
        ),
      ),
    ));
    expect(find.text('version '), findsOneWidget);
    expect(find.text('versi'), findsNothing);
    expect(find.text('on'), findsNothing);
  });

  test('draft locales have the same keys as English and no empty strings', () {
    final enKeys = en.keys.toSet();
    for (final entry in drafts.entries) {
      expect(enKeys.containsAll(entry.value.keys), isTrue, reason: entry.key);
      for (final value in entry.value.values) {
        expect(value.trim(), isNotEmpty, reason: entry.key);
        expect(value.length, lessThan(500), reason: entry.key);
      }
    }
    expect(
      lookupAppLocalizations(
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ).privacyIntro,
      isNotEmpty,
    );
  });

  test('draft purchase menu text does not invent a price or subscription', () {
    const banned = [
      'Plus',
      'kr 49',
      'NOK',
      '29',
      '19',
      '订阅',
      '訂閱',
      '月费',
      '月費',
      '月額',
      '구독',
      'サブスクリプション',
    ];
    for (final entry in drafts.entries) {
      final menu = entry.value['removeAdsMenuItem']!;
      for (final word in banned) {
        expect(menu.contains(word), isFalse,
            reason: '${entry.key} menu contains $word');
      }
      expect(menu, isNot(contains('monthly')));
    }
  });

  test('draft copy keeps unknown risk and does not add Asian grocery coverage',
      () {
    for (final entry in drafts.entries) {
      expect(entry.value['unknown'], isNotEmpty);
      final joined = entry.value.values.join('\n');
      expect(joined, isNot(contains('超市名录')));
      expect(joined, isNot(contains('店舗目録')));
      expect(joined, isNot(contains('상점 목록이 있습니다')));
    }
    expect(kSourceCountryCodes, isNot(contains('CN')));
    expect(kSourceCountryCodes, isNot(contains('JP')));
    expect(kSourceCountryCodes, isNot(contains('KR')));
    for (final code in kDraftLocaleCodes) {
      final body = draftFarmThemeBody(code)!;
      expect(body, isNot(contains('商店名录已覆盖')));
      expect(
        body.contains('不是中国') ||
            body.contains('不是中國') ||
            body.contains('ではありません') ||
            body.contains('아닙니다'),
        isTrue,
        reason: code,
      );
    }
  });

  test('lookup returns the draft catalog and labels it as not Norwegian', () {
    expect(kDraftLocaleReviewStatus, 'draft-pending-linguistic-qa');
    final hans = lookupAppLocalizations(
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    );
    final hant = lookupAppLocalizations(
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    );
    final ja = lookupAppLocalizations(const Locale('ja'));
    final ko = lookupAppLocalizations(const Locale('ko'));
    expect(hans.scanBarcode, '扫描条码');
    expect(hant.scanBarcode, '掃描條碼');
    expect(ja.scanBarcode, 'バーコードをスキャン');
    expect(ko.scanBarcode, '바코드 스캔');
    expect(hans.removeAdsMenuItem, isNot(contains('kr')));
    expect(draftPurchaseCopy('ja')!.body, isNot(contains('月額')));
    expect(draftPurchaseCopy('ko')!.body, contains('구독이 아닙니다'));
  });

  testWidgets('draft Japanese string builds in the same theme as the app',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      locale: const Locale('ja'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) =>
            Text(AppLocalizations.of(context)!.scanBarcode),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('バーコードをスキャン'), findsOneWidget);
  });
}

Map<String, String> _arb(String name) {
  final file = File('lib/l10n/$name');
  final raw = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return {
    for (final entry in raw.entries)
      if (!entry.key.startsWith('@')) entry.key: entry.value as String,
  };
}
