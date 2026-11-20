# AppGallery form facts for Mat Sjekk

Prepared answers only. No AppGallery field was changed, and nothing here has been submitted.

The privacy URL below was read from this repository and fetched live. No second rights URL was found, so none is invented.

## Version baseline observed in AppGallery Connect

| Item | Observed value |
| --- | --- |
| Released | 1.1.3, versionCode 60 |
| Rejected, To modify, unsubmitted | 1.1.4, versionCode 61 |
| Highest versionCode shown | 61 |

A later Huawei upload has to use a versionCode above 61. Huawei’s 60 and 61 are a separate sequence from Google Play. Do not use 62 as the shared Play code.

## Google Play baseline observed on the release-track overview

| Item | Observed value |
| --- | --- |
| Production version | 1.1.8, versionCode 3501945 |
| Highest of the latest 5 bundles on that overview | 3501945 |
| Scope of that highest code | Release-track overview only, not every historical track |
| Internal | 3501553 |
| Alpha | 1 |
| Production countries | 178/178 |
| Pending reviews | None visible |
| Installed base 53.85% | Installed-base share. It is not a rollout percentage. |
| Billing policy | Versions below 8 are blocked for updates. The deadline 31 Aug 2026 is in force, and the warning is confirmed. |

The next shared `versionCode` has to be greater than 3501945. This branch uses `1.2.0+3501946`. That integer is above the verified Play overview maximum and above Apple’s selected build 3465810. It is not a claim that every historical or unprocessed build was enumerated. Apple App ID 6759604589 is 1.1.8 Ready for Distribution on build 3465810. No pending next App Store version was shown. The latest processed TestFlight build was not checked because the history timestamp failed to load, so no earlier TestFlight build is assumed. No Apple project files are changed for that baseline. 3501946 is also above Huawei’s rejected code 61. Do not use 62 as the Play code. `1.2.0` is this branch’s version name because it includes the farm-shop map. The published Play name is still 1.1.8. Play Billing in this branch is `in_app_purchase` 3.3.1 / `in_app_purchase_android` 0.5.5, which resolves `com.android.billingclient:billing:9.1.0` (PR 70). No app update was uploaded.

## URLs that exist

Privacy policy, canonical in `docs/privacy.html` and in `lib/config/links.dart` as `kPublicPrivacyPolicyBaseUrl`:

https://matsjekk.com/privacy.html

A live fetch of that URL returned the same policy (last updated March 2026), including Google AdMob, optional analytics consent, Open Food Facts lookups, and the heading “Dine rettigheter (GDPR)”.

Data subject rights URL: there is no separate page and no `id` on that heading. A fragment such as `#rights` is not in the file, so it is not a verified URL. The rights text and the contact `mailto:matsjekk@gmail.com` are on the privacy page. The AGC fields for Privacy Policy URL and Data Subject Right URL were observed empty on the 1.1.4 form. Filling them later still needs a human to choose whether the rights field may reuse the one verified page. This note does not submit that choice.

## Form values observed, not edited

| Field | Observed | What the current code supports |
| --- | --- | --- |
| Collect personal data | Yes | See the rows below. The summary row was empty and still needs a category, item and description. |
| Analytics | Checked | The website uses Google Analytics after consent. The app stores `analytics_opt_in` and `Analytics.logEvent` only prints in debug. The app does not send those events to an analytics SDK. |
| Advertising and marketing | Checked | The Android app uses Google AdMob (`google_mobile_ads`) and the AD_ID permission. |
| Third-party disclosure | Checked | Barcodes are sent to Open Food Facts. Ads go through Google. The website can load Google ads and analytics after consent. |
| Generative AI | Not involved | The app sources under `lib/` do not call a generative model. A manual GitHub workflow, `.github/workflows/ngt-monitor.yml`, can call OpenAI and open a draft pull request. That workflow says risk rules are not changed automatically. “Not involved” matches the app the user runs. It does not mean the maintainer workflow never uses a model. |
| Age | 12+ for China and other regions | No age gate exists in the app. This is the current form value, not a new rating. |
| Brazil reset notice | Present | Recorded as observed. Not changed. |
| Countries | 198 | Recorded as observed. Not changed. |
| Base app | Free | There is no paid download in the app. |
| IAP | Shown as `--` | AppGallery already has the active non-consumable `matsjekk_remove_ads_lifetime` at CNY 35.26 in China, and no subscription groups. The `--` does not match that product. The current Android code still queries Google Play for that id. |
| Sign-in required | Unchecked | The app has no account sign-in. |
| Release | Full release immediately after approval | Recorded as the current form setting. Not changed. |
| Paid Apps Distribution Service Agreement | Unsigned | A merchant payment confirmation was requested and has not been accepted. |

## Rows that match the empty personal-data summary

These describe this branch’s code. They are not a substitute for a filed form.

| Category | Item | Description |
| --- | --- | --- |
| Camera | Barcode scan | `mobile_scanner` reads a barcode on the device. The app does not upload camera images. |
| Advertising | Advertising ID | Google AdMob can use the advertising ID to show ads. Removing ads is the one-time product `matsjekk_remove_ads_lifetime`. |
| Location | Device location | The farm-shop map uses geolocator to measure distance. The shop list is the Norway and Europe dataset used by matsjekk.com, not a China, Japan or Korea directory. Location is not sent to a Matsjekk server. |
| Product lookup | Barcode | The barcode is sent to Open Food Facts. Matsjekk does not receive an account from that service. |
| Purchases | Store token | A successful store purchase is kept as the local flag `adsRemoved`. There is no Matsjekk account. |
| Analytics | On-device choice | The opt-in flag stays on the device. The current app code does not transmit analytics events. |

## 1.1.4 review screen

The reviewer video showed an empty Google Play product query for this lifetime id, while ads loaded and Wi-Fi was visible. The review comment had no reason. That cause is still not known. The empty IAP field on the form and the unsigned paid-apps agreement are separate facts, not a guessed rejection cause.
