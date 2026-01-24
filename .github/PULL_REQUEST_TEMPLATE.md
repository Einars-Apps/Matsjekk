### Summary

This PR includes a set of stability, analyzer, and test improvements:

- Centralize safe UI helpers and remove `use_build_context_synchronously` issues.
- Add `buildProductsIndex` and improve product indexing logic.
- Add alert reporting persisted to Hive (`alerts_feedback`) and tests for alert→report flow.
- Replace deprecated APIs (`withOpacity`, `RadioListTile`) and run `dart fix`/format.
- Add CI with pub & Flutter SDK caching and a `stable`/`beta` matrix.

### Checklist

- [ ] Tests pass locally (`flutter test -r expanded`).
- [ ] Analyzer is clean (`flutter analyze`).
- [ ] CHANGELOG updated.
- [ ] Any platform-specific issues documented (Windows test teardown note).

### Notes for reviewers

- Focus review on `lib/widgets.dart`, `lib/main.dart`, `lib/ui_safe.dart`, and `test/alert_report_flow_test.dart`.
- CI runs on `stable` and `beta` channels; failures on Windows might be intermittent due to test harness finalizer race — see `test/alert_report_flow_test.dart` teardown.

