import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google User Messaging Platform (UMP) consent manager.
///
/// Implements the Google-certified consent flow required by AdMob for EEA/UK
/// traffic (GDPR) and US state privacy laws. The consent message itself must be
/// created and published in the AdMob console (Privacy & messaging) — this code
/// requests an info update and shows the form when required.
///
/// Flow (per Google's recommendation):
/// 1. [gatherConsent] requests a consent-info update and shows the form if
///    required. Safe to call on every app start.
/// 2. [canRequestAds] reports whether ads may be requested yet.
/// 3. Only initialise/load ads once [canRequestAds] is true.
class ConsentManager {
  ConsentManager._();

  static final ConsentManager instance = ConsentManager._();

  /// Requests a consent-info update and shows the consent form if required.
  /// Never throws; on error it simply completes so the app can continue.
  Future<void> gatherConsent() async {
    final completer = Completer<void>();
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        try {
          ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
            if (!completer.isCompleted) completer.complete();
          });
        } catch (_) {
          if (!completer.isCompleted) completer.complete();
        }
      },
      (FormError error) {
        if (!completer.isCompleted) completer.complete();
      },
    );
    return completer.future;
  }

  /// Whether ads may be requested given the current consent state.
  /// Defaults to true if the check fails, matching SDK behaviour outside the EEA.
  Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (_) {
      return true;
    }
  }

  /// Whether a privacy-options entry point (e.g. a "Privacy choices" button)
  /// should be shown, so EEA users can change consent later.
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status =
          await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  /// Re-opens the consent form so the user can change their privacy choices.
  Future<void> showPrivacyOptionsForm() async {
    final completer = Completer<void>();
    try {
      ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (!completer.isCompleted) completer.complete();
      });
    } catch (_) {
      if (!completer.isCompleted) completer.complete();
    }
    return completer.future;
  }
}
