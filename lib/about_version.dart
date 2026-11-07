/// Text for the About dialog. The installed package version is passed in.
/// Never invent a marketing version such as 1.8.
String aboutVersionLabel({
  required String versionName,
  required String buildNumber,
}) {
  final name = versionName.trim();
  final build = buildNumber.trim();
  if (name.isEmpty && build.isEmpty) return 'Versjon ukjent';
  if (build.isEmpty) return 'Versjon $name';
  if (name.isEmpty) return 'Versjon ($build)';
  return 'Versjon $name ($build)';
}

/// Menu label for the lifetime remove-ads screen.
/// The screen stays reachable after a purchase so restore is not hidden.
String purchaseMenuTitle({
  required bool entitled,
  required String offerLabel,
}) {
  if (entitled) return 'Annonsefri er aktiv';
  return offerLabel;
}
