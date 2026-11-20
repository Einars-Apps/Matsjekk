# Changelog

## Unreleased (working)

- Android: move the supported purchase plugin to `in_app_purchase` 3.3.x so the resolved Google Play Billing Library is 9.1.0 (was 7.1.1). The lifetime remove-ads product id is unchanged. Gradle 8.14.3, Android Gradle Plugin 8.13.1 and Kotlin 2.3.20 are the minimum current Flutter stable accepts for that artifact without moving to Android Gradle Plugin 9.
- Set TINE and TINE dairy brands (Jarlsberg, Norvegia and the other Norwegian sub-brands) to yellow for Bovaer. TINE oppgir at de ikke lenger leverer Bovaer-melk til forbruker, men eldre produkter (f.eks. ost) kan fortsatt finnes i butikk.
- Replace the NGT-only co-occurrence monitor with a Monday OpenAI evidence review
  covering Bovaer, GMO feed, insect protein and NGT, with explicit country/level
  coverage and draft proposals requiring human approval.
- Publish the existing country rules at the app's previously missing remote
  endpoint; support additional remote categories and intentional empty overrides.
- Add safe UI helpers to avoid use_build_context_synchronously issues (`lib/ui_safe.dart`).
- Add `buildProductsIndex` helper for canonical product indexing and merging.
- Migrate `ProductInfoDialogContent` to StatefulWidget and inline alert->report flow (persisted to Hive `alerts_feedback`).
- Centralized safe dialog/snack/pop helpers and replaced unsafe calls.
- Added and stabilized widget tests for alert->report and product info dialog.
- Replaced deprecated `withOpacity` usages and migrated `RadioListTile` usages to `ListTile` selectable rows.
- Ran `dart fix --apply` and `dart format .`.
- Hardened Windows test teardown to reduce PathNotFoundException race.
- Added GitHub Actions CI workflow with pub & Flutter SDK caching and matrix for `stable`/`beta` channels.

## Notes
- Remaining work: extract rule engine to `lib/rules/`, centralize index builder, more unit tests for indexing/rules, and minor analyzer info cleanups.
