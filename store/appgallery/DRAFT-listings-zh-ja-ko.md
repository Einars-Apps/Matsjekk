# Draft AppGallery text — not for submission

Status: draft, pending linguistic QA. This is not a native-reviewed translation and has not been saved in AppGallery Connect.

Do not upload, submit, or publish this text. It describes the current Android app on `main`. It does not describe a native HarmonyOS app, a monthly plan, or a China/Japan/Korea grocery database.

## What the binary actually does

- Package `com.ebors.matsjekk`. In-app language picker. These four locales are draft UI languages: zh-Hans, zh-Hant, ja, ko.
- Product data is requested from Open Food Facts. Shopping lists stay on the device.
- Risk text for an unknown source stays unknown. Bovaer colours in the app come from the existing sourced status data; this draft does not add new Bovaer claims.
- Farm-shop entry opens the existing website page. That data is Norway and parts of Europe. It is not a store directory for China, Japan or Korea.
- Ads in the current Android binary are Google AdMob.
- The only purchase is the one-time product `matsjekk_remove_ads_lifetime`. The screen shows the price returned by the store. There is no monthly price in the app.
- Verified in AppGallery Connect on 7 Nov 2026: that product is an active non-consumable. The China price shown there is CNY 35.26. There are no subscription groups. This is a console fact, not a new price and not a monthly plan. The app must keep reading the store price and must not convert existing buyers to a monthly product.
- The Paid Apps Distribution Service Agreement is unsigned. A merchant payment confirmation has been requested and has not been accepted. Do not describe AppGallery purchases as ready to take payment.
- Version 1.1.4 is rejected. The review comment is generic and gives no reason. The parent supplied the reviewer MP4 observations. The refusal cause is not known. Do not guess it.
- The visible English purchase screen matches the Google Play query for `matsjekk_remove_ads_lifetime`. An empty product list with no billing error was labeled both as a network failure and as a missing product id. Ads loading and Wi-Fi do not show which billing provider answered. This build asks Google Play, not AppGallery. The same id is the active AppGallery non-consumable. An empty list can therefore be the provider, regional availability, or the unsigned paid-apps agreement.
- The restore button is shown on iOS only in the current screen. Android does not show that button.
- Current Android billing code is Google Play Billing, not HMS IAP. Do not tell AppGallery users that purchase or restore works there until a separate Huawei purchase build exists and the paid-apps agreement is accepted.

## zh-Hans

名称：Mat Sjekk

短说明：扫描条码，查看基于公开数据的食品提醒。一次性去除广告，不是订阅。

完整说明：
Mat Sjekk 使用 Open Food Facts 和内部规则，对 Bovaer、昆虫粉、转基因饲料和隐性转基因（NGT）给出提醒。没有来源时，结果显示为未知。购物清单保存在设备上。农场店页面只覆盖挪威和欧洲部分地区，不是中国商店名录。广告由当前 Android 版本中的 Google AdMob 显示。去除广告是一次性购买，价格由商店返回，不是月费。

## zh-Hant

名稱：Mat Sjekk

短說明：掃描條碼，查看基於公開資料的食品提醒。一次性移除廣告，不是訂閱。

完整說明：
Mat Sjekk 使用 Open Food Facts 和內部規則，對 Bovaer、昆蟲粉、基因改造飼料和隱性基因改造（NGT）給出提醒。沒有來源時，結果顯示為未知。購物清單保存在裝置上。農場店頁面只涵蓋挪威和歐洲部分地區，不是台灣、香港或中國商店名錄。廣告由目前 Android 版本中的 Google AdMob 顯示。移除廣告是一次性購買，價格由商店回傳，不是月費。

## ja

名前：Mat Sjekk

短い説明：バーコードをスキャンし、公開データに基づく食品の警告を見ます。広告の削除は買い切りで、月額ではありません。

詳しい説明：
Mat Sjekk は Open Food Facts と内部規則を使い、Bovaer、昆虫粉、遺伝子組み換え飼料、隠れた遺伝子組み換え（NGT）の警告を示します。出典がない場合、結果は不明のままです。買い物リストは端末に保存されます。農場直売ページの範囲はノルウェーと欧州の一部であり、日本の店舗目録ではありません。現在の Android 版の広告は Google AdMob です。広告の削除は買い切りで、価格はストアが返し、月額ではありません。

## ko

이름: Mat Sjekk

짧은 설명: 바코드를 스캔하고 공개 자료에 기반한 식품 알림을 확인합니다. 광고 제거는 일회성 구매이며 월 구독이 아닙니다.

자세한 설명:
Mat Sjekk는 Open Food Facts와 내부 규칙으로 Bovaer, 곤충 분말, 유전자변형 사료, 숨은 유전자변형(NGT) 알림을 보여 줍니다. 출처가 없으면 결과는 알 수 없음으로 남습니다. 장보기 목록은 기기에 저장됩니다. 농장 상점 페이지의 범위는 노르웨이와 유럽 일부이며 한국 상점 목록이 아닙니다. 현재 Android 버전의 광고는 Google AdMob입니다. 광고 제거는 일회성 구매이고, 가격은 스토어가 반환하며 월 요금이 아닙니다.
