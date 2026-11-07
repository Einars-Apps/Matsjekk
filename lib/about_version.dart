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

/// A new paid purchase is offered only when the store returned the product
/// and this install does not already have the lifetime right.
bool offersNewPurchase({
  required bool loading,
  required bool storeAvailable,
  required bool hasProduct,
  required bool entitled,
}) {
  return !loading && storeAvailable && hasProduct && !entitled;
}

/// Explains the purchase screen from local state and the Play catalog.
/// It does not change Hive or contact Play.
List<String> purchaseStatusLines({
  required bool entitled,
  required bool loading,
  required bool storeAvailable,
  required bool hasProduct,
  required String productId,
}) {
  if (loading) {
    return const ['Sjekker lokal rettighet og Google Play. Ingen kjøp er endret.'];
  }
  if (entitled) {
    return const [
      'Lokal rettighet: annonsefri er lagret på denne installasjonen. Kjøp tilbys ikke på nytt, og annonser lastes ikke.',
      'Gjenopprett spør Google Play. Et tomt eller feilet svar fjerner ikke rettigheten.',
    ];
  }
  if (!storeAvailable) {
    return const [
      'Lokal rettighet: annonsefri er ikke lagret. Google Play Billing svarte ikke, så kjøp kan ikke startes.',
      'Et manglende banner betyr at AdMob ikke leverte et annonseobjekt. Det er ikke et kjøpsresultat.',
    ];
  }
  if (!hasProduct) {
    return [
      'Lokal rettighet: annonsefri er ikke lagret. Play returnerte ikke $productId, så kjøp kan ikke startes.',
      'Intern testtilgang er ikke det samme som en lisens-tester. Et manglende banner er et AdMob-svar, ikke et kjøp.',
    ];
  }
  return const [
    'Lokal rettighet: annonsefri er ikke lagret. Play returnerte produktet.',
    'Kjøp permanent bruker ekte Google Play-fakturering, ikke en lokal simulering.',
  ];
}
