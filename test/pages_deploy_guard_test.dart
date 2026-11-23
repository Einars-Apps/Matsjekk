import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Main CI Pages jobs deploy only on a push to main', () {
    final text = File('.github/workflows/main.yml').readAsStringSync();
    const guard =
        "if: github.event_name == 'push' && github.ref == 'refs/heads/main'";
    final docs = text.split('deploy-docs:').last.split('deploy-pages:').first;
    final pages = text.split('deploy-pages:').last;

    expect(docs, contains(guard));
    expect(pages, contains(guard));
    expect(docs, contains('needs: [flutter, python]'));
    expect(pages, contains('needs: deploy-docs'));
    expect(text, contains('pull_request:'));
  });

  test('release Gradle config refuses a debug-signed bundle', () {
    final text = File('android/app/build.gradle.kts').readAsStringSync();
    expect(text, contains('MATSJEKK_KEY_PROPERTIES'));
    expect(text, contains('MATSJEKK_STORE_FILE_BASE'));
    expect(text, contains('Refusing to use the debug key'));
    expect(text, isNot(contains('getByName("debug")')));
  });

  test('the separate docs workflow is not a pull_request Pages path', () {
    final text = File('.github/workflows/deploy_docs.yml').readAsStringSync();
    expect(text, isNot(contains('pull_request:')));
    expect(text, contains('ref: main'));
  });
}
